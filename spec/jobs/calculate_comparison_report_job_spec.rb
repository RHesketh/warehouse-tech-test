# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalculateComparisonReportJob, type: :job do
  context 'When given an unprocessed comparison' do
    let(:scan_file) { fixture_file_upload(Rails.root.join('spec/fixtures/example-scan.json'), 'application/json') }
    let(:scan) do
      Scan.create_from_json(report_file: scan_file)
    end
    let(:manifest_file) do
      fixture_file_upload(Rails.root.join('spec/fixtures/example-customer.csv'), 'application/csv')
    end
    let(:comparison) do
      Comparison.create_from_manifest(scan:, manifest_file:)
    end

    # NOTE: We rely on the ComparisonReportCalculator specs to test the actual report contents
    it 'calculates the comparison report' do
      CalculateComparisonReportJob.perform_now(comparison)
      expect(comparison.comparison_outcome).to be_present
    end

    it 'changes the processing status' do
      expect(comparison.processing?).to be true # Safety check
      CalculateComparisonReportJob.perform_now(comparison)
      expect(comparison.processing?).to be false
    end

    it 'broadcasts the comparison' do
      expect do
        CalculateComparisonReportJob.perform_now(comparison)
      end.to have_broadcasted_to('comparisons')
    end
  end
end
