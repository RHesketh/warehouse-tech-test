# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Scan, type: :model do
  describe '.create_from_json' do
    let(:scan_file) { fixture_file_upload(Rails.root.join('spec/fixtures/example-scan.json'), 'application/json') }

    it 'creates a new scan record' do
      expect do
        Scan.create_from_json(report_file: scan_file)
      end.to change(Scan, :count).by(1)
    end

    it 'stores the scan report contents' do
      Scan.create_from_json(report_file: scan_file)
      expect(Scan.last.report_contents).to eq(JSON.parse(scan_file.read))
    end
  end
end
