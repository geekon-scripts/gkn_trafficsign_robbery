Config = {}

Config.Ped = {
    model = 's_m_y_construct_01',
    coords = vector4(2319.1985, 2553.4998, 46.6906, 235.5665),
    name = 'Carl'
}

Config.SignProps = { -- you can change or add sign prop locations here
    vector3(2028.8434, 3821.7625, 33.5375),
    vector3(1429.0333, 3601.3062, 34.9260),
    vector3(839.6757, 3636.0256, 32.9547),
    vector3(1770.0828, 3940.7197, 34.4446),
    vector3(2175.4946, 3778.8040, 33.3781),
}

Config.SignModel = 'prop_sign_road_01a' -- sign prop
Config.RequiredItem = 'workingstuff'
Config.RewardItem1 = 'stuffone'
Config.RewardItem2 = 'stufftwo'

Config.ItemPrices = {
    stuffone = 150,
    stufftwo = 75
}

Config.ItemLabels = {
    stuffone = "Traffic sign - TOP part",
    stufftwo = "Traffic sign - OTHER part"
}


Config.Locales = {
    talk_label = "Talk",
    talk_icon = "fas fa-comments",
    talking_label = "Talking...",
    mission_menu_title = "Carl",
    mission_start_title = "Dismantle Road Sign",
    mission_start_desc = "This will dismantle a road sign at a specific location.",
    mission_in_progress_title = "Dismantle Road Sign",
    mission_in_progress_desc = "A mission is already in progress.",
    mission_cancel_title = "Cancel Mission",
    mission_cancel_desc = "Cancels the current mission.",
    buy_tools_title = "Buy Tools",
    buy_tools_desc = "Buy tools for dismantling road signs.",
    buying_tools_label = "Paying for tools...",
    tools_bought_success = "You bought the tools!",
    blip_notification = "Sign location has been marked on the map!",
    dismantle_label = "Dismantle Sign",
    dismantle_icon = "fas fa-wrench",
    no_tools_error = "You don't have the required equipment!",
    dismantle_fail = "You failed to dismantle the sign! Police were alerted!",
    dismantle_progress = "Dismantling sign...",
    mission_complete = "You dismantled the sign! Return to Carl to finish the mission.",
    mission_end = "Mission completed or canceled.",
    mission_success = "Mission successfully completed!",
    --dispatch
    dispatch_title = 'Traffic Sign Dismantle',
    dispatch_message = 'Citizen is trying to dismantle a traffic sign!',
    dispatch_blip_text = '911 - Report',
    -- selling
    sell_items_title = "Sell parts",
    selling_progress = "Talking about price...",
    sell_items_desc = "Sell everything you got!",
    sell_not_enough = "You dont have anything to sell!",
    sell_success = "You sold %dx %s for $%d!",
    not_enough_money = "You dont have enough money!" 

}
