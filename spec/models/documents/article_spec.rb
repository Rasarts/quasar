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

  describe 'attachments and masters' do
    let(:article)   { FactoryGirl.create :article }
    let(:article_2) { FactoryGirl.create :article, title: 'Second article' }

    before :all do
      article.attach article_2  
    end

    describe 'Master Article' do
      it 'can attach documents through #attach method' do
        article_3 = FactoryGirl.create :article, title: 'Third article'

        article.attach article_3
        article.attachments.size.should have(2).attachments
      end

      it 'responds to #attachments(only: :some_attachments)' do
        article.attachments(only: :some_attachments).size.should have(0).attachments
      end

      it 'responds to #attachments(except: :articles)' do
        article.attachments(except: :articles).size.should have(0).attachments
      end

      it 'responds to #has_attachments? with result true' do
        article.has_attachments?.should be_true
      end

      it 'responds to #has_attachments?(only: :some_documents)' do
        article.has_attachments?(only: :some_documents).should be_false
      end

      it 'responds to #has_attachments?(except: :articles)' do
        article.has_attachments?(except: :articles).should be_false
      end

      it 'responds to #articles with list of attached articles' do
        article.articles.should have(1).attachment
      end

      it 'responds to #attached_articles with list of attached articles' do
        article.attached_articles.shoul have(1).article
      end

      it 'responds to #has_attached(:articles)?' do
        article.has_attached_articles?.should be_true
      end
    end

    describe 'Attached Article' do
      it 'responds to #master_documents' do
        article_2.master_documents.should have(1).master_documents
      end

      it 'responds to #master(:articles)' do
        article_2.master(:articles).should have(1).articles
      end

      it 'responds to #master(only: :some_documents)' do
        article_2.master(only: :some_documents).should have(0).articles
      end

      it 'responds to #master(except: :articles)' do
        article_2.master(except: :articles).should have(0).articles
      end

      it 'responds to #master_articles' do
        article_2.master_articles have(1).articles
      end

      it 'responds to #has_master?(:articles)' do
        article_2.has_master?(:articles).should be_true
      end

      it 'responds to #has_master?(only: :some_documents)' do
        article_2.master(only: :some_documents).should be_false
      end

      it 'responds to #has_master?(except: :articles)' do
        article_2.master(except: :articles).should be_false
      end

    end
  end
end