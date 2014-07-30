class StatusMessageRenderer < Struct.new(:renderer)
  def call(pull_request, job)
    renderer.render_to_string(
      'messages/message.markdown',
      locals: {
        message: {
          pull_request: pull_request,
          job:          job
        }
      },
      layout: 'message.markdown'
    )
  end
end
