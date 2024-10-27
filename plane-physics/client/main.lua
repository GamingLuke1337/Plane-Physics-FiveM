local allowedPlaneSpawnCodes = {
    "an2", "a320", "a380", "b707", "b747", "b757", "b767", 
    "b777", "conc", "dc9", "dc10", "e145", "e145f", "emb110", 
    "emb111", "emb120", "emba", "embf", "embp", "ep100", 
    "duster", "luxor", "shamal", "velum", "titan", "howard", 
    "tula", "savage", "cuban800", "mammatus", "p51d", 
    "beechcraft", "bicycle", "harrier", "avenger", "hydra", 
    "bombushka", "starling", "nimbus", "pyro", "vestra"
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10000)  

        local playerPed = PlayerPedId()

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

            if isAllowedPlane then
                local currentWeather = GetPrevWeatherTypeHashName()
                local isStormyWeather = IsThisModelABoat(planeEntity) and IsEntityInAir(planeEntity) and IsWeatherType("THUNDER")

                local turbulenceMultiplier
                if isStormyWeather then
                    turbulenceMultiplier = math.random(25, 30) * 1.0  
                    ShowNotification("~r~Super Strong Turbulence!!!")
                elseif randomChance >= 0.8 then
                    turbulenceMultiplier = math.random(10, 15) * 1.0 
                    ShowNotification("~y~Bad Turbulance")
                elseif randomChance >= 0.5 then
                    ShowNotification("~g~Moderate Turblance")
                    turbulenceMultiplier = math.random(2, 4) * 1.0  
                else
                    turbulenceMultiplier = 0.0  
                end

                SetPlaneTurbulenceMultiplier(planeEntity, turbulenceMultiplier)

                local landingGearProblemChance = 0.05  
                if randomChance < landingGearProblemChance then
                    ControlLandingGear(planeEntity, false)  
                    ShowNotification("~y~Landing gear problems detected.")
                end

                local aileronFailureChance = 0.1  
                if randomChance < aileronFailureChance then
                    SetEntityControlSurface(planeEntity, 1, 0.0)  
                    ShowNotification("~y~Aileron failure detected.")
                end

                local engineFailureChance = 0.05  
                if randomChance < engineFailureChance then
                    SetPlaneEngineHealth(planeEntity, 0.0)  
                    ShowNotification("~r~Engine failure detected.")
                end

                local engineFireChance = 0.1  
                if randomChance < engineFireChance then
                    StartPlaneEngineFire(planeEntity)  
                    ShowNotification("~r~Engine fire detected.")
                end

                local birdStrikeChance = 0.05  
                if randomChance < birdStrikeChance then
                    StartPlaneEngineFire(planeEntity)  
                    ShowNotification("~r~Bird strike detected. Engine caught fire.")
                end

                local collidesWithAnimal = false
                local animalModels = { "a_c_crow", "a_c_pigeon", "a_c_seagull", "a_c_rabbit" }

                for _, model in ipairs(animalModels) do
                    if IsVehicleInArea(planeEntity, GetEntityCoords(playerPed), 10.0, 10.0, 10.0, false, true, 0) then
                        collidesWithAnimal = true
                        break
                    end
                end

                if collidesWithAnimal then
                    local animalCollisionChance = 0.1  
                    if randomChance < animalCollisionChance then
                        SetPlaneEngineHealth(planeEntity, 0.0)  
                        ShowNotification("~r~Engine failure due to animal collision.")
                    else
                        StartPlaneEngineFire(planeEntity)  
                        ShowNotification("~r~Engine caught fire due to animal collision.")
                    end
                end

                if IsEntityInAir(planeEntity) then
                    local _, _, verticalSpeed = table.unpack(GetEntitySpeedVector(planeEntity, true))

                    if verticalSpeed < -5.0 then
                        SetVehicleSuspensionHeight(planeEntity, 0.15)  
                        SetVehicleSuspensionReboundSpeed(planeEntity, 10.0)  
                        SetVehicleCollisionDamageMultiplier(planeEntity, 1.5)  
                        ShowNotification("~y~Landing impact detected. Adjust your landing technique.")
                        Citizen.Wait(5000)
                        SetVehicleSuspensionHeight(planeEntity, 1.0)  
                        SetVehicleSuspensionReboundSpeed(planeEntity, 1.0)  
                        SetVehicleCollisionDamageMultiplier(planeEntity, 1.0)  

                        if verticalSpeed < -10.0 then
                            SetVehicleTyreBurst(planeEntity, 0, true, 1000.0)
                            StartVehicleAlarm(planeEntity)
                            StartVehicleEngineFire(planeEntity, 0, true)
                            ShowNotification("~r~Hard landing detected. Tire popped and engine is smoking.")
                        end
                    end
                end

                local rudderFailureChance = 0.1  
                if randomChance < rudderFailureChance then
                    SetEntityControlSurface(planeEntity, 2, 0.0)  
                    ShowNotification("~y~Rudder failure detected.")
                end

                local betterGlideChance = 0.7  
                if randomChance < betterGlideChance then
                    SetEntityMaxSpeed(planeEntity, 100.0)  
                    SetVehicleDensityMultiplierThisFrame(0.2)  
                    ShowNotification("~y~Better glide mode enabled.")
                else
                    SetEntityMaxSpeed(planeEntity, 240.0)  
                    SetVehicleDensityMultiplierThisFrame(1.0)  
                end
            end
        end
    end
end)

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end
