require 'spec_helper'

describe Article do
  STATUSES = %w[ published moderated in_moderation in_work removed ]

  # validations
  it 'validate presence of title' do
    should validate_presence_of :title
  end
  
  it 'validate presence of content' do
    should validate_presence_of :content
  end
  
  it 'validate presence of user_id' do
    should validate_presence_of :user_id
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
  it 'have many *attachments*' do
    should have_many(:attachments).dependent :destroy
  end
  
  it 'have many *master_documents* through attachments' do
    should have_many(:master_documents).through :attachments
  end
  
  it 'have many *slave_documents* through attachments' do
    should have_many(:slave_documents).through :attachments
  end
  
end