class VideoUploader < CarrierWave::Uploader::Base

  if Rails.env.development? # 開発環境の場合
    storage :file
  elsif Rails.env.test? # テスト環境の場合
    storage :file
  else # 本番環境の場合
    storage :fog
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_allowlist
    %w(jpg jpeg gif png MOV wmv mp4)
  end

  def size_range
    0..45.megabytes
  end
end
