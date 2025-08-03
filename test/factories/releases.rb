FactoryBot.define do
  factory :release do
    association :project
    sequence(:uuid) { |n| "release-uuid-#{n}" }
    sequence(:tag_name) { |n| "v1.#{n}.0" }
    name { "Release #{tag_name}" }
    body { "Release notes for #{tag_name}" }
    draft { false }
    prerelease { false }
    published_at { 1.week.ago }
    author { "maintainer" }
    target_commitish { "main" }
    
    trait :draft do
      draft { true }
      published_at { nil }
    end
    
    trait :prerelease do
      prerelease { true }
      tag_name { "v2.0.0-beta.1" }
    end
  end
end