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

  # security & attributes
  COLUMNS.each do |column|
    it "allows mass assignment for *#{column}*" do
      should allow_mass_assignment_of column.to_sym
    end
  end



  describe 'attachments and masters' do

    before :each do
      @article   = FactoryGirl.create :article
      @article_2 = FactoryGirl.create :article, title: 'Second article'
      @article_3 = FactoryGirl.create :article, title: 'Third article'
      @article.attach @article_2
    end

    # some helpers
    it 'responds to #name' do
      @article.name.should == @article.title
    end

    describe 'Master Article' do
      it 'responds to #attachment_links' do
        @article.should respond_to :attachment_links
      end

      it 'responds to #attach' do
        @article.should respond_to :attach
      end

      it 'responds to #attachments' do
        @article.should respond_to :attachments
      end

      it 'can attach resources through #attach method' do
        @article.attach @article_3
        @article.attachments["Article"].should have(3).attachments
      end

      it 'responds to #attachments(only: :some_attachments)' do
        pending
        @article.attachments(only: :some_attachments).size.should have(0).attachments
      end

      it 'responds to #attachments(except: :articles)' do
        pending
        @article.attachments(except: :articles).size.should have(0).attachments
      end

      it 'responds to #has_attachments? with result true' do
        @article.has_attachments?.should be_true
      end

      it 'responds to #has_attachments?(only: :some_resources)' do
        pending
        @article.has_attachments?(only: :some_resources).should be_false
      end

      it 'responds to #has_attachments?(except: :articles)' do
        pending
        @article.has_attachments?(except: :articles).should be_false
      end

      it 'responds to #articles with list of attached articles' do
        pending
        @article.articles.should have(2).attachment
      end

      it 'responds to #attached(:articles) with list of attached articles' do
        @article.attached(:articles).should have(2).articles
      end

      it 'responds to #has_attached(:articles)?' do
        @article.has_attached?(:articles).should be_true
      end

      it 'has attachments count' do
        @article.attach @article_3
        @article.attachments_count.should == 2
      end

      it 'after destroy destroys all associated attachment links' do
        @article.destroy
        @article.attachment_links.size.should == 0
      end
    end

    describe 'Attached Article' do
      it 'responds to #masters' do
        @article_2.masters.should have(1).master_resource
      end

      it 'responds to #master(:articles)' do
        @article_2.master(:articles).should have(1).article
      end

      it 'responds to #master(only: :some_resources)' do
        pending
        @article_2.master(only: :some_resources).should have(0).articles
      end

      it 'responds to #master(except: :articles)' do
        pending
        @article_2.master(except: :articles).should have(0).articles
      end

      it 'responds to #master_articles' do
        pending
        @article_2.master_articles have(1).articles
      end

      it 'responds to #has_master?(:articles)' do
        @article_2.has_master?(:articles).should be_true
      end

      it 'responds to #has_master?(only: :some_resources)' do
        pending
        @article_2.master(only: :some_resources).should be_false
      end

      it 'responds to #has_master?(except: :articles)' do
        pending
        @article_2.master(except: :articles).should be_false
      end

      it 'has masters count' do
        @article_3.attach @article_2
        @article_2.masters_count.should == 2
      end

      it 'after destroy destroys all associated master links' do
        @article_2.destroy
        @article_2.master_links.size.should == 0
      end

    end
  end
end