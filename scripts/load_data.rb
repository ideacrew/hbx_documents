class DataLoaderFor1095A
  def initialize
  end

  def load
#    MemberDocument.delete_all
#    StoredFileChunk.delete_all
#    StoredFile.delete_all
    files = Dir.glob(File.join(Padrino.root, "test_data/**", "*.pdf"))
    total = files.length
    puts total
    pb = ProgressBar.create(
       :title => "Loading pdfs",
       :total => total,
       :format => "%t %a %e |%B| %P%%"
    )
    files.each do |f|
      f_name = File.basename(f)
      upload_name = f_name
      document_kind = "1095A"
      if f_name.downcase.include?("corrected")
        document_kind = "1095A Correction"
      end
      ct = "application/pdf"
      num1, hbx, num2, m_id, p_id, *whatevs = f_name.split(".").first.split("_")
      in_io = File.open(f, 'rb')
      sf = StoredFile.store(upload_name, ct, in_io)
      sf.id
      MemberDocument.create!(
        :document_id => sf.id,
        :document_name => upload_name,
        :document_kind => document_kind,
        :member_id => m_id
      )
      in_io.close
      pb.increment
    end
  end

  def self.run
    self.new.load
  end
end

DataLoaderFor1095A.run
