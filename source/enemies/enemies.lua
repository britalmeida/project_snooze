
-- file for defining the spawning and progression of different enemies

-- enemy types
-- alarmx6, cat, mosquito

-- progression
-- lvl1 alarm1 2
-- lvl2 alarm1-4 3
--     cat      1

import "alarm_analog"
import "mosquito"

PROGRESSION = {
  LVL1 = {AlarmAnalog, Mosquito},
  --LVL2 = 'alarm3', 'alarm4',
  --LVL3 = 'alarm5', 'alarm6',
}


ENEMIES_MANAGER = {
  enemies = {},
  prototypes = {
    alarm_analog = AlarmAnalog,
    mosquito = Mosquito,
  },
  proto = {}
}

function ENEMIES_MANAGER:spawnEnemy(prototype)
  local enemy = prototype()
  enemy:start()
  table.insert(self.enemies, enemy)
end

function ENEMIES_MANAGER:spawnRandomEnemy()
  local randomIndex = math.random(#ENEMIES_MANAGER.proto)
  -- Init a random enemy from the list
  local enemy = ENEMIES_MANAGER.proto[randomIndex]()
  enemy:start()
  table.insert(self.enemies, enemy)
end

function ENEMIES_MANAGER:setEnemiesPrototypes()

end
