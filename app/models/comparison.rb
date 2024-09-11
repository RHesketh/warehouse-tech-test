# frozen_string_literal: true

require 'csv'

# Records a comparison between a warehouse scan and the expected manifest
class Comparison < ApplicationRecord
  belongs_to :scan

  def processing?
    comparison_outcome.nil?
  end

  def self.create_from_manifest(scan:, manifest_file:)
    manifest_contents = File.read(manifest_file)
    expected_manifest = CSV.parse(manifest_contents)
    Comparison.create!(scan:, expected_manifest:)
  end

  def headers
    return [] if comparison_outcome.nil?

    comparison_outcome.first
  end

  def outcome_data
    return [] if comparison_outcome.nil?

    comparison_outcome[1..]
  end
end
