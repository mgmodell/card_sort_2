# frozen_string_literal: true

class AddRefsFromBiblioJob < ApplicationJob
  queue_as :internal

  def perform(source_text:, source:)
    topic = Topic.where(name: 'Undetermined').take
    source_text.split("\n").each do |citation|
      Anystyle.parse(citation).each do |src|
        s = Source.where(title: src[:title].capitalize).take
        unless s.present?
          s = Source.create(author_list: src[:author],
                            title: src[:title],
                            year: src[:date],
                            citation: citation,
                            dataset: nil,
                            topic: topic)
          source.refs << s
        end
        source.refs_processed = true
        source.save
        s.save
        s.preproc
      end
    end
  end
end
