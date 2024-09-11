# frozen_string_literal: true

# Handles requests for pending and completed comparison reports.
class ComparisonsController < ApplicationController
  before_action :validate_request, only: %i[create]
  before_action :set_scan, only: %i[create]

  def create
    @comparison = Comparison.create_from_manifest(scan: @scan, manifest_file: params[:manifest])
    CalculateComparisonReportJob.perform_later(@comparison)

    render turbo_stream: [
      turbo_stream.append('verified-scans-table', partial: 'scans/verified_scan_row', locals: { scan: @scan }),
      turbo_stream.remove("unverified-scan-row-#{@scan.id}")
    ]
  rescue StandardError => e
    redirect_to scans_path, alert: e.message
  end

  def show
    @comparison = Comparison.includes(:scan).find(params[:id])
    @headers = @comparison.headers
    @outcome = @comparison.outcome_data
  end

  private

  def validate_request
    return if params[:manifest].present?

    redirect_to scans_path, alert: 'Please attach a manifest for comparison!'
  end

  def set_scan
    @scan = Scan.find(params[:scan_id])
  end

  def comparison_params
    params.permit(:manifest, :scan_id)
  end
end
