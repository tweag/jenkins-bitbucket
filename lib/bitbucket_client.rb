class BitbucketClient
  # TODO: put this somewhere else
  ATTRIBUTES = %i(user password repo pull_request_builder)
  class << self
    attr_accessor(*ATTRIBUTES)
  end
  attr_writer(*ATTRIBUTES)
  ATTRIBUTES.each do |attr|
    define_method attr do
      instance_variable_get("@#{attr}") || self.class.public_send(attr)
    end
  end

  def initialize
    @conn = Faraday.new(url: 'https://api.bitbucket.org') do |faraday|
      faraday.request :basic_auth, user, password
      faraday.request :json
      faraday.response :json
      faraday.adapter Faraday.default_adapter
    end
  end

  def create_pull_request(title)
    pull_request_attrs = post(
      pull_requests_path,
      'source' => { 'branch' => { 'name' => 'my-branch' } },
      'title' => title,
      'description' => 'Test Pull Request'
    )
    build_pull_request(pull_request_attrs)
  end

  def update_pull_request(id, title, description)
    put(pull_request_path(id), title: title, description: description)
  end

  def pull_requests
    get(pull_requests_path)['values'].map do |pull_request|
      build_pull_request(pull_request)
    end
  end

  def pull_request(id)
    build_pull_request(get(pull_request_path(id)))
  end

  def decline_pull_request(id)
    post(decline_pull_request_path(id))
  end

  private

  def build_pull_request(*args)
    (pull_request_builder || ->(x) { x }).call(*args)
  end

  def post(url, body = nil)
    @conn.post do |req|
      req.url url
      if body.present?
        req.headers['Content-Type'] = 'application/json'
        req.body = body.to_json
      end
    end.body
  end

  def put(url, data)
    @conn.put(url, data)
  end

  def get(str)
    @conn.get(str).body
  end

  def pull_requests_path
    "/2.0/repositories/#{repo}/pullrequests"
  end

  def pull_request_path(id)
    path(pull_requests_path, id)
  end

  def decline_pull_request_path(id)
    path(pull_request_path(id), 'decline')
  end

  def path(*parts)
    parts.join('/')
  end
end
