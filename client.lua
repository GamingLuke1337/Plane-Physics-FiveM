local allowedPlaneSpawnCodes = {
    "an2",
    "a320",
    "a380",
    "b707",
    "b747",
    "b757",
    "b767",
    "b777",
    "conc",
    "dc9",
    "dc10",
    "e145",
    "e145f",
    "emb110",
    "emb111",
    "emb120",
    "emba",
    "embf",
    "embp",
    "ep100",
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
                turbulenceMultiplier = math.random(25, 30) * 1.0  -- Super Strong (Storms)
                ShowNotification("~r~Super Strong Turbulence!!!")
            elseif randomChance >= 0.8 then
                turbulenceMultiplier = math.random(10, 15) * 1.0 -- Mild (Regualr Plane Turplance)
                ShowNotification("~y~Bad Turbulance")
            elseif randomChance >= 0.5 then
                ShowNotification("~g~Moderate Turblance")
                turbulenceMultiplier = math.random(2, 4) * 1.0  -- Moderate turbulence
            else
                turbulenceMultiplier = 0.0  -- No turbulence
            end

            SetPlaneTurbulenceMultiplier(planeEntity, turbulenceMultiplier)

            -- Add a small chance of landing gear problems
            local landingGearProblemChance = 0.05  -- 5% chance of landing gear problems
            if randomChance < landingGearProblemChance then
                ControlLandingGear(planeEntity, false)  -- Retract landing gear
                ShowNotification("~y~Landing gear problems detected.")
            end

            -- Add a small chance of aileron failure
            local aileronFailureChance = 0.1  -- 10% chance of aileron failure
            if randomChance < aileronFailureChance then
                SetEntityControlSurface(planeEntity, 1, 0.0)  -- Aileron failure (roll)
                ShowNotification("~y~Aileron failure detected.")
            end

            -- Add a small chance of engine failure
            local engineFailureChance = 0.05  -- 5% chance of engine failure
            if randomChance < engineFailureChance then
                SetPlaneEngineHealth(planeEntity, 0.0)  -- Simulate engine failure
                ShowNotification("~r~Engine failure detected.")
            end

            -- Add a small chance of engine fire
            local engineFireChance = 0.1  -- 10% chance of engine fire
            if randomChance < engineFireChance then
                StartPlaneEngineFire(planeEntity)  -- Simulate engine fire
                ShowNotification("~r~Engine fire detected.")
            end

            local birdStrikeChance = 0.05  -- 5% chance of bird strike
            if randomChance < birdStrikeChance then
                StartPlaneEngineFire(planeEntity)  -- Simulate engine fire due to bird strike
                ShowNotification("~r~Bird strike detected. Engine caught fire.")
            end

            -- Check for collisions with animals (Modify this to match your desired collision detection)
            local collidesWithAnimal = false
            local animalModels = { "a_c_crow", "a_c_pigeon", "a_c_seagull", "a_c_rabbit" }  -- Example animal models

            for _, model in ipairs(animalModels) do
                if IsVehicleInArea(planeEntity, GetEntityCoords(playerPed), 10.0, 10.0, 10.0, false, true, 0) then
                    collidesWithAnimal = true
                    break
                end
            end

            if collidesWithAnimal then
                local animalCollisionChance = 0.1  -- 10% chance of engine failure due to animal collision
                if randomChance < animalCollisionChance then
                    SetPlaneEngineHealth(planeEntity, 0.0)  -- Simulate engine failure due to animal collision
                    ShowNotification("~r~Engine failure due to animal collision.")
                else
                    StartPlaneEngineFire(planeEntity)  -- Simulate engine fire due to animal collision
                    ShowNotification("~r~Engine caught fire due to animal collision.")
                end
            end

            -- Simulate landing impact for realistic landings
            if IsEntityInAir(planeEntity) then
                local _, _, verticalSpeed = table.unpack(GetEntitySpeedVector(planeEntity, true))

                if verticalSpeed < -5.0 then
                    -- Adjust suspension and collision damage to simulate landing impact
                    SetVehicleSuspensionHeight(planeEntity, 0.15)  -- Adjust suspension height
                    SetVehicleSuspensionReboundSpeed(planeEntity, 10.0)  -- Adjust suspension rebound speed
                    SetVehicleCollisionDamageMultiplier(planeEntity, 1.5)  -- Increase collision damage
                    ShowNotification("~y~Landing impact detected. Adjust your landing technique.")
                    Citizen.Wait(5000)
                    SetVehicleSuspensionHeight(planeEntity, 1.0)  -- Reset suspension height
                    SetVehicleSuspensionReboundSpeed(planeEntity, 1.0)  -- Reset suspension rebound speed
                    SetVehicleCollisionDamageMultiplier(planeEntity, 1.0)  -- Reset collision damage

                    -- Check if the landing was too hard
                    if verticalSpeed < -10.0 then
                        -- Pop a tire and emit engine smoke
                        SetVehicleTyreBurst(planeEntity, 0, true, 1000.0)
                        StartVehicleAlarm(planeEntity)
                        StartVehicleEngineFire(planeEntity, 0, true)
                        ShowNotification("~r~Hard landing detected. Tire popped and engine is smoking.")
                    end
                end
            end

            -- Add a small chance of rudder failure
            local rudderFailureChance = 0.1  -- 10% chance of rudder failure
            if randomChance < rudderFailureChance then
                SetEntityControlSurface(planeEntity, 2, 0.0)  -- Rudder failure (yaw)
                ShowNotification("~y~Rudder failure detected.")
            end

                -- Implement better glide
                local betterGlideChance = 0.7  -- 20% chance of better glide
                if randomChance < betterGlideChance then
                    SetEntityMaxSpeed(planeEntity, 100.0)  -- Adjust max speed for smoother gliding
                    SetVehicleDensityMultiplierThisFrame(0.2)  -- Reduce air resistance for better glide
                    ShowNotification("~y~Better glide mode enabled.")
                else
                    SetEntityMaxSpeed(planeEntity, 240.0)  -- Reset max speed to default
                    SetVehicleDensityMultiplierThisFrame(1.0)  -- Reset air resistance to default
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