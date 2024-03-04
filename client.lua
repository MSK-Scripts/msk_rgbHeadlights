local _menuPool, mainMenu = nil, nil
local isMenuOpen = false

CreateThread(function()
    while true do
        local sleep = 1000
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false) -- false = CurrentVehicle, true = LastVehicle

        if DoesEntityExist(vehicle) then
            local headlight = GetVehicleXenonLightsColor(vehicle)
            local plate = GetVehicleNumberPlateText(vehicle)

            local color = MSK.Trigger("msk_rgbHeadlights:getHeadlightColor", plate)
            if not color then return end
                
            if color ~= headlight then
                logging('debug', 'Set headlight to ' .. color)
                ToggleVehicleMod(vehicle, 22, true) -- toggle xenon
                SetVehicleHeadlightsColour(vehicle, color)
                ESX.Game.SetVehicleProperties(vehicle, {
                    xenonColor = color
                })
            end
        end

        Wait(sleep)
    end
end)

CreateThread(function()
	while true do
        local sleep = 1
        isMenuOpen = false
        
        if _menuPool then
            if _menuPool:IsAnyMenuOpen() then 
                isMenuOpen = true
                _menuPool:ProcessMenus()
            elseif not _menuPool:IsAnyMenuOpen() then 
                _menuPool:Remove()
            end
        end
        
		Wait(sleep)
	end
end)
---- NativeUI ----

RegisterNetEvent('msk_rgbHeadlights:checkHeadlights')
AddEventHandler('msk_rgbHeadlights:checkHeadlights', function()
    openHeadlightsMenu()
end)

function openHeadlightsMenu()
    if _menuPool then 
        _menuPool:Remove()
        _menuPool = nil
    end

    _menuPool = NativeUI.CreatePool()

    mainMenu = NativeUI.CreateMenu(Translation[Config.Locale]['header'], '~b~')
    _menuPool:Add(mainMenu)

    for k, color in pairs(Config.Colors) do
        colorList = _menuPool:AddSubMenu(mainMenu, color.label)
        colorList.ParentItem:RightLabel('~b~→→→')

        confirm = NativeUI.CreateItem(Translation[Config.Locale]['confirm'], '~b~')
        confirm:RightLabel(color.label)
        colorList:AddItem(confirm)

        confirm.Activated = function(sender, index)
            setVehicleHeadlight(color)
            _menuPool:CloseAllMenus()
        end
    end

    mainMenu:Visible(true)
    _menuPool:RefreshIndex()
    _menuPool:MouseControlsEnabled(false)
    _menuPool:MouseEdgeEnabled(false)
    _menuPool:ControlDisablingEnabled(false)
end

function setVehicleHeadlight(color)
    local setColor = false

    if Config.useNearVehicle then
        local vehicle = ESX.Game.GetClosestVehicle()

        if DoesEntityExist(vehicle) then
            local plate = GetVehicleNumberPlateText(vehicle)
            local dist = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(vehicle))

            if dist <= Config.Distance then 
                if color.color == -1 then
                    ToggleVehicleMod(vehicle, 22, false) -- toggle xenon
                    SetVehicleHeadlightsColour(vehicle, -1)
                elseif color.color == 'xenon' then
                    ToggleVehicleMod(vehicle, 22, true) -- toggle xenon
                    SetVehicleHeadlightsColour(vehicle, -1)
                else
                    ToggleVehicleMod(vehicle, 22, true) -- toggle xenon
                    SetVehicleHeadlightsColour(vehicle, color.color)
                    ESX.Game.SetVehicleProperties(vehicle, {
                        xenonColor = color.color
                    })
                end
                TriggerServerEvent('msk_rgbHeadlights:setHeadlights', color, plate)
                Config.Notification(nil, 'client', nil, Translation[Config.Locale]['new_headlight'] .. color.label)
                setColor = true
            else
                Config.Notification(nil, 'client', nil, Translation[Config.Locale]['not_in_distance'])
            end
        end

        if setColor then 
            return 
        end
    end

    if Config.useInsideVehicle then
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false) -- false = CurrentVehicle, true = LastVehicle

        if DoesEntityExist(vehicle) then
            local plate = GetVehicleNumberPlateText(vehicle)

            if color.color == -1 then
                ToggleVehicleMod(vehicle, 22, false) -- toggle xenon
                SetVehicleHeadlightsColour(vehicle, -1)
            elseif color.color == 'xenon' then
                ToggleVehicleMod(vehicle, 22, true) -- toggle xenon
                SetVehicleHeadlightsColour(vehicle, -1)
            else
                ToggleVehicleMod(vehicle, 22, true) -- toggle xenon
                SetVehicleHeadlightsColour(vehicle, color.color)
                ESX.Game.SetVehicleProperties(vehicle, {
                    xenonColor = color.color
                })
            end
            TriggerServerEvent('msk_rgbHeadlights:setHeadlights', color, plate)
            Config.Notification(nil, 'client', nil, Translation[Config.Locale]['new_headlight'] .. color.label)
        end
    end
end

logging = function(code, ...)
    if not Config.Debug then return end
    MSK.logging(code, ...)
end