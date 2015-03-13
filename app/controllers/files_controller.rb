HbxDocuments::App.controllers :files do

  get :new, :map => "new" do
      render 'files/new'
  end

  post :store, :map => "/files" do
    file = params[:file]
    if file[:tempfile].blank?
      error 422
    end
    t_file = file[:tempfile]
    ct = params[:content_type] || "application/octet-stream"
    f_name = params[:file_name] || params[:file][:filename]
    sf = StoredFile.store(f_name, ct, t_file)
    status '202'
    sf.id
  end

  get :download, :map => "/files", :with => :id do
    sf = StoredFile.where({"id" => params[:id] }).first
    if sf
      content_type sf.contentType
      response['Content-Disposition'] = "inline;filename=\"#{URI.escape(sf.filename)}\""
      stream do |out|
        sf.each_chunk do |chunk|
          out << chunk
        end
      end
    else
      error 404
    end
  end
end
