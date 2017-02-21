require 'fileutils'

class DataLoaderFor1095A

  def initialize
    @source_dir = "1095A_documents"
  end

  def load
    puts "Initial document count in database: #{MemberDocument.count}"

    Dir.mkdir(@source_dir) unless File.exists?(@source_dir)

    files = Dir.glob(File.join(Padrino.root, "#{@source_dir}/**", "*.pdf"))

    puts "Total number of files to upload: #{files.length}"

    pb = ProgressBar.create(
       :title => "Loading pdfs",
       :total => files.length,
       :format => "%t %a %e |%B| %P%%"
    )

    files.each do |f|
      f_name = File.basename(f)

      if MemberDocument.where(document_name: f_name).count > 0
        puts "Duplicate document with name: #{f_name}. Skipping"
        next
      end

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
      member_document = MemberDocument.create!(
        :document_id => sf.id,
        :document_name => upload_name,
        :document_kind => document_kind,
        :member_id => m_id
      )

      in_io.close
      pb.increment
    end

    puts "Final document count in database: #{MemberDocument.count}"

    FileUtils.rm_rf Dir.glob(File.join(Padrino.root, "#{@source_dir}", '*'))
  end

  def self.run
    self.new.load
  end
end

DataLoaderFor1095A.run
