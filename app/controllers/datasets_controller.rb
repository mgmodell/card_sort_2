class DatasetsController < ApplicationController

  def show
    # Build out any history support.

    # Histogram info
    stem_hist = @dataset.sources.joins( factors: { words: :stems } ).group( factor ).count
  
  end

  def edit; end

  def update
    if @dataset.update( dataset_params )
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
    @dataset.sources.each do |source|
      source.preproc
    end
    render :show
  end

  private
    def set_dataset
      @dataset = Dataset.find( params[ :id ] )
    end

    def dataset_params
      params.require(:dataset).permit( :name,
                                    source: [:citation, :year, :title,
                                            :discard_reason, :topic_id,
                                            :purpose, ] )
    end

end
