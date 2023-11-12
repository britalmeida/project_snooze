
-- file for defining the spawning and progression of different enemies

-- enemy types
-- alarmx6, cat, mosquito

-- progression
-- lvl1 alarm1 2
-- lvl2 alarm1-4 3
--     cat      1

import "alarm"

PROGRESSION = {
  LVL1 = 'alarm1', 'alarm2',
  LVL2 = 'alarm3', 'alarm4',
  LVL3 = 'alarm5', 'alarm6',
}

ENEMIES_MANAGER = {
  enemies = {}
}

function ENEMIES_MANAGER:spawnEnemy(category, variant)
  variant = variant or nil
  if category == 'alarm' then
    local alarm = Alarm(variant)
    alarm:start()
    table.insert(self.enemies, alarm)
  elseif category == 'cat' then
    return nil
  elseif category == 'mosquito' then
    return nil
  end
end
