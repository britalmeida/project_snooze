local sp <const> = playdate.sound.sampleplayer

SOUND = {
  ALARM1 = sp.new("sound/alarm1"),
  ALARM2 = sp.new("sound/alarm2"),
  ALARM3 = sp.new("sound/alarm3"),
  ALARM4 = sp.new("sound/alarm4"),
  ALARM5 = sp.new("sound/alarm5"),
  ALARM6 = sp.new("sound/alarm6"),
  BG_LOOP_1 = sp.new("sound/background_loop_stage1"),
  BG_LOOP_2 = sp.new("sound/background_loop_stage2"),
  BG_LOOP_3 = sp.new("sound/background_loop_stage3"),
  CAT_MEOW = sp.new("sound/cat_meow"),
  CURTAIN_CLOSE = sp.new("sound/curtain_close"),
  SLAP_ALARM = sp.new("sound/slap_alarm"),
  SLAP_MOSQUITO = sp.new("sound/slap_mosquito"),
  WINDOW_OPEN_LOOP = sp.new("sound/window_open_loop"),
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

