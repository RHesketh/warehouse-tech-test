# frozen_string_literal: true

# Performs the calculation of the comparison report in the background
class CalculateComparisonReportJob < ApplicationJob
  queue_as :default

  def perform(comparison)
    outcome = ComparisonReportCalculator.calculate(
      scan_report: comparison.scan.report_contents,
      manifest: comparison.expected_manifest
    )

    comparison.update!(comparison_outcome: outcome)
    broadcast_job_completion(comparison.scan)
  end

  private

  def broadcast_job_completion(scan)
    Turbo::StreamsChannel.broadcast_replace_to(
      'comparisons',
      target: "verified-scan-row-#{scan.id}",
      partial: 'scans/verified_scan_row',
      locals: { scan: }
    )
  end
end
