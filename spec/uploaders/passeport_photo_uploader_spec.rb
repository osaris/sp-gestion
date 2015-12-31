require 'rails_helper'

describe PasseportPhotoUploader do
  include CarrierWave::Test::Matchers

  let(:uploader) do
    uploader = PasseportPhotoUploader.new(create(:fireman), :passeport_photo)
    uploader.store!(File.open("#{Rails.root}/spec/fixtures/files/uploads/logo/logo_test.png"))
    uploader
  end

  let(:uploader_empty) do
    PasseportPhotoUploader.new(create(:fireman), :passeport_photo)
  end

  context 'filename' do
    it "should be passeport_photo" do
      expect(uploader.filename).to eq "passeport_photo.png"
    end
  end

  context 'resize' do
    it "should scale down to 155,200 pixels" do
      expect(uploader).to have_dimensions(155, 200)
    end

    it "should scale thumb down to 50,65 pixels" do
      expect(uploader.thumb).to have_dimensions(50, 65)
    end
  end

  context 'default_url' do
    it "should be passeport_photo.png" do
      expect(uploader_empty.url).to match /\/assets\/back\/default_passeport_photo-.*\.png/
    end
  end
end
