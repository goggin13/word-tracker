require "aws-sdk"

timestamp = Time.now.strftime("%Y%m%d-%H%M")
key = "word-tracker-production-#{timestamp}.sqlite3"

s3 = Aws::S3::Resource.new(region:'us-east-1')
obj = s3.bucket('goggin-backups').object(key)

result = obj.upload_file("data/production.sqlite3")

if result
  puts "Uploaded #{obj.content_length} bytes to #{obj.bucket_name}/#{key}"
else
  puts "Failed: #{result.inspect}"
end
