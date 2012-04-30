require 'spec_helper'

describe User do
  ROLES = %w[ admin moderator reader ]

  # validations
  ROLES.each do |role|
    it "allows value #{role} for *role*" do
      should allow_value(role).for :role
    end
  end
  
  it "don't allows value 'some value' for *role*" do
    should_not allow_value('some value').for :role
  end
  
  it "validates presence of *nickname*" do 
    should validate_presence_of :nickname
  end
  
  it "validates presence of *email*" do
    should validate_presence_of :email
  end
  
  it "allows value 'real_email@email.com' for *email*" do 
    should allow_value('real_email@email.com').for :email
  end
  
  it "not allows value 'fakemail' for *email*" do
    should_not allow_value("fakemail").for :email
  end
  
  it "ensures length of *nickname* is at least 3 chars and is at most 20 chars" do
    should ensure_length_of(:nickname).is_at_least(3).is_at_most 20
  end
  
  it "ensures length of *nickname* is at least 2 chars and is at most 20 chars" do
    should ensure_length_of(:first_name).is_at_least(2).is_at_most 20
  end
    
  it "ensures length of *nickname* is at least 2 chars and is at most 20 chars" do
    should ensure_length_of(:last_name).is_at_least(2).is_at_most 20
  end 

  # security
  it "allows mass assignment of *role*" do
    should allow_mass_assignment_of :role
  end
  it "allows mass assignment of *role*" do
    should allow_mass_assignment_of :nickname
  end
  
  it "allows mass assignment of *first_name*" do
    should allow_mass_assignment_of :first_name
  end
  
  it "allows mass assignment of *last_name*" do
    should allow_mass_assignment_of :last_name
  end

  # associations
  RESTYPES.each do |resource|
    it "has many *#{resource.underscore}*" do
      have_many resource.underscore.to_sym
    end
  end
  
  # helpers
  describe 'helpers' do
    before :all do
      @user      = FactoryGirl.create :reader_user
      @admin     = FactoryGirl.create :admin_user
      @moderator = FactoryGirl.create :moderator_user
    end
    
    describe "reader" do
      subject { @user }
    
      its(:full_name)  { should == "#{@user.first_name} #{@user.last_name}" }
      its(:is_reader?) { should be_true }
    end
    
    describe "admin" do
      subject { @admin }
    
      its(:is_admin?) { should be_true }
    end
    
    describe "moderator" do
      subject { @moderator }
    
      its(:is_moderator?) { should be_true }
    end
  end
end