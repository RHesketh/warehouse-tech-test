# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Scans', type: :request do
  describe 'POST /' do
    describe 'when a scan report is uploaded' do
      let(:scan_file) { fixture_file_upload(Rails.root.join('spec/fixtures/example-scan.json'), 'application/json') }

      it 'returns a 201 status code' do
        post scans_path, params: { scan: { file: scan_file } }
        expect(response).to have_http_status(:created)
      end

      it 'creates a new scan record' do
        expect do
          post scans_path, params: { scan: { file: scan_file } }
        end.to change(Scan, :count).by(1)
      end

      context 'When there is a problem parsing the JSON' do
        let(:scan_file) do
          fixture_file_upload(Rails.root.join('spec/fixtures/errors/incomplete.json'), 'application/json')
        end

        it 'returns a 400 status code' do
          post scans_path, params: { scan: { file: scan_file } }
          expect(response).to have_http_status(:bad_request)
        end
      end
    end
  end
end
