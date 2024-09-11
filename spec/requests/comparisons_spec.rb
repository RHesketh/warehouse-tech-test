# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Comparisons', type: :request do
  let(:scan) { Scan.create! }
  let(:manifest_file) do
    fixture_file_upload(Rails.root.join('spec/fixtures/example-customer.csv'), 'application/csv')
  end

  describe 'POST /comparisons' do
    before do
      post '/comparisons', params: { scan_id: scan.id, manifest: manifest_file }
    end

    it 'creates a new comparison record' do
      expect(Comparison.count).to eq(1)
    end

    it 'queues a job to calculate the comparison report' do
      expect(CalculateComparisonReportJob).to have_been_enqueued.with(Comparison.first)
    end

    it 'renders a turbo stream response' do
      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq('text/vnd.turbo-stream.html')
    end
  end

  describe 'GET /comparisons/:id' do
    let(:comparison) { Comparison.create_from_manifest(scan:, manifest_file:) }

    before do
      get "/comparisons/#{comparison.id}"
    end

    it 'returns a successful response' do
      expect(response).to have_http_status(:ok)
    end
  end
end
