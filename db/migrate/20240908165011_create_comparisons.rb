class CreateComparisons < ActiveRecord::Migration[7.1]
  def change
    create_table :comparisons do |t|
      t.belongs_to :scan, null: false, foreign_key: true
      t.json :expected_manifest
      t.json :comparison_outcome

      t.timestamps
    end
  end
end
