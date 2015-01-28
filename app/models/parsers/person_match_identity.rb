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
  end

  def to_person_match

  end
end
