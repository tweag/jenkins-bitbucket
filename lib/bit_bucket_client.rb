class BitBucketClient

  # TODO: put this somewhere else
  ATTRIBUTES = %i[user password repo]
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
    @conn = Faraday.new(:url => 'https://api.bitbucket.org') do |faraday|
      faraday.request :basic_auth, user, password
      faraday.request :json
      faraday.response :json
      faraday.adapter  Faraday.default_adapter
    end
  end

  def create_pr(title)
    post(prs_path,
         "source" => { "branch" => { "name" => "my-branch" }, },
         "title" => title,
         "description" => "Test Pull Request"
        )
  end

  def update_pr(id, title, description)
    put(pr_path(id), title: title, description: description)
  end

  def prs
    get(prs_path)['values'].map{|pr| PullRequest.new(pr) }
  end

  def pr(id)
    PullRequest.new(get(pr_path(id)))
  end

  def decline_pr(id)
    post(decline_pr_path(id))
  end

  private

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


  def prs_path
    "/2.0/repositories/#{repo}/pullrequests"
  end

  def pr_path(id)
    path(prs_path, id)
  end

  def decline_pr_path(id)
    path(pr_path(id), "decline")
  end

  def path(*parts)
    parts.join('/')
  end

  class PullRequest < Hashie::Mash
    def story_number
      Util.extract_id(title)
    end
  end
end

