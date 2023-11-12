import "enemies/alarm_analog"
import "enemies/alarm_digital"
import "enemies/alarm_phone"
import "enemies/mosquito"
import "enemies/cat"

local function isInRange(number, min, max)
  return number >= min and number <= max
end

local multiplier = 2

local LVL2_THRESHOLD = 8000 * multiplier
local LVL3_THRESHOLD = 16000 * multiplier
local LVL4_THRESHOLD = 24000 * multiplier

PROGRESSION_PLAN = {
  LVL1 = {
    ID = 1,
    ENEMIES_SPAWNABLE = {AlarmDigital, AlarmAnalog},
    MUSIC = SOUND.BG_LOOP_1,
    SPAWN_INTERVAL_MS = 3000,
  },
  LVL2 = {
    ID = 2,
    ENEMIES_SPAWNABLE = {AlarmPhone, AlarmAnalog},
    MUSIC = SOUND.BG_LOOP_2,
    SPAWN_INTERVAL_MS = 3000,
  },
  LVL3 = {
    ID = 3,
    ENEMIES_SPAWNABLE = {Cat, AlarmDigital, AlarmAnalog},
    MUSIC = SOUND.BG_LOOP_3,
    SPAWN_INTERVAL_MS = 2000,
  },
  LVL4 = {
    ID = 4,
    ENEMIES_SPAWNABLE = {Mosquito, AlarmAnalog},
    MUSIC = SOUND.BG_LOOP_4,
    SPAWN_INTERVAL_MS = 2000,
  }
}

PROGRESSION = PROGRESSION_PLAN.LVL1

local function initProgressionLevel(level)
  print('Level: ' .. level.ID)
  if PROGRESSION.MUSIC:isPlaying() then
    PROGRESSION.MUSIC:stop()
  end
  PROGRESSION = level
  PROGRESSION.MUSIC:play(0)
end

initProgressionLevel(PROGRESSION_PLAN.LVL1)

function updateProgression()
  local t = playdate.getCurrentTimeMilliseconds()
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
