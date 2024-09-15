fx_version 'cerulean'
game 'gta5'
lua54 'yes'
version '1.8'

author 'Icarus Modding'
description 'Small Resources script made by Icarus Modding'

shared_scripts {
    'shared/config.lua',
    '@qb-core/shared/locale.lua',
    'shared/words.lua',
    '@ox_lib/init.lua',
}

client_scripts {
    'client/client.lua',
    'client/carry.lua',
    'client/vehcontrol.lua',
    'client/sniperscope.lua'
}

server_scripts {
    'server.lua',
    'versioncheck/version.lua',
    '@oxmysql/lib/MySQL.lua',
}

dependencies {
    'qb-core',
    'ox_lib',
}
