class AddRefsFromBiblioJob < ApplicationJob
  queue_as :internal

  def perform(source_text:,source:)
    topic = Topic.where( name: "Undetermined" ).take
    Anystyle.parse( source_text ).each do |src|
      s = Course.create( author_list: src[ :author ],
                          title: src[ :title ],
                          year: src[ :date ],
                          citation: src.format_raw.to_s,
                          topic: topic )
      s.preproc
      source.refs << s
      source.refs_processed
      source.save
    end
  end
end
