class CreateServiceCheckJobs < ActiveRecord::Migration
  def change
    create_table :service_check_jobs do |t|
      t.string :service
      t.string :host
      t.string :status

      t.timestamps
    end
  end
end
