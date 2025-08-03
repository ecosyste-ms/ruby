FactoryBot.define do
  factory :issue do
    association :project
    sequence(:number) { |n| n }
    sequence(:uuid) { |n| "issue-uuid-#{n}" }
    state { "open" }
    title { "Test Issue" }
    body { "This is a test issue body" }
    user { "testuser" }
    labels { ["bug", "help wanted"] }
    pull_request { false }
    comments_count { 2 }
    
    trait :closed do
      state { "closed" }
      closed_at { 1.day.ago }
      closed_by { "maintainer" }
    end
    
    trait :pull_request do
      pull_request { true }
      title { "Test Pull Request" }
      labels { ["enhancement"] }
    end
    
    trait :good_first_issue do
      labels { ["good first issue", "help wanted"] }
      state { "open" }
    end
  end
end