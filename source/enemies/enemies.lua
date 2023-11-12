
-- file for defining the spawning and progression of different enemies

-- enemy types
-- alarmx6, cat, mosquito

-- progression
-- lvl1 alarm1 2
-- lvl2 alarm1-4 3
--     cat      1

import "alarm_analog"
import "alarm_digital"
import "alarm_phone"
import "mosquito"
import "cat"

ENEMIES_MANAGER = {
  enemies = {},
  prototypes = {
    alarm_analog = AlarmAnalog,
    mosquito = Mosquito,
  },
  last_spawned_enemy_time = 0,
}

function ENEMIES_MANAGER:spawnEnemy(prototype)
  local enemy = prototype()
  enemy:start()
  table.insert(self.enemies, enemy)
end

function ENEMIES_MANAGER:spawnRandomEnemy()
  local t = playdate.getCurrentTimeMilliseconds()
  if t - ENEMIES_MANAGER.last_spawned_enemy_time < PROGRESSION.SPAWN_INTERVAL_MS then
    return
  end
  ENEMIES_MANAGER.last_spawned_enemy_time = t
  print('len' .. #PROGRESSION.ENEMIES_SPAWNABLE)
  local randomIndex = math.random(#PROGRESSION.ENEMIES_SPAWNABLE)
  print('index' .. randomIndex)
  -- Init a random enemy from the list
  local prototype = PROGRESSION.ENEMIES_SPAWNABLE[randomIndex]
  print(prototype)
  local enemy = prototype()
  print(enemy)
  enemy:start()
  table.insert(self.enemies, enemy)
end
