-- Funkce pro odesílání zprávy na Discord ve formě embed a ping uživatele
function sendToDiscordEmbed(name, action, discordID, coords, licensePlate)
    local mention = discordID and string.format("<@%s>", discordID) or "Neznámé"
    local embedContent = {
        {
            ["color"] = 15548997, -- Barva embedu
            ["title"] = "Admin Akce",
            ["fields"] = {
                {["name"] = "Jméno", ["value"] = name, ["inline"] = true},
                {["name"] = "Funkce", ["value"] = action, ["inline"] = true},
                {["name"] = "Discord", ["value"] = mention, ["inline"] = true},
                {["name"] = "Vozidlo", ["value"] = licensePlate or "Neznámé", ["inline"] = false},
                {["name"] = "Souřadnice", ["value"] = coords or "Neznámé", ["inline"] = false}
            },
            ["footer"] = {
                ["text"] = os.date("Datum a čas: %d.%m.%Y %H:%M:%S"),
            }
        }
    }

    PerformHttpRequest(
        "https://discord.com/api/webhooks/1313531377542631576/NameHkcvm6qOtro4_trsm53_0bf_tvS85zA3vJC7dWBbTVoqx2Ydf8wCjjKe2tKqk3Yp", 
        function(err, text, headers) end, 
        'POST', 
        json.encode({
            username = "Admin Mod Car", 
            embeds = embedContent -- Embed obsahující zmínku
        }), 
        { ['Content-Type'] = 'application/json' }
    )
end


-- Pomocná funkce pro odesílání logů admin akcí na Discord
function logAdminActionEmbed(xPlayer, action)
    local name = xPlayer.getName()
    local identifiers = GetPlayerIdentifiers(xPlayer.source)
    local discordID = nil
    local coords = "Neznámé"
    local licensePlate = "Neznámé"

    -- Hledání Discord ID
    for _, id in pairs(identifiers) do
        if string.sub(id, 1, 8) == "discord:" then
            discordID = string.sub(id, 9)
            break
        end
    end

    -- Získání souřadnic hráče
    local playerPed = GetPlayerPed(xPlayer.source)
    if playerPed then
        local playerCoords = GetEntityCoords(playerPed)
        coords = string.format("X: %.2f, Y: %.2f, Z: %.2f", playerCoords.x, playerCoords.y, playerCoords.z)
    end

    -- Získání SPZ vozidla
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if DoesEntityExist(vehicle) then
        licensePlate = GetVehicleNumberPlateText(vehicle) or "Neznámé"
    end

    sendToDiscordEmbed(name, action, discordID, coords, licensePlate)
end

-- Event pro ověření admin práv s embed logováním
RegisterNetEvent('admin_vehicle_mod:checkAdmin', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer then
        local playerGroup = xPlayer.getGroup()

        if playerGroup == 'owner' or playerGroup == 'admin' then
            logAdminActionEmbed(xPlayer, "Otevřel Mod Menu vozidla")
            TriggerClientEvent('admin_vehicle_mod:openMenu', src)
        else
            TriggerClientEvent('esx:showNotification', src, '~r~Nemáš oprávnění používat tento příkaz!')
            logAdminActionEmbed(xPlayer, "Pokusil se použít Mod Menu bez oprávnění")
        end
    else
        print(('Chyba: hráč s ID %s není registrován v ESX!'):format(src))
    end
end)

-- Eventy pro konkrétní akce v menu s embed logováním
RegisterNetEvent('admin_vehicle_mod:lights_on', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    logAdminActionEmbed(xPlayer, "Zapnul funkci úpravy světel")
end)

RegisterNetEvent('admin_vehicle_mod:lights_off', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    logAdminActionEmbed(xPlayer, "Vypnul funkci úpravy světel")
end)

RegisterNetEvent('admin_vehicle_mod:repair_vehicle', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    logAdminActionEmbed(xPlayer, "Opravil vozidlo")
end)

RegisterNetEvent('admin_vehicle_mod:destroy_vehicle', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    logAdminActionEmbed(xPlayer, "Zničil vozidlo")
end)

RegisterNetEvent('admin_vehicle_mod:color_change', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    logAdminActionEmbed(xPlayer, "Změnil barvu vozidla")
end)

-- Logování změny barvy vozidla
RegisterNetEvent('admin_vehicle_mod:log_vehicle_color', function(colorLabel)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    -- Odeslání logu s názvem barvy
    logAdminActionEmbed(xPlayer, ("Změnil barvu vozidla na: %s"):format(colorLabel))
end)


-- Logování změny barvy světel
RegisterNetEvent('admin_vehicle_mod:log_headlight_color', function(colorLabel)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    logAdminActionEmbed(xPlayer, ("Změnil barvu světel na: %s"):format(colorLabel))
end)
RegisterNetEvent('admin_vehicle_mod:log_headlight_color_vychozi', function(colorLabel)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    logAdminActionEmbed(xPlayer, "Změnil barvu světel na: Výchozí")
end)


-- Logování přidání tuningu
RegisterNetEvent('admin_vehicle_mod:log_tuning', function(label)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    -- Používáme pouze label pro log
    logAdminActionEmbed(xPlayer, ("Přidal tuning: %s"):format(label))
end)

-- Logování změny výkonu
RegisterNetEvent('admin_vehicle_mod:log_power', function(power)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    logAdminActionEmbed(xPlayer, ("Změnil výkon na: %s%%"):format(power))
end)

-- Logování podsvícení
RegisterNetEvent('admin_vehicle_mod:log_neon', function(lightIndex, state)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local status = state and "Zapnuto" or "Vypnuto"
    logAdminActionEmbed(xPlayer, ("Podsvícení světel vypnuto"):format(status, lightIndex))
end)
RegisterNetEvent('admin_vehicle_mod:log_neon_on', function(r, g, b)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    logAdminActionEmbed(xPlayer, "Podsvícení světel zapnuto")
end)

RegisterNetEvent('admin_vehicle_mod:log_neon_color', function(label)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    logAdminActionEmbed(xPlayer, ("Změnil barvu podsvícení na: %s"):format(label))
end)


-- Logování zatmavení skel
RegisterNetEvent('admin_vehicle_mod:log_tint', function(tint)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    -- Logování s použitím správného názvu zatmavení
    logAdminActionEmbed(xPlayer, ("Změnil zatmavení skel na: %s"):format(tint))
end)
RegisterNetEvent('admin_vehicle_mod:nenivevozidle', function(tint)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    -- Logování s použitím správného názvu zatmavení
    logAdminActionEmbed(xPlayer, "Se pokusil otevřít Mod Menu ale neni ve vozidle")
end)


