class DatasetsController < ApplicationController

  def show
  end

  def edit
  end

  def update
  end

  def destroy
    @dataset.destroy
    redirect_to :root
  end

  def process
    @dataset.sources.each do |source|
      source.preproc
    end
  end

  private
    def set_dataset
      @dataset = Dataset.find( params[ :id ]
    end

    def dataset_params
      params.require(:dataset).permit( :name,
                                    source: [:citation, :year, :title,
                                            :discard_reason, :topic_id,
                                            :purpose, ] )
    end

end
