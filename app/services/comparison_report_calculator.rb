# frozen_string_literal: true

# Compares a warehouse scan with a customer manifest to check for discrepancies.
class ComparisonReportCalculator
  def self.calculate(scan_report:, manifest:)
    hashed_scan_report = hashify_scan_report(scan_report)
    hashed_manifest = hashify_manifest(manifest)

    results = hashed_manifest.keys.map do |location|
      ComparisonRowPresenter.to_row(
        location,
        hashed_scan_report[location],
        hashed_manifest[location]
      )
    end

    [headers] + results
  end

  def self.headers
    ['Location', 'Scan Status', 'Occupation Status', 'Expected Barcodes', 'Detected Barcodes', 'Status'].freeze
  end

  def self.manifest_locations(manifest)
    manifest[1..].map { |row| row[0] }
  end

  def self.hashify_scan_report(scan_report)
    scan_report.index_by do |location|
      location['name']
    end
  end

  def self.hashify_manifest(manifest)
    manifest[1..].index_by do |row|
      row[0]
    end
  end
end
