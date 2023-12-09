CURRENT_BG_MUSIC = nil

function rampUpTheMusic(level, duration_S)
  local loops = {SOUND.BG_LOOP_1, SOUND.BG_LOOP_2, SOUND.BG_LOOP_3, SOUND.BG_LOOP_4}
  local current_loop = loops[level]
  if current_loop == nil then
    return
  end
  current_loop:play(0)
  CURRENT_BG_MUSIC = current_loop
  playdate.timer.new(duration_S*1000, function()
    if level ~= #loops then
      current_loop:stop()
    end
    rampUpTheMusic(level+1, duration_S)
  end)
end

