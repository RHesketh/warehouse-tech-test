# frozen_string_literal: true

# Incoming scan data from Robot warehouse scanners
class ScansController < ApplicationController
  before_action :set_scans, only: %i[index]

  def index; end

  def create
    Scan.create_from_json(report_file: scan_params['file'])
    head :created
  rescue JSON::ParserError => e
    render status: :bad_request, json: { errors: e.message }
  end

  private

  def set_scans
    @scans = Scan.all.includes(:comparison).order(created_at: :desc)
    @verified_scans = @scans.where.not(comparison: { scan_id: nil })
    @unverified_scans = @scans.where(comparison: { scan_id: nil })
  end

  def scan_params
    params.require(:scan).permit(:file)
  end
end
