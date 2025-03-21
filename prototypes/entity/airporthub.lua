-- Airport Hub

local airportHub = {
    type = "container",
    name = "airport-hub",
    
    icon = "__base__/graphics/icons/cargo-landing-pad.png",

    flags = { "placeable-neutral", "placeable-player", "player-creation" },

    minable = { mining_time = 0.5, result = "airport-hub" },
    max_health = 400,
    corpse = "cargo-landing-pad-remnants",
    dying_explosion = "rocket-silo-explosion",

    -- Default cargo landing pad box definitions
    collision_box = {{-3.9, -3.9}, {3.9, 3.9}},
    selection_box = {{-4, -4}, {4, 4}},
    
    open_sound = { filename = "__base__/sound/machine-open.ogg", volume = 0.85 },
    close_sound = { filename = "__base__/sound/machine-close.ogg", volume = 0.75 },
    
    inventory_size = 80,

    circuit_wire_max_distance = 10,

    picture = {
        layers = 
        {
            {
                filename = "__airport-logistics__/graphics/buildings/cc.png",
                priority = "extra-high",
                width = 72,
                height = 72,
                scale = 3
            },
            {
                filename = "__airport-logistics__/graphics/buildings/cc.png",
                priority = "extra-high",
                width = 72,
                height = 72,
                scale = 3,
                shift = util.by_pixel(10.5, 6),
                draw_as_shadow = true,
            }
        },
    },
}

local airportHubItem = {
    type = "item",
    name = "airport-hub",
    icon = "__airport-logistics__/graphics/buildings/cc-icon.png",
    icon_size = 36,
    subgroup = "logistic-network",
    place_result = "airport-hub",
    stack_size = 1,
    weight = 100 * kg

}

-- Recipe stats
local airportHubRecipe = {
    type = "recipe",
    name = "airport-hub",
    enabled = true,
    energy_required = 1, -- time to craft in seconds (at crafting speed 1)
    ingredients = {
      {type = "item", name = "iron-plate", amount = 1},
    },
    results = {{type = "item", name = "airport-hub", amount = 1}}
}

data:extend{airportHub, airportHubItem, airportHubRecipe} -- Maybe we should separate entities, items, recipes, like in the base game? 