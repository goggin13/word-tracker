
BUCKET = "matt-goggin-backup"
PATH = "databases/word-tracker"

desc "PG Backup"
namespace :pg do
  desc "Backup postgres database to AWS"
  task :backup => [:environment] do
    datestamp = Time.now.strftime("%Y-%m-%d_%H-%M-%S")
    backup_file = "#{Rails.root}/tmp/word_tracker_#{datestamp}_dump.sql.gz"
    sh "pg_dump -h localhost -U #{db_user} #{db_name} | gzip -c > #{backup_file}"
    send_to_amazon backup_file
    File.delete backup_file
  end

  desc "import postgres database from AWS"
  task :import, :file_name do |t, args|
    puts "THIS WILL OVERWRITE YOUR DATABASE; ARE YOU SURE? y/n"
    response = STDIN.gets.chomp
    raise "Aborted by user" unless response == "y"

    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke

    pull_from_amazon(args[:file_name])
  end
end

def db_config
  Rails.configuration.database_configuration[Rails.env]
end

def db_user
  db_config["username"]
end

def db_name
  db_config["database"]
end

def send_to_amazon(file_path)
  file_name = File.basename(file_path)
  AWS::S3::Base.establish_connection!(
    :access_key_id => ENV["AWSAccessKeyId"],
    :secret_access_key => ENV["AWSSecretKey"],
  )
  AWS::S3::S3Object.store(file_name, File.open(file_path), "#{BUCKET}/#{PATH}")
end

def pull_from_amazon(file)
  AWS::S3::Base.establish_connection!(
    :access_key_id => ENV["AWSAccessKeyId"],
    :secret_access_key => ENV["AWSSecretKey"],
  )
  object = AWS::S3::S3Object.find("#{PATH}/#{file}", "matt-goggin-backup")

  tmp_file_path = "/tmp/#{file}"
  File.open(tmp_file_path, "w:ASCII-8BIT") { |f| f.write object.value }

  sh "gzip -d #{tmp_file_path}"
  unzipped_temp_file_path = tmp_file_path[0..-4]

  sh "psql -h localhost -p 5433 -U #{db_user} -d #{db_name} -f #{unzipped_temp_file_path }"

  sh "rm #{unzipped_temp_file_path}"
end
