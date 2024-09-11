# frozen_string_literal: true

module Comparisons
  # Handles requests for CSV downloads of comparison reports
  class CsvController < ApplicationController
    def index
      @comparison = Comparison.find(params[:id])
      headers = @comparison.headers
      outcome = @comparison.comparison_outcome[1..]

      # This could also be moved into a service object or class method on Comparison in future
      csv_data = CSV.generate(headers: true) do |csv|
        csv << headers
        outcome.each do |row|
          csv << row
        end
      end

      send_data csv_data, filename: "comparison_#{params[:id]}.csv", type: 'text/csv'
    end
  end
end
