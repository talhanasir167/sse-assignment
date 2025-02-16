require 'csv'

# This job processes CSV files for importing blogs in the background.
class ImportBlogsJob < ApplicationJob
  queue_as :default

  def perform(file_data, user_id)
    BlogImportService.new(file_data, user_id).import
  rescue StandardError => e
    Rails.logger.error("CSV Import failed: #{e.message}")
  end
end
