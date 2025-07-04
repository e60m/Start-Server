fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'Ameer Mahdi'
description 'Black Market with Vue & ls-inventory'
version '1.0.0'
use_experimental_fxv2_oal 'yes'
shared_scripts {
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

files {
    'web/dist/fonts/*.otf',               -- الخطوط
    'web/dist/*.png',               -- الصور مثل home.png في مجلد web الرئيسي
    'web/dist/index.html',     -- ملف HTML الرئيسي
    'web/dist/assets/*.js',    -- ملفات الجافاسكريبت للواجهة
    'web/dist/assets/*.css',   -- ملفات الـ CSS
    'web/dist/images/*.png',   -- صور داخل مجلد dist/images (مثل الصور التي تستخدم في السوق)
    'web/dist/*.svg',          -- أيقونات أو صور SVG
}

ui_page 'web/dist/index.html'