class BitbucketHooksController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def create
    pull_request_interactor.call params
    render text: 'Thanks'
  end

  def index
    render text: 'Point Bitbucket\'s "POST Pull Request" hook to this URL'
  end

  def refresh
    pull_request_interactor.refresh params[:id]
    redirect_to(params[:back_to] || :back)
  end

  def refresh_all
    pull_request_interactor.refresh_all
    redirect_to :back
  end

  def refresh_button
    render layout: false
  end
end
