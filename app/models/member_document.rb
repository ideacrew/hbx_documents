class MemberDocument
  include Mongoid::Document

  before_save :set_upload_date

  field(:member_id, :type => String)
  field(:document_id, :type => String)
  field(:document_kind, :type => String)
  field(:document_name, :type => String)
  field(:upload_date, :type => Time)
  field(:update_date, :type => Time)

  index({:member_id => 1})
  index({:document_kind => 1})
  index({:document_id => 1})
  index({:upload_date => 1})

  def to_s
    "member_id: #{member_id}, document_id: #{document_id}, document_kind: #{document_kind}, document_name: #{document_name}, upload_date: #{upload_date}"
  end

  private

  def set_upload_date
    if self.upload_date.blank?
      self.upload_date = Time.now.utc
    else
      set_update_date
    end
  end

  def set_update_date
    self.update_date = Time.now.utc
  end
end
