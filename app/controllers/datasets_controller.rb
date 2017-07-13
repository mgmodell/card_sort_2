class DatasetsController < ApplicationController

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def add_sources
    Anystyle.parse( params[ :sources ] )each do |source|

    end
  end

  def process
    @dataset.sources.each do |source|
      parsed = Anystyle.parse source.citation
      #TODO finish this


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
