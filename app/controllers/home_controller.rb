# frozen_string_literal: true

class HomeController < ApplicationController
  def index; end

  def load
    credentials = request.env['omniauth.auth']['credentials']
    session = GoogleDrive::Session.from_access_token(credentials['token '])
    myspreadsheets = session.spreadsheets
  end
end
