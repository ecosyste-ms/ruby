FactoryBot.define do
  factory :dependency do
    association :project
    ecosystem { "rubygems" }
    sequence(:name) { |n| "test-gem-#{n}" }
    count { 5 }
    repository_url { "https://github.com/user/test-gem" }
    average_ranking { 3.5 }
    
    package do
      {
        "name" => name,
        "ecosystem" => ecosystem,
        "registry_url" => "https://rubygems.org/gems/#{name}",
        "description" => "A test gem dependency"
      }
    end
    
    trait :popular do
      count { 50 }
      average_ranking { 4.8 }
    end
    
    trait :npm do
      ecosystem { "npm" }
      repository_url { "https://github.com/user/test-package" }
      package do
        {
          "name" => name,
          "ecosystem" => "npm",
          "registry_url" => "https://www.npmjs.com/package/#{name}",
          "description" => "A test npm package dependency"
        }
      end
    end
  end
end