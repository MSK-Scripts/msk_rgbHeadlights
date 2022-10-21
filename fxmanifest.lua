fx_version 'adamant'
games { 'gta5' }

author 'Musiker15 - MSK Scripts'
name 'msk_rgbheadlights'
description 'Changeable Vehicle Headlights with an Item'
version '1.0'

lua54 'yes'

escrow_ignore {
	'config.lua',
	'locales/*.lua'
}

shared_script {
	'config.lua',
	'translation.lua'
}

client_scripts {
	'@NativeUI/NativeUI.lua',
	'client.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server.lua',
}

dependencies {
	'es_extended',
	'oxmysql'
}