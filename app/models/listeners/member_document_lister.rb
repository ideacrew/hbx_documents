module Listeners
  class MemberDocumentLister < ::Amqp::Client
    def validate(delivery_info, properties, payload)
      if properties.headers["hbx_member_id"].blank?
        add_error("No hbx_member_id")
      end
      if properties.reply_to.blank?
        add_error("No reply to!")
      end
    end

    def on_message(delivery_info, properties, payload)
      member_id = properties.headers['hbx_member_id']
      reply_to = properties.reply_to
      # channel.acknowledge(delivery_info.delivery_tag, false)
    end

    def self.routing_key
      "member_documents.find_by_hbx_member_id"
    end

    def self.queue_name
      ec = ExchangeInformation
      "#{ec.hbx_id}.#{ec.environment}.q.hbx_documents.member_document_lister"
    end
  end
end
