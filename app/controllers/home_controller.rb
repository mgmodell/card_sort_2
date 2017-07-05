# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @datasets = Dataset.all

    session = GoogleDrive::Session.from_access_token( current_user.token )
    query = "trashed != true"
    @sheets = session.spreadsheets(q: "trashed != true",
                              corpus: "user",
                             orderBy: "viewedByMeTime desc",
                            pageSize: 10 )

  end

  def load
    credentials = request.env['omniauth.auth']['credentials']
    session = GoogleDrive::Session.from_access_token(credentials['token '])
    myspreadsheets = session.spreadsheets
  end
end
