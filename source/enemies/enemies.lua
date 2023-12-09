import "alarm_analog"
import "alarm_digital"
import "alarm_phone"
import "mosquito"
import "cat"

ENEMY_SEQUENCE = {AlarmAnalog, AlarmAnalog, AlarmDigital, AlarmPhone, AlarmPhone, Mosquito, Mosquito, AlarmDigital, Mosquito, AlarmPhone, Cat, AlarmAnalog, AlarmDigital, AlarmPhone, Mosquito}
-- {AlarmAnalog, AlarmAnalog, AlarmAnalog, AlarmAnalog, AlarmAnalog, AlarmAnalog, AlarmAnalog, AlarmAnalog, AlarmAnalog, AlarmAnalog, AlarmAnalog, AlarmAnalog}
-- {AlarmAnalog, AlarmAnalog, AlarmDigital, AlarmAnalog, AlarmPhone, AlarmDigital, Mosquito, AlarmDigital, Mosquito, AlarmPhone, Cat, AlarmAnalog, AlarmDigital, AlarmPhone, Mosquito}

ENEMIES = {}

function spawn_next_enemy()
  local next_enemy_idx = #ENEMIES + 1
  local next_enemy = ENEMY_SEQUENCE[next_enemy_idx]
  if next_enemy == nil then
      print("All enemies spawned. Game won't get any harder.")
      return
  end
  next_enemy = next_enemy()
  print("Spawned enemy " .. next_enemy_idx .. " " .. next_enemy.name)
  table.insert(ENEMIES, next_enemy)
  playdate.timer.new(ENEMY_SPAWN_GAP_SECONDS*1000, function()
      spawn_next_enemy()
  end)
end
