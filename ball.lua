ball = {}

local velocity, direction

function ball:load()
  self.x = 160
  self.y = 0
  self.width = 16
  self.height = 16

  self.velx = 0
  self.vely = 0

  self.gravity = 0.1
  self.colliding = false
  self.rotation = 0

  if self.sprite == nil then
    self.sprite = love.graphics.newImage("football.png")
    self.sprite:setFilter("nearest", "nearest")
  end
end

function ball:animate()
  if ball.velx < 0 then
    self.rotation = self.rotation - 6
  elseif ball.velx > 0 then
    self.rotation = self.rotation + 6
  end

  if
    self.rotation > 360 or
    self.rotation < -360 then

    self.rotation = 0
  end
end

function ball:collide(colliding)
  if not self.colliding and colliding then
    velocity = math.random(2) == 1 and 1 or 2
    direction = math.random(2) == 1 and -1 or 1

    self.velx = velocity * direction
    self.vely = -7 + velocity

    incrementScore()
  end

  self.colliding = colliding
end

function ball:update()
  self.vely = self.vely + self.gravity

  self.x = self.x + self.velx
  self.y = self.y + self.vely

  if
    self.x <= 0 or
    self.x + self.width >= game.width then

    self.velx = self.velx * -1
  end

  if self.y + self.height >= game.floor then
    self.y = game.floor - self.height
    game.state = "done"
  end

  ball:animate()
end

function ball:draw()
  love.graphics.setColor(30/255, 30/255, 30/255, 0.2)

  love.graphics.ellipse(
    "fill", self.x + self.width / 2, game.floor,
    10 + math.min(math.abs(self.y + self.height - game.floor), 12), 4
  )

  love.graphics.setColor(255/255, 255/255, 255/255)

  love.graphics.draw(
    self.sprite,
    self.x + self.width / 2, self.y + self.height / 2,
    math.rad(self.rotation), 1, 1, self.width / 2, self.height / 2
  )
end
