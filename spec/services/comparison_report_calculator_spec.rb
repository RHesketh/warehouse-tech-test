# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ComparisonReportCalculator, type: :job do
  let(:scan_report) do
    [
      {
        'name' => 'ZA001A',
        'scanned' => true,
        'occupied' => true,
        'detected_barcodes' => [
          'DX9850004338'
        ]
      }
    ]
  end

  let(:expected_manifest) do
    [
      %w[LOCATION ITEM],
      %w[ZA001A DX9850004338]
    ]
  end

  describe '.calculate' do
    let(:result) { ComparisonReportCalculator.calculate(scan_report:, manifest: expected_manifest) }
    let(:results_row) { result.second }

    it 'includes the expected headers' do
      expect(result.first).to eq(['Location', 'Scan Status', 'Occupation Status', 'Expected Barcodes',
                                  'Detected Barcodes', 'Status'])
    end

    it 'includes the expected data' do
      expect(results_row).to eq(['ZA001A', 'Scanned', 'Occupied', 'DX9850004338', 'DX9850004338',
                                 'Location was occupied, as expected'])
    end
  end
end
