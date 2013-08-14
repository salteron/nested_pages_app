FactoryGirl.define do
  factory :page do
    name     "name"
    title    "title"
    content  "content"
    parent_id    nil
  end

  factory :invalid_page, parent: :page do |f|
  	f.name  nil
  end

  factory :page_with_invalid_parent_id, parent: :page do |f|
  	f.parent_id  0
  end
end