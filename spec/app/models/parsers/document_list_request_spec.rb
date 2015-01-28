require 'spec_helper'

describe Parsers::DocumentListRequest do
  before(:all) do
    xml_file = File.open(File.join(Padrino.root, "spec", "data", "app/models/parsers/document_list_request.xml")).read
    @subject = Parsers::DocumentListRequest.parse(xml_file)
    @identity = @subject.identity
  end

  it "should have the right name elements" do
    expect(@identity.name_first).to eq "First"
    expect(@identity.name_last).to eq "Last"
  end

  it "should have the right dob" do
    expect(@identity.dob).to eq "19830125"
  end

  it "should have the right ssn" do
    expect(@identity.ssn).to eq "123451234"
  end

  it "should have the right email" do
    expect(@identity.email).to eq "email@me.com"
  end

  it "should have the right member_id" do
    expect(@identity.hbx_member_id).to eq "12345"
  end
end
