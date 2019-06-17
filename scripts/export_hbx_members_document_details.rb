#  frozen_string_literal: true

require 'csv'
require 'fileutils'
class ExportHbxMembers1095A
  def initialize
    @filed_names = %w[HBX\ Member\ IDS Document\ Name]
    export_deatils
  end

  def export_deatils
    time_stamp = Time.now.utc.strftime("%Y%m%d_%H%M%S")
    file_name = File.expand_path("public/hbx_documents_memberid_document_#{time_stamp}.csv", Padrino.root)

    kollection = fetch_record_collections
    puts "Total number of Member Documents collection count is #{kollection.count}"

    CSV.open(file_name, "w", force_quotes: true) do |csv|
      csv << @field_names
      kollection.each do |member_document|
        csv << [member_document.send(:member_id),
                member_document.send(:document_name)]
      end
    end
  end

  def fetch_record_collections
    MemberDocument.where(:document_name.exists => true)
  end
end

ExportHbxMembers1095A.new
