lib.callback.register('traffic:checkItem', function(source, item)
    local hasItem = exports.ox_inventory:Search(source, 'count', item)
    return hasItem and hasItem > 0
end)

RegisterServerEvent('traffic:giveRewards', function()
    local src = source
    exports.ox_inventory:AddItem(src, Config.RewardItem1, 1)
    exports.ox_inventory:AddItem(src, Config.RewardItem2, math.random(1, 10))
end)

RegisterNetEvent('traffic:dispatchPolice', function()
    local src = source
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)

    TriggerEvent('cd_dispatch:AddNotification', {
        job_table = {'police'},
        coords = coords,
        title = Config.Locales.dispatch_title or 'Traffic Sign Dismantle',
        message = Config.Locales.dispatch_message or 'Citizen is trying to dismantle a traffic sign!',
        flash = 0,
        unique_id = 'sign' .. math.random(1111, 9999),
        sound = 1,
        blip = {
            sprite = 544,
            scale = 1.2,
            colour = 3,
            flashes = false,
            text = Config.Locales.dispatch_blip_text or '911 - Report',
            time = 5,
            radius = 0,
        }
    })
end)

lib.callback.register('traffic:tryBuyTools', function(source)
    local player = source
    local price = 350

    local money = exports.ox_inventory:Search(player, 'count', 'money')

    if not money or money < price then
        TriggerClientEvent('ox_lib:notify', player, {
            type = 'error',
            description = Config.Locales.not_enough_money
        })
        return false
    end

    CreateThread(function()
        Wait(3000)
        exports.ox_inventory:RemoveItem(player, 'money', price)
        TriggerClientEvent('traffic:pedGiveItemAnim', -1)
        Wait(1500)
        exports.ox_inventory:AddItem(player, 'workingstuff', 1)
    end)

    return true
end)

RegisterNetEvent('traffic:autoSellItems', function()
    local src = source
    local total = 0
    local soldItems = {}

    for item, price in pairs(Config.ItemPrices) do
        local count = exports.ox_inventory:Search(src, 'count', item)
        if count and count > 0 then
            table.insert(soldItems, { name = item, amount = count, value = count * price })
            total = total + (count * price)
        end
    end

    if total == 0 then
        TriggerClientEvent('ox_lib:notify', src, {
            type = 'error',
            description = Config.Locales.sell_not_enough
        })
        return
    end


    TriggerClientEvent('traffic:playGiveAnim', src)
    Wait(2000)


    for _, entry in pairs(soldItems) do
        exports.ox_inventory:RemoveItem(src, entry.name, entry.amount)
    end


    TriggerClientEvent('traffic:pedGiveItemAnim', -1)
    Wait(1500)


    exports.ox_inventory:AddItem(src, 'money', total)

    for _, entry in pairs(soldItems) do
        local label = Config.Locales.item_labels[entry.name] or entry.name
        TriggerClientEvent('ox_lib:notify', src, {
            type = 'success',
            description = string.format(Config.Locales.sell_success, entry.amount, label, entry.value)
        })
    end
end)




