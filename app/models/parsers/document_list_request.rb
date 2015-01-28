module Parser
  class DocumentListRequest
    include HappyMapper
    register_namespace "cv", "http://openhbx.org/api/terms/1.0"
    tag 'member_documents'
    namespace 'cv'

    has_one :identity, Parsers::PersonMatchIdentity
  end
end
