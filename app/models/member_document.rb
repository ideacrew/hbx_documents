class MemberDocument
  include Mongoid::Document

  field (:member_id, :type => String)
  field (:document_id, :type => String)
  field (:document_kind, :type => String)
  field (:document_name, :type => String)

  index({:member_id => 1})
  index({:document_kind => 1})
  index({:document_id => 1})
end
