# frozen_string_literal: true

# The results of a single database scan performed by a warehouse robot
class Scan < ApplicationRecord
  has_one :comparison, dependent: :destroy

  def self.create_from_json(report_file:)
    file_contents = File.read(report_file)
    report_contents = JSON.parse(file_contents)

    create!(report_contents:)
  end
end
