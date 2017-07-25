# frozen_string_literal: true

class LoadDataJob < ApplicationJob
  queue_as :external

  def perform(task_user:, key:)
    # Do something later
    task_user.refresh_token_if_expired

    puts '------------------ Creating a Dataset ------------------ '

    session = GoogleDrive::Session.from_access_token(task_user.token)
    ss = session.spreadsheet_by_key(key)
    title = ss.title

    ws = ss.worksheet_by_title('meta-Main')

    item_count = 1 + (ws.num_rows * 12)

    progress = 1.0

    ds = Dataset.create name: "#{title} - (#{DateTime.current})",
                        user: task_user, load_pct: 100 * (progress / item_count)
    puts ds.errors.full_messages unless ds.errors.empty?

    puts '***** Topics *******'
    (2..ws.num_rows).each do |row_num|
      s = Source.new
      s.citation = ws[row_num, 1]
      s.year = ws[row_num, 2]
      s.author_list = ws[row_num, 3]
      s.purpose = ws[row_num, 4]
      s.discard_reason = ws[row_num, 8]
      t = Topic.where(name: ws[row_num, 6]).count > 0 ?
                  Topic.where(name: ws[row_num, 6]).take :
                  Topic.where(name: 'Undetermined').take
      s.topic = t
      s.dataset = ds
      s.save

      # update progress
      progress += 1
      ds.load_pct = 100 * (progress / item_count)
      ds.save

      puts s.errors.full_messages unless s.errors.empty?
    end

    not_hit = []
    ds.sources.each do |source|
      puts '******** SOURCES *************'
      # puts "#{source.author_list} (#{source.year}"
      ws = ss.worksheet_by_title source.author_list
      if ws.nil?
        not_hit << source.author_list
        # puts "--------- NO SHEET NAMED '#{source.author_list}'"
      else
        (1..ws.num_rows).each do |row_num|
          # puts "\t #{ws[row_num, 1]}"
          f = Factor.create source: source, text: ws[row_num, 1]
          puts f.errors.full_messages unless f.errors.empty?
        end
      end
      # update progress
      progress += 1
      ds.load_pct = 100 * (progress / item_count)
      ds.save
    end
    puts "Unable to retrieve #{not_hit.count} sets of factors"
    not_hit.each do |list|
      puts "----- '#{list}'"
    end
    ds.load_pct = 100
    ds.save
  end
end
