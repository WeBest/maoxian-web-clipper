
require 'fileutils'
require 'base64'
require 'ostruct'
require_relative 'log'

module Storage

  def self.save_base64_encoded_file(filename, content)
    return persist(filename) { Base64.decode64(content) }
  end

  def self.save_file(filename, content)
    return persist(filename) { content }
  end

  def self.persist(filename, &blk)
    begin
      mkdir(filename)
      content = yield blk
      File.open(filename, 'wb') {|f| f.write(content) }
      return OpenStruct.new(ok: true)
    rescue => e
      Log.fatal(e.message)
      Log.fatal(e.backtrace.join("\n"))
      return OpenStruct.new(ok: false, message: e.message)
    end
  end

  def self.mkdir(filename)
    dir = filename[0, filename.rindex('/')]
    unless File.exist?(dir)
      FileUtils.mkdir_p(dir)
    end
  end

end
