fx_version 'cerulean'
game 'gta5'

name 'bcde_holster'
description 'BCDE Holster'
version '1.0.0'

ox_lib 'locale'

shared_scripts {
    '@ox_lib/init.lua',
    '@qbx_core/modules/lib.lua',
}

client_scripts {
    'client.lua'
}

files {
    'config.lua'
}

lua54 'yes'
use_experimental_fxv2_oal 'yes'
