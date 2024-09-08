# frozen_string_literal: true

# Incoming scan data from Robot warehouse scanners
class ScansController < ApplicationController
  def create
    Scan.create_from_json(report_file: scan_params['file'])
    head :created
  rescue JSON::ParserError => e
    render status: :internal_server_error, json: { errors: e.message }
  end

  private

  def scan_params
    params.require(:scan).permit(:file)
  end
end
