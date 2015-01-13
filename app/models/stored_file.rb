class StoredFile
  include Mongoid::Document

  CHUNK_SIZE = (2 ** 21)

  store_in :collection => "fs.files"

  field :name, type: String
  field(:length, :type => Integer, :default => 0)
  field(:chunkSize, :type => Integer, :default => CHUNK_SIZE)
  field(:uploadDate, :type => Time, :default => Time.now.utc)
  field(:md5, :type => String, :default => Digest::MD5.hexdigest(''))

  field(:filename, :type => String)
  field(:contentType, :type => String, :default => 'application/octet-stream')

  index({:filename => 1})
  index({:uploadDate => 1})
  index({:md5 => 1})

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
    total_length = 0
    md5digest = Digest::MD5.new
    io.rewind if io.respond_to?(:rewind)
    while (data = io.read(self.chunkSize))
      md5digest << data
      StoredFileChunk.create!(
        n: n,
        data: binary_for(data),
        file_id: self.id
      )
      total_length = total_length + data.size
      n = n + 1
    end
    self.length = total_length
    self.md5 = md5digest.hexdigest
    self.save!
  end

  protected
  def binary_for(*buf)
    if defined?(Moped::BSON)
      Moped::BSON::Binary.new(:generic, buf.join)
    else
      BSON::Binary.new(buf.join, :generic)
    end
  end
end
