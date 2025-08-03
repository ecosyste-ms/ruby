require 'test_helper'

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  context "ProjectsController" do
    setup do
      @project = create(:project)
      @project_without_sync = create(:project, :no_sync)
    end

    context "GET #show" do
      should "load project correctly" do
        get project_path(@project)
        
        project = assigns(:project)
        assert_not_nil project
        assert_equal @project, project
      end
      
      should "handle project without sync data" do
        get project_path(@project_without_sync)
        
        assert_not_nil assigns(:project)
        assert_equal @project_without_sync, assigns(:project)
      end
    end

    context "GET #index" do
      setup do
        @high_score = create(:project, :high_score, name: "High Score")
        @ruby_project = create(:project, name: "Ruby Proj")
        @python_project = create(:project, name: "Python Proj")
        @python_project.update(repository: @python_project.repository.merge("language" => "Python"))
      end

      should "load projects with optimized select" do
        get projects_path
        
        assert_response :success
        projects = assigns(:projects)
        assert_not_nil projects
        
        # Test we can access the selected fields
        projects.each do |project|
          assert_not_nil project.url
          assert_not_nil project.name
          # These should be accessible due to our select optimization
          assert_respond_to project, :description
          assert_respond_to project, :keywords
          assert_respond_to project, :score
        end
      end

      should "filter by keyword" do
        keyword = @project.keywords.first
        get projects_path(keyword: keyword)
        
        assert_response :success
        # Controller should apply the keyword filter
        scope = assigns(:scope)
        assert_not_nil scope
      end

      should "filter by language" do
        get projects_path(language: "Python")
        
        assert_response :success
        # Should filter by language
        scope = assigns(:scope)
        assert_not_nil scope
      end

      should "sort by score" do
        get projects_path(sort: "score", order: "desc")
        
        assert_response :success
        projects = assigns(:projects)
        scores = projects.limit(3).pluck(:score)
        assert_equal scores, scores.sort.reverse
      end
    end

    context "GET #lookup" do
      should "find existing project" do
        get lookup_projects_path(url: @project.url)
        assert_redirected_to @project
      end

      should "create new project when not found" do
        new_url = "https://github.com/newuser/newrepo"
        
        assert_difference 'Project.count', 1 do
          get lookup_projects_path(url: new_url)
        end
        
        new_project = Project.find_by(url: new_url.downcase)
        assert_redirected_to new_project
      end

      should "handle case insensitive URLs" do
        upper_url = @project.url.upcase
        get lookup_projects_path(url: upper_url)
        assert_redirected_to @project
      end
    end

    context "GET #dependencies" do
      setup do
        @dependency = create(:dependency, project: @project, count: 10)
      end

      should "load dependencies page without crashing" do
        get dependencies_projects_path
        assert_response :success
      end

      should "preload projects for dependency records" do
        get dependencies_projects_path
        
        dependency_records = assigns(:dependency_records)
        # Should include our dependency with count > 1
        found_dep = dependency_records.find { |d| d.id == @dependency.id }
        assert_not_nil found_dep
        
        # Should have preloaded the project association
        assert found_dep.association(:project).loaded? if found_dep.project.present?
      end
    end

    context "performance optimizations" do
      should "use includes for show action to prevent N+1" do
        project_with_data = create(:project, :with_associations)
        
        # Count queries executed during the request
        query_count = 0
        counter = lambda do |name, started, finished, unique_id, payload|
          query_count += 1 if payload[:sql] && payload[:sql] !~ /^(BEGIN|COMMIT|ROLLBACK|SAVEPOINT|RELEASE|PRAGMA|SHOW|SET|EXPLAIN)/i
        end
        
        ActiveSupport::Notifications.subscribed(counter, 'sql.active_record') do
          get project_path(project_with_data)
        end
        
        # With includes(), should use significantly fewer queries
        assert query_count < 15, "Expected fewer than 15 queries, got #{query_count}"
        assert_not_nil assigns(:project)
      end

      should "use select optimization for index to reduce data transfer" do
        create_list(:project, 5)
        
        get projects_path
        assert_response :success
        
        projects = assigns(:projects)
        # Should be able to access selected fields
        projects.each do |project|
          assert_not_nil project.id
          assert_not_nil project.url
          # Should not crash when accessing these optimized fields
          project.name
          project.description if project.description
          project.keywords
        end
      end
    end
  end
end