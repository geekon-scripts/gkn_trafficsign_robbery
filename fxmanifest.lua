fx_version 'cerulean'
game 'gta5'

lua54 'yes'

author 'GeeKoN Scripts'
description 'https://discord.gg/E5J6wvwqRw'

shared_script 'config.lua'
shared_script '@ox_lib/init.lua'

client_script 'client.lua'
server_script 'server.lua'

dependencies {
    'ox_inventory',
    'ox_lib',
    'ox_target',
    'cd_dispatch'
}
