#!/home/nagonago/.rbenv/versions/2.2.5/bin/ruby
# #!/usr/bin/ruby
# encoding: utf-8
require 'bundler/setup'
require 'active_support'
require 'active_support/core_ext'
require 'sinatra'

class SotTime
  def initialize(time)
    @time = time
  end

  def sec
    0
  end

  def min
    @time.sec
  end

  def hour
    (@time.hour % 2).zero? ? (@time.min + 12) % 24 : @time.min % 24
  end

  def day
    correct = 27
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
  msg << "　ロンドン(BST): #{now.in_time_zone('London')}"
  msg << "　アメリカ太平洋(PDT/PST): #{now.in_time_zone('America/Los_Angeles')}"
  msg << "　アメリカ東部(EDT/EST): #{now.in_time_zone('America/New_York')}"
  msg << ''
  msg << 'ゲーム内時間：'
  sot = sot_time(now)
  msg << "　<b>#{v_sot(sot)}</b>"
  msg << ''
  msg << '今の時間、幽霊船は'
  msg << sea(sot)
  msg << '次の幽霊船は'
  next_time = if (sot.day % 10).zero?
                24 - sot.hour
              else
                (10 - sot.day % 10) * 24 + (24 - sot.hour)
              end
  msg << "　約#{next_time} 分(#{'%2.1f' % (next_time / 60.0)} 時間)後に"
  msg << "　日本時間(JST): #{(now + next_time.minutes).in_time_zone('Asia/Tokyo')} 頃に"
  msg << sea(sot_time(now + next_time.minutes))

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
