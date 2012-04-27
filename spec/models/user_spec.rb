require 'spec_helper'

describe User do
  # validations
  %w[ user moderator reader ].each do |role_name|
    it "allow value #{role_name} for *role*" do
      should allow_value(role_name).for :role
    end
  end
  
  it "not allow value 'some value' for *role*" do
    should_not allow_value('some value').for :role
  end
  
  it "validate presence of *nickname*" do 
    should validate_presence_of :nickname
  end
  
  it "validate presence of *email*" do
    should validate_presence_of :email
  end
  
  it "allow value 'real_email@email.com' for *email*" do 
    should allow_value('real_email@email.com').for :email
  end
  
  it "not allow value 'fakemail' for *email*" do
    should_not allow_value("fakemail").for :email
  end
  
  it "ensure length of *nickname* is at least 3 chars and is at most 20 chars" do
    should ensure_length_of(:nickname).is_at_least(3).is_at_most 20
  end
  
  it "ensure length of *nickname* is at least 2 chars and is at most 20 chars" do
    should ensure_length_of(:first_name).is_at_least(2).is_at_most 20
  end
    
  it "ensure length of *nickname* is at least 2 chars and is at most 20 chars" do
    should ensure_length_of(:last_name).is_at_least(2).is_at_most 20
  end 

  # security
  it "allow mass assignment of *role*" do
    should allow_mass_assignment_of :role
  end
  it "allow mass assignment of *role*" do
    should allow_mass_assignment_of :nickname
  end
  
  it "allow mass assignment of *first_name*" do
    should allow_mass_assignment_of :first_name
  end
  
  it "allow mass assignment of *last_name*" do
    should allow_mass_assignment_of :last_name
  end

  # associations
  it { should have_many :documents }
  
  # helpers
  describe 'helpers' do
    before :each do
      @user      = FactoryGirl.create :user
      @admin     = FactoryGirl.create :admin_user
      @moderator = FactoryGirl.create :moderator_user
    end
    
    # for reader
    subject = @user
    
    its(:full_name)  { should == 'Test User' }
    its(:is_reader?) { should be_true }
    
    # for admin
    subject = @admin
    
    its(:is_admin?) { should be_true }
    
    # for moderator
    subject = @moderator
    
    its(:is_moderator?) { should be_true }
    
  end
  
end
