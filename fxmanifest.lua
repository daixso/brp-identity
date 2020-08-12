fx_version 'adamant'
game 'gta5'

client_scripts {
    'config.lua',
    'client/cl_main.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'config.lua',
    'server/sv_main.lua'
}