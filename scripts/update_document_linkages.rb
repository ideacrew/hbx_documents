require 'fileutils'

# Usage
# padrino r scripts/update_document_linkages.rb
# Requires a spreadsheet that should be placed in the root directory. It should have a filename of documents_to_update.csv

CSV.foreach("documents_to_update.csv", headers: true) do |csv_row|
  data = csv_row.to_h
  old_hbx_id = data["non_authority_id"]
  new_hbx_id = data["authority_id"]
  documents = MemberDocument.where(member_id: old_hbx_id)
  documents.each do |document|
    document.update_attributes!(member_id: new_hbx_id)
    puts "#{document.document_id}'s HBX ID was updated from #{old_hbx_id} to #{new_hbx_id}"
  end
end