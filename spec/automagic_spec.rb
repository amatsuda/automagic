# coding: utf-8
require 'automagic'

RSpec::Matchers.define :say do |expected|
  match do |block|
    block.call
    $_fake_stdout.string == expected
  end
end

describe 'autmagic' do
  before do
    `cp "#{File.dirname __FILE__}/hello_org.rb" "#{File.dirname __FILE__}/hello.rb"`
    @_stdout = $stdout
    $stdout = $_fake_stdout = StringIO.new
  end
  after do
    $stdout = @_stdout
    `rm "#{File.dirname __FILE__}/hello.rb"`
  end

  describe 'load' do
    specify do
      lambda {
        load File.expand_path('../hello.rb', __FILE__)
      }.should say "こんにちは\n"
    end
  end

  describe 'require' do
    specify do
      lambda {
        require File.expand_path('../hello', __FILE__)
      }.should say "こんにちは\n"
    end
  end

  describe 'require_relative' do
    before { pending }
    specify do
      lambda {
        require_relative 'hello'
      }.should say "こんにちは\n"
    end
  end
end
