module Parsers
  class PersonMatchIdentity
    include HappyMapper

    register_namespace "cv", "http://openhbx.org/api/terms/1.0"
    tag 'identity'
    namespace "cv"

    element :name_first, String
    element :name_last, String
    element :ssn, String
    element :dob, String
    element :email, String
    element :hbx_member_id, String

    def to_person_match
      data = {
        
      }
      if !name_first.blank?
        data[:name_first] = name_first
      end
      if !name_last.blank?
        data[:name_last] = name_last
      end
      if !ssn.blank?
        data[:ssn] = ssn
      end
      if !dob.blank?
        data[:dob] = dob
      end
      if !email.blank?
        data[:email] = email
      end
      if !hbx_member_id.blank?
        data[:hbx_member_id] = hbx_member_id
      end
      data
    end
  end

end
