Config = {}
----------------------------------------------------------------
Config.Locale = 'de'
Config.VersionChecker = true
Config.Debug = true
----------------------------------------------------------------
-- !!! This function is clientside AND serverside !!!
Config.Notification = function(source, message, info)
    if IsDuplicityVersion() then -- serverside
        MSK.Notification(source, 'MSK RGBHeadlights', message, info)
    else -- clientside
        MSK.Notification('MSK RGBHeadlights', message, info)
    end
end
----------------------------------------------------------------
Config.Item = {name = 'headlights', label = 'Headlights'}
Config.removeItem = true -- Set to false if you dont want to remove the Item after use

Config.useNearVehicle = true -- Set to false if you dont want to use the item outside of the vehicle
Config.useInsideVehicle = true -- Set to false if you want to use the item inside of the vehicle
Config.Distance = 3.0 -- Only effects if Config.useNearVehicle = true

Config.Colors = {
    {name = 'default', label = 'Default', color = -1}, -- please don't edit the color in this line !!
    {name = 'xenon', label = 'Xenon', color = 'xenon'}, -- please don't edit the color in this line !!
    {name = 'white', label = 'White', color = 0},
    {name = 'blue', label = 'Blue', color = 1},
    {name = 'electric_blue', label = 'Electric_Blue', color = 2},
    {name = 'mint_green', label = 'Mint Green', color = 3},
    {name = 'lime_green', label = 'Lime Green', color = 4},
    {name = 'yellow', label = 'Yellow', color = 5},
    {name = 'gold', label = 'Gold', color = 6},
    {name = 'orange', label = 'Orange', color = 7},
    {name = 'red', label = 'Red', color = 8},
    {name = 'pony_pink', label = 'Pony Pink', color = 9},
    {name = 'hot_pink', label = 'Hot Pink', color = 10},
    {name = 'purple', label = 'Purple', color = 11},
    {name = 'blacklight', label = 'Blacklight', color = 12},
}