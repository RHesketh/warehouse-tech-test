# frozen_string_literal: true

namespace :debug do
  desc 'Import scans from JSON files in lib/tasks/data/scans'
  task import_scans: :environment do
    scans_dir = Rails.root.join('lib/tasks/data/scans')
    json_files = Dir.glob("#{scans_dir}/*.json")

    json_files.each do |file_path|
      print "Importing scan from #{file_path}..."
      file_content = File.open(file_path)
      Scan.create_from_json(report_file: file_content)
      puts ' Done.'
    end

    puts "Finished importing #{json_files.count} scans."
  end
end
