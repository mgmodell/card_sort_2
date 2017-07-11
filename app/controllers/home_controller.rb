# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @datasets = Dataset.all

    session = GoogleDrive::Session.from_access_token( current_user.token )
    query = "trashed != true"

    current_user.refresh_token_if_expired
    @sheets = session.spreadsheets(q: "trashed != true",
                              corpus: "user",
                             orderBy: "viewedByMeTime desc",
                            pageSize: 10 )

  end

  def load
    key = params[ :key ]
    current_user.refresh_token_if_expired

    session = GoogleDrive::Session.from_access_token( current_user.token )
    ss = session.spreadsheet_by_key( key )
    title = ss.title
    ws = ss.worksheet_by_title 'meta-Main'

    ds = Dataset.create name: "#{title} - (#{DateTime.current})",
                        user: current_user
    puts ds.errors.full_messages unless ds.errors.empty?


    puts '************'
    (2..ws.num_rows).each do |row_num|
      s = Source.new
      s.citation = ws[row_num, 1]
      s.year = ws[row_num, 2]
      s.author_list = ws[row_num, 3]
      s.purpose = ws[row_num, 4]
      s.discard_reason = ws[row_num, 8]
      t = Topic.where( name: ws[row_num, 6 ] ).count > 0 ?
                  Topic.where( name: ws[row_num, 6] ).take :
                  Topic.where( name: 'Undetermined' ).take
      s.topic = t
      s.dataset = ds
      s.save

      puts s.errors.full_messages unless s.errors.empty?
    end

    not_hit = []
    ds.sources.each do |source|
      puts "*********************"
      puts "#{source.author_list} (#{source.year}"
      ws = ss.worksheet_by_title source.author_list
      unless ws.nil?
        (1..ws.num_rows).each do |row_num|
          # puts "\t #{ws[row_num, 1]}"
          f = Factor.create source: source, text: ws[row_num, 1]
          puts f.errors.full_messages unless f.errors.empty?
        end
      else
        not_hit << source.author_list
        puts "--------- NO SHEET NAMED '#{source.author_list}'"
      end
    end
    puts "Unable to retrieve #{not_hit.count} sets of factors"
    not_hit.each do |list|
      puts "----- '#{list}'"
    end

    render :index
  end
end
