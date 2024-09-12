# Calculates the values for a single row in the comparison report
class ComparisonRowPresenter
  def self.to_row(location_id, scan_report_row, manifest_row)
    [
      location_id,
      readable_status('Scanned', scan_report_row['scanned']),
      readable_status('Occupied', scan_report_row['occupied']),
      expected_barcodes(manifest_row),
      detected_barcodes(scan_report_row),
      status_report
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

  private_class_method def self.status_report
    'TODO'
  end
end
