class SourcesController < ApplicationController
  before_action :set_source

  def show; end

  def edit; end

  def update
    if @source.update( source_params )
      redirect_to source_path(@source), notice: 'Updated!'
    else
      render :edit
    end
  end

  def add_refs
    #Add any references here
    topic = Topic.where( name: "Undetermined" ).take
    Anystyle.parse( params[ :sources ] )each do |src|
      s = Source.create( author_list: src[ :author ],
                      title: src[ :title ],
                      year: src[ :date ],
                      citation: src.format_raw.to_s,
                      topic: topic )
      s.preproc
      @source.refs << s
      @source.save
    end
  end

  def data_proc
    @source.preproc
  end

  def destroy
    @source.destroy
    redirect_to dataset_path( @source.dataset )
  end

  private
    def set_source
      @source = Source.find( params[ :id ]
    end

    def source_params
      params.require(:source).permit( :citation,
                                    :author_list, :year, :purpose,
                                    :topic_id, :discard_reason, :title )
    end

end
