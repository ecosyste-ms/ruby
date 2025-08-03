FactoryBot.define do
  factory :project do
    sequence(:url) { |n| "https://github.com/user/project-#{n}" }
    name { "Test Project" }
    description { "A test project for development" }
    keywords { ["ruby", "test", "development"] }
    keywords_from_contributors { ["testing", "ruby"] }
    last_synced_at { 1.hour.ago }
    score { 5.5 }
    matching_criteria { true }
    
    repository do
      {
        "id" => 123456,
        "full_name" => "user/project",
        "language" => "Ruby",
        "owner" => "testuser",
        "archived" => false,
        "stargazers_count" => 100,
        "open_issues_count" => 5,
        "icon_url" => "https://avatars.githubusercontent.com/u/123456",
        "html_url" => url,
        "default_branch" => "main",
        "created_at" => "2023-01-01T00:00:00Z",
        "pushed_at" => 1.day.ago.iso8601,
        "host" => { "name" => "GitHub" },
        "metadata" => {
          "files" => {
            "readme" => "README.md",
            "license" => "MIT"
          }
        }
      }
    end
    
    packages do
      [
        {
          "name" => "test-gem",
          "ecosystem" => "rubygems",
          "downloads" => 1000,
          "registry" => { "name" => "rubygems.org" },
          "licenses" => ["MIT"]
        }
      ]
    end
    
    commits do
      {
        "total_commits" => 50,
        "total_committers" => 3,
        "past_year_total_commits" => 25,
        "past_year_total_bot_commits" => 2,
        "mean_commits" => 16.7,
        "dds" => 0.85,
        "past_year_mean_commits" => 8.3,
        "past_year_dds" => 0.72,
        "last_synced_at" => 1.hour.ago.iso8601,
        "committers" => [
          {
            "name" => "Test User",
            "email" => "test@example.com",
            "login" => "testuser",
            "count" => 30
          },
          {
            "name" => "Another User", 
            "email" => "another@company.com",
            "login" => "anotheruser",
            "count" => 20
          }
        ]
      }
    end
    
    issues_stats do
      {
        "issues_count" => 10,
        "pull_requests_count" => 5,
        "past_year_issues_count" => 8,
        "past_year_pull_requests_count" => 4,
        "past_year_bot_issues_count" => 1,
        "past_year_bot_pull_requests_count" => 0,
        "bot_issues_count" => 2,
        "bot_pull_requests_count" => 1,
        "issue_authors_count" => 5,
        "pull_request_authors_count" => 3,
        "avg_time_to_close_issue" => 172800,
        "avg_time_to_close_pull_request" => 86400,
        "past_year_avg_time_to_close_issue" => 259200,
        "past_year_avg_time_to_close_pull_request" => 129600,
        "past_year_issue_authors_count" => 4,
        "past_year_pull_request_authors_count" => 2,
        "avg_comments_per_issue" => 2.5,
        "avg_comments_per_pull_request" => 1.8,
        "past_year_avg_comments_per_issue" => 2.2,
        "past_year_avg_comments_per_pull_request" => 1.9,
        "merged_pull_requests_count" => 4,
        "past_year_merged_pull_requests_count" => 3,
        "last_synced_at" => 1.hour.ago.iso8601,
        "issue_author_associations_count" => {
          "CONTRIBUTOR" => 3,
          "MEMBER" => 2
        },
        "pull_request_author_associations_count" => {
          "CONTRIBUTOR" => 2,
          "MEMBER" => 1
        },
        "issue_authors" => {
          "user1" => 3,
          "user2" => 2,
          "user3" => 1
        },
        "pull_request_authors" => {
          "user1" => 2,
          "user2" => 1
        },
        "issue_labels_count" => {
          "bug" => 5,
          "enhancement" => 3,
          "documentation" => 2
        },
        "pull_request_labels_count" => {
          "enhancement" => 3,
          "bug fix" => 2
        }
      }
    end
    
    trait :with_associations do
      after(:create) do |project|
        create_list(:issue, 2, project: project)
        create_list(:release, 1, project: project)
        create_list(:dependency, 2, project: project)
      end
    end
    
    trait :archived do
      repository do
        attributes_for(:project)[:repository].merge("archived" => true)
      end
    end
    
    trait :no_sync do
      last_synced_at { nil }
    end
    
    trait :high_score do
      score { 15.5 }
    end
  end
end