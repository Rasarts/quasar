require 'spec_helper'

describe AttachmentLink do
  COLUMNS = %w[ attachment_id master_id attachment_type master_type removable ]

  # validations
  it 'validates presence of master_id' do
    should validate_presence_of :master_id
  end
  
  it 'validates presence of attachment_id' do
    should validate_presence_of :attachment_id
  end
  
  it 'validates presence of attachment_type' do
    should validate_presence_of :attachment_type
  end
  
  it 'validates presence of master_type' do
    should validate_presence_of :master_type
  end

  # asssociations
  it 'belongs to *master*' do
    should belong_to :master
  end
  
  it 'belongs to *attachment*' do
    should belong_to :attachment
  end
  
  # security and attributes
  COLUMNS.each do |column|
    it "allows mass assigment of #{column}" do
      should allow_mass_assignment_of column.to_sym
    end
  end
end
