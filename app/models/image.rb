class Image
  include Mongoid::Document
  
  mount_uploader :attachment, AttachmentUploader
  belongs_to :variant
end