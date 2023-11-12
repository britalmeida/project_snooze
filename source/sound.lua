local sp <const> = playdate.sound.sampleplayer

SOUND = {
  BG_LOOP_1 = sp.new("sound/background_loop_stage1"),
  BG_LOOP_2 = sp.new("sound/background_loop_stage2"),
  BG_LOOP_3 = sp.new("sound/background_loop_stage3"),
  ALARM1 = sp.new("sound/enemy_alarm_analog"),
  ALARM2 = sp.new("sound/enemy_alarm_cat"),
  ALARM3 = sp.new("sound/enemy_alarm_digital"),
  ALARM4 = sp.new("sound/enemy_cat_meow"),
  ALARM5 = sp.new("sound/enemy_mosquito"),
  ALARM6 = sp.new("sound/enemy_phone"),
  SLAP_ALARM = sp.new("sound/slap_alarm"),
  SLAP_MOSQUITO = sp.new("sound/slap_mosquito"),
  SLAP_CAT = sp.new("sound/slap_cat"),
  WINDOW_OPEN_LOOP = sp.new("sound/window_open_loop"),
  CURTAIN_CLOSE = sp.new("sound/curtain_close"),
}


function init_sound()

  SOUND.BG_LOOP_1:play()
  TIMER = playdate.timer.new(8000, function()
      if SOUND.BG_LOOP_1:isPlaying() then
          SOUND.BG_LOOP_1:stop()
      end
      SOUND.BG_LOOP_1:play()
  end)
  TIMER.repeats = true;


end

