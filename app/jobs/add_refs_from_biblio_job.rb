# frozen_string_literal: true

class AddRefsFromBiblioJob < ApplicationJob
  queue_as :internal

  def perform(source_text:, source:)
    topic = Topic.where(name: 'Undetermined').take
    source_text.split("\n").each do |citation|
      Anystyle.parse(citation).each do |src|
        title = src[:title]
        title = src[:booktitle] if title.nil?
        if title.nil?
          puts "\n\n\t\tnot found: #{citation}\n\t\t#{src}\n"
        else
          s = Source.where(title: title.capitalize).take
          unless s.present?
            s = Source.create(author_list: src[:author],
                              title: title,
                              year: src[:date],
                              citation: citation,
                              dataset: nil,
                              topic: topic)
          end
          source.refs << s
          source.refs_processed = true
          source.save
          s.save
          s.preproc
        end
      end
    end
  end
end
