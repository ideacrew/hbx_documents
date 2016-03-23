require 'csv'

op = CSV.open("policies.csv", "w")

@documents = MemberDocument.all

def file_status(document)
   if document.document_name =~ /_IRS1095A/
     return "2014 Original"
   elsif document.document_name =~ /_IRS1095ACorrected/
     return "2014 Corrected"
   elsif document.document_name =~ /IRS1095A_/
     return "2015 Original"
   elsif document.document_name =~ /IRS1095ACorrected_/
       return "2015 Corrected"
   else
     return "None"
   end
end

CSV.foreach('/Users/CitadelFirm/Downloads/policy.csv') do |row|
  @documents.where(document_name: /#{row[0]}/).each do |document|
    puts "#{document.document_name}  #{file_status(document)}"
    op << [row[0], file_status(document)]
  end
end