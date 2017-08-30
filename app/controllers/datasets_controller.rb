# frozen_string_literal: true

class DatasetsController < ApplicationController
  before_action :set_dataset

  def show
    # Build out any history support.
    @stats = {}
    @stats = JSON.parse(@dataset.stats_cache) if @dataset.stats_cache.present?

    # Histogram info
    stem_hist = @dataset.sources.joins(factors: { words: :stem }).group('factors.id').count
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
    when 'words'
      counts = @dataset.get_word_counts
    when 'synonyms'
      counts = @dataset.get_synonym_counts
    end

    puts 'here!'
    puts counts

    respond_to do |format|
      format.json { render json: counts.to_a }
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
