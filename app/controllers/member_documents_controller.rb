HbxDocuments::App.controllers :member_documents do
  post :list, :map => "/member_documents" do
    xml = request.body.read
    doc_service = Services::ListMemberDocuments.new
    res_code, res_body = doc_service.call(xml)
    if res_code != "200"
      halt res_code.to_i, ""
    end
    status res_code
    content_type "application/xml"
    body res_body
  end

#  post :download , :map => "/member_documents/:id" do
#  end
end
