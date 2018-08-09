Class = require "class"

Ball = Class {}

function Ball:init(x, y, radius)
    self.x = x
    self.y = y
    self.radius = radius
    self.dx = 0
    self.dy = 0
end

function Ball:update(dt)
    -- 上下墙壁冲突检测
    if self.y - self.radius <= 0 or self.y + self.radius >= love.graphics.getHeight() then
        self.dy = -self.dy
        if self.dy < 0 then
            self.y = self.y - self.radius
        else
            self.y = self.y + self.radius
        end
    end

    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:collide(paddle)
    return self.x < paddle.x + paddle.width and paddle.x < self.x + self.radius and self.y < paddle.y + paddle.height and paddle.y < self.y + self.radius
end

function Ball:render()
    love.graphics.setColor(0, 255, 0)
    love.graphics.circle('fill', self.x, self.y, self.radius)
end

function Ball:reset()
    self.x = love.graphics.getWidth()/2
    self.y = love.graphics.getHeight()/2
    self.dx = 0
    self.dy = 0
end