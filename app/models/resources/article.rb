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


  # callbacks

  after_destroy do
    # for masters
    decrement_attachments_count_on_masters
    destroy_attachment_links

    # for attachments
    decrement_masters_count_on_attachments
    destroy_all_master_links
  end


  # some helpers
  def name
    title
  end

  # get list of associated attachment_links
  def attachment_links()
    @attachment_links ||= AttachmentLink.where("master_id = ? AND master_type = ?", id,  class_name).limit(attachments_count)
  end

  def master_links()
    @master_links ||= AttachmentLink.where("attachment_id = ? AND attachment_type = ?", id,  class_name).limit(masters_count)
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
  def masters
    @masters ||= {}
    
    if @masters.empty?
      master_links.each do |master_link|
        master_class_name = master_link.master_type
        master_class = master_class_name.constantize
        @masters[master_class_name] ||= []
        @masters[master_class_name] << master_class.where(id: master_link.master_id).limit(1)
      end
    end

    return @masters
  end

  def master(master_class)
    masters[master_class.to_s.singularize.classify]
  end
  
  # attaches attachment to article
  def attach(attachment)
    if new_attlink(attachment).save
      increment_attachments_count
      reload_attachments_with attachment
      attachment.increment_masters_count
    end
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
  
  # returns attachments of <attclass> type
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

  def decrement_attachments_count_on_masters
    masters.values.flatten.each { |mstr| mstr.decrement_attachments_count }
  end

  def decrement_masters_count_on_attachments
    attachments.values.flatten.each { |att| att.decrement_masters_count }
  end

  def increment_attachments_count
    update_attribute(:attachments_count, attachments_count + 1)
  end

  def decrement_attachments_count
    update_attribute(:attachments_count, attachments_count - 1)
  end

  def increment_masters_count
    update_attribute(:masters_count, masters_count + 1)
  end

  def decrement_masters_count
    update_attribute(:masters_count, masters_count - 1)
  end

  private
  
  # add attachment to @attachments
  def reload_attachments_with(attachment)
    attachments[attachment.class.to_s] ||= []

    unless attachments[attachment.class.to_s].include? attachment
      attachments[attachment.class.to_s] << attachment
    end
  end

  def destroy_attachment_links
    attachment_links.destroy_all
  end
  
  def destroy_all_master_links
    master_links.destroy_all
  end

end
