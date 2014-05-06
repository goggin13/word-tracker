desc "PG Backup"
namespace :pg do
  task :backup => [:environment] do
    datestamp = Time.now.strftime("%Y-%m-%d_%H-%M-%S")
    backup_file = "#{Rails.root}/tmp/db_name_#{datestamp}_dump.sql.gz"
    sh "pg_dump -h localhost -U pair my_words | gzip -c > #{backup_file}"
    send_to_amazon backup_file
    File.delete backup_file
  end
end

def send_to_amazon(file_path)
  bucket = "matt-goggin-backup/databases/word-tracker"
  file_name = File.basename(file_path)
  AWS::S3::Base.establish_connection!(
    :access_key_id => ENV["AWSAccessKeyId"],
    :secret_access_key => ENV["AWSSecretKey"],
  )
  AWS::S3::S3Object.store(file_name, File.open(file_path), bucket)
end
