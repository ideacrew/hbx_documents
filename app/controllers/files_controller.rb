HbxDocuments::App.controllers :files do
  post :store, :map => "/files" do
    file = params[:file]
    ct = params[:content_type] || "application/octet-stream"
    f_name = params[:file_name]
    sf = StoredFile.store!(f_name, ct, file)
  end

  get :download, :map => "/files", :with => :id do
    sf = StoredFile.where(params[:id]).first
    if sf
      content_type sf.contentType
      response['Content-Disposition'] = "attachment;filename=\"#{URI.escape(sf.filename)}\""
      stream do |out|
        sf.with_chunks do |chunk|
          out << chunk
        end
      end
    else
      error 404
    end
  end
end
