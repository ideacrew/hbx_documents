module Services
  class ListMemberDocuments
    def initialize(member_document_class = MemberDocument, body_parser_class = Parsers::DocumentListRequest)
      @doc_class = member_document_class
      @parser_klass = body_parser_class
    end

    def construct_pipeline
      failure = Fail.new
      failure.bind do |identity|
        properties = {
          :routing_key => "person.match",
          :headers => identity.to_person_match
        }
        req = Amqp::Requestor.default
        req.request(properties, "")
      end
      failure.bind do |person_match_response|
        di, rprops, r_payload = person_match_response
        rs = response_status_for(rprops)
        if rs != "200"
          throw :fail, [rs, nil]
        end
        extract_member_id(r_payload)
      end
      failure.bind do |person_match_result|
        ["200", docs_for_member(m_id)]
      end
      failure
    end

    def call(xml)
      data = @parser_klass.parse(xml)
      pipeline = construct_pipeline
      begin
        pipeline.call(data.identity)
      rescue
        ["422", nil]
      end
    end

    def response_status_for(props)
      props.headers["return_status"]
    end

    def extract_member_id(r_payload)
      xml = Nokogiri::XML(r_payload)
      xml.at_xpath("//cv:person/cv:id/cv:id", nses).content
    end

    def nses
      { "cv" => "http://openhbx.org/api/terms/1.0" }
    end

    def docs_for_member(m_id)
      docs = MemberDocument.where("member_id" => m_id)
      gen_doc = Parsers::DocumentListResponse.new
      dlis = []
      docs.each do |doc|
        dli = Parsers::DocumentListItem.new
        puts doc.document_id.inspect
        dli.document_id = doc.document_id
        dli.document_kind = doc.document_kind
        dli.document_name = doc.document_name
        dlis << dli
      end
      gen_doc.document = dlis
      gen_doc.to_xml
    end
  end
end
