module Parsers
  class DocumentGetRequest
    include HappyMapper
    register_namespace "cv", "http://openhbx.org/api/terms/1.0"
    tag 'member_document'
    namespace 'cv'

    has_one :identity, Parsers::PersonMatchIdentity
    element :document_id, String, :tag => "document_id"
  end
end
