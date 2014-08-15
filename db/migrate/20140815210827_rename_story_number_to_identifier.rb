class RenameStoryNumberToIdentifier < ActiveRecord::Migration
  def change
    rename_column :jenkins_jobs, :story_number, :identifier
  end
end
