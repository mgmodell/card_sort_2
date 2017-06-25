# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]
  has_many :datasets, inverse_of: :user

  # Omniauth support
  def self.from_omniauth(access_token)
    session = GoogleDrive::Session.from_access_token( access_token[ :credentials ][ :token ] )
    x = session.spreadsheet_by_title 'Framework Evaluation' 
    ws = x.worksheet_by_title 'meta-Main'

    ds = Dataset.create name: "new (#{DateTime.current})"

    puts "************"
    (2..ws.num_rows).each do |row_num|
      s = Source.new
      s.citation = ws[ row_num, 1 ]
      s.year = ws[ row_num, 2 ]
      s.author_list = ws[ row_num, 3 ]
      s.purpose = ws[ row_num, 4 ]
      s.discard_reason = ws[ row_num, 8 ]
      s.dataset = ds
      s.save

      puts s.errors.full_messages unlss s.errors.empty?
    end

    Source.find_all do |source|
      ws = x.worksheet_by_title s.author_list
      (1..ws.num_rows).each do |row_num|
        Factor.create source: s, text: ws[ row_num, 1 ]
      end
    end

    # byebug

    data = access_token.info
    user = User.where(email: data['email']).first

    unless user
      user = User.create(
        email: data['email'],
        password: Devise.friendly_token[0, 20]
      )
    end
    user
  end
end
