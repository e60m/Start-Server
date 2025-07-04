Config = {}

-- General Settings
Config.Debug = false
Config.Locale = 'en'
Config.Framework = 'ESX' -- ESX Framework

-- Database Settings
Config.Database = {
    CryptoTable = "phone_crypto",
    CryptoCoin = "bitcoin",
    TransactionTable = "blackmarket_transactions"
}

-- Access Control
Config.Access = {
    RequiredItem = nil, -- 'vpn_device' -- Set to an item name if you want to require a specific item
    RequiredJob = nil, -- 'gang' -- Set to a job name if you want to restrict access
    RequiredGang = nil, -- Not applicable for ESX, use jobs instead
    RequiredIdentifier = {}, -- Add specific identifiers for exclusive access
    Whitelist = false, -- Set to true to use whitelist mode
    WhitelistedPlayers = {} -- Add identifiers for whitelist
}

-- Security Settings
Config.Security = {
    MaxTransactionAmount = 100,
    MinTransactionAmount = 1,
    CooldownBetweenTransactions = 5000, -- 5 seconds
    AntiSpam = true,
    LogAllTransactions = true,
    MaxDailyTransactions = 50,
    RequireConfirmation = true,
    EnableDiscordLogs = false
}

-- Market Settings
Config.Market = {
    PriceUpdateInterval = 300000, -- 5 minutes in milliseconds
    MaxPriceFluctuation = 0.15, -- 15% max change per update
    SellPriceMultiplier = 0.85, -- Players sell at 85% of buy price
    VolatilityFactor = 0.1, -- Random price volatility (10%)
    DemandDecayRate = 0.95, -- How fast demand decreases over time
    SupplyGrowthRate = 1.02, -- How fast supply increases over time
    MarketOpenHours = { start = 0, stop = 24 }, -- 24/7 market
    DynamicPricing = true
}

-- ESX Item Categories
Config.Categories = {
    weapon = { label = "Weapons", color = "#ff0040" },
    drug = { label = "Drugs", color = "#00ff00" },
    ammo = { label = "Ammunition", color = "#ffff00" },
    illegal = { label = "Illegal Items", color = "#ff8c00" },
    stolen = { label = "Stolen Goods", color = "#8a2be2" }
}

-- Rarity System
Config.Rarity = {
    common = { label = "Common", multiplier = 1.0, color = "#666666" },
    uncommon = { label = "Uncommon", multiplier = 1.2, color = "#4caf50" },
    rare = { label = "Rare", multiplier = 1.5, color = "#2196f3" },
    epic = { label = "Epic", multiplier = 2.0, color = "#9c27b0" },
    legendary = { label = "Legendary", multiplier = 3.0, color = "#ff9800" }
}

-- Market Items Configuration (ESX Item Names)
Config.MarketItems = {
    -- Weapons
    ["weapon_pistol"] = {
        label = "Pistol",
        category = "weapon",
        rarity = "common",
        basePrice = 0.0015,
        minPrice = 0.0010,
        maxPrice = 0.0030,
        baseDemand = 50,
        baseSupply = 100,
        emoji = "🔫",
        description = "Basic pistol for personal protection"
    },
    ["weapon_assaultrifle"] = {
        label = "AK-47",
        category = "weapon",
        rarity = "rare",
        basePrice = 0.0045,
        minPrice = 0.0030,
        maxPrice = 0.0080,
        baseDemand = 70,
        baseSupply = 30,
        emoji = "🔫",
        description = "High-damage assault rifle"
    },
    ["weapon_pistol50"] = {
        label = "Desert Eagle",
        category = "weapon",
        rarity = "legendary",
        basePrice = 0.0120,
        minPrice = 0.0080,
        maxPrice = 0.0200,
        baseDemand = 90,
        baseSupply = 10,
        emoji = "🔫",
        description = "Legendary handgun with devastating power"
    },
    ["weapon_carbinerifle"] = {
        label = "M4A1",
        category = "weapon",
        rarity = "epic",
        basePrice = 0.0080,
        minPrice = 0.0050,
        maxPrice = 0.0150,
        baseDemand = 85,
        baseSupply = 15,
        emoji = "🔫",
        description = "Military-grade assault rifle"
    },
    ["weapon_sniperrifle"] = {
        label = "Sniper Rifle",
        category = "weapon",
        rarity = "legendary",
        basePrice = 0.0200,
        minPrice = 0.0150,
        maxPrice = 0.0300,
        baseDemand = 95,
        baseSupply = 5,
        emoji = "🔫",
        description = "Long-range precision weapon"
    },
    
    -- Drugs
    ["weed"] = {
        label = "Marijuana",
        category = "drug",
        rarity = "common",
        basePrice = 0.0003,
        minPrice = 0.0001,
        maxPrice = 0.0008,
        baseDemand = 80,
        baseSupply = 150,
        emoji = "🌿",
        description = "High-quality cannabis"
    },
    ["coke"] = {
        label = "Cocaine",
        category = "drug",
        rarity = "uncommon",
        basePrice = 0.0012,
        minPrice = 0.0008,
        maxPrice = 0.0020,
        baseDemand = 85,
        baseSupply = 60,
        emoji = "❄️",
        description = "Pure Colombian cocaine"
    },
    ["heroin"] = {
        label = "Heroin",
        category = "drug",
        rarity = "rare",
        basePrice = 0.0035,
        minPrice = 0.0020,
        maxPrice = 0.0060,
        baseDemand = 75,
        baseSupply = 25,
        emoji = "💉",
        description = "Pure heroin"
    },
    ["meth"] = {
        label = "Methamphetamine",
        category = "drug",
        rarity = "uncommon",
        basePrice = 0.0018,
        minPrice = 0.0010,
        maxPrice = 0.0035,
        baseDemand = 78,
        baseSupply = 40,
        emoji = "💎",
        description = "High-purity crystal meth"
    },
    ["lsd"] = {
        label = "LSD",
        category = "drug",
        rarity = "rare",
        basePrice = 0.0025,
        minPrice = 0.0015,
        maxPrice = 0.0050,
        baseDemand = 65,
        baseSupply = 20,
        emoji = "🌈",
        description = "Mind-altering psychedelic"
    },
    ["opium"] = {
        label = "Opium",
        category = "drug",
        rarity = "uncommon",
        basePrice = 0.0020,
        minPrice = 0.0012,
        maxPrice = 0.0040,
        baseDemand = 70,
        baseSupply = 35,
        emoji = "🌸",
        description = "Raw opium poppy extract"
    },
    
    -- Ammunition
    ["ammo_pistol"] = {
        label = "Pistol Ammo",
        category = "ammo",
        rarity = "common",
        basePrice = 0.0001,
        minPrice = 0.00005,
        maxPrice = 0.0003,
        baseDemand = 60,
        baseSupply = 200,
        emoji = "🔸",
        description = "9mm ammunition"
    },
    ["ammo_rifle"] = {
        label = "Rifle Ammo",
        category = "ammo",
        rarity = "uncommon",
        basePrice = 0.0003,
        minPrice = 0.0001,
        maxPrice = 0.0008,
        baseDemand = 65,
        baseSupply = 120,
        emoji = "🔹",
        description = "7.62mm ammunition"
    },
    ["ammo_shotgun"] = {
        label = "Shotgun Ammo",
        category = "ammo",
        rarity = "common",
        basePrice = 0.0002,
        minPrice = 0.0001,
        maxPrice = 0.0005,
        baseDemand = 55,
        baseSupply = 180,
        emoji = "🔶",
        description = "12-gauge shotgun shells"
    },
    ["ammo_sniper"] = {
        label = "Sniper Ammo",
        category = "ammo",
        rarity = "rare",
        basePrice = 0.0008,
        minPrice = 0.0005,
        maxPrice = 0.0015,
        baseDemand = 80,
        baseSupply = 50,
        emoji = "🔺",
        description = "High-caliber sniper rounds"
    },
    
    -- Illegal Items
    ["fake_money"] = {
        label = "Counterfeit Money",
        category = "illegal",
        rarity = "epic",
        basePrice = 0.0080,
        minPrice = 0.0050,
        maxPrice = 0.0150,
        baseDemand = 95,
        baseSupply = 15,
        emoji = "💵",
        description = "High-quality fake bills"
    },
    ["stolen_phone"] = {
        label = "Stolen Electronics",
        category = "illegal",
        rarity = "uncommon",
        basePrice = 0.0025,
        minPrice = 0.0015,
        maxPrice = 0.0050,
        baseDemand = 70,
        baseSupply = 80,
        emoji = "📱",
        description = "Hot electronics"
    },
    ["fake_id"] = {
        label = "Forged Documents",
        category = "illegal",
        rarity = "rare",
        basePrice = 0.0060,
        minPrice = 0.0035,
        maxPrice = 0.0120,
        baseDemand = 88,
        baseSupply = 20,
        emoji = "📋",
        description = "Fake IDs and passports"
    },
    ["stolen_card"] = {
        label = "Stolen Credit Cards",
        category = "illegal",
        rarity = "uncommon",
        basePrice = 0.0015,
        minPrice = 0.0008,
        maxPrice = 0.0035,
        baseDemand = 75,
        baseSupply = 60,
        emoji = "💳",
        description = "Compromised credit cards"
    },
    
    -- Stolen Goods
    ["stolen_car_part"] = {
        label = "Stolen Car Parts",
        category = "stolen",
        rarity = "common",
        basePrice = 0.0008,
        minPrice = 0.0005,
        maxPrice = 0.0015,
        baseDemand = 65,
        baseSupply = 100,
        emoji = "🔧",
        description = "Hot car parts"
    },
    ["stolen_jewelry"] = {
        label = "Stolen Jewelry",
        category = "stolen",
        rarity = "rare",
        basePrice = 0.0045,
        minPrice = 0.0025,
        maxPrice = 0.0080,
        baseDemand = 85,
        baseSupply = 30,
        emoji = "💎",
        description = "High-value stolen jewelry"
    },
    ["stolen_art"] = {
        label = "Stolen Artwork",
        category = "stolen",
        rarity = "epic",
        basePrice = 0.0100,
        minPrice = 0.0060,
        maxPrice = 0.0180,
        baseDemand = 92,
        baseSupply = 8,
        emoji = "🖼️",
        description = "Priceless stolen artwork"
    }
}

-- Access Locations
Config.AccessLocations = {
    {
        name = "Alley Access Point",
        coords = vector3(-1172.69, -1572.23, 4.66),
        radius = 2.0,
        blip = {
            sprite = 500,
            color = 1,
            scale = 0.8,
            label = "Underground Access",
            display = 4
        },
        marker = {
            type = 1,
            color = { r = 255, g = 0, b = 0, a = 100 },
            size = { x = 2.0, y = 2.0, z = 1.0 }
        }
    },
    {
        name = "Warehouse Access",
        coords = vector3(1087.48, -2008.69, 30.88),
        radius = 2.0,
        blip = {
            sprite = 500,
            color = 1,
            scale = 0.8,
            label = "Underground Access",
            display = 4
        },
        marker = {
            type = 1,
            color = { r = 255, g = 0, b = 0, a = 100 },
            size = { x = 2.0, y = 2.0, z = 1.0 }
        }
    },
    {
        name = "Pier Access",
        coords = vector3(-1797.24, -1193.13, 13.02),
        radius = 2.0,
        blip = {
            sprite = 500,
            color = 1,
            scale = 0.8,
            label = "Underground Access",
            display = 4
        },
        marker = {
            type = 1,
            color = { r = 255, g = 0, b = 0, a = 100 },
            size = { x = 2.0, y = 2.0, z = 1.0 }
        }
    },
    {
        name = "Industrial Access",
        coords = vector3(2433.84, 4968.32, 42.35),
        radius = 2.0,
        blip = {
            sprite = 500,
            color = 1,
            scale = 0.8,
            label = "Underground Access",
            display = 4
        },
        marker = {
            type = 1,
            color = { r = 255, g = 0, b = 0, a = 100 },
            size = { x = 2.0, y = 2.0, z = 1.0 }
        }
    },
    {
        name = "Sandy Shores Access",
        coords = vector3(1905.84, 3729.73, 32.85),
        radius = 2.0,
        blip = {
            sprite = 500,
            color = 1,
            scale = 0.8,
            label = "Underground Access",
            display = 4
        },
        marker = {
            type = 1,
            color = { r = 255, g = 0, b = 0, a = 100 },
            size = { x = 2.0, y = 2.0, z = 1.0 }
        }
    }
}

-- Notification Settings
Config.Notifications = {
    Duration = 5000, -- 5 seconds
    Position = "top-right",
    Sounds = true,
    UseESXNotify = true -- Use ESX notification system
}

-- Webhook Settings (for Discord logs)
Config.Webhooks = {
    Enable = false,
    TransactionWebhook = "", -- Discord webhook URL
    AdminWebhook = "", -- Discord webhook URL for admin actions
    Colors = {
        buy = 3066993, -- Green
        sell = 15158332, -- Red
        admin = 3447003 -- Blue
    }
}

-- Language Settings
Config.Locales = {
    ['en'] = {
        -- General
        ['black_market'] = 'Black Market',
        ['access_denied'] = 'Access denied',
        ['insufficient_funds'] = 'Insufficient Bitcoin',
        ['transaction_success'] = 'Transaction successful',
        ['transaction_failed'] = 'Transaction failed',
        ['cooldown_active'] = 'Transaction cooldown active',
        ['invalid_quantity'] = 'Invalid quantity',
        ['item_not_found'] = 'Item not found',
        ['not_enough_items'] = 'Not enough items to sell',
        ['market_closed'] = 'Market is currently closed',
        ['no_inventory_space'] = 'Not enough inventory space',
        
        -- UI
        ['search_placeholder'] = 'Search items...',
        ['buy_button'] = 'Buy',
        ['sell_button'] = 'Sell',
        ['confirm_button'] = 'Confirm',
        ['cancel_button'] = 'Cancel',
        ['bitcoin_wallet'] = 'Bitcoin Wallet',
        ['your_inventory'] = 'Your Inventory',
        ['market_status'] = 'Market Status',
        ['price_change'] = 'Price Change',
        ['demand'] = 'Demand',
        ['supply'] = 'Supply',
        ['refresh_market'] = 'Refresh Market',
        
        -- Access
        ['access_point'] = '[E] Access Black Market',
        ['required_item'] = 'You need a %s to access the market',
        ['required_job'] = 'You need to be %s to access the market',
        
        -- Admin
        ['admin_reset_prices'] = 'Market prices have been reset',
        ['admin_no_permission'] = 'You do not have permission to use this command',
        ['admin_logs_header'] = 'Recent Black Market Transactions:',
        
        -- Errors
        ['error_invalid_data'] = 'Invalid transaction data',
        ['error_price_changed'] = 'Price has changed, please refresh',
        ['error_insufficient_supply'] = 'Not enough supply in market',
        ['error_transaction_failed'] = 'Transaction failed, please try again'
    },
    
    ['ar'] = {
        -- General
        ['black_market'] = 'السوق السوداء',
        ['access_denied'] = 'تم رفض الوصول',
        ['insufficient_funds'] = 'البيتكوين غير كافي',
        ['transaction_success'] = 'تمت المعاملة بنجاح',
        ['transaction_failed'] = 'فشلت المعاملة',
        ['cooldown_active'] = 'فترة انتظار المعاملة نشطة',
        ['invalid_quantity'] = 'كمية غير صحيحة',
        ['item_not_found'] = 'لم يتم العثور على العنصر',
        ['not_enough_items'] = 'عناصر غير كافية للبيع',
        ['market_closed'] = 'السوق مغلق حالياً',
        ['no_inventory_space'] = 'مساحة المخزون غير كافية',
        
        -- UI
        ['search_placeholder'] = 'البحث عن العناصر...',
        ['buy_button'] = 'شراء',
        ['sell_button'] = 'بيع',
        ['confirm_button'] = 'تأكيد',
        ['cancel_button'] = 'إلغاء',
        ['bitcoin_wallet'] = 'محفظة البيتكوين',
        ['your_inventory'] = 'مخزونك',
        ['market_status'] = 'حالة السوق',
        ['price_change'] = 'تغير السعر',
        ['demand'] = 'الطلب',
        ['supply'] = 'العرض',
        ['refresh_market'] = 'تحديث السوق',
        
        -- Access
        ['access_point'] = '[E] دخول السوق السوداء',
        ['required_item'] = 'تحتاج إلى %s للوصول إلى السوق',
        ['required_job'] = 'تحتاج إلى أن تكون %s للوصول إلى السوق',
        
        -- Admin
        ['admin_reset_prices'] = 'تم إعادة تعيين أسعار السوق',
        ['admin_no_permission'] = 'ليس لديك صلاحية لاستخدام هذا الأمر',
        ['admin_logs_header'] = 'معاملات السوق السوداء الأخيرة:',
        
        -- Errors
        ['error_invalid_data'] = 'بيانات المعاملة غير صحيحة',
        ['error_price_changed'] = 'تغير السعر، يرجى التحديث',
        ['error_insufficient_supply'] = 'عرض غير كافي في السوق',
        ['error_transaction_failed'] = 'فشلت المعاملة، يرجى المحاولة مرة أخرى'
    }
}

-- Admin Settings
Config.Admin = {
    Commands = {
        ['blackmarket:reset'] = 'admin', -- ESX group required
        ['blackmarket:logs'] = 'admin',
        ['blackmarket:reload'] = 'admin',
        ['blackmarket:setprice'] = 'superadmin',
        ['blackmarket:addbitcoin'] = 'admin',
        ['blackmarket:removebitcoin'] = 'admin'
    },
    LogLevel = 'info' -- debug, info, warn, error
}

-- Integration Settings
Config.Integration = {
    -- Phone integration (if using phone script)
    Phone = {
        Enable = false,
        AppName = "BlackMarket",
        AppIcon = "fas fa-user-secret"
    },
    
    -- Banking integration
    Banking = {
        Enable = false,
        BankAccount = 'black_market_account'
    },
    
    -- Inventory integration
    Inventory = {
        Type = 'default', -- 'default', 'ox_inventory', 'qs-inventory'
        ImagePath = 'nui://esx_inventoryhud/html/img/items/'
    }
}

-- Performance Settings
Config.Performance = {
    UpdateInterval = 1000, -- How often to update UI (milliseconds)
    MaxPlayersInMarket = 10, -- Maximum concurrent players in market
    CacheTimeout = 300000, -- Cache timeout for market data (5 minutes)
    OptimizeQueries = true -- Optimize database queries
}

-- Development Settings (Remove in production)
Config.Development = {
    EnableTestCommands = false,
    DebugMode = false,
    MockData = false,
    FastTransactions = false -- Remove cooldowns for testing
}