-- client/main.lua

-- Konfiguration aus config.lua laden
local config = Config  -- Da config.lua als Shared Script definiert ist, steht die Config hier zur Verfügung

-- Lokalisierung basierend auf dem in der config.lua angegebenen Standardwert
local locales = _G[Config.defaultLocale]  -- Hier greifen wir auf das passende Locale zu, z.B. 'locales/de.lua'

-- Liste der erlaubten Flugzeugcodes
local allowedPlaneSpawnCodes = {
    "an2", "a320", "a380", "b707", "b747", "b757", "b767", 
    "b777", "conc", "dc9", "dc10", "e145", "e145f", "emb110", 
    "emb111", "emb120", "emba", "embf", "embp", "ep100", 
    "duster", "luxor", "shamal", "velum", "titan", "howard", 
    "tula", "savage", "cuban800", "mammatus", "p51d", 
    "beechcraft", "bicycle", "harrier", "avenger", "hydra", 
    "bombushka", "starling", "nimbus", "pyro", "vestra"
}

-- Funktion für Benachrichtigungen
function ShowNotification(key, subkey)
    local message = locales[key] and locales[key][subkey] or "Notification not found"
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(false, false)
end

-- Der Hauptthread
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10000)  -- 10 Sekunden warten

        local playerPed = PlayerPedId()

        -- Überprüfe, ob der Spieler in einem Flugzeug ist
        if IsPedInAnyPlane(playerPed) then
            local planeEntity = GetVehiclePedIsIn(playerPed, false)
            local randomChance = math.random()

            local planeModel = GetEntityModel(planeEntity)
            local isAllowedPlane = false
            for _, spawnCode in ipairs(allowedPlaneSpawnCodes) do
                if GetHashKey(spawnCode) == planeModel then
                    isAllowedPlane = true
                    break
                end
            end

            -- Wenn es ein erlaubtes Flugzeug ist
            if isAllowedPlane then
                if randomChance >= 0.8 then
                    SetPlaneTurbulenceMultiplier(planeEntity, math.random(config.turbulenceSettings.superStrong.min, config.turbulenceSettings.superStrong.max) * 1.0)
                    ShowNotification("turbulence", "strong")
                elseif randomChance >= 0.5 then
                    SetPlaneTurbulenceMultiplier(planeEntity, math.random(config.turbulenceSettings.moderate.min, config.turbulenceSettings.moderate.max) * 1.0)
                    ShowNotification("turbulence", "moderate")
                else
                    SetPlaneTurbulenceMultiplier(planeEntity, math.random(config.turbulenceSettings.mild.min, config.turbulenceSettings.mild.max) * 1.0)
                    ShowNotification("turbulence", "mild")
                end

                -- Weitere Logik hier...
            end
        end
    end
end)
