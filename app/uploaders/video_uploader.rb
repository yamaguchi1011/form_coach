class VideoUploader < CarrierWave::Uploader::Base

  if Rails.env.production?
    storage :fog # 本番環境のみ
  else
    storage :file # 本番環境以外
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_allowlist
    %w(jpg jpeg gif png MOV wmv mp4)
  end

  def size_range
    0..30.megabytes
  end
end
