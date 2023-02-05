fx_version 'cerulean'
game 'gta5'

author 'noblelady'
description 'Loot Crates'
version '1.0.0'

shared_scripts {
  '@qb-core/shared/locale.lua',
  'locales/en.lua',
  'locales/*.lua',
  'config.lua'
}

server_scripts {
  'server/main.lua'
}

client_script 'client/main.lua'

dependencies {
  'qb-target',
}

escrow_ignore {
  'client/*.lua',
  'server/*.lua',
  'locale/*.lua',
  'config.lua',
}

lua54 'yes'
dependency '/assetpacks'server_scripts { '@mysql-async/lib/MySQL.lua' }