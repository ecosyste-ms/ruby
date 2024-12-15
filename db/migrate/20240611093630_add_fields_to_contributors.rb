class AddFieldsToContributors < ActiveRecord::Migration[7.1]
  def change
    add_column :contributors, :project_ids, :integer, array: true, default: []
    add_column :contributors, :projects_count, :integer
  end
end
