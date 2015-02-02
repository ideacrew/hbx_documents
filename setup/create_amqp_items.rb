class SetupAmqpTasks
  def initialize
    conn = Bunny.new(ExchangeInformation.amqp_uri)
    conn.start
    @ch = conn.create_channel
    @ch.prefetch(1)
  end

  def queue(q)
    @ch.queue(q, :durable => true)
  end

  def exchange(e_type, name)
    @ch.send(e_type.to_sym, name, {:durable => true})
  end

  def logging_queue(ec, name)
    q_name = "#{ec.hbx_id}.#{ec.environment}.q.#{name}"
    @ch.queue(q_name, :durable => true)
  end

  def run
    ec = ExchangeInformation
    mdl_q = queue(Listeners::MemberDocumentLister.queue_name)
    direct_ex = exchange("direct", ec.request_exchange)
    mdl_q.bind(direct_ex, {:routing_key => Listeners::MemberDocumentLister.routing_key})
  end
end

SetupAmqpTasks.new.run
