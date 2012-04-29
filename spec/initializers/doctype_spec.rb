require 'spec_helper'

describe 'DOCTYPES' do
  it 'inludes all documents' do
    DOCTYPES.size.should == Dir.glob("#{Rails.root}/app/models/documents/*").size
  end
end