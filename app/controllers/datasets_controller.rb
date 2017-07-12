class DatasetsController < ApplicationController

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def add_source
  end

  def process
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
