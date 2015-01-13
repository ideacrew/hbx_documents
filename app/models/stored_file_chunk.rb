class StoredFileChunk
  include Mongoid::Document

  store_in :collection => "fs.chunks"
  field(:n, :type => Integer, :default => 0)
  field(:data, :type => (defined?(Moped::BSON) ? Moped::BSON::Binary : BSON::Binary))

  belongs_to(:file, :foreign_key => :file_id, :class_name => "StoredFile")

  index({:file_id => 1, :n => -1}, :unique => true)
end
