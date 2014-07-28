class BitbucketHooksController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :create

  def create
    bitbucket_hook_handler.call params
    render text: "Thanks"
  end

  def index
    render text: 'Point Bitbucket\'s "POST Pull Request" hook to this URL'
  end
end
