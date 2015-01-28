module Parser
  class DocumentListRequest
    include HappyMapper
    register_namespace "cv", "http://openhbx.org/api/terms/1.0"
    tag 'document_list'
    namespace 'cv'

    has_many :document, Parser::DocumentListItem
  end
end
