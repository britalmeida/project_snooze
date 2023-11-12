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
  local randomIndex = math.random(#PROGRESSION.ENEMIES_SPAWNABLE)
  -- Init a random enemy from the list
  local enemy = PROGRESSION.ENEMIES_SPAWNABLE[randomIndex]()
  enemy:start()
  table.insert(self.enemies, enemy)
end
