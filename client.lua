local activeMission = false
local currentSignIndex = nil
local missionPed
local currentSignProp = nil
local missionObjectiveComplete = false
local missionBlip = nil

CreateThread(function()
    RequestModel(Config.Ped.model)
    while not HasModelLoaded(Config.Ped.model) do Wait(0) end

    missionPed = CreatePed(0, Config.Ped.model, Config.Ped.coords.xyz, Config.Ped.coords.w, false, true)
    FreezeEntityPosition(missionPed, true)
    SetEntityInvincible(missionPed, true)
    SetBlockingOfNonTemporaryEvents(missionPed, true)

    exports.ox_target:addLocalEntity(missionPed, {
        {
            label = Config.Locales.talk_label,
            icon = Config.Locales.talk_icon,
            onSelect = function()
                startConversation()
            end
        }
    })
end)

function startConversation()
    lib.progressBar({
        duration = 4000,
        label = Config.Locales.talking_label,
        useWhileDead = false,
        canCancel = false,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
        anim = {
            dict = 'mini@prostitutestalk',
            clip = 'street_argue_f_a'
        }
    })

    openMissionMenu()
end

function openMissionMenu()
    local options = {}

    if not activeMission then
        table.insert(options, {
            title = Config.Locales.mission_start_title,
            description = Config.Locales.mission_start_desc,
            icon = 'fas fa-tools',
            onSelect = function()
                startMission()
            end
        })
    else
        table.insert(options, {
            title = Config.Locales.mission_in_progress_title,
            description = Config.Locales.mission_in_progress_desc,
            icon = 'fas fa-ban',
            disabled = true
        })

        table.insert(options, {
            title = Config.Locales.mission_cancel_title,
            description = Config.Locales.mission_cancel_desc,
            icon = 'fas fa-times',
            onSelect = function()
                cancelMission()
            end
        })
    end

    table.insert(options, {
        title = Config.Locales.buy_tools_title,
        description = Config.Locales.buy_tools_desc,
        icon = 'fas fa-shopping-cart',
        onSelect = function()
            purchaseTools()
        end
    })

    table.insert(options, {
        title = Config.Locales.sell_items_title,
        description = Config.Locales.sell_items_desc,
        icon = 'fas fa-dollar-sign',
        onSelect = function()
            openSellMenu()
        end
    })

    lib.registerContext({
        id = 'mission_menu',
        title = Config.Locales.mission_menu_title,
        options = options
    })

    lib.showContext('mission_menu')
end

function openSellMenu()
    lib.progressBar({
        duration = 3000,
        label = Config.Locales.selling_progress,
        useWhileDead = false,
        canCancel = false,
        anim = {
            dict = 'missheistfbi_fire',
            clip = 'two_talking'
        },
        disable = {
            car = true,
            move = true,
            combat = true,
        }
    })

    TriggerServerEvent('traffic:autoSellItems')
end

RegisterNetEvent('traffic:playGiveAnim', function()
    local playerPed = PlayerPedId()
    RequestAnimDict('mp_common')
    while not HasAnimDictLoaded('mp_common') do Wait(0) end
    TaskPlayAnim(playerPed, 'mp_common', 'givetake1_a', 8.0, -8.0, 2000, 0, 0, false, false, false)
end)


RegisterNetEvent('traffic:playGiveAnim', function()
    local playerPed = PlayerPedId()
    RequestAnimDict('mp_common')
    while not HasAnimDictLoaded('mp_common') do Wait(0) end
    TaskPlayAnim(playerPed, 'mp_common', 'givetake1_a', 8.0, -8.0, 2000, 0, 0, false, false, false)
end)


RegisterNetEvent('traffic:playGiveAnim')
AddEventHandler('traffic:playGiveAnim', function()
    local playerPed = PlayerPedId()
    RequestAnimDict('mp_common')
    while not HasAnimDictLoaded('mp_common') do Wait(0) end
    TaskPlayAnim(playerPed, 'mp_common', 'givetake1_a', 8.0, -8.0, 2000, 0, 0, false, false, false)
end)



function purchaseTools()
    lib.callback('traffic:tryBuyTools', false, function(success)
        if success then
            lib.progressBar({
                duration = 3000,
                label = Config.Locales.buying_tools_label,
                useWhileDead = false,
                canCancel = false,
                disable = {
                    car = true,
                    move = true,
                    combat = true,
                },
                anim = {
                    dict = 'mp_common',
                    clip = 'givetake1_a'
                }
            })

            lib.notify({ type = 'success', description = Config.Locales.tools_bought_success })
        end
    end)
end

function startMission()
    activeMission = true
    currentSignIndex = math.random(1, #Config.SignProps)
    local coords = Config.SignProps[currentSignIndex]

    if missionBlip then
        RemoveBlip(missionBlip)
        missionBlip = nil
    end

    missionBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipRoute(missionBlip, true)
    SetBlipRouteColour(missionBlip, 5)
    SetBlipScale(missionBlip, 1.0)
    SetBlipAsShortRange(missionBlip, false)
    SetBlipCategory(missionBlip, 7)

    RequestModel(Config.SignModel)
    while not HasModelLoaded(Config.SignModel) do Wait(0) end

    currentSignProp = CreateObject(Config.SignModel, coords.x, coords.y, coords.z - 1.0, true, true, false)
    SetEntityHeading(currentSignProp, coords.w or 0.0)
    FreezeEntityPosition(currentSignProp, true)

    exports.ox_target:addLocalEntity(currentSignProp, {
        {
            label = Config.Locales.dismantle_label,
            icon = Config.Locales.dismantle_icon,
            canInteract = function(entity, distance, coords)
                return activeMission
            end,
            onSelect = function()
                tryDismantle(coords)
            end
        }
    })

    lib.notify({ type = 'info', description = Config.Locales.blip_notification })
end

function tryDismantle(coords)
    local hasItem = lib.callback.await('traffic:checkItem', false, Config.RequiredItem)

    if not hasItem then
        lib.notify({ type = 'error', description = Config.Locales.no_tools_error })
        return
    end

    local success = lib.skillCheck({'easy', 'easy', 'medium'}, {'w', 'a', 's', 'd'})

    if not success then
        lib.notify({ type = 'error', description = Config.Locales.dismantle_fail })
        TriggerServerEvent('traffic:dispatchPolice', coords)
        return
    end

    lib.progressBar({
        duration = 5000,
        label = Config.Locales.dismantle_progress,
        useWhileDead = false,
        canCancel = false,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
        anim = {
            dict = 'missmechanic',
            clip = 'work_base'
        }
    })

    TriggerServerEvent('traffic:giveRewards')

    if DoesEntityExist(currentSignProp) then
        DeleteEntity(currentSignProp)
        currentSignProp = nil
    end

    missionObjectiveComplete = true

    if missionBlip then
       RemoveBlip(missionBlip)
    end

    missionBlip = AddBlipForCoord(Config.Ped.coords.x, Config.Ped.coords.y, Config.Ped.coords.z)
    SetBlipRoute(missionBlip, true)
    SetBlipRouteColour(missionBlip, 5)
    SetBlipScale(missionBlip, 1.0)
    SetBlipAsShortRange(missionBlip, false)
    SetBlipCategory(missionBlip, 7)

    lib.notify({ type = 'inform', description = Config.Locales.mission_complete })
end

function cancelMission()
    activeMission = false
    if missionBlip then
        RemoveBlip(missionBlip)
        missionBlip = nil
    end
    lib.notify({ type = 'info', description = Config.Locales.mission_end })
end

function finishMission()
    activeMission = false
    missionObjectiveComplete = false

    lib.notify({ type = 'success', description = Config.Locales.mission_success })
end

RegisterNetEvent('traffic:pedGiveItemAnim', function()
    if DoesEntityExist(missionPed) then
        RequestAnimDict('mp_common')
        while not HasAnimDictLoaded('mp_common') do Wait(0) end

        TaskPlayAnim(missionPed, 'mp_common', 'givetake1_b', 8.0, -8.0, 2000, 0, 0, false, false, false)
    end
end)

RegisterNetEvent('traffic:playerSellAnim', function()
    RequestAnimDict('mp_common')
    while not HasAnimDictLoaded('mp_common') do Wait(0) end
    TaskPlayAnim(PlayerPedId(), 'mp_common', 'givetake1_a', 8.0, -8.0, 2000, 0, 0, false, false, false)
end)
