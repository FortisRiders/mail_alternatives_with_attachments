module MailAlternativesWithAttachments::ActionMailerPrepareMessage

  # Copied directly from ActionMailer::Base#mail but without
  # the automatic rendering of templates.
  def prepare_message(headers = {}, &block)
    return message if @_mail_was_called && headers.blank? && !block

    # At the beginning, do not consider class default for content_type
    content_type = headers[:content_type]

    headers = apply_defaults(headers)

    # Apply charset at the beginning so all fields are properly quoted
    message.charset = charset = headers[:charset]

    # Set configure delivery behavior
    wrap_delivery_behavior!(headers[:delivery_method], headers[:delivery_method_options])

    assign_headers_to_message(message, headers)

    @_mail_was_called = true

    # Setup content type, reapply charset and handle parts order
    message.content_type = set_content_type(message, content_type, headers[:content_type])
    message.charset      = charset

    if message.multipart?
      message.body.set_sort_order(headers[:parts_order])
      message.body.sort_parts!
    end

    message
  end
end

ActionMailer::Base.send(:include, MailAlternativesWithAttachments::ActionMailerPrepareMessage)
