if fs.exists("game-utils") == false then shell.run("wget https://raw.githubusercontent.com/Terandox-The-Pineapple/TRX-Librarys/main/game-utils.lua game-utils") end
local game_utils = require("game-utils")
if fs.exists("table-utils") == false then shell.run("wget https://raw.githubusercontent.com/Terandox-The-Pineapple/TRX-Librarys/main/table-utils.lua table-utils") end
local table_utils = require("table-utils")
if fs.exists("class") == false then shell.run("wget https://raw.githubusercontent.com/Terandox-The-Pineapple/TRX-Librarys/main/class.lua class") end
local class_lib = require("class")

-- Variables
local pause = false
local buffer = false
-- Classes
local points = { posX = 1, posY = 1, value = 0, color = colours.white }
function points:draw()
    term.setCursorPos(self.posX, self.posY)
    term.setBackgroundColor(colours.black)
    term.setTextColor(self.color)
    term.write(self.value)
end

function points:undraw()
    term.setCursorPos(self.posX, self.posY)
    term.setBackgroundColor(game_utils.backgrounds.backgroundlist[game_utils.backgrounds.selected].render[self.posX][self.posY].color)
    term.write(" ")
end

function points:add()
    self:undraw()
    self.value = self.value + 1
    if self.value >= 9 then
        self.color = colours.red
    end
    self:draw()
end

function points:reset()
    self.value = 0
    self.color = colours.white
    self:draw()
end

points = class_lib.class:new(points)
-- Points
local player_points = points:new({ posX = 24, posY = 3 })
local enemy_points = points:new({ posX = 28, posY = 3 })
-- Entitys
local player = game_utils.add_player(2, 7, "player_1")
function player:reset()
    self:undraw()
    self.posX = 2
    self.posY = 7
    self:draw()
end

local enemy = game_utils.add_enemy(50, 7, "enemy_1")
function enemy:reset()
    self:undraw()
    self.posX = 50
    self.posY = 7
    self:draw()
end

local ball = game_utils.add_other(48, 9, "ball_1")
function ball:reset()
    self:undraw()
    self.posX = 48
    self.posY = 9
    self.motionX = -1
    self.motionY = math.random(2)
    if self.motionY == 2 then
        self.motionY = -1
    end
    self:draw()
end

function ball:bounce()
    self.motionY = self.motionY * -1
end

function ball:bounce_back()
    self.motionX = self.motionX * -1
end

function ball:goal()
    if self.posX == 1 then
        if enemy_points.value >= 9 then
            return end_game(false)
        else
            enemy_points:add()
            os.sleep(0.5)
            self:reset()
        end
    elseif self.posX == 51 then
        if player_points.value >= 9 then
            return end_game(true)
        else
            player_points:add()
            os.sleep(0.5)
            self:reset()
        end
    end
end

-- menus
local main_menu = game_utils.add_menu("main")
local end_menu = game_utils.add_menu("end")
-- menu points
local do_start = game_utils.add_menu_point(main_menu, "Start Game")
local do_exit = game_utils.add_menu_point(main_menu, "Exit")
local do_restart = game_utils.add_menu_point(end_menu, "Restart Game")
local do_end_exit = game_utils.add_menu_point(end_menu, "Exit")
-- backgrounds
local menu_back = game_utils.add_background("menu_back")
local game_back = game_utils.add_background("game_back")
-- controllers
local main_menu_controll = game_utils.add_controller("main_menu")
local end_menu_controll = game_utils.add_controller("end_menu")
local game_controll = game_utils.add_controller("game")
-- controller keys
game_utils.add_controller_key(main_menu_controll, "Up", keys.up, function()
    main_menu:up()
    main_menu:draw(21, 9)
end)
game_utils.add_controller_key(main_menu_controll, "Down", keys.down, function()
    main_menu:down()
    main_menu:draw(21, 9)
end)
game_utils.add_controller_key(main_menu_controll, "Select", keys.enter, function()
    if main_menu.selected == table_utils.getIndex(main_menu.selection, do_start) then
        main_menu_controll:stop()
        start_game()
    elseif main_menu.selected == table_utils.getIndex(main_menu.selection, do_exit) then
        main_menu_controll:stop()
        exit()
    end
end)
game_utils.add_controller_key(end_menu_controll, "Up", keys.up, function()
    end_menu:up()
    end_menu:draw(20, 9)
end)
game_utils.add_controller_key(end_menu_controll, "Down", keys.down, function()
    end_menu:down()
    end_menu:draw(20, 9)
end)
game_utils.add_controller_key(end_menu_controll, "Select", keys.enter, function()
    if end_menu.selected == table_utils.getIndex(end_menu.selection, do_restart) then
        end_menu_controll:stop()
        start_game()
    elseif end_menu.selected == table_utils.getIndex(end_menu.selection, do_end_exit) then
        end_menu_controll:stop()
        exit()
    end
end)
game_utils.add_controller_key(game_controll, "Up", keys.up, function()
    if pause == false and player.posY > 2 then buffer = "U" end
end)
game_utils.add_controller_key(game_controll, "Down", keys.down, function()
    local sizeX, sizeY = player:getSize()
    if pause == false and player.posY < (19 - sizeY) then buffer = "D" end
end)
game_utils.add_controller_key(game_controll, "Pause", keys.space, function()
    if pause then
        pause = false
    elseif pause == false then
        pause = true
        buffer = false
    end
end)
-- Render Inits
for x = 1, 51, 1 do
    for y = 1, 19, 1 do
        if x == 1 or x == 51 or y == 1 or y == 19 or ((x >= 19 and x <= 32) and (y >= 8 and y <= 12)) then
            menu_back.render[x][y].color = colours.white
        else
            menu_back.render[x][y].color = colours.black
        end
    end
end
for x = 1, 51, 1 do
    for y = 1, 19, 1 do
        if y == 1 or y == 19 or x == 26 then
            game_back.render[x][y].color = colours.white
        else
            game_back.render[x][y].color = colours.black
        end
    end
end
player.render[1][1].color = colours.lightGrey
player.render[1][2].color = colours.lightGrey
player.render[1][3].color = colours.lightGrey
player.render[1][4].color = colours.lightGrey
enemy.render[1][1].color = colours.lightGrey
enemy.render[1][2].color = colours.lightGrey
enemy.render[1][3].color = colours.lightGrey
enemy.render[1][4].color = colours.lightGrey
ball.render[1][1].color = colours.grey
-- Game Functions
function start_game()
    game_utils.change_background(game_back)
    player:reset()
    enemy:reset()
    ball:reset()
    player_points:reset()
    enemy_points:reset()
    game_controll:start(game)
end

function end_game(win)
    game_controll:stop()
    open_menu(false, win)
end

function open_menu(main, win)
    win = win or false
    game_utils.change_background(menu_back)
    if main then
        game_utils.change_menu(main_menu, 21, 9)
        repeat
            main_menu_controll:start(function()
                os.sleep(1)
            end)
        until main_menu_controll.finished
    else
        game_utils.change_menu(end_menu, 20, 9)
        term.setCursorPos(20, 6)
        term.setTextColor(colours.white)
        term.setBackgroundColor(colours.black)
        if win then
            term.write("You Win!!!")
        else
            term.write("You Lose!!!")
        end
        repeat
            end_menu_controll:start(function()
                os.sleep(1)
            end)
        until end_menu_controll.finished
    end
end

function game()
    while game_controll.finished == false do
        if pause == false then
            player_move()
            enemy_move()
            move_ball()
            move_ball()
            os.sleep(1)
        end
    end
end

function exit()
    os.shutdown()
end

function player_move()
    if buffer == "U" then
        player:undraw()
        player:moveUp()
        player:draw()
        buffer = false
    elseif buffer == "D" then
        player:undraw()
        player:moveDown()
        player:draw()
        buffer = false
    end
end

function enemy_move()
    local lastX, lastY = enemy:getLastPosition()
    local sizeX, sizeY = enemy:getSize()
    if (enemy.posY > ball.posY) and (enemy.posY > 2) then
        enemy:undraw()
        enemy:moveUp()
        enemy:draw()
    elseif (lastY < ball.posY) and (enemy.posY < (19 - sizeY)) then
        enemy:undraw()
        enemy:moveDown()
        enemy:draw()
    end
end

function move_ball()
    ball:undraw()
    if ball.motionX == 1 then
        ball:moveRight()
    elseif ball.motionX == -1 then
        ball:moveLeft()
    end
    if ball.motionY == 1 then
        ball:moveDown()
    elseif ball.motionY == -1 then
        ball:moveUp()
    end
    ball:draw()
    check_ball()
end

function check_ball()
    local nextX, nextY = ball.posX, ball.posY
    if nextX == 1 or nextX == 51 then return ball:goal() end
    if ball.motionX == 1 then
        nextX = nextX + 1
    elseif ball.motionX == -1 then
        nextX = nextX - 1
    end
    if ball.motionY == 1 then
        nextY = nextY + 1
    elseif ball.motionY == -1 then
        nextY = nextY - 1
    end
    if nextY == 1 or nextY == 19 then ball:bounce() end
    local plx, ply = player:getLastPosition()
    local elx, ely = enemy:getLastPosition()
    if (nextX == player.posX and nextY <= ply and nextY >= player.posY) or (nextX == enemy.posX and nextY <= ely and nextY >= enemy.posY) then
        ball:bounce_back()
    end
end

open_menu(true)
