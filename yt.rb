#!/usr/bin/ruby
# frozen_string_literal: true

def audio
  %w[mp3 flac]
end

def playlist
  %w[playlist channel]
end

def video_q
  %w[best 1080 720 480 360].each do |e|
    return true if ARGV.include? e
  end

  false
end

url = ARGV.pop
command = ARGV + ['default']

is_audio = (ARGV & audio).any?
is_playlist = ARGV.include? 'playlist'
is_channel = ARGV.include? 'channel'

command << if is_audio
             'audio'
           else
             'video'
           end

command << 'output' if !is_playlist && !is_channel

command << '720' if !is_audio && !video_q

if ARGV.include? 'debug'
  puts command.flatten
  exit
else
  p command.sort!
  system("youtube-dl --config-location ~/.yt-dl/yt.#{command.sort.join('.')}.conf #{url}")
end
