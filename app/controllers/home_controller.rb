# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @datasets = Dataset.all

    session = GoogleDrive::Session.from_access_token(current_user.token)
    query = 'trashed != true'

    current_user.refresh_token_if_expired
    @sheets = session.spreadsheets(q: 'trashed != true',
                                   corpus: 'user',
                                   orderBy: 'viewedByMeTime desc',
                                   pageSize: 10)
  end

  def pull
    key = params[:key]
    LoadDataJob.perform_later(task_user: current_user, key: key)
    redirect_to :root
  end

  # This is not thread safe!!!
  # Would be good to add a mutex
  def update_synonyms
    UpdateThesaurusJob.perform_later
    redirect_to :root
  end
end
