 require 'carrierwave/storage/abstract'
 require 'carrierwave/storage/file'
 require 'carrierwave/storage/fog'

 CarrierWave.configure do |config|
     config.cache_dir = "/tmp"
     config.storage :fog
     config.fog_provider = 'fog/aws'
     config.fog_directory  = ENV['AWS_BUCKET'] # 作成したバケット名を記述
     config.fog_credentials = {
       provider: 'AWS',
       aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'], # 環境変数
       aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'], # 環境変数
       region: ENV['AWS_REGION'],   # アジアパシフィック(東京)を選択した場合
       path_style: true
      
     }
 end
