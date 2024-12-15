-- by filipp
local function openLightMenu(vehicle)
    local elements = {
        { label = "Zapnout světla", value = "lights_on" },
        { label = "Vypnout světla", value = "lights_off" },
        { label = "Barva: Výchozí", value = { label = "Výchozí" } },
        { label = "Barva: Modrá", value = { r = 0, g = 0, b = 255, label = "Modrá" } },
        { label = "Barva: Zelená", value = { r = 0, g = 255, b = 0, label = "Zelená" } },
        { label = "Barva: Červená", value = { r = 255, g = 0, b = 0, label = "Červená" } },
        { label = "Barva: Žlutá", value = { r = 255, g = 255, b = 0, label = "Žlutá" } },
        { label = "Barva: Růžová", value = { r = 255, g = 105, b = 180, label = "Růžová" } },
        { label = "Barva: Tyrkysová", value = { r = 64, g = 224, b = 208, label = "Tyrkysová" } }
    }

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'light_menu', {
        title = "Nastavení světel vozidla",
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        if data.current.value == "lights_on" then
            SetVehicleLights(vehicle, 2)
            TriggerServerEvent('admin_vehicle_mod:lights_on')  -- Zapnutí světel
            ESX.ShowNotification("~g~Světla zapnuta!")
        elseif data.current.value == "lights_off" then
            SetVehicleLights(vehicle, 1)
            TriggerServerEvent('admin_vehicle_mod:lights_off')  -- Vypnutí světel
            ESX.ShowNotification("~r~Světla vypnuta!")
        elseif data.current.value.label == "Výchozí" then
            ToggleVehicleMod(vehicle, 22, false)  -- Výchozí barva světel
            ESX.ShowNotification("~g~Barva světel nastavena na výchozí!")
            TriggerServerEvent('admin_vehicle_mod:log_headlight_color_vychozi')
        else
            -- Nastavení barvy xenonových světel
            local color = data.current.value
            ToggleVehicleMod(vehicle, 22, true)  -- Aktivace xenonů
            SetVehicleHeadlightsColour(vehicle, GetVehicleLightColor(color))
            ESX.ShowNotification(("~g~Barva světel změněna na: %s!"):format(color.label))
            TriggerServerEvent('admin_vehicle_mod:log_headlight_color', color.label) -- Poslání labelu na server
        end
        menu.close()
    end, function(data, menu)
        menu.close()
    end)
end


-- Pomocná funkce pro převod barvy na hodnotu pro světla v GTA V
function GetVehicleLightColor(color)
    if color.r == 0 and color.g == 0 and color.b == 255 then
        return 2 -- Modrá
    elseif color.r == 0 and color.g == 255 and color.b == 0 then
        return 1 -- Zelená
    elseif color.r == 255 and color.g == 0 and color.b == 0 then
        return 3 -- Červená
    elseif color.r == 255 and color.g == 255 and color.b == 0 then
        return 5 -- Žlutá
    elseif color.r == 255 and color.g == 105 and color.b == 180 then
        return 8 -- Růžová
    elseif color.r == 64 and color.g == 224 and color.b == 208 then
        return 6 -- Tyrkysová
    else
        return 0 -- Výchozí bílá
    end
end

local function openColorMenu(vehicle)
    local elements = {
        { label = "Červená", value = { r = 255, g = 0, b = 0, label = "Červená" } },
        { label = "Zelená", value = { r = 0, g = 255, b = 0, label = "Zelená" } },
        { label = "Modrá", value = { r = 0, g = 0, b = 255, label = "Modrá" } },
        { label = "Žlutá", value = { r = 255, g = 255, b = 0, label = "Žlutá" } },
        { label = "Oranžová", value = { r = 255, g = 165, b = 0, label = "Oranžová" } },
        { label = "Fialová", value = { r = 128, g = 0, b = 128, label = "Fialová" } },
        { label = "Růžová", value = { r = 255, g = 105, b = 180, label = "Růžová" } },
        { label = "Hnědá", value = { r = 139, g = 69, b = 19, label = "Hnědá" } },
        { label = "Šedá", value = { r = 128, g = 128, b = 128, label = "Šedá" } },
        { label = "Černá", value = { r = 0, g = 0, b = 0, label = "Černá" } },
        { label = "Bílá", value = { r = 255, g = 255, b = 255, label = "Bílá" } },
        { label = "Tyrkysová", value = { r = 64, g = 224, b = 208, label = "Tyrkysová" } },
        { label = "Krémová", value = { r = 255, g = 253, b = 208, label = "Krémová" } },
        { label = "Zlatá", value = { r = 255, g = 215, b = 0, label = "Zlatá" } },
        { label = "Stříbrná", value = { r = 192, g = 192, b = 192, label = "Stříbrná" } },
        { label = "Indigová", value = { r = 75, g = 0, b = 130, label = "Indigová" } },
        { label = "Limetková", value = { r = 50, g = 205, b = 50, label = "Limetková" } },
        { label = "Mintová", value = { r = 189, g = 252, b = 201, label = "Mintová" } },
        { label = "Korálová", value = { r = 255, g = 127, b = 80, label = "Korálová" } },
        { label = "Béžová", value = { r = 245, g = 245, b = 220, label = "Béžová" } },
        { label = "Tmavě modrá", value = { r = 0, g = 0, b = 139, label = "Tmavě modrá" } },
        { label = "Lávová", value = { r = 255, g = 69, b = 0, label = "Lávová" } },
        { label = "Oliva", value = { r = 107, g = 142, b = 35, label = "Oliva" } },
        { label = "Kobaltová", value = { r = 0, g = 71, b = 171, label = "Kobaltová" } }
    }

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'color_menu', {
        title = "Výběr barvy vozidla",
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        local color = data.current.value
        SetVehicleCustomPrimaryColour(vehicle, color.r, color.g, color.b)
        SetVehicleCustomSecondaryColour(vehicle, color.r, color.g, color.b)
        ESX.ShowNotification(("~g~Barva vozidla změněna na: %s!"):format(color.label))
        -- Poslání na server s label
        TriggerServerEvent('admin_vehicle_mod:log_vehicle_color', color.label)
        menu.close()
    end, function(data, menu)
        menu.close()
    end)
end


local function openTuningMenu(vehicle)
    local elements = {
        { label = "Maximální brzdy", value = { modType = 12, modIndex = GetNumVehicleMods(vehicle, 12) - 1 } },
        { label = "Maximální motor", value = { modType = 11, modIndex = GetNumVehicleMods(vehicle, 11) - 1 } },
        { label = "Maximální převodovka", value = { modType = 13, modIndex = GetNumVehicleMods(vehicle, 13) - 1 } },
        { label = "Maximální suspension", value = { modType = 15, modIndex = GetNumVehicleMods(vehicle, 15) - 1 } },
        { label = "Maximální turbo", value = { modType = 18, modIndex = 1 } },
        { label = "Maximální armour", value = { modType = 16, modIndex = GetNumVehicleMods(vehicle, 16) - 1 } }
    }    
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'tuning_menu', {
        title = "Tuning vozidla",
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        local label = data.current.label  -- Zachování labelu pro logování
        local modType = data.current.value.modType
        local modIndex = data.current.value.modIndex
        
        -- Použití hodnoty pro tuning vozidla
        SetVehicleMod(vehicle, modType, modIndex, false)
        ESX.ShowNotification("~g~Tuningová úprava použita!")

        -- Odeslat pouze label pro logování na server
        TriggerServerEvent('admin_vehicle_mod:log_tuning', label)

        menu.close()
    end, function(data, menu)
        menu.close()
    end)
end

RegisterNetEvent('admin_vehicle_mod:log_power', function(power)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    logAdminActionEmbed(xPlayer, ("Změnil výkon na: %s%%"):format(power))
end)

local function openPerformanceMenu(vehicle)
    local elements = {
        { label = "Výkon na Výchozí", value = 0 },
        { label = "Zvýšit výkon na 150%", value = 1.5 },
        { label = "Zvýšit výkon na 200%", value = 2.0 },
        { label = "Zvýšit výkon na 250%", value = 2.5 },
        { label = "Zvýšit výkon na 300%", value = 3.0 },
        { label = "Zvýšit výkon na 350%", value = 3.5 },
        { label = "Zvýšit výkon na 400%", value = 4.0 }
    }

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'performance_menu', {
        title = "Nastavení výkonu vozidla",
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        local multiplier = data.current.value
        ModifyVehicleTopSpeed(vehicle, multiplier)
        SetVehicleEnginePowerMultiplier(vehicle, multiplier * 50.0)
        ESX.ShowNotification(("~g~Výkon vozidla zvýšen na %d%%!"):format(multiplier * 100))
        
        -- Odeslat hodnotu výkonu na server (multiplier)
        TriggerServerEvent('admin_vehicle_mod:log_power', multiplier * 100)

        menu.close()
    end, function(data, menu)
        menu.close()
    end)
end


-- Upravený event pro změnu barvy
RegisterNetEvent('admin_vehicle_mod:log_neon_color', function(label)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    -- Odeslání logu na Discord
    logAdminActionEmbed(xPlayer, ("Změnil barvu podsvícení na: %s"):format(label))
end)

-- Otevření menu s neonovým podsvícením
local function openNeonMenu(vehicle)
    local elements = {
        { label = "Zapnout podsvícení", value = "enable" },
        { label = "Vypnout podsvícení", value = "disable" },
        { label = "Červená", value = { r = 255, g = 0, b = 0, label = "Červená" } },
        { label = "Zelená", value = { r = 0, g = 255, b = 0, label = "Zelená" } },
        { label = "Modrá", value = { r = 0, g = 0, b = 255, label = "Modrá" } },
        { label = "Růžová", value = { r = 255, g = 105, b = 180, label = "Růžová" } }
        -- Přidej další barvy
    }

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'neon_menu', {
        title = "Nastavení podsvícení",
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        if data.current.value == "enable" then
            TriggerServerEvent('admin_vehicle_mod:log_neon_on')
            for i = 0, 3 do
                SetVehicleNeonLightEnabled(vehicle, i, true)
            end
            ESX.ShowNotification("~g~Podsvícení zapnuto!")
        elseif data.current.value == "disable" then
            for i = 0, 3 do
                SetVehicleNeonLightEnabled(vehicle, i, false)
            end
            ESX.ShowNotification("~r~Podsvícení vypnuto!")
            TriggerServerEvent('admin_vehicle_mod:log_neon')
        else
            local color = data.current.value
            -- Nastavení barvy
            SetVehicleNeonLightsColour(vehicle, color.r, color.g, color.b)
            ESX.ShowNotification(("~g~Barva podsvícení změněna na: %s!"):format(color.label))
            -- Volání serverového eventu s label
            TriggerServerEvent('admin_vehicle_mod:log_neon_color', color.label)
        end
        menu.close()
    end, function(data, menu)
        menu.close()
    end)
end



-- Pomocná funkce pro převod barvy na hodnotu pro světla v GTA V
function GetVehicleLightColor(color)
    if color.r == 0 and color.g == 0 and color.b == 255 then
        return 2 -- Modrá
    elseif color.r == 0 and color.g == 255 and color.b == 0 then
        return 1 -- Zelená
    elseif color.r == 255 and color.g == 0 and color.b == 0 then
        return 3 -- Červená
    elseif color.r == 255 and color.g == 255 and color.b == 0 then
        return 5 -- Žlutá
    elseif color.r == 255 and color.g == 105 and color.b == 180 then
        return 8 -- Růžová
    elseif color.r == 64 and color.g == 224 and color.b == 208 then
        return 6 -- Tyrkysová
    else
        return 0 -- Výchozí bílá
    end
end


local windowTintNames = {
    [0] = "Žádné zatmavení",
    [1] = "Tmavá kouřová",
    [2] = "Světle kouřová",
    [3] = "Zelená",
    [4] = "Černá",
    -- Přidejte další hodnoty podle potřeby
}

local function openWindowTintMenu(vehicle)
    local elements = {
        { label = "Žádné zatmavení", value = 0 },
        { label = "Tmavá kouřová", value = 1 },
        { label = "Světle kouřová", value = 2 },
        { label = "Zelená", value = 3 },
        { label = "Černá", value = 4 }
    }

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'window_tint_menu', {
        title = "Nastavení zatmavení skel",
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        SetVehicleWindowTint(vehicle, data.current.value)
        ESX.ShowNotification("~g~Zatmavení skel změněno!")

        -- Získání textového názvu zatmavení
        local tintName = windowTintNames[data.current.value] or "Neznámé zatmavení"

        -- Odeslání názvu zatmavení na server
        TriggerServerEvent('admin_vehicle_mod:log_tint', tintName)

        menu.close()
    end, function(data, menu)
        menu.close()
    end)
end



local function openVehicleModMenu()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if vehicle == 0 then
        ESX.ShowNotification("~r~Nejsi v žádném vozidle!")
        logAdminActionEmbed(xPlayer, "Se pokusil otevřít Mod Menu ale není ve vozidle")
        return
    end

    local elements = {
        { label = "Změnit barvu", value = "color" },
        { label = "Přidat tuning", value = "tuning" },
        { label = "Podsvícení", value = "neon" },
        { label = "Zatmavení skel", value = "window_tint" },
        { label = "Nastavení světel", value = "lights" },
        { label = "Opravit vozidlo", value = "repair" },
        { label = "Zničit vozidlo", value = "destroy" },
    }

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_mod_menu', {
        title = "Menu pro úpravu vozidla        --by filipp",
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        if data.current.value == "color" then
            openColorMenu(vehicle)
        elseif data.current.value == "tuning" then
            openTuningMenu(vehicle)
        elseif data.current.value == "performance" then
            openPerformanceMenu(vehicle)
        elseif data.current.value == "neon" then
            openNeonMenu(vehicle)
        elseif data.current.value == "window_tint" then
            openWindowTintMenu(vehicle)
        elseif data.current.value == "lights" then
            openLightMenu(vehicle)
        elseif data.current.value == "repair" then
            SetVehicleFixed(vehicle)
TriggerServerEvent('admin_vehicle_mod:repair_vehicle')
            SetVehicleDirtLevel(vehicle, 0.0)
            ESX.ShowNotification("~g~Vozidlo opraveno!")
        elseif data.current.value == "destroy" then
            ExecuteCommand('dv')
TriggerServerEvent('admin_vehicle_mod:destroy_vehicle')
        end
    end, function(data, menu)
        menu.close()
    end)
end

RegisterCommand('modcar', function()
    TriggerServerEvent('admin_vehicle_mod:checkAdmin')
end, false)

RegisterNetEvent('admin_vehicle_mod:openMenu', function()
    openVehicleModMenu()
end)