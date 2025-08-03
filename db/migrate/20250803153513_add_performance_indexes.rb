class AddPerformanceIndexes < ActiveRecord::Migration[8.0]
  def change
    # ProjectsController#index performance (200 req/day × 1,018ms P95)
    add_index :projects, :last_synced_at
    add_index :projects, "((repository ->> 'language'))", name: 'index_projects_on_repository_language'
    add_index :projects, "((repository ->> 'owner'))", name: 'index_projects_on_repository_owner'  
    add_index :projects, "((repository ->> 'archived'))", name: 'index_projects_on_repository_archived'
    add_index :projects, :keywords, using: 'gin'
    add_index :projects, :matching_criteria
    
    # Missing foreign keys causing N+1 queries
    add_index :dependencies, :project_id
    add_index :releases, :project_id
    
    # Contributor performance bottlenecks
    add_index :contributors, :email
    add_index :contributors, :topics, using: 'gin'
    add_index :contributors, :project_ids, using: 'gin'
    
    # Dependencies table performance
    add_index :dependencies, :count
    add_index :dependencies, [:ecosystem, :name], unique: true
  end
end
