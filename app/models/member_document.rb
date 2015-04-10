class MemberDocument
  include Mongoid::Document

  field(:member_id, :type => String)
  field(:document_id, :type => String)
  field(:document_kind, :type => String)
  field(:document_name, :type => String)

  index({:member_id => 1})
  index({:document_kind => 1})
  index({:document_id => 1})

  def to_s
    "member_id: #{member_id}, document_id: #{document_id}, document_kind: #{document_kind}, document_name: #{document_name}"
  end
end
