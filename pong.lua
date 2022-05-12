if fs.exists("game-utils") == false then shell.run("wget https://raw.githubusercontent.com/Terandox-The-Pineapple/TRX-Librarys/main/game-utils.lua game-utils") end
local game_utils = require("game-utils")
if fs.exists("table-utils") == false then shell.run("wget https://raw.githubusercontent.com/Terandox-The-Pineapple/TRX-Librarys/main/table-utils.lua table-utils") end
local table_utils = require("table-utils")

-- menus
local main_menu = game_utils.add_menu("main")
local end_menu = game_utils.add_menu("end")
-- menu points
local do_start = game_utils.add_menu_point(main_menu, "Start Game")
local do_exit = game_utils.add_menu_point(main_menu, "Exit")
local do_restart = game_utils.add_menu_point(end_menu, "Restart Game")
local do_end_exit = game_utils.add_menu_point(end_menu, "Exit")
-- controllers
local main_menu_controll = game_utils.add_controller("main_menu")
local end_menu_controll = game_utils.add_controller("end_menu")
local game_controll = game_utils.add_controller("game")
-- controller keys
game_utils.add_controller_key(main_menu_controll, "Up", keys.up, function()
    main_menu:up()
end)
game_utils.add_controller_key(main_menu_controll, "Down", keys.down, function()
    main_menu:down()
end)
game_utils.add_controller_key(main_menu_controll, "Select", keys.enter, function()
    if main_menu.selected == table_utils.getIndex(do_start) then
        main_menu_controll:stop()
        start_game()
    elseif main_menu.selected == table_utils.getIndex(do_exit) then
        main_menu_controll:stop()
        exit = true
    end
end)
game_utils.add_controller_key(end_menu_controll, "Up", keys.up, function()
    end_menu:up()
end)
game_utils.add_controller_key(end_menu_controll, "Down", keys.down, function()
    end_menu:down()
end)
game_utils.add_controller_key(end_menu_controll, "Select", keys.enter, function()
    if end_menu.selected == table_utils.getIndex(do_restart) then
        end_menu_controll:stop()
        start_game()
    elseif end_menu.selected == table_utils.getIndex(do_end_exit) then
        end_menu_controll:stop()
        exit = true
    end
end)
-- Variables
local exit = false
-- Game Functions
function start_game()

end
