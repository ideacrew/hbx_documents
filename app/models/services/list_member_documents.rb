module Services
  class ListMemberDocuments
    def initialize(member_document_class = MemberDocument, body_parser_class = Parsers::DocumentListRequest)
      @doc_class = member_document_class
      @parser_klass = body_parser_class
    end

    def call(xml)
      data = @parser_klass.parse(xml)
      if data == []
        return ["422", ""]
      end
      begin
        rc, m_id = call_person_match(data.identity)
        case rc
        when "200"
          ["200", docs_for_member(m_id)]
        when "409"
          ["409", nil]
        else
          ["404", nil]
        end
      rescue
        ["422", nil]
      end
    end

    def call_person_match(identity)
      req = Amqp::Requestor.default
      properties = {
        :routing_key => "person.match",
        :headers => identity.to_person_match
      }
      di, rprops, r_payload = req.request(properties, "")
      case response_status_for(rprops)
      when "200"
        return(["200", extract_member_id(r_payload)])
      when "409"
        puts r_payload
        return(["409", nil])
      else
        return(["404", nil])
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
