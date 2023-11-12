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
  local t = playdate.getElapsedTime()
  if t - ENEMIES_MANAGER.last_spawned_enemy_time < PROGRESSION.SPAWN_INTERVAL_S then
    return
  end
  local randomIndex = math.random(#PROGRESSION.ENEMIES_SPAWNABLE)
  -- Init a random enemy from the list
  local enemy = PROGRESSION.ENEMIES_SPAWNABLE[randomIndex]()
  -- Ensure that only one cat exists
  if enemy.name == 'cat' then
    for _, e in ipairs(ENEMIES_MANAGER.enemies) do
      if e.name == 'cat' then
        return
      end
    end
  end
  enemy:start()
  table.insert(self.enemies, enemy)
  ENEMIES_MANAGER.last_spawned_enemy_time = t
end
