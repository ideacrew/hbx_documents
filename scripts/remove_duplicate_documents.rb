@documents = MemberDocument.all

puts "Initial group count #{@documents.count}"

doc_group = @documents.group_by do |doc|
  doc.document_name
end

puts "Doc group count #{doc_group.count}"

doc_group.each do |doc_name, docs|
  next if docs.size == 1
  MemberDocument.where(document_name: docs.last.document_name).last.delete
end

puts "New count from db #{MemberDocument.count}"

