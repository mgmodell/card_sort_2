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
    session = GoogleDrive::Session.from_access_token( access_token )
    my_spreadsheets = session.spreadsheets
    puts "************"
    puts my_spreadsheets.count

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
