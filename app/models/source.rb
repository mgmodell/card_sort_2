# frozen_string_literal: true

class Source < ApplicationRecord
  default_scope { order( :citation ) }
  belongs_to :dataset, inverse_of: :sources
  has_and_belongs_to_many :authors, inverse_of: :sources
  belongs_to :topic, inverse_of: :sources
  has_many :factors, inverse_of: :source, dependent: :destroy

  has_and_belongs_to_many :refs, 
              class_name: "Source", 
              join_table: :references, 
              foreign_key: :source_id, 
              association_foreign_key: :reference_source_id,
              dependent: :destroy

  @@filter = Stopwords::Snowball::Filter.new('en')

  def self.filter
    @@filter
  end

  def preproc
    self.processed = false
    self.save
    PreProcSourceJob.perform_later( source: self )
  end
end
