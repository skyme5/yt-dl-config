#!/usr/bin/ruby
# frozen_string_literal: true

require 'json'

system('yaml2json flags.yaml flags.json')

data = JSON.parse(File.read('flags.json'))

config = {}

data['flags'].each_pair do |key, val|
  val.each do |gtype|
    gtype = data[gtype] if gtype == 'quality'
    [gtype].flatten.each do |type|
      config[type] = [] unless config.key?(type)
      config[type] << key.gsub('{AUDIOFORMAT}', type)
                         .gsub('{ARCHIVE}', type)
    end
  end
end

Dir.mkdir('config') unless Dir.exist?('config')
config.each_pair do |key, val|
  content = val.join("\n")
  out = File.open("config/yt.#{key}.conf", 'w')
  out.puts content
  out.close
end

list = {
  'audio' => %w[mp3 flac],
  'video' => %w[best 1080 720 480 360]
}
#
# %w[audio video].each do |fmt|
#   list[fmt].each do |quality|
#     files = ['default', fmt, quality].sort
#     out = File.open("config/yt.#{files.join('.')}.conf", 'w')
#     files.each do |file|
#       out.puts File.read("config/yt.#{file}.conf")
#     end
#     out.close
#
#     list['playlist'].each do |type|
#       files = ['default', fmt, type, quality].sort
#       out = File.open("config/yt.#{files.join('.')}.conf", 'w')
#       files.each do |file|
#         out.puts File.read("config/yt.#{file}.conf")
#       end
#       out.close
#     end
#   end
# end

[
  %w[default video output vformats],
  %w[default video playlist vformats],
  %w[default video reverse vformats],
  %w[default video channel vformats],
  %w[default audio output vformats],
  %w[default audio playlist vformats],
  %w[default audio reverse vformats],
  %w[default audio channel vformats]
].each do |config_list|
  filename = []
  content = []
  config_list.each do |file|
    filename << file if file != 'vformats'
    content << File.read("config/yt.#{file}.conf") if file != 'vformats'
  end

  list[config_list[1]].each do |f|
    out = File.open("config/yt.#{[filename, [f]].flatten.sort.join('.')}.conf", 'w')
    out.puts content, File.read("config/yt.#{f}.conf")
    out.close
  end
end
