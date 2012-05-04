FactoryGirl.define do
  factory :article do
    title       "MyString"
    description "MyText"
    content     "MyLongLongLongText"
    status      "in_work"
    
    association :creator, factory: :user
  end
end
