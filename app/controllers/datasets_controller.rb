# frozen_string_literal: true

class DatasetsController < ApplicationController
  before_action :set_dataset

  def show
    # Build out any history support.
    @stats = {}
    @stats = JSON.parse(@dataset.stats_cache) if @dataset.stats_cache.present?
  end

  def edit; end

  def update
    if @dataset.update(dataset_params)
      redirect_to dataset_path(@dataset), notice: 'Updated!'
    else
      render :edit
    end
  end

  def destroy
    @dataset.destroy
    redirect_to :root
  end

  def data_proc
    @dataset.sources.each(&:preproc)
    redirect_to dataset_path(@dataset)
  end

  def calc_stats
    DatasetStatsJob.perform_later(dataset: @dataset)
    redirect_to dataset_path(@dataset)
  end

  def get_data
    counts = {}
    case params[:type].downcase
    when 'stems'
      counts = @dataset.get_stem_counts
      stat_key = 'top stems'
    when 'words'
      counts = @dataset.get_word_counts
      stat_key = 'top words'
    when 'synonyms'
      counts = @dataset.get_synonym_counts
      stat_key = 'top synonyms'
    end

    unless @dataset.stats_cache.blank?
      stats = JSON.parse(@dataset.stats_cache) if @dataset.stats_cache.present?
      max = nil
      min = nil
      sd = stats[stat_key]['standard_deviation']
      case params[:slice].downcase
      when 'all'
      when 'bottom'
        max = stats[stat_key]['mean'] - 2 * sd
      when 'lower half'
        max = stats[stat_key]['mean']
      when 'upper half'
        min = stats[stat_key]['mean']
      when 'within 1sd'
        max = stats[stat_key]['mean'] + sd
        min = stats[stat_key]['mean'] - sd
      when 'within 2sd'
        max = stats[stat_key]['mean'] + 2 * sd
        min = stats[stat_key]['mean'] - 2 * sd
      when 'lower 1sd'
        max = stats[stat_key]['mean']
        min = stats[stat_key]['mean'] - sd
      when 'upper 1sd'
        min = stats[stat_key]['mean']
        max = stats[stat_key]['mean'] + sd
      when 'lower 2sd'
        max = stats[stat_key]['mean']
        min = stats[stat_key]['mean'] - 2 * sd
      when 'upper 2sd'
        min = stats[stat_key]['mean']
        max = stats[stat_key]['mean'] + 2 * sd
      when 'between 1sd and 3sd up'
        min = stats[stat_key]['mean'] + sd
        max = stats[stat_key]['mean'] + 3 * sd
      when 'between 1sd and 2sd up'
        min = stats[stat_key]['mean'] + sd
        max = stats[stat_key]['mean'] + 2 * sd
      when 'top'
        min = stats[stat_key]['mean'] + 2 * sd
      when '1sd above'
        min = stats[stat_key]['mean'] + sd
      end

      counts = counts.delete_if { |_key, value| (min.present? && value < min) || (max.present? && value > max) }

    end

    respond_to do |format|
      format.json { render json: counts.sort }
    end
  end

  private

  def set_dataset
    @dataset = Dataset.find(params[:id])
  end

  def dataset_params
    params.require(:dataset).permit(:name,
                                    source: %i[citation year title
                                               discard_reason topic_id
                                               purpose])
  end
end
