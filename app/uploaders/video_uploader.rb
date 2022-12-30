class VideoUploader < CarrierWave::Uploader::Base
  # storage :file
  storage :fog

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_allowlist
    %w(jpg jpeg gif png MOV wmv mp4)
  end
end
