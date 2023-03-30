class VideoUploader < CarrierWave::Uploader::Base
  # 開発環境
  storage :file
  # 本番環境用AWS S３に保存
  # storage :fog

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
