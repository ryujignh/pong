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

push = require 'push'

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    smallFont = love.graphics.newFont('font.ttf', 8)
    scoreFont = love.graphics.newFont('font.ttf', 32)
    

    player1Score = 0
    player2Score = 0

    player1Y = 30
    player2Y = VIRTUAL_HEIGHT - 40
        
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINODW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = false
    })
end


function love.update(dt)
    if love.keyboard.isDown('w') then
        player1Y = math.max(0, player1Y - PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('s') then
        player1Y = math.min(VIRTUAL_HEIGHT - 20, player1Y + PADDLE_SPEED * dt)
    end

    if love.keyboard.isDown('up') then
        player2Y = math.max(0, player2Y - PADDLE_SPEED * dt)

    elseif love.keyboard.isDown('down') then
        player2Y = math.min(VIRTUAL_HEIGHT - 20, player2Y + PADDLE_SPEED * dt)
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end


function love.draw()
    -- begin rendering at virtual resolution
    push:apply('start')

    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255) -- background color

    -- ball
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 5, 5) -- Doing subtraction to do manual adjustment for the position of the ball

    -- left paddle
    love.graphics.rectangle('fill', 10, player1Y, 5, 20)
    -- right paddle
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 20)

    -- condensed onto one line from last example
    -- note we are now using virtual width and height now for text placement
    love.graphics.setFont(smallFont)
    love.graphics.printf(
        "Hello Pong!", 
        0, 
        20, -- Height of "Hello Pong"
        VIRTUAL_WIDTH, 
        'center')

        love.graphics.setFont(scoreFont)
        love.graphics.print(player1Score, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
        love.graphics.print(player2Score, VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

    -- end rendering at virtual resolution
    push:apply('end')
end