# frozen_string_literal: true
require 'google/apis/drive_v2'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]
  has_many :datasets, inverse_of: :user

  # Omniauth support
  def self.from_omniauth(access_token)
    #session = GoogleDrive::Session.new( access_token )
    drive = Google::Apis::DriveV2::DriveService.new
    files = drive.list_files(
      fields: "nextPageToken, files(id, name)",
      q: "mimeType = 'application/vnd.google-apps.spreadsheet' AND trashed != true",
    )

    # byebug
    puts "************"

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
