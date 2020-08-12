ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('citizen-card', function(playerId)
    TriggerClientEvent("bayside-identity:SendProxMessage", playerId)
end)

RegisterNetEvent('brp-identity:purchaseID')
AddEventHandler('brp-identity:purchaseID', function(player)
    local xPlayer = ESX.GetPlayerFromId(player)
    if xPlayer.getMoney() >= Config.IDPrice then
        xPlayer.removeMoney(Config.IDPrice)
        xPlayer.addInventoryItem('citizen-card', 1)
        TriggerClientEvent('notification', player, 'You purchased an ID Card for $'..Config.IDPrice, 1)
    else
        TriggerClientEvent('notification', player, 'You can\'t afford this.', 2)
    end
end)

RegisterNetEvent("bayside-identity:SendProxMessage")
AddEventHandler("bayside-identity:SendProxMessage", function(players)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    MySQL.Async.fetchAll('SELECT * FROM `characters` WHERE `identifier` = @identifier', {
		['@identifier'] = xPlayer.getIdentifier()
    }, function(result)
        local job = firstToUpper(xPlayer.getJob().name) -- Ensure job is capitalized
		local firstname		= result[1].firstname
        local lastname  	= result[1].lastname
        local dateofbirth	= result[1].dateofbirth
        local sex	     	= result[1].sex
        if sex == "m" then sex = "Male" else sex = "Female" end
        if job == "Police" or job == "Offpolice" then job = "Law Enforcement" end
        if job == "Ambulance" or job == "Offambulance" then job = "EMS" end

        message = string.format("Name: %s %s | DOB: %s | Sex: %s | Job: %s", firstname, lastname, dateofbirth, sex, job)
        
        -- Show to the original player
        TriggerClientEvent('chat:addMessage', src, {
            template = '<div class="chat-message id">^*{0}</div>',
            args = { message }
        })

        print('players', #players)
        -- Show to nearby players
        for i = 1, #players, 1 do
            print('Sending message to', players[i])
            TriggerClientEvent('chat:addMessage', players[i], {
                template = '<div class="chat-message id">^*{0}</div>',
                args = { message }
            })
        end
    end)
end)

RegisterNetEvent("bayside-identity:fingerprint")
AddEventHandler("bayside-identity:fingerprint", function(source, player)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local zPlayer = ESX.GetPlayerFromId(player)

    MySQL.Async.fetchAll('SELECT * FROM `characters` WHERE `identifier` = @identifier', {
		['@identifier'] = zPlayer.getIdentifier()
    }, function(result)
        local job = firstToUpper(zPlayer.getJob().name) -- Ensure job is capitalized
		local firstname		= result[1].firstname
        local lastname  	= result[1].lastname
        local dateofbirth	= result[1].dateofbirth
        local sex	     	= result[1].sex
        if sex == "m" then sex = "Male" else sex = "Female" end
        if job == "Police" or job == "Offpolice" then job = "Law Enforcement" end
        if job == "Ambulance" or job == "Offambulance" then job = "EMS" end

        message = string.format("Name: %s %s | DOB: %s | Sex: %s | Job: %s", firstname, lastname, dateofbirth, sex, job)
        
        -- Show to the original player
        TriggerClientEvent('chat:addMessage', src, {
            template = '<div class="chat-message id">^*{0}</div>',
            args = { message }
        })

        TriggerClientEvent('notification', _source, "You have fingerprinted " .. firstname .. ' ' .. lastname)
        TriggerClientEvent('notification', args[1], "You have been fingerprinted")
    end)
end)

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end