require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  test "github_pages_to_repo_url" do
    project = Project.new
    repo_url = project.github_pages_to_repo_url('https://foo.github.io/bar')
    assert_equal 'https://github.com/foo/bar', repo_url
  end

  test "github_pages_to_repo_url with trailing slash" do
    project = Project.new(url: 'https://foo.github.io/bar/')
    repo_url = project.repository_url
    assert_equal 'https://github.com/foo/bar', repo_url
  end

  test "sync_releases ignores unknown and locally managed attributes" do
    releases_url = 'https://repos.ecosyste.ms/api/v1/hosts/GitHub/repositories/user/project/releases'
    project = create(:project)
    other_project = create(:project)
    project.repository['releases_url'] = releases_url

    payload = [{
      'uuid' => 'abc-123',
      'tag_name' => 'v1.0.0',
      'name' => 'v1.0.0',
      'body' => 'notes',
      'draft' => false,
      'prerelease' => false,
      'published_at' => '2026-01-01T00:00:00Z',
      'author' => 'someone',
      'assets' => [],
      'target_commitish' => 'main',
      'tag_url' => 'https://example.com/tag',
      'html_url' => 'https://example.com/release',
      'last_synced_at' => '2026-01-01T00:00:00Z',
      'release_url' => 'https://example.com/api/release',
      'immutable' => true,
      'project_id' => other_project.id
    }]

    stub_request(:get, "#{releases_url}?per_page=1000")
      .to_return(status: 200, body: payload.to_json)

    assert_difference 'project.releases.count', 1 do
      project.sync_releases
    end

    release = project.releases.first
    assert_equal 'v1.0.0', release.tag_name
    assert_equal project.id, release.project_id
  end
end
