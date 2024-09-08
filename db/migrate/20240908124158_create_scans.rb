# frozen_string_literal: true

class CreateScans < ActiveRecord::Migration[7.1]
  def change
    create_table :scans do |t|
      t.json :report_contents

      t.timestamps
    end
  end
end
