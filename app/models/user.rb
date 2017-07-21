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


      response    = RestClient.post "#{domain}oauth2/token",
                      :grant_type => 'refresh_token',
                      :refresh_token => self.refresh_token,
                      :client_id => key,
                      :client_secret => secret
      refreshhash = JSON.parse(response.body)
  
      token_will_change!
      expires_at_will_change!
  
      self.token     = refreshhash['access_token']
      self.expires_at = DateTime.now + refreshhash["expires_in"].to_i.seconds
  
      self.save
      puts 'Saved'
    end
  end

  def token_expired?
    expiry = Time.at(self.expires_at) 
    return true if expiry < Time.now # expired token, so we should quickly return
    token_expires_at = expiry
    save if changed?
    false # token not expired. :D
  end
end
