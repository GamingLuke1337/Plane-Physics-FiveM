local function CheckForUpdates()
    local updateUrl = "https://raw.githubusercontent.com/GamingLuke1337/Plane-Physics/main/fxmanifest.lua"
    PerformHttpRequest(updateUrl, function(status, response, headers)
        if status == 200 then
            local updateData = json.decode(response)
            if updateData.version ~= GetResourceMetadata(GetCurrentResourceName(), 'version', 0) then
                print("^2[Updater] Neue Version verfügbar: " .. updateData.version .. "^0")
                print("^3Changelog: " .. updateData.changelog .. "^0")
            else
                print("^2[Updater] Deine Version ist aktuell.^0")
            end
        else
            print("^1[Updater] Fehler beim Abrufen der Updates.^0")
        end
    end, "GET", "", {["Content-Type"] = "application/json"})
end

Citizen.CreateThread(function()
    CheckForUpdates()
    Citizen.Wait(3600000) -- Alle 60 Minuten prüfen
end)
