require "ball"
require "player"

assets = {}

game = {
  width = 352,
  height = 256,
  scale = 3,
  floor = 224,
  score = 0,
  frames = 0,
  state = "play"
}

local velocity, direction

function checkCircularCollision(ax, ay, bx, by, ar, br)
	local dx = bx - ax
	local dy = by - ay

	return dx^2 + dy^2 < (ar + br)^2
end

function clearGame()
  ball:load()
  player:load()

  game.score = 0
  game.state = "play"
end

function incrementScore()
  game.score = game.score + 1
end

function love.load()
  love.window.setTitle("maradona soccer")
  love.window.setMode(game.width * game.scale, game.height * game.scale)

  ball:load()
  player:load()

  background = love.graphics.newImage("background.png")
  smallfont = love.graphics.newFont("retrogaming.ttf", 16)
  largefont = love.graphics.newFont("retrogaming.ttf", 32)

  love.graphics.setDefaultFilter("nearest", "nearest")
  background:setFilter("nearest", "nearest")

  math.randomseed(os.time())
end

function love.keypressed(key)
  if key == "space" then
    if game.state == "play" then
      player:jump()
    elseif game.state == "done" then
      clearGame()
    end
  end
end

function love.update(delta)
  if game.state == "done" then return end

  if 1 / 60 > delta then
    love.timer.sleep(1 / 60 - delta)
  end

  game.frames = game.frames + 1

  if
    checkCircularCollision(
      ball.x + ball.width / 2, ball.y + ball.height / 2,
      player.x + player.width / 2, player.y + player.height / 3,
      ball.width / 2, player.width / 2
    ) then

    ball:collide(true)
  else
    ball:collide(false)
  end

  player:update()
  ball:update()
end

function love.draw()
  love.graphics.scale(game.scale, game.scale)
  love.graphics.clear(38 / 255, 201 / 255, 255 / 255)

  love.graphics.setColor(255/255, 255/255, 255/255)
  love.graphics.draw(background, 0, 0)

  player:draw()
  ball:draw()

  love.graphics.setFont(smallfont)
  love.graphics.setColor(20/255, 20/255, 20/255)

  if game.state == "play" then
    love.graphics.printf("embaixadinhas: " .. game.score, 16, 8, game.width, "left")
  else
    love.graphics.setFont(largefont)
    love.graphics.printf("embaixadinhas: " .. game.score, 0, (game.height / 2) - 40, game.width, "center")

    love.graphics.setFont(smallfont)
    love.graphics.printf("aperte [espaco] para jogar de novo", 0, game.height / 2, game.width, "center")
  end
end
