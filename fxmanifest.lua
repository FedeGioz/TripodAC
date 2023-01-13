fx_version 'cerulean'
game 'gta5'

author 'FedeGioz'
description 'Tripod'
version '1.0.0'

shared_scripts {
    'tables/*.lua',
    'whitelists/*.lua',
    'configs/*.lua'
}

client_script 'src/tripod-client.lua'

server_scripts {
    'src/tripod-server.lua',
}

client_scripts {
    '@menuv/menuv.lua',
    'src/tripod-menu.lua',
}
dependency 'menuv'
