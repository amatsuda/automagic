#TODO require_relative
module Kernel
  def load_with_automagic(load_filename, wrap=false)
    load_without_automagic load_filename, wrap
  rescue SyntaxError => e
    if e.message.include? 'invalid multibyte char'
      filename = e.message.scan(/(^.*?):/).first.first
      require 'tempfile'
      temp = Tempfile.new('automagic_temp', File.dirname(filename))
      temp.write "# coding: utf-8\n"
      temp.write File.read filename
      File.rename temp.path, filename
      File.chmod File.stat(filename).mode, filename
      temp.close

      load filename, wrap
    else
      raise e
    end
  end
  alias_method :load_without_automagic, :load
  alias_method :load, :load_with_automagic

  def require_with_automagic(name)
    require_without_automagic name
  rescue SyntaxError => e
    if e.message.include? 'invalid multibyte char'
      filename = e.message.scan(/(^.*?):/).first.first
      require 'tempfile'
      temp = Tempfile.new('automagic_temp', File.dirname(filename))
      temp.write "# coding: utf-8\n"
      temp.write File.read filename
      File.rename temp.path, filename
      File.chmod File.stat(filename).mode, filename
      temp.close

      load filename
    else
      raise e
    end
  end
  alias_method :require_without_automagic, :require
  alias_method :require, :require_with_automagic
end
