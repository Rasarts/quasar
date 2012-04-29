require 'spec_helper'

describe Document do
  COLUMNS = %w[content creator_id description title]
  
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
  
  it 'have many *attachment_links*' do
    #pending "attachments doesn't present yet"
    should have_many(:attachment_links).dependent :destroy
  end
  
  it 'have many *masters (documents)* through attachment_links' do
    #pending "attachments doesn't present yet"
    should have_many(:masters).through :attachment_links
  end
  
  it 'have many *attachments (documents)* through attachment_links' do
    #pending "attachments doesn't present yet"
    should have_many(:attachments).through :attachment_links
  end
  
  # security & attributes
  COLUMNS.each do |column|
    it "allow mass assignment for *#{column}*" do
      should allow_mass_assignment_of column.to_sym
    end
  end
  
end
