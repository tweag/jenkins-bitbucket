class StatusMessageRenderer < Struct.new(:renderer)
  def call(message)
    renderer.render_to_string(
      'messages/message.markdown',
      locals: { message: message },
      layout: 'message.markdown'
    )
  end
end
