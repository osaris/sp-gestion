# -*- encoding : utf-8 -*-
require 'rubygems'

ENV['EXECJS_RUNTIME'] = 'RubyRacer'

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])