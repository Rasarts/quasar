require 'spec_helper'

describe Article do
  STATUSES = %w[ published moderated in_moderation in_work removed ]
  COLUMNS  = %w[ content creator_id description title status ]

  # validations
  it 'validate presence of title' do
    should validate_presence_of :title
  end
  
  it 'validate presence of content' do
    should validate_presence_of :content
  end
  
  it 'validate presence of creator_id' do
    should validate_presence_of :creator_id
  end
  
  it 'validate presence of status' do
    should validate_presence_of :status
  end
    
  STATUSES.each do |status|
    it "allow value #{status} for status" do
      should allow_value(status).for :status
    end
  end
  
  it "don't allow value some value for status" do
    should_not allow_value('some value').for :status
  end
  
  # associations
  it 'have many *attachment_links*' do
    should have_many(:attachment_links).dependent :destroy
  end
  
  it 'have many *masters* through attachment_links' do
    should have_many(:masters).through :attachment_links
  end
  
  it 'have many *attachments* through attachment_links' do
    should have_many(:attachments).through :attachment_links
  end
  
  # security & attributes
  COLUMNS.each do |column|
    it "allow mass assignment for *#{column}*" do
      should allow_mass_assignment_of column.to_sym
    end
  end
  
end