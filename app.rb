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
    correct = -1
    min_count = @time.min / 24.0
    min_count += 1
    days = @time.hour % 12 * 60 / 24.0
    ((days + min_count + correct) % 30).round
  end
end

def sot_time(now)
  base = SotTime.new(now)
  base
end

def v_sot(time)
  "#{time.day}日 #{'%2.2d' % time.hour}:#{'%2.2d' % time.min}"
end

def sea(sot)
  msg = []
  msg << '場所は'
  case sot.day
  when 1..10
    msg << '　<b>The Shores of Plenty 海域のSmuggler\'s Bay の西(マップの左上)です</b>'
    msg << <<'EOT'
    The Battle for The Shores of Plenty<br>
    North West of Smuggler's Bay, 1st through the 10th<br>
EOT
  when 11..20
    msg << '　<b>The Ancient Isles 海域のShark Bait Cove の西(マップの左下)です</b>'
    msg << <<'EOT'
    The Great War of The Ancient Isles<br>
    West of Sharkbait Cove, 11th through the 20th<br>
EOT
  when 21..30
    msg << '　<b>The Wilds 海域のMarauder\'s Arch の東(マップの右上)です</b>'
    msg << <<'EOT'
    The Final Stand of The Wilds<br>
    East of Marauder's Arch, 21st through the 30ht<br>
EOT
  end
  msg
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
  #msg << '今の時間、幽霊船は'
  #msg << sea(sot)
  #msg << '次の幽霊船は'
  #required_time = if (sot.day % 10).zero?
  #              (24 - sot.hour)
  #            else
  #              (10 - sot.day % 10) * 24 + (24 - sot.hour)
  #            end
  #msg << "　約 #{required_time} 分(#{'%2.1f' % (required_time / 60.0)} 時間)後"
  #next_time = now + (required_time - 1).minutes + (60 - sot.min).seconds
  #msg << "　日本時間(JST): #{(next_time).in_time_zone('Asia/Tokyo')}"
  #msg << "　ロンドン(BST): #{next_time.in_time_zone('London')}"
  #msg << "　アメリカ太平洋(PDT/PST): #{next_time.in_time_zone('America/Los_Angeles')}"
  #msg << "　アメリカ東部(EDT/EST): #{next_time.in_time_zone('America/New_York')}"
  #msg << sea(sot_time(next_time))

  msg.join('<BR>')
end

def release_note
  [
    '',
    '<a href="https://www.seaofthieves.com/release-notes">Release Notes</a>',
    '<a href="https://translate.google.com/translate?hl=ja&sl=auto&tl=ja&u=https%3A%2F%2Fwww.seaofthieves.com%2Frelease-notes">Release Notes(Google 翻訳)</a>',
    '',
  ].join('<br>')
end

def twitter
  [
    '',
    '<a href="https://twitter.com/seaofthieves">@seaofthieves</a>',
    '<a href="https://twitter.com/SeaOfThievesHQ">@SeaOfThievesHQ</a>',
    '',
  ].join('<br>')
end

get '/' do
  [
    '<html>',
    '<head><meta http-equiv="refresh" content="15"></head><body>',
    view,
    release_note,
    twitter,
    '</body></html>'
  ].join("\n")
end

get '' do
  [
    '<html>',
    '<head><meta http-equiv="refresh" content="15"></head><body>',
    view,
    release_note,
    twitter,
    '</body></html>'
  ].join("\n")
end
