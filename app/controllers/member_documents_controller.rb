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
      member_document.delete
      redirect('/member_documents', :notice => "Deleted Member Document #{params[:id]}.\n")
    rescue Exception=>e
      redirect("/member_documents/#{params[:id]}", :notice => "Error deleting Member Document #{params[:id]}.\n" + e.message, :status => '422')
    end
  end

  get :show, :map => "/member_documents/:id" do
    @member_document = MemberDocument.find(params[:id])
    render 'show'
  end

  post :update, :map => "/member_documents/:id" do
    begin
      @member_document = MemberDocument.find(params[:id])
      @member_document.document_name = params[:document_name]
      @member_document.document_kind = params[:document_kind]
      @member_document.member_id = params[:member_id]

      if params[:file]
        tempfile = params[:file][:tempfile]
        content_type = params[:content_type] || "application/octet-stream"
        file_name = params[:file][:filename]
        stored_file = StoredFile.store(file_name, content_type, tempfile)
        @member_document.document_id = stored_file.id
      end

      @member_document.save
      render 'show'
    rescue Exception => e
      redirect back, notice:"Failed to edit member document " + e.message
    end

  end

  post :store, :map => "/member_documents" do
    begin
      file = params[:file]
      if file[:tempfile].blank?
        error 422
      end

      tempfile = file[:tempfile]
      content_type = params[:content_type] || "application/octet-stream"
      file_name = params[:file_name] || params[:file][:filename]

      stored_file = StoredFile.store(file_name, content_type, tempfile)

      member_document = MemberDocument.create!(
          :document_id => stored_file.id,
          :document_name => params[:document_name],
          :document_kind => params[:file_name],
          :member_id => params[:member_id]
      )
      redirect('/member_documents/new', :notice => "Successfully processed file #{params[:file][:filename]} file id:#{stored_file.id} member_document: #{member_document.id}", :status => '200')
    rescue Exception=>e
      redirect('/member_documents/new', :notice => "Error processing file #{params[:file]}.\n" + e.message, :status => '422')
    end
  end

  get :index, :map => "/member_documents" do
    @member_documents = MemberDocument.all
    render 'index'
  end

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
