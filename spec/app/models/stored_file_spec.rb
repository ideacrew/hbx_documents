require 'spec_helper'

describe StoredFile do
  before(:all) do
    @file_name = "the file name"
    @content_type = "application/x-madeup-mimetype"
    @random_data = "a" * 5000000
    @it = StoredFile.store(@file_name, @content_type, StringIO.new(@random_data))
  end

  it "should create the right number of chunks" do
    expect(@it.chunks.length).to eql 3
  end

  after(:all) do
    StoredFileChunk.delete_all
    StoredFile.delete_all
  end
end
