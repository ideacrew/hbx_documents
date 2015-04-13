HbxDocuments::App.controllers :member_documents do

  get :new, :map => "member_documents/new" do
    render 'member_documents/new'
  end

  get :edit, :map => "/member_documents/:id/edit" do
    @member_document = MemberDocument.find(params[:id])
    render 'edit'
  end

  delete :destroy, :map =>"member_documents/:id" do
    member_document = nil
    begin
      member_document = MemberDocument.find(params[:id])
      document_id = member_document.document_id
      member_document.delete
      redirect('/member_documents', :notice => "Deleted Member Document #{document_id}.\n")
    rescue Exception=>e
      redirect("/member_documents", :notice => "Error deleting Member Document\n" + e.message, :status => '422')
    end
  end

  post :store, :map => "/member_documents" do
    begin
      file = params[:file]
      if file.blank? || file[:tempfile].blank?
        redirect('/member_documents/new', :notice => "Error. File missing.\n", :status => '422')
        return
      end

      tempfile = file[:tempfile]
      content_type = params[:content_type] || "application/octet-stream"
      file_name = params[:file_name] || params[:file][:filename]

      stored_file = StoredFile.store(file_name, content_type, tempfile)

      document_kind = "1095A"
      if file_name.downcase.include?("corrected")
        document_kind = "1095A Correction"
      end

      serial_number, hbx, num2, member_id, policy_id, *whatevs = file_name.split(".").first.split("_")

      member_document = MemberDocument.create!(
          :document_id => stored_file.id,
          :document_name => file_name,
          :document_kind => document_kind,
          :member_id => member_id
      )
      redirect('/member_documents/new', :notice => "Successfully processed file #{file_name} member_document: #{member_document}", :status => '200')
    rescue Exception=>e
      redirect('/member_documents/new', :notice => "Error processing file #{file_name}.\n" + e.message, :status => '422')
    end
  end

  get :index, :map => "/member_documents" do
    @member_documents = MemberDocument.all
    render 'index'
  end

=begin
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
=end

  post :download , :map => "/member_documents/:id/download" do
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
