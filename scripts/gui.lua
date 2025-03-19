-- Filler Data/function still testing
local function build_airport_object(parent, caption)
    local frame = parent.add{
        type = "frame",
        name = "airport_object_frame" .. caption,
        style = "apl_content_frame"
    }
    local airport_name = frame.add{
        type = "label",
        name = "label_airport_name_" .. caption,
        caption = caption
    }
    airport_name.style.right_padding = 100
    local line = frame.add{
        type = "line",
        name = "line_" .. caption,
        direction = "vertical"
    }
    local statuses = frame.add{
        type = "table",
        column_count = 1
    }
    local status1 = statuses.add{
        type = "label",
        name = "label_status1_" .. caption,
        caption = "Status: " .. caption
    }
    local status2 = statuses.add{
        type = "label",
        name = "label_status2_" .. caption,
        caption = "Status: " .. caption
    }
    local status3 = statuses.add{
        type = "label",
        name = "label_status3_" .. caption,
        caption = "Status: " .. caption
    }
end

local function build_airport_manager_interface(player)
    local player_storage = storage.players[player.index]
    local frame = player.gui.screen

    -- The main frame
    local main_frame_airport_manager = frame.add{
        type="frame",
        name="apl_main_frame_airport_manager",
        caption={"apl.title_airport_manager"}
    }
    main_frame_airport_manager.style.size = {1280, 720}
    main_frame_airport_manager.auto_center = true

    -- Minimap frame
    local map_frame = main_frame_airport_manager.add{
        type = "frame",
        name = "apl_minimap_frame",
        direction = "vertical",
        style = "apl_content_frame"
    }
    map_frame.style.minimal_width = 800
    map_frame.style.horizontally_stretchable = false
    map_frame.style.vertically_stretchable = true

    local minimap = map_frame.add{
        type = "minimap",
        name = "apl_minimap",
        position = {0,0},
    }
    minimap.style.horizontally_stretchable = true
    minimap.style.vertically_stretchable = true
    player_storage.elements.minimap = minimap
    minimap.zoom = player_storage.zoom_level

    -- Airport list frame
    local airport_list_frame = main_frame_airport_manager.add{
        type = "frame",
        name = "airport_list_frame",
        direction = "vertical",
        style = "apl_content_frame"
    }
    airport_list_frame.style.minimal_width = 250
    airport_list_frame.style.horizontally_stretchable = true
    airport_list_frame.style.vertically_stretchable = true

    local airport_list = airport_list_frame.add{
        type = "scroll-pane",
        name = "airport_list",
        style = "apl_scroll_pane"
    }
    airport_list.style.horizontally_stretchable = true
    airport_list_frame.style.vertically_stretchable = true

    local table = airport_list.add {
        type = "table",
        name = "airport_table",
        column_count = 1
    }

    local objects = {"YYZ", "YVR", "NYC", "NRT", "LAX", "HND", "SFO"} -- filler
    for _, objects in pairs(objects) do
        build_airport_object(table, objects)
    end

    player.opened = main_frame_airport_manager
    player_storage.elements.main_frame_airport_manager = main_frame_airport_manager
end

local function toggle_airport_manager(player)
    local player_storage = storage.players[player.index]
    local main_frame_airport_manager = player_storage.elements.main_frame_airport_manager

    if main_frame_airport_manager == nil then
        build_airport_manager_interface(player)
    else
        main_frame_airport_manager.destroy()
        player_storage.elements = {}
    end
end

local function initialize_storage(player)
    storage.players[player.index] = { elements = {}, zoom_level = 10, zoom = true }
end

function init_gui()
    storage.players = {}

    for _, player in pairs(game.players) do
        initialize_storage(player)
    end
end

script.on_configuration_changed(function(config_changed_data)
    if config_changed_data.mod_changes["airport-logistics"] then
        for _, player in pairs(game.players) do
            local player_storage = storage.players[player.index]
            if player_storage.elements.main_frame ~= nil then toggle_airport_manager(player) end
        end
    end
end)

script.on_event(defines.events.on_player_created, function(event)
    local player = game.get_player(event.player_index)
    initialize_storage(player)
end)

script.on_event(defines.events.on_player_removed, function(event)
    storage.players[event.player_index] = nil
end)

script.on_event("apl_toggle_airport_manager", function(event)
    local player = game.get_player(event.player_index)
    toggle_airport_manager(player)
end)

script.on_event(defines.events.on_gui_closed, function(event)
    if event.element and event.element.name == "apl_main_frame_airport_manager" then
        local player = game.get_player(event.player_index)
        toggle_airport_manager(player)
    end
end)

script.on_event(defines.events.on_gui_leave, function(event)
    if event.element.name == "apl_minimap" then
        local player_storage = storage.players[event.player_index]
        player_storage.zoom = false
        game.print("not hovering")
    end
end)

script.on_event("apl_minimap_zoom_in", function(event)
    local player_storage = storage.players[event.player_index]
    local main_frame_airport_manager = player_storage.elements.main_frame_airport_manager
    local minimap = player_storage.elements.minimap
    if main_frame_airport_manager ~= nil and player_storage.zoom_level < 1000 then
        player_storage.zoom_level = player_storage.zoom_level * 1.1
        minimap.zoom = player_storage.zoom_level
    end
end)

script.on_event("apl_minimap_zoom_out", function(event)
    local player_storage = storage.players[event.player_index]
    local main_frame_airport_manager = player_storage.elements.main_frame_airport_manager
    local minimap = player_storage.elements.minimap
    if main_frame_airport_manager ~= nil and player_storage.zoom_level > 1 then
        player_storage.zoom_level = player_storage.zoom_level * 0.9
        minimap.zoom = player_storage.zoom_level
    end
end)
