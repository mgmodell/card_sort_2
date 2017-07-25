# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, # :rememberable,
         :trackable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]
  has_many :datasets, inverse_of: :user, dependent: :destroy

  # Omniauth support
  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    unless user
      user = User.create(
        email: data['email'],
        password: Devise.friendly_token[0, 20],
        token: access_token[:credentials][:token],
        refresh_token: access_token[:credentials][:refresh_token],
        expires_at: access_token[:credentials][:expires_at]
      )
    end

    user
  end

  def refresh_token_if_expired
    if token_expired?

      key = Rails.application.config.google_key
      secret = Rails.application.config.google_secret
      domain = Rails.application.config.google_domain

      options = {
        body: {
          client_id: key,
          client_secret: secret,
          refresh_token: refresh_token,
          grant_type: 'refresh_token'
        },
        headers: {
          'Content-Type' => 'application/x-www-form-urlencoded'
        }
      }

      response = HTTParty.post("#{domain}oauth2/token", options)
      if response.code == 200
        self.token = response.parsed_response['access_token']
        self.expires_at = DateTime.now + response.parsed_response['expires_in'].seconds
        save
      else
        puts "Unable to refresh token: #{response.body}"
      end
    end
  end

  def token_expired?
    expiry = Time.at(expires_at)
    return true if expiry < Time.now # expired token, so we should quickly return
    token_expires_at = expiry
    save if changed?
    false # token not expired. :D
  end
end
