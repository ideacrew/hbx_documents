class DataLoaderFor1095A
  def initialize
  end

  def load
    files = Dir.glob(File.join(Padrino.root, "test_data", "*.pdf"))
    files.each do |f|
      f_name = File.basename(f)
      upload_name = f_name
      ct = "application/pdf"
      num1, hbx, num2, m_id, p_id, *whatevs = f_name.split(".").first.split("_")
      in_io = File.open(f, 'rb')
      sf = StoredFile.store(upload_name, ct, in_io)
      sf.id
      MemberDocument.create!(
        :document_id => sf.id,
        :document_name => upload_name,
        :document_kind => "1095A",
        :member_id => m_id
      )
      in_io.close
    end
  end

  def self.run
    self.new.load
  end
end

DataLoaderFor1095A.run
