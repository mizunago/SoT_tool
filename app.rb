#!/home/ubuntu/.rbenv/versions/2.7.3/bin/ruby
# #!/usr/bin/ruby
# encoding: utf-8
require 'bundler/setup'
require 'active_support'
require 'active_support/core_ext'
require 'sinatra'

class SotTime
  def initialize(time)
    @time = Time.at(time.to_i).utc
  end

  def sec
    0
  end

  def min
    @time.sec
  end

  def hour
    (@time.hour % 2).zero? ? @time.min % 24 : (@time.min + 12) % 24
  end

  def day
    (@time.to_i / (24 * 60)  % 30 + 1).round
  end
end

def sot_time(now)
  base = SotTime.new(now)
  base
end

def v_sot(time)
  "#{time.day}日 #{'%2.2d' % time.hour}:#{'%2.2d' % time.min}"
end

def view
  msg = []
  now = Time.now
  msg << '現在時刻:'
  msg << "　日本時間(JST): #{now.in_time_zone('Asia/Tokyo')}"
  msg << "　協定世界時(UTC/GMT): #{now.in_time_zone('UTC')}"
  msg << "　ロンドン(BST): #{now.in_time_zone('London')}"
  msg << "　アメリカ太平洋(PDT/PST): #{now.in_time_zone('America/Los_Angeles')}"
  msg << "　アメリカ東部(EDT/EST): #{now.in_time_zone('America/New_York')}"
  msg << ''
  msg << 'ゲーム内時間：'
  msg << "　<b>#{v_sot(sot_time(now))}</b>"
  #30.times do |i|
  #msg << "　<b>#{v_sot(sot_time(now + i * 24.minutes))}</b>"
  #end
  #24.times do |i|
  #msg << "　<b>#{v_sot(sot_time(now + i.minutes))}</b>"
  #end
  msg << ''
  msg.join('<BR>')
end

get '/' do
  [
    '<html>',
    '<head><meta http-equiv="refresh" content="15"></head><body>',
    view,
    '</body></html>'
  ].join("\n")
end

get '' do
  [
    '<html>',
    '<head><meta http-equiv="refresh" content="15"></head><body>',
    view,
    '</body></html>'
  ].join("\n")
end
