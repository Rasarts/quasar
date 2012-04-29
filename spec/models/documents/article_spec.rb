require 'spec_helper'

describe Article do
  STATUSES = %w[ published moderated in_moderation in_work removed ]
  COLUMNS  = %w[ content creator_id description title status ]

  # validations
  it 'validates presence of title' do
    should validate_presence_of :title
  end
  
  it 'validates presence of content' do
    should validate_presence_of :content
  end
  
  it 'validates presence of creator_id' do
    should validate_presence_of :creator_id
  end
  
  it 'validates presence of status' do
    should validate_presence_of :status
  end
    
  STATUSES.each do |status|
    it "allows value #{status} for status" do
      should allow_value(status).for :status
    end
  end
  
  it "don't allows value 'some value' for status" do
    should_not allow_value('some value').for :status
  end
  
  # associations
  it 'belongs to *creator (user)*' do
    should belong_to :creator
  end
  
  it 'has many *attachment_links*' do
    should have_many(:attachment_links).dependent :destroy
  end
  
  it 'has many *masters* through attachment_links' do
    should have_many(:masters).through :attachment_links
  end
  
  it 'has many *attachments* through attachment_links' do
    should have_many(:attachments).through :attachment_links
  end
  
  # security & attributes
  COLUMNS.each do |column|
    it "allows mass assignment for *#{column}*" do
      should allow_mass_assignment_of column.to_sym
    end
  end
  
end