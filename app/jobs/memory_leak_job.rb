# frozen_string_literal: true

# Processes blog records in batches and delegates the processing to ProcessBlogBatchJob
class MemoryLeakJob < ApplicationJob
  BATCH_SIZE = 5000
  queue_as :default

  def perform
    Blog.valid_blogs.in_batches(of: BATCH_SIZE) do |batch|
      batch_ids = batch.pluck(:id)
      batch_ids.each_slice(1000) do |slice|
        ApiResponse.insert_all(build_api_responses(slice))
      end
    end

    invalid_blogs_count = Blog.invalid_blogs.count
    Rails.logger.info("#{invalid_blogs_count} invalid blogs")
  end

  private

  def build_api_responses(blog_ids)
    blog_ids.map do |blog_id|
      {
        blog_id: blog_id,
        api_response_id: "#{SecureRandom.hex}-#{blog_id}",
        api_status: ApiResponse.api_statuses.keys.sample
      }
    end
  end
end
