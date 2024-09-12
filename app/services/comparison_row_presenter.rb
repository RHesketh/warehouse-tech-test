# frozen_string_literal: true

# Calculates the values for a single row in the comparison report
class ComparisonRowPresenter
  def self.to_row(location_id, scan_report_row, manifest_row)
    [
      location_id,
      readable_status('Scanned', scan_report_row['scanned']),
      readable_status('Occupied', scan_report_row['occupied']),
      expected_barcodes(manifest_row),
      detected_barcodes(scan_report_row),
      status_report(manifest_row, scan_report_row)
    ]
  end

  private_class_method def self.readable_status(label, status)
    case status
    when true
      label
    when false
      "Not #{label}"
    else
      "#{label} Status Unknown"
    end
  end

  private_class_method def self.expected_barcodes(manifest_row)
    manifest_row[1].to_s
  end

  private_class_method def self.detected_barcodes(scan_report_row)
    scan_report_row['detected_barcodes'].join(', ')
  end

  # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/AbcSize
  # NOTE: If I were expecting to add more statuses, I would refactor this method into a series of smaller classes.
  # Each of these classes would be passed the manifest_row and scan_report_row and would return a status string
  # if the conditions were met. This would make the code more modular and easier to test, however it would also split
  # the logic across multiple files, which could make it harder to follow.
  private_class_method def self.status_report(manifest_row, scan_report_row)
    expected_barcode = manifest_row[1]
    detected_barcodes = scan_report_row['detected_barcodes']

    if scan_report_row['scanned'] == false
      'Location was not scanned'
    elsif scan_report_row['occupied'] == true && detected_barcodes.empty?
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
  # rubocop:enable Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/AbcSize
end
