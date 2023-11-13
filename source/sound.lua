local sp <const> = playdate.sound.sampleplayer

SOUND = {
  BG_LOOP_1 = sp.new("sound/background_loop_stage1"),
  BG_LOOP_2 = sp.new("sound/background_loop_stage2"),
  BG_LOOP_3 = sp.new("sound/background_loop_stage3"),
  BG_LOOP_4 = sp.new("sound/background_loop_stage4"),
  BG_LOOP_MENU = sp.new("sound/background_loop_menu"),
  BG_LOOP_CREDITS = sp.new("sound/background_loop_credits"),
  ENEMY_ALARM_ANALOG = sp.new("sound/enemy_alarm_analog"),
  ENEMY_ALARM_PHONE = sp.new("sound/enemy_alarm_phone"),
  ENEMY_ALARM_DIGITAL = sp.new("sound/enemy_alarm_digital"),
  ENEMY_CAT = sp.new("sound/enemy_alarm_cat"),
  ENEMY_CAT_MEOW = sp.new("sound/enemy_cat_meow"),
  ENEMY_MOSQUITO = sp.new("sound/enemy_mosquito"),
  SLAP_ALARM = sp.new("sound/slap_alarm"),
  SLAP_MOSQUITO = sp.new("sound/slap_mosquito"),
  SLAP_CAT = sp.new("sound/slap_cat"),
  DEATH = sp.new("sound/death"),
}


function start_gameplay_sound() -- unused?

  SOUND.BG_LOOP_1:play()
  TIMER = playdate.timer.new(8000, function()
      if SOUND.BG_LOOP_1:isPlaying() then
          SOUND.BG_LOOP_1:stop()
      end
      SOUND.BG_LOOP_1:play()
  end)
  TIMER.repeats = true;


end

