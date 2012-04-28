require 'spec_helper'

describe Document do
  
  # validations
  it 'validates presence of title' do
    should validate_presence_of :title
  end
  
  it 'validates presence of creator_id' do
    should validate_presence_of :creator_id
  end
  
  # associations
  it 'belong to *creator (user)*' do
    should belong_to :creator
  end
  
  it 'have many *attachments*' do
    #pending "attachments doesn't present yet"
    should have_many(:attachments).dependent :destroy
  end
  
  it 'have many *master_documents (documents)* through attachments' do
    #pending "attachments doesn't present yet"
    should have_many(:master_documents).through :attachments
  end
  
  it 'have many *slave_documents (documents)* through attachments' do
    #pending "attachments doesn't present yet"
    should have_many(:slave_documents).through :attachments
  end
  
  # security & attributes
  %w[content creator_id description title].each do |column|
    it "allow mass assignment for *#{column}*" do
      should allow_mass_assignment_of column.to_sym
    end
  end
  
end
