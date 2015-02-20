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
        conn = Bunny.new(ExchangeInformation.amqp_uri)
        conn.start
        begin
          req = Amqp::Requestor.new(conn)
          di, rprops, r_payload = req.request(properties, "")
          rs = response_status_for(rprops)
          if rs != "200"
            throw :fail, [rs, nil]
          end
          validate_identity_data(identity, r_payload)
        ensure
          conn.close
        end
      end
      failure.bind do |person_match_result|
        rs, m_id = person_match_result
        if rs != "200"
          throw :fail, [rs, nil]
        end
        ["200", docs_for_member(m_id)]
      end
      failure
    end

    def call(xml)
      data = @parser_klass.parse(xml)
      pipeline = construct_pipeline
      #      begin
      pipeline.call(data.identity)
      #     rescue
      #       ["422", nil]
      #     end
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
      gen_doc = Parsers::DocumentListResponse.from_documents(docs)
      gen_doc.to_xml
    end

    def validate_identity_data(identity, r_payload)
      if [identity.name_first, identity.name_last, identity.dob, identity.ssn].any?(&:blank?)
        return ["422", nil]
      end
      id_data = extract_identity_data(r_payload)
      if (identity.dob != id_data[:dob])
        return ["409", nil]
      end 
      if (identity.ssn != id_data[:ssn])
        return ["409", nil]
      end
      if !compare_without_case(identity.name_first,id_data[:name_first])
        return ["409", nil]
      end
      if !compare_without_case(identity.name_last,id_data[:name_last])
        return ["409", nil]
      end
      ["200", id_data[:hbx_member_id]]
    end

    def compare_without_case(prop1, prop2)
      val1 = Maybe.new(prop1).strip.downcase.value
      val2 = Maybe.new(prop2).strip.downcase.value
      val1 == val2
    end

    def extract_identity_data(r_payload)
      xml = Nokogiri::XML(r_payload)
      {
        :hbx_member_id => Maybe.new(xml.at_xpath("//cv:person/cv:id/cv:id", nses)).content.value,
        :name_first => Maybe.new(xml.at_xpath("//cv:person/cv:person_name/cv:person_given_name", nses)).content.value,
        :name_last => Maybe.new(xml.at_xpath("//cv:person/cv:person_name/cv:person_surname", nses)).content.value,
        :ssn => Maybe.new(xml.at_xpath("//cv:person_demographics/cv:ssn", nses)).content.value,
        :dob => Maybe.new(xml.at_xpath("//cv:person_demographics/cv:birth_date", nses)).content.value
      }
    end
  end
end
