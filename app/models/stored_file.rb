class StoredFile
  include Mongoid::Document

  CHUNK_SIZE = 2 ** 21

  property :name, type: String
  store_in :collection => "fs.files"

  field(:length, :type => Integer, :default => 0)
  field(:chunkSize, :type => Integer, :default => CHUNK_SIZE)
  field(:uploadDate, :type => Time, :default => Time.now.utc)

  field(:filename, :type => String)
  field(:contentType, :type => String, :default => 'application/octet-stream')

  index({:filename => 1})
  index({:uploadDate => 1})

  has_many(:chunks, :class_name => "StoredFileChunk", :inverse_of => :file, :dependent => :destroy, :order => [:n, :asc])

  def self.store(file_name, ct, io)
    sf = self.create!({
      filename: file_name,
      contentType: ct
    })
    sf.write_data(io)
    sf
  end

  def write_data(io)
    n = 0
    length = 0
    io.rewind if io.respond_to?(:rewind)
    while (data = io.read(self.chunk_size))
      StoredFileChunk.create!(
        n: n,
        data: binary_for(data),
        file_id: self.id
      )
      self.length = self.length + data.size
      n = n + 1
    end
    self.save!
  end


  def binary_for(*buf)
    if defined?(Moped::BSON)
      Moped::BSON::Binary.new(:generic, buf.join)
    else
      BSON::Binary.new(buf.join, :generic)
    end
  end
end
