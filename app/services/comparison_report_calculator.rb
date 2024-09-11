# frozen_string_literal: true

class ComparisonReportCalculator
  def self.calculate(scan_report:, manifest:)
    hashed_scan_report = hashify_scan_report(scan_report)
    hashed_manifest = hashify_manifest(manifest)

    results = hashed_manifest.keys.map do |location|
      [
        location,
        scanned_status(hashed_scan_report[location]['scanned']),
        occupied_status(hashed_scan_report[location]['occupied']),
        hashed_manifest[location][1].to_s,
        hashed_scan_report[location]['detected_barcodes'].join(', '),
        status_report(hashed_manifest[location], hashed_scan_report[location])
      ]
    end

    [headers] + results
  end

  def self.headers
    ['Location','Scan Status','Occupation Status','Expected Barcodes','Detected Barcodes','Status'].freeze
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

  # These could be reconciled down into one method named human_readable_status or similar,
  # but I think writing code out in full like this is more readable for a reviewer.
  def self.scanned_status(status)
    case status
    when true
      'Scanned'
    when false
      'Not Scanned'
    else
      'Scan Status Unknown'
    end
  end

  def self.occupied_status(status)
    case status
    when true
      'Occupied'
    when false
      'Not Occupied'
    else
      'Occupation Status Unknown'
    end
  end

  # NOTE: It would be possible to refactor this down into two sections, first checking if the location was empty/occupied,
  # and then appending whether that was expected. However, such an implementation would be tightly coupled to the present
  # content of the status messages, and we have no guarentee that more will not need to be added/removed in future.
  # For this reason, I think the below structure is more readable and thus more maintainable.
  def self.status_report(manifest_row, scan_report_row)
    expected_barcode = manifest_row[1]
    detected_barcodes = scan_report_row['detected_barcodes']

    if scan_report_row['occupied'] == true && detected_barcodes.empty?
      'Location was occupied, but no barcodes were detected'
    elsif expected_barcode.nil? && detected_barcodes.empty?
      'Location was empty, as expected'
    elsif expected_barcode.present? && detected_barcodes.empty?
      'Location was empty, but should have been occupied'
    elsif expected_barcode.nil? && detected_barcodes.present?
      'Location was occupied, but should have been empty'
    elsif expected_barcode.present? && detected_barcodes.present? && !detected_barcodes.include?(expected_barcode)
      'Location was occupied, but the barcodes do not match'
    elsif expected_barcode.present? && detected_barcodes.present?
      'Location was occupied, as expected'
    end
  end
end
