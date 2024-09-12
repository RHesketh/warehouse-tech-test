# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ComparisonRowPresenter do
  let(:location_id) { 'ZA001A' }
  let(:scan_report_row) do
    {
      'name' => 'ZA001A',
      'scanned' => true,
      'occupied' => false,
      'detected_barcodes' => [
        'DX9850004338'
      ]
    }
  end
  let(:manifest_row) { %w[ZA001A DX9850004338] }

  describe '.to_row' do
    let(:returned_row) { described_class.to_row(location_id, scan_report_row, manifest_row) }

    it 'includes the location ID' do
      expect(returned_row[0]).to eq('ZA001A')
    end

    context 'when the location was scanned' do
      it 'includes the scanned status' do
        expect(returned_row[1]).to eq('Scanned')
      end
    end

    context 'when the location was not scanned' do
      let(:scan_report_row) do
        {
          'name' => 'ZA001A',
          'scanned' => false,
          'occupied' => false,
          'detected_barcodes' => []
        }
      end

      it 'includes the scanned status' do
        expect(returned_row[1]).to eq('Not Scanned')
      end
    end

    context 'when the location was occupied' do
      it 'includes the occupied status' do
        expect(returned_row[2]).to eq('Not Occupied')
      end
    end

    context 'when the location was not occupied' do
      let(:scan_report_row) do
        {
          'name' => 'ZA001A',
          'scanned' => true,
          'occupied' => false,
          'detected_barcodes' => []
        }
      end

      it 'includes the occupied status' do
        expect(returned_row[2]).to eq('Not Occupied')
      end
    end

    it 'includes the expected barcodes' do
      expect(returned_row[3]).to eq('DX9850004338')
    end

    it 'includes the detected barcodes' do
      expect(returned_row[4]).to eq('DX9850004338')
    end

    context 'status field' do
      context 'when the location was empty, as expected' do
        let(:scan_report_row) do
          {
            'name' => 'ZA001A',
            'scanned' => true,
            'occupied' => false,
            'detected_barcodes' => []
          }
        end

        let(:manifest_row) do
          ['ZA001A', nil]
        end

        it 'includes the expected_status' do
          expect(returned_row[5]).to eq('Location was empty, as expected')
        end
      end

      context 'when the location was empty, but should have been occupied' do
        let(:scan_report_row) do
          {
            'name' => 'ZA001A',
            'scanned' => true,
            'occupied' => false,
            'detected_barcodes' => []
          }
        end

        let(:manifest_row) { %w[ZA001A DX9850004338] }

        it 'includes the expected status' do
          expect(returned_row[5]).to eq('Location was empty, but should have been occupied')
        end
      end

      context 'when the location was occupied as expected' do
        let(:scan_report_row) do
          {
            'name' => 'ZA001A',
            'scanned' => true,
            'occupied' => true,
            'detected_barcodes' => ['DX9850004338']
          }
        end

        let(:manifest_row) { %w[ZA001A DX9850004338] }

        it 'includes the expected status' do
          expect(returned_row[5]).to eq('Location was occupied, as expected')
        end
      end

      context 'when the location was occupied, but the barcodes do not match' do
        let(:scan_report_row) do
          {
            'name' => 'ZA001A',
            'scanned' => true,
            'occupied' => true,
            'detected_barcodes' => ['DX9850004339']
          }
        end

        let(:manifest_row) { %w[ZA001A ANOTHERBARCODE] }

        it 'includes the expected status' do
          expect(returned_row[5]).to eq('Location was occupied, but the barcodes do not match')
        end
      end

      context 'when the location was occupied, but should have been empty' do
        let(:scan_report_row) do
          {
            'name' => 'ZA001A',
            'scanned' => true,
            'occupied' => true,
            'detected_barcodes' => ['DX9850004338']
          }
        end

        let(:manifest_row) { ['ZA001A', nil] }

        it 'includes the expected status' do
          expect(returned_row[5]).to eq('Location was occupied, but should have been empty')
        end
      end

      context 'when the location was occupied, but no barcodes were detected' do
        let(:scan_report_row) do
          {
            'name' => 'ZA001A',
            'scanned' => true,
            'occupied' => true,
            'detected_barcodes' => []
          }
        end

        let(:manifest_row) { %w[ZA001A DX9850004338] }

        it 'includes the expected status' do
          expect(returned_row[5]).to eq('Location was occupied, but no barcodes were detected')
        end
      end

      context 'when the location was not scanned' do
        let(:scan_report_row) do
          {
            'name' => 'ZA001A',
            'scanned' => false,
            'occupied' => false,
            'detected_barcodes' => []
          }
        end

        it 'includes the expected status' do
          expect(returned_row[5]).to eq('Location was not scanned')
        end
      end
    end
  end
end
