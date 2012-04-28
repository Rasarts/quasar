require 'spec_helper'

describe Attachment do
  # validations
  it 'validate presence of master_document_id' do
    should validate_presence_of :master_document_id
  end
  
  it 'validate presence of slave_document_id' do
    should validate_presence_of :slave_document_id
  end
  
  it 'validate presence of slave_document_type' do
    should validate_presence_of :slave_document_type
  end

  # asssociations
  it 'belong to *master_document*' do
    should belong_to :master_document
  end
  
  it 'belong to *slave_document*' do
    should belong_to :slave_document
  end
  
  # security and attributes
  %w[ slave_document_id master_document_id slave_document_type removable ].each do |column|
    it "allow mass assigment of #{column}" do
      should allow_mass_assignment_of column.to_sym
    end
  end
end
