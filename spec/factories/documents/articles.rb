FactoryGirl.define do
  factory :article do
    title       "MyString"
    description "MyText"
    content     "MyLongLongLongText"
    status      "in_work"
    
    creator
  end
end
