# frozen_string_literal: true

class SourcesController < ApplicationController
  before_action :set_source

  def show
    @stats = {}
    @stats = JSON.parse(@source.stats_cache) if @source.stats_cache.present?
  end

  def edit; end

  def update
    if @source.update(source_params)
      redirect_to source_path(@source), notice: 'Updated!'
    else
      render :edit
    end
  end

  def add_refs
    # Add any references here
    @source.add_refs(source_text: params[:sources])
    redirect_to source_path(@source)
  end

  def data_proc
    @source.preproc
    redirect_to source_path(@source)
  end

  def get_data
    counts = {}
    case params[:type].downcase
    when 'stems'
      counts = @source.get_stem_counts
      stat_key = 'top stems'
    when 'words'
      counts = @source.get_word_counts
      stat_key = 'top words'
    when 'synonyms'
      counts = @source.get_synonym_counts
      stat_key = 'top synonyms'
    end


    unless @source.stats_cache.blank?
      stats = JSON.parse(@source.stats_cache) if @source.stats_cache.present?
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
      when 'between 1sd and 2sd up'
        min = stats[stat_key]['mean'] + sd
        max = stats[stat_key]['mean'] + 2 * sd
      when 'top'
        min = stats[stat_key]['mean'] - 2 * sd
      end

      counts = counts.delete_if { |_key, value| (min.present? && value < min) || (max.present? && value > max) }

    end

    respond_to do |format|
      format.json { render json: counts.to_a }
    end
  end

  def destroy
    @source.destroy
    redirect_to dataset_path(@source.dataset)
  end

  private

  def set_source
    @source = Source.find(params[:id])
  end

  def source_params
    params.require(:source).permit(:citation,
                                   :author_list, :year, :purpose,
                                   :topic_id, :discard_reason, :title)
  end
end
