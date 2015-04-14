require 'spec_helper'

describe "get /member_documents/new" do
  it "should have the form" do
    visit '/member_documents/new'
    expect(last_response.body.include?("Upload Member Document")).to be_truthy
  end
end