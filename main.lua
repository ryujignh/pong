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

push = require 'push'

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINODW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = false
    })
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end


function love.draw()
    push:apply('start')

    love.graphics.printf(
        "Hello Pong!", 
        0, 
        VIRTUAL_HEIGHT / 2 - 6, 
        VIRTUAL_WIDTH, 
        'center')

    push:apply('end')
end