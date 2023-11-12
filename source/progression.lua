import "enemies/alarm_analog"
import "enemies/alarm_digital"
import "enemies/alarm_phone"
import "enemies/mosquito"
import "enemies/cat"

local function isInRange(number, min, max)
  return number >= min and number <= max
end

local multiplier = 1

local LVL2_THRESHOLD = 8 * multiplier
local LVL3_THRESHOLD = 16 * multiplier
local LVL4_THRESHOLD = 24 * multiplier

PROGRESSION_PLAN = {
  LVL1 = {
    ID = 1,
    ENEMIES_SPAWNABLE = {AlarmAnalog, AlarmDigital},
    MUSIC = SOUND.BG_LOOP_1,
    SPAWN_INTERVAL_S = 3,
  },
  LVL2 = {
    ID = 2,
    ENEMIES_SPAWNABLE = {AlarmPhone, AlarmAnalog},
    MUSIC = SOUND.BG_LOOP_2,
    SPAWN_INTERVAL_S = 3,
  },
  LVL3 = {
    ID = 3,
    ENEMIES_SPAWNABLE = {Cat, AlarmDigital, AlarmAnalog},
    MUSIC = SOUND.BG_LOOP_3,
    SPAWN_INTERVAL_S = 2,
  },
  LVL4 = {
    ID = 4,
    ENEMIES_SPAWNABLE = {Mosquito, AlarmAnalog},
    MUSIC = SOUND.BG_LOOP_4,
    SPAWN_INTERVAL_S = 2,
  }
}

PROGRESSION = PROGRESSION_PLAN.LVL1

function initProgressionLevel(level)
  print('Level: ' .. level.ID)
  if PROGRESSION.MUSIC:isPlaying() then
    PROGRESSION.MUSIC:stop()
  end
  PROGRESSION = level
  PROGRESSION.MUSIC:play(0)
end

function updateProgression()
  local t = playdate.getElapsedTime()
  if t > LVL4_THRESHOLD then
    if PROGRESSION.ID ~= PROGRESSION_PLAN.LVL4.ID then
      initProgressionLevel(PROGRESSION_PLAN.LVL4)
    end
  elseif isInRange(t, LVL3_THRESHOLD, LVL4_THRESHOLD) then
    if PROGRESSION.ID ~= PROGRESSION_PLAN.LVL3.ID then
      initProgressionLevel(PROGRESSION_PLAN.LVL3)
    end
  elseif isInRange(t, LVL2_THRESHOLD, LVL3_THRESHOLD) then
    if PROGRESSION.ID ~= PROGRESSION_PLAN.LVL2.ID then
      initProgressionLevel(PROGRESSION_PLAN.LVL2)
    end
  end
end
