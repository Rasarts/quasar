class Article < ActiveRecord::Base
  attr_accessible :content, :description, :status, :title, :creator_id
    
  STATUSES= %w[ published moderated in_moderation in_work removed ]

  # validations
  validates :title,      presence: true
  validates :content,    presence: true
  validates :status,     presence: true, inclusion: { in: STATUSES }
  validates :creator_id, presence: true
  
  # associations
  belongs_to :creator, class_name: 'User'
  
  # get list of associated attachment_links
  def attachment_links()
    @attachment_links ||= AttachmentLink.where("master_id = ? AND master_type = ?", id,  class_name)
  end

  def master_links()
    @master_links ||= AttachmentLink.where("attachment_id = ? AND attachment_type = ?", id,  class_name)
  end
  
  # get hash of attachments { "AttachmentClass" => [...] }
  def attachments()
    @attachments ||= {}
    
    if @attachments.empty?
      attachment_links.each do |attlink|
        attclass_name = attlink.attachment_type
        attclass = attclass_name.constantize
        attachment = attclass.where(id: attlink.attachment_id).limit(1)
        @attachments[attclass_name] ||= []

        unless @attachments[attclass_name].include? attachment
          @attachments[attclass_name] << attachment
        end
      end
    end

    return @attachments
  end
  
  # get hash of master_resources
  def master_resources
    @master_resources ||= {}
    
    if @master_resources.empty?
      master_links.each do |master_link|
        master_class_name = master_link.master_type
        master_class = master_class_name.constantize
        @master_resources[master_class_name] ||= []
        @master_resources[master_class_name] << master_class.where(id: master_link.master_id).limit(1)
      end
    end

    return @master_resources
  end

  def master(master_class)
    master_resources[master_class.to_s.singularize.classify]
  end
  
  # attaches attachment to article
  def attach(attachment)
    new_attlink(attachment).save
    reload_attachments_with attachment  
  end

  # create new AttributeLink record with current record as master but don't save it
  def new_attlink(attachment = nil)
    AttachmentLink.new do |attlink|
      attlink.master_id   = self.id
      attlink.master_type = class_name
      
      if attachment.present?
        attlink.attachment_id   = attachment.id
        attlink.attachment_type = attachment.class_name
      end
    end
  end

  def has_attachments?
    attachments.present?
  end

  def class_name
    self.class.to_s
  end

  def attached(attclass)
    attachments[attclass.to_s.classify]
  end

  def has_attached?(attclass)
    attached(attclass).present?
  end

  def has_master?(master_class)
    master(master_class).present?
  end

  def method_missing(method_name, *args, &block)
    if RESTYPES.include? method_name.to_s.classify
      return attachments[method_name.to_s.classify]
    else
      super method_name, args, block
    end
  end



  private
  
  # add attachment to @attachments
  def reload_attachments_with(attachment)
    attachments[attachment.class.to_s] ||= []

    unless attachments[attachment.class.to_s].include? attachment
      attachments[attachment.class.to_s] << attachment
    end
  end
end
