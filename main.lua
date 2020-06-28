-- push.lua v0.3


local love11 = love.getVersion() == 11
local getDPI = love11 and love.window.getDPIScale or love.window.getPixelScale
local windowUpdateMode = love11 and love.window.updateMode or function(width, height, settings)

    local _, _, flags = love.window.getMode()
    for k, v in pairds(settings) do flag[k]= v end
    love.window.setMode(width, height, flags)
end

local push = {

    defaults = {
        fullscreen = false,
        resizable = false,
        pixelperfect = false,
        highdpi = true,
        canvas = true,
        stencil = true
    }
}

WINODW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT= 243

PADDLE_SPEED = 200
Class = require 'class'
push = require 'push'

require 'Ball'
require 'Paddle'

function love.load()
    math.randomseed(os.time())

    
    love.graphics.setDefaultFilter('nearest', 'nearest')

    smallFont = love.graphics.newFont('font.ttf', 8)
    scoreFont = love.graphics.newFont('font.ttf', 32)
    

    player1Score = 0
    player2Score = 0

    player1Y = 30
    player2Y = VIRTUAL_HEIGHT - 40

    paddle1 = Paddle(5, 20, 5, 20)
    paddle2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)
    ball = Ball(VIRTUAL_WIDTH / 2 -  2, VIRTUAL_HEIGHT / 2 - 2, 5, 5)

    gameState = 'start'
        
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINODW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = false
    })
end


function love.update(dt)

    if ball:collides(paddle1) then
        -- deflect ball to the right
        ball.dx = -ball.dx
    end

    if ball:collides(paddle2) then
        -- deflect ball to the left
        ball.dx = -ball.dx
    end

    if ball.y <= 0 then
        -- deflect the ball down
        ball.dy = -ball.dy        
        ball.y = 0
    end

    if ball.y >= VIRTUAL_HEIGHT - 4 then
        ball.dy = -ball.dy
        ball.y = VIRTUAL_HEIGHT - 4
    end

    paddle1:update(dt)
    paddle2:update(dt)

    if love.keyboard.isDown('w') then
        paddle1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        paddle1.dy = PADDLE_SPEED
    else
        paddle1.dy = 0
    end

    if love.keyboard.isDown('up') then
        paddle2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        paddle2.dy = PADDLE_SPEED
    else
        paddle2.dy = 0
    end

    if gameState == 'play' then
        ball:update(dt)
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        elseif gameState == 'play' then
            gameState = 'start'
            ball:reset()
        end
    end
end


function love.draw()
    -- begin rendering at virtual resolution
    push:apply('start')

    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255) -- background color

    paddle1:render() -- left paddle
    paddle2:render() -- right paddle
    ball:render()
    displayFPS()

    -- condensed onto one line from last example
    -- note we are now using virtual width and height now for text placement
    love.graphics.setFont(smallFont)
    if gameState == 'start' then
        love.graphics.printf("Hello Start State!", 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then
        love.graphics.printf("Hello Play State!", 0, 20, VIRTUAL_WIDTH, 'center')
    end

    love.graphics.setFont(scoreFont)
    love.graphics.print(player1Score, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(player2Score, VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

    -- end rendering at virtual resolution
    push:apply('end')
end

function displayFPS()
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.setFont(smallFont)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 40, 20)
    love.graphics.setColor(1, 1, 1, 1)
end