fx_version 'cerulean'
game 'gta5'

author 'TRAPZY'
description 'NPC Dialog System (cash item support - codem-inventory)'
version '1.0.1'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

