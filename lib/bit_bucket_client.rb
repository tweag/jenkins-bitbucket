class BitBucketClient
  def initialize
    @conn = Faraday.new(:url => 'https://api.bitbucket.org') do |faraday|
      faraday.request :basic_auth, 'jenkins-bitbucket', 'NXTUpRQGeJMokuQAnQcWqnGbvsMsAqn9DwqcFGTseNaGJWLCy3'
      faraday.request :json
      faraday.response :json
      faraday.adapter  Faraday.default_adapter
    end
  end

  def create_pr(title)
    post(prs_path,
         "source" => { "branch" => { "name" => "my-branch" }, },
         "title" => title,
         "description" => "it's a pr"
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
    "/2.0/repositories/jenkins-bitbucket/jenkins-bitbucket/pullrequests"
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
  end
end

