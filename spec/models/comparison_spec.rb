# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comparison, type: :model do
  describe '.create_from_manifest' do
    let(:scan) { Scan.create! }
    let(:manifest_file) do
      fixture_file_upload(Rails.root.join('spec/fixtures/example-customer.csv'), 'application/csv')
    end

    it 'creates a new comparison record' do
      expect do
        Comparison.create_from_manifest(scan:, manifest_file:)
      end.to change(Comparison, :count).by(1)
    end

    it 'stores the expected manifest contents' do
      Comparison.create_from_manifest(scan:, manifest_file:)
      expect(Comparison.last.expected_manifest).to eq(CSV.parse(manifest_file.read))
    end
  end

  describe '#processing?' do
    it 'returns true if comparison_outcome is nil' do
      comparison = Comparison.new(comparison_outcome: nil)
      expect(comparison.processing?).to be true
    end

    it 'returns false if comparison_outcome is not nil' do
      comparison = Comparison.new(comparison_outcome: 'outcome')
      expect(comparison.processing?).to be false
    end
  end

  describe '#headers' do
    context 'when comparison_outcome is nil' do
      it 'returns an empty array' do
        comparison = Comparison.new(comparison_outcome: nil)
        expect(comparison.headers).to eq([])
      end
    end

    context 'when comparison_outcome is not nil' do
      it 'returns the first element of comparison_outcome' do
        comparison = Comparison.new(comparison_outcome: %w[header data])
        expect(comparison.headers).to eq('header')
      end
    end
  end

  describe '#outcome_data' do
    context 'when comparison_outcome is nil' do
      it 'returns an empty array' do
        comparison = Comparison.new(comparison_outcome: nil)
        expect(comparison.outcome_data).to eq([])
      end
    end

    context 'when comparison_outcome is not nil' do
      it 'returns all but the first element of comparison_outcome' do
        comparison = Comparison.new(comparison_outcome: %w[header data])
        expect(comparison.outcome_data).to eq(['data'])
      end
    end
  end
end
