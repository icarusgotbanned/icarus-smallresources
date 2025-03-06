fx_version 'cerulean'
game 'gta5'
lua54 'yes'
version '1.9'

author 'Icarus Modding'
description 'Small Resources script made by Icarus Modding'

dependencies {
    'qb-core',
    'ox_lib',
}

shared_scripts {
    'shared/config.lua',
    '@qb-core/shared/locale.lua',
    'shared/words.lua',
    '@ox_lib/init.lua',
}

client_scripts {
    'client.lua',  
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
}
