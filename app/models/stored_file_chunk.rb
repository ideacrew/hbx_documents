class StoredFileChunk
  include Mongoid::Document

  store_in :collection => "fs.chunks"
  field(:n, :type => Integer, :default => 0)
  field(:data, :type => (defined?(Moped::BSON) ? Moped::BSON::Binary : BSON::Binary))

  belongs_to(:file, :foreign_key => :files_id, :class_name => "StoredFile")

  index({:files_id => 1, :n => -1}, :unique => true)
end
