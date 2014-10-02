# -*- encoding : utf-8 -*-
require 'rails_helper'

describe LogoUploader do
  include CarrierWave::Test::Matchers

  let(:uploader) do
    uploader = LogoUploader.new(create(:station), :logo)
    uploader.store!(File.open("#{Rails.root}/spec/fixtures/files/uploads/logo/logo_test.png"))
    uploader
  end

  context 'filename' do
    it "should be logo" do
      expect(uploader.filename).to eq "logo.png"
    end
  end

  context 'resize' do
    it "should scale down to 100,50 pixels" do
      expect(uploader).to have_dimensions(100, 50)
    end
  end
end
