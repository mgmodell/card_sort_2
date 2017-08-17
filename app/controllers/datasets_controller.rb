# frozen_string_literal: true

class DatasetsController < ApplicationController
  before_action :set_dataset

  def show
    # Build out any history support.
    @stats = {}
    @stats[ 'top words' ] = @dataset.words.group( :raw ).count
    @stats[ 'top synonyms' ] = @dataset.synonyms.group( :word ).count
    @stats[ 'top stems' ]  = @dataset.stems.group( :word ).count

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
