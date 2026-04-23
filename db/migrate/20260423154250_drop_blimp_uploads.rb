# frozen_string_literal: true

class DropBlimpUploads < ActiveRecord::Migration[7.2]
  def up
    drop_table :blimp_uploads
  end

  def down
    create_table :blimp_uploads do |t|
      t.string :csv_file
      t.timestamps
    end
  end
end
