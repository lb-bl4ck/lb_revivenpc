local pedCreated, playerLoaded = false, false
local npc, currentPedCoord = nil, nil

local function createNPC(model, coords)
    lib.requestModel(model)
    NPC = CreatePed(4, model, coords.x, coords.y, coords.z, coords.w, false, true)
    SetEntityInvincible(NPC, true)
    FreezeEntityPosition(NPC, true)
    SetEntityAsMissionEntity(NPC, true, true)
    SetBlockingOfNonTemporaryEvents(NPC, true)
    TaskStartScenarioInPlace(NPC, 'WORLD_HUMAN_CLIPBOARD')
    return NPC
end

local function checkService()
    local count = 0
    local finished = false
    ESX.TriggerServerCallback('esx_service:getInServiceList', function(inServiceList)
        for k,v in pairs(inServiceList) do
            if v == true then
                count = count + 1
            end
        end
        finished = true
    end, 'ambulance')
    while not finished do
        Wait(5)
    end
    return count
end

local function mainThreadOne()
    local player = PlayerPedId()

    if Config.enableBlips then
        for k, coord in pairs(Config.pedMedics) do
            local blip = AddBlipForCoord(coord.x,coord.y,coord.z)
            SetBlipSprite(blip, Config.blipSprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 0.7)
            SetBlipColour(blip, Config.blipColor)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(Translate('ped_blip'))
            EndTextCommandSetBlipName(blip)
        end
    end

    while playerLoaded do
        Citizen.Wait(2000)
        local playerCoords = GetEntityCoords(player)
        local closestDistance = Config.drawDistance + 10
        local closestCoord = nil
        for i = 1, #Config.pedMedics do
            local distance = #(playerCoords - vector3(Config.pedMedics[i].x, Config.pedMedics[i].y, Config.pedMedics[i].z))
            if distance <= closestDistance then
                if Config.duty then
                    local connectedCount = lib.callback.await('lb_revivenpc:EMScount')
                    if connectedCount < Config.maxEMS then
                        closestDistance = distance
                        closestCoord = Config.pedMedics[i]
                    end
                else
                    closestDistance = distance
                    closestCoord = Config.pedMedics[i]
                end
            end
        end
        if closestDistance <= Config.drawDistance then
            if not pedCreated or (pedCreated and currentPedCoord ~= closestCoord) then
                if npc ~= nil then
                    DeleteEntity(npc)
                    npc = nil
                end
                npc = createNPC(Config.pedModel, closestCoord)
                pedCreated = true
                currentPedCoord = closestCoord
            end
        elseif closestDistance > Config.drawDistance and pedCreated then
            DeleteEntity(npc)
            npc = nil
            pedCreated = false
            currentPedCoord = nil
        end
    end
end

local function mainThreadTwo()
    local player = PlayerPedId()
    local textuiShown = false

    while playerLoaded do
        local sleep = 5000
        local playerCoords = GetEntityCoords(player)
        local closestDistance = Config.drawDistance + 10
        local closestCoord = nil
        local action = nil
        local hasEnoughMoney = false
        local account = nil

        for i = 1, #Config.pedMedics do
            local distance = #(playerCoords - vector3(Config.pedMedics[i].x, Config.pedMedics[i].y, Config.pedMedics[i].z))
            if distance <= closestDistance then
                sleep = 1000
                closestDistance = distance
                closestCoord = Config.pedMedics[i]
            end
            if closestDistance <= 2 and currentPedCoord == closestCoord then
                sleep = 1
                if IsEntityDead(player) then
                    action = 'revive'
                elseif GetEntityHealth(player) < Config.maxLife then
                    action = 'heal'
                end
            end
        end

        if action == 'revive' or action == 'heal' then
            if not textuiShown then
                local message = Translate('ped_revive', Config.revivePrice)
                if action == 'heal' then
                    message = Translate('ped_heal', Config.healPrice)
                end
                lib.showTextUI(message, {icon = 'fa-solid fa-hand-holding-heart'})
                textuiShown = true
            end

            if IsControlJustReleased(0, 38) then
                hasEnoughMoney, account = lib.callback.await('lb_revivenpc:checkMoney', 1000, Config.revivePrice)
                if action == 'heal' then
                    hasEnoughMoney, account = lib.callback.await('lb_revivenpc:checkMoney', 1000, Config.healPrice)
                end
                if hasEnoughMoney then
                    if action == 'revive' then
                        TriggerEvent('esx_ambulancejob:revive')
                    elseif action == 'heal' then
                        TriggerEvent('esx_ambulancejob:heal', 'big', false)
                    end

                    TriggerServerEvent('lb_revivenpc:payment', account, action)
                    textuiShown = false
                else
                    lib.notify({description = Translate('ped_notEnoughMoney')})
                end
            end
        else
            if textuiShown then
                lib.hideTextUI()
                textuiShown = false
            end
        end
        Citizen.Wait(sleep)
    end
end

AddEventHandler('esx:onPlayerLogout', function()
    playerLoaded = false
    if pedCreated or npc ~= nil then
        DeleteEntity(npc)
        npc = nil
        pedCreated = false
        currentPedCoord = nil
    end
end)

AddEventHandler('esx:onPlayerSpawn', function()
    if not playerLoaded then
        playerLoaded = true
        CreateThread(mainThreadOne)
        CreateThread(mainThreadTwo)
    end
end)

if Config.debug == true and not playerLoaded then
    playerLoaded = true
    CreateThread(mainThreadOne)
    CreateThread(mainThreadTwo)
end