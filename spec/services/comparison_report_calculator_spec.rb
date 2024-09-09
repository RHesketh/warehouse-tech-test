# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ComparisonReportCalculator, type: :job do
  let(:scan_report) do
    [
      {
        "name": 'ZA001A',
        "scanned": true,
        "occupied": true,
        "detected_barcodes": [
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
    let(:first_row) { result.first }

    it 'includes the location name' do
      expect(first_row[0]).to eq('ZA001A')
    end

    context 'when the location was succesfully scanned' do
      let(:scan_report) do
        [
          {
            "name": 'ZA001A',
            "scanned": true,
            "occupied": true,
            "detected_barcodes": [
              'DX9850004338'
            ]
          }
        ]
      end

      it 'includes the scanned status' do
        expect(first_row[1]).to eq('Scanned')
      end
    end

    context 'when the location was not scanned' do
      let(:scan_report) do
        [
          {
            "name": 'ZA001A',
            "scanned": false,
            "occupied": true,
            "detected_barcodes": [
              'DX9850004338'
            ]
          }
        ]
      end

      it 'includes the scanned status' do
        expect(first_row[1]).to eq('Not Scanned')
      end
    end

    context 'when the location was not occupied' do
      let(:scan_report) do
        [
          {
            "name": 'ZA001A',
            "scanned": true,
            "occupied": false,
            "detected_barcodes": [
              'DX9850004338'
            ]
          }
        ]
      end

      it 'includes the occupied status' do
        expect(first_row[2]).to eq('Not Occupied')
      end
    end

    context 'when the location was occupied' do
      let(:scan_report) do
        [
          {
            "name": 'ZA001A',
            "scanned": true,
            "occupied": true,
            "detected_barcodes": [
              'DX9850004338'
            ]
          }
        ]
      end

      it 'includes the occupied status' do
        expect(first_row[2]).to eq('Occupied')
      end
    end

    context 'When no barcodes were expected for a location' do
      let(:expected_manifest) do
        [
          %w[LOCATION ITEM],
          ['ZA001A', nil]
        ]
      end

      it 'includes a blank cell' do
        expect(first_row[3]).to eq('')
      end
    end

    context 'When a barcode was expected for a location' do
      it 'includes the expected barcodes' do
        expect(first_row[3]).to eq('DX9850004338')
      end
    end

    context 'When no barcodes were detected for a location' do
      let(:scan_report) do
        [
          {
            "name": 'ZA001A',
            "scanned": true,
            "occupied": true,
            "detected_barcodes": []
          }
        ]
      end

      it 'includes a blank cell' do
        expect(first_row[4]).to eq('')
      end
    end

    context 'When a barcode was detected for a location' do
      it 'includes the expected barcodes' do
        expect(first_row[4]).to eq('DX9850004338')
      end
    end

    describe 'status field' do
      context 'when the location was empty, as expected' do
        let(:scan_report) do
          [
            {
              "name": 'ZA001A',
              "scanned": true,
              "occupied": false,
              "detected_barcodes": []
            }
          ]
        end

        let(:expected_manifest) do
          [
            %w[LOCATION ITEM],
            ['ZA001A', nil]
          ]
        end

        it 'includes the expected status' do
          expect(first_row[5]).to eq('Location was empty, as expected')
        end
      end

      context 'when the location was empty but should have been occupied' do
        let(:scan_report) do
          [
            {
              "name": 'ZA001A',
              "scanned": true,
              "occupied": false,
              "detected_barcodes": []
            }
          ]
        end

        let(:expected_manifest) do
          [
            %w[LOCATION ITEM],
            %w[ZA001A DX9850004338]
          ]
        end

        it 'includes the expected status' do
          expect(first_row[5]).to eq('Location was empty, but should have been occupied')
        end
      end

      context 'when the location was occupied, as expected' do
        let(:scan_report) do
          [
            {
              "name": 'ZA001A',
              "scanned": true,
              "occupied": true,
              "detected_barcodes": ['DX9850004338']
            }
          ]
        end

        let(:expected_manifest) do
          [
            %w[LOCATION ITEM],
            %w[ZA001A DX9850004338]
          ]
        end

        it 'includes the expected status' do
          expect(first_row[5]).to eq('Location was occupied, as expected')
        end
      end

      context 'when the location was occupied but the barcodes do not match' do
        let(:scan_report) do
          [
            {
              "name": 'ZA001A',
              "scanned": true,
              "occupied": true,
              "detected_barcodes": ['ADIFFERENTBARCODE']
            }
          ]
        end

        let(:expected_manifest) do
          [
            %w[LOCATION ITEM],
            %w[ZA001A DX9850004338]
          ]
        end

        it 'includes the expected status' do
          expect(first_row[5]).to eq('Location was occupied, but the barcodes do not match')
        end
      end

      context 'when the location was occupied but should have been empty' do
        let(:scan_report) do
          [
            {
              "name": 'ZA001A',
              "scanned": true,
              "occupied": true,
              "detected_barcodes": ['DX9850004338']
            }
          ]
        end

        let(:expected_manifest) do
          [
            %w[LOCATION ITEM],
            ['ZA001A', nil]
          ]
        end

        it 'includes the expected status' do
          expect(first_row[5]).to eq('Location was occupied, but should have been empty')
        end
      end

      context 'when the location was occupied but no barcodes were detected' do
        let(:scan_report) do
          [
            {
              "name": 'ZA001A',
              "scanned": true,
              "occupied": true,
              "detected_barcodes": []
            }
          ]
        end

        let(:expected_manifest) do
          [
            %w[LOCATION ITEM],
            %w[ZA001A DX9850004338]
          ]
        end

        it 'includes the expected status' do
          expect(first_row[5]).to eq('Location was occupied, but no barcodes were detected')
        end
      end
    end
  end
end
