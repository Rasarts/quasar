FactoryGirl.define do
  factory :attachment do
    slave_document
    master_document
    
    removable false
  end
end
