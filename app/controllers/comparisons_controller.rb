# frozen_string_literal: true

# Handles requests for pending and completed comparison reports.
class ComparisonsController < ApplicationController
  before_action :set_scan, only: %i[create]

  def create
    @comparison = Comparison.create_from_manifest(scan: @scan, manifest_file: params[:manifest])
    CalculateComparisonReportJob.perform_later(@comparison)

    render turbo_stream: [
      turbo_stream.append(
        'verified-scans-table',
        partial: 'scans/verified_scan_row',
        locals: { scan: @scan }
      ),
      turbo_stream.remove("unverified-scan-row-#{@scan.id}")
    ]
  end

  def show
    @comparison = Comparison.includes(:scan).find(params[:id])
    @headers = @comparison.headers
    @outcome = @comparison.outcome_data
  end

  private

  def set_scan
    @scan = Scan.find(params[:scan_id])
  end

  def comparison_params
    params.permit(:manifest, :scan_id)
  end
end
