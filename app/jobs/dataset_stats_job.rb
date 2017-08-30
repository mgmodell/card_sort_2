# frozen_string_literal: true

class DatasetStatsJob < ApplicationJob
  queue_as :default

  def perform(dataset:)
    stats = {}
    stats['top words'] = dataset.words.group(:raw).count
                                .values.extend(DescriptiveStatistics).descriptive_statistics
    stats['top synonyms'] = dataset.synonyms.group(:word).count
                                   .values.extend(DescriptiveStatistics).descriptive_statistics
    stats['top stems'] = dataset.stems.group(:word).count
                                .values.extend(DescriptiveStatistics).descriptive_statistics

    dataset.stats_cache = stats.to_json
    dataset.save
  end
end
