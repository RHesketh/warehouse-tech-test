# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comparisons::CsvController, type: :request do
  let(:scan) { Scan.create! }
  let(:dummy_report) { [%w[Header], %w[Data]] }
  let(:comparison) { Comparison.create!(scan:, comparison_outcome: dummy_report) }

  before do
    get csv_comparison_path(id: comparison.id)
  end

  describe 'GET /csv' do
    it 'returns a csv file' do
      expect(response.headers['Content-Type']).to eq('text/csv')
      expect(response.headers['Content-Disposition']).to include("comparison_#{comparison.id}.csv")
    end

    it 'returns the correct data' do
      expect(response.body).to eq("Header\nData\n")
    end
  end
end
