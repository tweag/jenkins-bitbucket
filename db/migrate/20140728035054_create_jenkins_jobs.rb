class CreateJenkinsJobs < ActiveRecord::Migration
  def change
    create_table :jenkins_jobs do |t|
      t.json :data

      t.timestamps
    end
  end
end
