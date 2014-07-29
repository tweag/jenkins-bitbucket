class BitbucketHooksController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def create
    bitbucket_hook_handler.call params
    render text: 'Thanks'
  end

  def index
    render text: 'Point Bitbucket\'s "POST Pull Request" hook to this URL'
  end

  def refresh
    bitbucket_hook_handler.refresh params[:id]
    render text: 'Updated'
  end

  def refresh_button
    render layout: false
  end
end
