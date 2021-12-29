player = {}

local quadx, quady, quad

function player:load()
  self.x = 160
  self.y = 190
  self.width = 22
  self.height = 34

  self.velx = 0
  self.vely = 0

  self.direction = 0
  self.gravity = 0.4
  self.jumping = false

  if self.sprite == nil then
    self.sprite = love.graphics.newImage("maradona-sprite.png")
    self.sprite:setFilter("nearest", "nearest")
  end
end

function player:jump()
  if self.jumping then return end

  self.vely = -7
  self.jumping = true
end

function player:animate()
  quadx = (math.abs(self.velx) == 0 and 0 or math.floor((game.frames / 5) % 3)) * self.width

  quad = love.graphics.newQuad(quadx, 0, self.width, self.height, player.sprite:getDimensions())
end

function player:update()
  if love.keyboard.isDown("right") then
    self.velx = 3
    self.direction = 1
  end

  if love.keyboard.isDown("left") then
    self.velx = -3
    self.direction = -1
  end

  self.vely = self.vely + self.gravity

  self.x = self.x + self.velx
  self.y = self.y + self.vely

  self.x = math.max(0, math.min(game.width - self.width, self.x))
  self.y = math.max(0, math.min(game.floor - self.height, self.y))

  self.velx = self.velx * 0.8

  if math.abs(self.velx) < 0.01 then
    self.velx = 0
  end

  if self.y + self.height == game.floor then
    self.jumping = false
  end

  player:animate()
end

function player:draw()
  love.graphics.setColor(30/255, 30/255, 30/255, 0.3)

  love.graphics.ellipse(
    "fill", self.x + self.width / 2, game.floor,
    10 + math.min(math.abs(self.y + self.height - game.floor), 16), 4
  )

  love.graphics.setColor(255/255, 255/255, 255/255)

  if self.direction < 0 then
    love.graphics.draw(self.sprite, quad, self.x + self.width, self.y, 0, -1, 1)
  else
    love.graphics.draw(self.sprite, quad, self.x, self.y)
  end
end
