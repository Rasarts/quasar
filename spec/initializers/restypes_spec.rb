require 'spec_helper'

describe 'RESTYPES' do
  it 'inludes all documents' do
    RESTYPES.size.should == Dir.glob("#{Rails.root}/app/models/resources/*").size
  end
end