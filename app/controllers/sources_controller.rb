# frozen_string_literal: true

class SourcesController < ApplicationController
  before_action :set_source

  def show
    @stats = {}
    @stats['top words'] = @source.words.group(:raw).count
    @stats['top synonyms'] = @source.synonyms.group(:word).count
    @stats['top stems'] = @source.stems.group(:word).count
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
      counts =  @source.get_stem_counts
    when 'words'
      counts =  @source.get_word_counts
    when 'synonyms'
      counts =  @source.get_synonym_counts
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
