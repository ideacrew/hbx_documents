HbxDocuments::App.controllers :member_documents do
  post :list, :map => "/member_documents" do
    xml = request.body.read
    doc_service = Services::ListMemberDocuments.new
    res_code, res_body = doc_service.call(xml)
    if res_code != "200"
      halt res_code.to_i, ""
    end
    status res_code.to_i
    content_type "application/xml"
    body res_body
  end

  post :download , :map => "/member_documents/:id" do
    xml = request.body.read
    doc_service = Services::GetMemberDocument.new
    res_code, doc_id = doc_service.call(xml, params[:id])
    if res_code != "200"
      halt res_code.to_i, ""
    end
    sf = StoredFile.where({"id" => doc_id}).first
    status 200
    content_type sf.contentType
    response['Content-Disposition'] = "inline;filename=\"#{URI.escape(sf.filename)}\""
    stream do |out|
      sf.each_chunk do |chunk|
        out << chunk
      end
    end
  end
end
