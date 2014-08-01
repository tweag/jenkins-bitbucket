class AddStoryNumberToJenkinsJob < ActiveRecord::Migration
  def change
    add_column :jenkins_jobs, :story_number, :string
    JenkinsJob.all.each do |job|
      job.story_number = job.story_number
      job.save!
    end
    add_index  :jenkins_jobs, :story_number, unique: true
  end
end
