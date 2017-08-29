# frozen_string_literal: true

class UpdateThesaurusJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    Word.where(syn_checked: false).each do |word|
      Thesaurus.lookup(word.raw).each do |syn|
        synonym = Synonym.where(word: syn.root).take
        synonym = Synonym.create(word: syn.root) unless synonym.present?
        word.synonyms << synonym unless word.synonyms.include? synonym
      end
      word.syn_checked = true
      word.save
    end
  end
end
