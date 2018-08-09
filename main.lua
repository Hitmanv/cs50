require "Ball"
require "Paddle"

WIDTH = 800
HEIGHT = 600
PADDLE_SPEED = 500


function love.load()
    love.window.setMode(WIDTH, HEIGHT, {
        vsync = true
    })
    love.window.setTitle("Pong")

    wg_font = love.graphics.newFont('waltographUI.ttf', 50)
    ball = Ball(WIDTH/2, HEIGHT/2, 10)
    
    p1 = Paddle(0, HEIGHT/2 - 20, 10, 100)
    p2 = Paddle(WIDTH-10, HEIGHT/2 - 20, 10, 100)
    p1_score = 0
    p2_score = 0

    collide_sound = love.audio.newSource("collide.wav", "static")
    boom_sound = love.audio.newSource("boom.wav", "static")

    status = 'stop'
end

function love.update(dt)
    -- p1 控制
    if love.keyboard.isDown("s") then
        p1.dy = PADDLE_SPEED
    elseif love.keyboard.isDown("w") then
        p1.dy = -PADDLE_SPEED
    else
        p1.dy = 0
    end
    -- p2 控制
    if love.keyboard.isDown("down") then
        p2.dy = PADDLE_SPEED
    elseif love.keyboard.isDown("up") then
        p2.dy = -PADDLE_SPEED
    else 
        p2.dy = 0
    end
    -- 球与p1,p2冲突检测
    if ball:collide(p1) or ball:collide(p2) then
        ball.dx = -ball.dx

        if ball.dx < 0 then
            ball.x = ball.x - 10
        else
            ball.x = ball.x + 10
        end
        love.audio.play(collide_sound)
    end
    -- 比分状态
    if ball.x < 0 then
        p2_score = p2_score + 1
        ball:reset()
        status = "stop"
        love.audio.play(boom_sound)
    end
    if ball.x > WIDTH then
        p1_score = p1_score + 1
        ball:reset()
        status = "stop"
        love.audio.play(boom_sound)
    end

    ball:update(dt)
    p1:update(dt)
    p2:update(dt)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if key == 'return' then
        if status == "stop" then
            ball.dx = math.random(-1000, 1000)
            ball.dy = math.random(-1000, 1000)
            status = "start"
        else
            ball:reset()
            status = "stop"
        end
    end
end

function love.draw()
    -- 比分
    love.graphics.setFont(wg_font)
    love.graphics.printf(tostring(p1_score), 0, 200, WIDTH/2, "center")
    love.graphics.printf(tostring(p2_score), WIDTH/2, 200, WIDTH/2, "center")

    love.graphics.line(WIDTH/2, 0, WIDTH/2, HEIGHT)
    ball:render()
    p1:render()
    p2:render()
    -- love.graphics.setFont(wg_font)
    -- love.graphics.printf("Game Over", 0, HEIGHT/2-25, WIDTH, "center")
end