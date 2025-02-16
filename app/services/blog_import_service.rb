# frozen_string_literal: true

# This class handles the import of blog records from a CSV file.
class BlogImportService
  BATCH_SIZE = 5000

  def initialize(file_data, user_id)
    @file_data = file_data
    @user_id = user_id
  end

  def import
    user = User.find(@user_id)
    rows = CSV.parse(@file_data, headers: true)
    rows.each_slice(BATCH_SIZE) do |batch|
      batch = batch.map { |row| { title: row['title'], body: row['body'] } }
      begin
        user.blogs.insert_all(batch)
      rescue StandardError => e
        Rails.logger.error("Error inserting batch: #{e.message}")
      end
    end
  end
end
