class HomeController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
    render text: "Hello World"
  end

  def jenkins
    $params = params
    pp params
    render text: "Thanks"
  end
end
