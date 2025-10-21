fx_version 'cerulean'
game 'gta5'

author 'TraPZY'
description 'TRAP NPC Dialogue - NPC interaction avec paiement ox_inventory'
version '1.2.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

dependencies {
    'ox_lib',
    'ox_target',
    'ox_inventory'
}
