ESX = exports["es_extended"]:getSharedObject()

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
        local alterTable = MySQL.query.await("ALTER TABLE owned_vehicles ADD COLUMN IF NOT EXISTS `headlight` varchar(255) DEFAULT NULL;")
        local item = MySQL.query.await("SELECT * FROM items WHERE name = @name", {['@name'] = Config.Item.name})

        if alterTable and alterTable.warningStatus < 1 then
			debug('^2 Successfully ^3 altered ^2 table ^3 owned_vehicles ^0')
		end

        if not item[1] then
			debug('^1 Item ^3 ' .. Config.Item.name .. ' ^1 not exists, inserting item... ^0')
			local insertItem = MySQL.query.await("INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('" .. Config.Item.name .. "', '" .. Config.Item.label .. "', 1, 0, 1);")
			if insertItem then
				debug('^2 Successfully ^3 inserted ^2 Item ^3 ' .. Config.Item.name .. ' ^2 in ^3 items ^0')
			end
		end
    end
end)

ESX.RegisterUsableItem(Config.Item.name, function(source)
    local src = source
	local xPlayer = ESX.GetPlayerFromId(src)

    xPlayer.triggerEvent('msk_rgbHeadlights:checkHeadlights')
end)

RegisterServerEvent('msk_rgbHeadlights:setHeadlights')
AddEventHandler('msk_rgbHeadlights:setHeadlights', function(color, plate)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    debug('Set Headlight to ' .. color.color .. ' from Plate ' .. plate)

	if color.color == -1 or color.color == 'xenon' then 
		MySQL.query('UPDATE owned_vehicles SET headlight = @headlight WHERE plate = @plate', {
			['@headlight'] = NULL,
			['@plate'] = plate
		})
	else
		MySQL.query('UPDATE owned_vehicles SET headlight = @headlight WHERE plate = @plate', {
			['@headlight'] = color.color,
			['@plate'] = plate
		})
	end

	if Config.removeItem then
		xPlayer.removeInventoryItem(Config.Item.name, 1)
	end
end)

ESX.RegisterServerCallback("msk_rgbHeadlights:getHeadlightColor", function(source, cb, plate)
    local owned_vehicles = MySQL.query.await("SELECT * FROM owned_vehicles WHERE plate = @plate", {['@plate'] = plate})

    if owned_vehicles[1] and owned_vehicles[1].headlight then
        cb(tonumber(owned_vehicles[1].headlight))
    else
        cb(false)
    end
end)

function debug(msg, msg2, msg3)
	if Config.Debug then
		if msg3 then
			print('[DEBUG]', msg, msg2, msg3)
        elseif msg2 and not msg3 then
            print('[DEBUG]', msg, msg2)
        else
		    print('[DEBUG]', msg)
        end
	end
end

---- GitHub Updater ----

function GetCurrentVersion()
	return GetResourceMetadata( GetCurrentResourceName(), "version" )
end

local CurrentVersion = GetCurrentVersion()
local resourceName = "^4["..GetCurrentResourceName().."]^0"

if Config.VersionChecker then
	PerformHttpRequest('https://raw.githubusercontent.com/MSK-Scripts/msk_rgbHeadlights/main/VERSION', function(Error, NewestVersion, Header)
		print("###############################")
    	if CurrentVersion == NewestVersion then
	    	print(resourceName .. '^2 ✓ Resource is Up to Date^0 - ^5Current Version: ^2' .. CurrentVersion .. '^0')
    	elseif CurrentVersion ~= NewestVersion then
        	print(resourceName .. '^1 ✗ Resource Outdated. Please Update!^0 - ^5Current Version: ^1' .. CurrentVersion .. '^0')
	    	print('^5Newest Version: ^2' .. NewestVersion .. '^0 - ^6Download here: ^9https://github.com/MSK-Scripts/msk_rgbHeadlights/releases/tag/v'.. NewestVersion .. '^0')
    	end
		print("###############################")
	end)
else
	print("###############################")
	print(resourceName .. '^2 ✓ Resource loaded^0')
	print("###############################")
end