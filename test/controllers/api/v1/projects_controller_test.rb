require 'test_helper'

class Api::V1::ProjectsControllerTest < ActionDispatch::IntegrationTest
  test 'index includes funding links when some packages have no metadata' do
    project = create(:project,
      url: 'https://github.com/example/funding-project',
      last_synced_at: 1.hour.ago,
      packages: [
        { 'name' => 'missing-metadata' },
        { 'name' => 'null-metadata', 'metadata' => nil },
        { 'name' => 'empty-metadata', 'metadata' => {} },
        { 'name' => 'string-funding', 'metadata' => { 'funding' => 'https://example.com/sponsor' } },
        { 'name' => 'object-funding', 'metadata' => { 'funding' => { 'url' => 'https://example.com/donate' } } },
        { 'name' => 'array-funding', 'metadata' => { 'funding' => ['https://example.com/support'] } }
      ]
    )

    get api_v1_projects_path

    assert_response :success
    result = response.parsed_body.find { |entry| entry['id'] == project.id }
    assert_equal [
      'https://example.com/sponsor',
      'https://example.com/donate',
      'https://example.com/support'
    ], result['funding_links']
  end
end
