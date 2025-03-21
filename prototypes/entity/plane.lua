-- All numbers and recipes are temporary
local function imageloop(filepath, filenumber, divider)
    local filelist = {}
        for i=0,(filenumber-1) do
            local file = filepath .. i .. ".png"
            if divider then
            if i % divider == 0 then
                table.insert(filelist, file)
            end
            else
            table.insert(filelist, file)
            end
        end
        return filelist
    end

local plane = {
    type = "locomotive",
    name = "plane",
    max_power = "750W",
    reversing_power_modifier = 1.0,
    energy_source = {
        type = "burner",
        fuel_categories = {"chemical"},
        effectivity = 1,
        fuel_inventory_size = 3
    },
    max_speed = 12,
    air_resistance = 0.0001,
    joint_distance = 5,
    connection_distance = 1,
    vertical_selection_shift = 1,
    weight = 10,
    braking_power = "100W",
    friction = 0.00001,
    energy_per_hit_point = 10,
    collision_box = {{-3, -3}, {3, 3}},
    selection_box = {{-3, -3}, {3, 3}},
    mineable = {
        mining_time = 1
    },
    pictures = {
        rotated = {
            layers = {
                {
                    priority = "low",
                    width = 512,
                    height = 512,
                    direction_count = 256,
                    allow_low_quality_rotation = true,
                    filenames = imageloop("__airport-logistics__/graphics/aircraft/temp_plane_", 4),
                    line_length = 8,
                    lines_per_file = 8,
                    scale = 0.85
                }
            }
        }
    }
}

local planeItem = {
    type = "item-with-entity-data",
    name = "plane",
    icon = "__airport-logistics__/graphics/aircraft/plane.png",
    icon_size = 360,
    subgroup = "logistic-network",
    stack_size = 1,
    place_result = "plane",
    weight = 100 * kg
}

-- Recipe stats
local planeRecipe = {
    type = "recipe",
    name = "plane",
    enabled = true,
    energy_required = 1, -- time to craft in seconds (at crafting speed 1)
    ingredients = {
      {type = "item", name = "iron-plate", amount = 1},
    },
    results = {{type = "item", name = "plane", amount = 1}}
}

data:extend{plane, planeItem, planeRecipe} -- Maybe we should separate entities, items, recipes, like in the base game? 