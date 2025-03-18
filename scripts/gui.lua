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
        name = "map_frame",
        direction = "vertical",
        style = "apl_content_frame"
    }
    map_frame.style.minimal_width = 800
    map_frame.style.horizontally_stretchable = false
    map_frame.style.vertically_stretchable = true

    -- Minimap
    -- local minimap_button = content_frame.add
    -- {
    --   type = "button",
    --   style = "locomotive_minimap_button"
    -- }
    -- minimap_button.style.width = 176
    -- minimap_button.style.height = 176
    local minimap = map_frame.add{
        type = "minimap",
        position = {0,0},
        zoom = 0.25
    }
    minimap.style.minimal_width = 176
    minimap.style.minimal_height = 176
    minimap.style.horizontally_stretchable = true
    minimap.style.vertically_stretchable = true

    -- Airport list frame
    local airport_list_frame = main_frame_airport_manager.add{
        type = "frame",
        name = "airport_list_frame",
        direction = "vertical",
        style = "apl_content_frame"
    }
    airport_list_frame.style.minimal_width = 250
    airport_list_frame.style.minimal_height = 500
    airport_list_frame.style.horizontally_stretchable = true
    airport_list_frame.style.vertically_stretchable = true

    local airport_list = airport_list_frame.add{
        type = "scroll-pane",
        name = "airport_list",
        style = "apl_scroll_pane"
    }
    airport_list.style.horizontally_stretchable = true
    airport_list.style.vertically_stretchable = true

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
    storage.players[player.index] = { elements = {} }
end

script.on_init(function()
    local freeplay = remote.interfaces["freeplay"]
    if freeplay then  -- Disable freeplay popup-message
        if freeplay["set_skip_intro"] then remote.call("freeplay", "set_skip_intro", true) end
        if freeplay["set_disable_crashsite"] then remote.call("freeplay", "set_disable_crashsite", true) end
    end

    storage.players = {}

    for _, player in pairs(game.players) do
        initialize_storage(player)
    end
end)

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
