fx_version 'cerulean'
game 'gta5'

author '_bl4ck'
description 'A simple revive NPC script'
version '1.0.0'
lua54 'yes'

shared_scripts {
    '@es_extended/imports.lua',
	'@es_extended/locale.lua',
	'@ox_lib/init.lua'
}

client_scripts {
    'locales/*.lua',
    'config.lua',
    'client/main.lua'
}

server_scripts {
    'locales/*.lua',
    'config.lua',
    'server/main.lua'
}

dependency 'esx_ambulancejob'