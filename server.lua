-- BlackMarket ESX Server Side
ESX = exports['es_extended']:getSharedObject()

CreateThread(function()
    while GetResourceState("fd_laptop") ~= "started" do
        Wait(500)
    end

    local added, errorMessage = exports.fd_laptop:addCustomApp({
        id = "fd_laptop_vue_template",
        name = "Vue App Template",
        appstore = {
            description =
            "Some kind of very awesome description",
            author = "Felis Development",
            installTime = 8000,
            images = {
                "https://images.unsplash.com/photo-1719937206158-cad5e6775044?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                "https://images.unsplash.com/photo-1720048169707-a32d6dfca0b3?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                "https://images.unsplash.com/photo-1727764673451-3d2494f9e409?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
            }
        },
        isDefaultApp = true,
        needsUpdate = false,
        icon = ("https://cfx-nui-%s/web/dist/question.svg"):format(GetCurrentResourceName()),
        ui = ("https://cfx-nui-%s/web/dist/index.html"):format(GetCurrentResourceName()),
    })

    if not added then
        print("Could not add app:", errorMessage)
    end
end)



-- Market Configuration
local Config = {
    -- Bitcoin wallet integration
    CryptoTable = "phone_crypto",
    CryptoCoin = "bitcoin",
    
    -- Market items configuration
    MarketItems = {
        -- Weapons
        ["weapon_pistol"] = {
            label = "Pistol",
            category = "weapon",
            rarity = "common",
            basePrice = 0.0015,
            minPrice = 0.0010,
            maxPrice = 0.0030,
            demand = 50,
            supply = 100,
            emoji = "🔫",
            description = "Basic pistol"
        },
        ["weapon_assaultrifle"] = {
            label = "AK-47",
            category = "weapon", 
            rarity = "rare",
            basePrice = 0.0045,
            minPrice = 0.0030,
            maxPrice = 0.0080,
            demand = 70,
            supply = 30,
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
            demand = 90,
            supply = 10,
            emoji = "🔫",
            description = "Legendary handgun"
        },
        
        -- Drugs
        ["weed"] = {
            label = "Marijuana",
            category = "drug",
            rarity = "common",
            basePrice = 0.0003,
            minPrice = 0.0001,
            maxPrice = 0.0008,
            demand = 80,
            supply = 150,
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
            demand = 85,
            supply = 60,
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
            demand = 75,
            supply = 25,
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
            demand = 78,
            supply = 40,
            emoji = "💎",
            description = "High-purity crystal meth"
        },
        
        -- Ammunition
        ["ammo_pistol"] = {
            label = "Pistol Ammo",
            category = "ammo",
            rarity = "common",
            basePrice = 0.0001,
            minPrice = 0.00005,
            maxPrice = 0.0003,
            demand = 60,
            supply = 200,
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
            demand = 65,
            supply = 120,
            emoji = "🔹",
            description = "7.62mm ammunition"
        },
        
        -- Illegal Items
        ["fake_money"] = {
            label = "Counterfeit Money",
            category = "illegal",
            rarity = "epic",
            basePrice = 0.0080,
            minPrice = 0.0050,
            maxPrice = 0.0150,
            demand = 95,
            supply = 15,
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
            demand = 70,
            supply = 80,
            emoji = "📱",
            description = "Hot electronics"
        }
    },
    
    -- Market dynamics
    PriceUpdateInterval = 300000, -- 5 minutes
    MaxPriceFluctuation = 0.15, -- 15% max change per update
    SellPriceMultiplier = 0.85, -- Players sell at 85% of buy price
    
    -- Security settings
    MaxTransactionAmount = 100,
    MinTransactionAmount = 1,
    CooldownBetweenTransactions = 5000, -- 5 seconds
}

-- Global variables
local MarketData = {}
local PlayerCooldowns = {}
local TransactionLogs = {}

-- Initialize market data
function InitializeMarketData()
    for itemName, itemData in pairs(Config.MarketItems) do
        MarketData[itemName] = {
            label = itemData.label,
            category = itemData.category,
            rarity = itemData.rarity,
            price = itemData.basePrice,
            priceChange = 0.0,
            demand = itemData.demand,
            supply = itemData.supply,
            emoji = itemData.emoji,
            description = itemData.description,
            minPrice = itemData.minPrice,
            maxPrice = itemData.maxPrice,
            basePrice = itemData.basePrice
        }
    end
end

-- Database functions
function GetPlayerBitcoin(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return 0 end
    
    local result = MySQL.Sync.fetchAll('SELECT amount FROM ' .. Config.CryptoTable .. ' WHERE id = ? AND coin = ?', {
        xPlayer.identifier,
        Config.CryptoCoin
    })
    
    if result and result[1] then
        return result[1].amount
    end
    return 0
end

function UpdatePlayerBitcoin(source, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return false end
    
    local currentAmount = GetPlayerBitcoin(source)
    local newAmount = currentAmount + amount
    
    if newAmount < 0 then return false end
    
    MySQL.Async.execute('INSERT INTO ' .. Config.CryptoTable .. ' (id, coin, amount) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE amount = ?', {
        xPlayer.identifier,
        Config.CryptoCoin,
        newAmount,
        newAmount
    })
    
    return true
end

function GetPlayerInventory(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return {} end
    
    local inventory = {}
    for itemName, itemData in pairs(Config.MarketItems) do
        local item = xPlayer.getInventoryItem(itemName)
        if item and item.count > 0 then
            table.insert(inventory, {
                name = itemData.label,
                itemName = itemName,
                quantity = item.count
            })
        end
    end
    
    return inventory
end

-- Market dynamics functions
function UpdateMarketPrices()
    for itemName, itemData in pairs(MarketData) do
        local oldPrice = itemData.price
        
        -- Calculate price based on supply and demand
        local demandFactor = itemData.demand / 100
        local supplyFactor = math.max(0.1, itemData.supply / 100)
        local volatility = (math.random() - 0.5) * 0.1 -- ±5% random volatility
        
        local priceMultiplier = (demandFactor / supplyFactor) * (1 + volatility)
        local newPrice = math.max(itemData.minPrice, math.min(itemData.maxPrice, itemData.basePrice * priceMultiplier))
        
        -- Apply maximum fluctuation limit
        local maxChange = oldPrice * Config.MaxPriceFluctuation
        if math.abs(newPrice - oldPrice) > maxChange then
            if newPrice > oldPrice then
                newPrice = oldPrice + maxChange
            else
                newPrice = oldPrice - maxChange
            end
        end
        
        itemData.price = newPrice
        itemData.priceChange = ((newPrice - oldPrice) / oldPrice) * 100
        
        -- Update supply and demand with some randomness
        local demandChange = (math.random() - 0.5) * 10
        local supplyChange = (math.random() - 0.5) * 5
        
        itemData.demand = math.max(1, math.min(100, itemData.demand + demandChange))
        itemData.supply = math.max(1, math.min(200, itemData.supply + supplyChange))
    end
    
    -- Broadcast updated prices to all players
    TriggerClientEvent('blackmarket:updateMarketData', -1, MarketData)
end

function IsPlayerOnCooldown(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return true end
    
    local playerId = xPlayer.identifier
    if PlayerCooldowns[playerId] and (GetGameTimer() - PlayerCooldowns[playerId]) < Config.CooldownBetweenTransactions then
        return true
    end
    return false
end

function SetPlayerCooldown(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    
    local playerId = xPlayer.identifier
    PlayerCooldowns[playerId] = GetGameTimer()
end

function LogTransaction(source, transactionType, itemName, quantity, price, totalAmount)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    
    local logEntry = {
        timestamp = os.time(),
        identifier = xPlayer.identifier,
        name = xPlayer.getName(),
        transactionType = transactionType,
        itemName = itemName,
        quantity = quantity,
        pricePerUnit = price,
        totalAmount = totalAmount
    }
    
    table.insert(TransactionLogs, logEntry)
    
    -- Log to database
    MySQL.Async.execute('INSERT INTO blackmarket_transactions (identifier, name, transaction_type, item_name, quantity, price_per_unit, total_amount, timestamp) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
        logEntry.identifier,
        logEntry.name,
        logEntry.transactionType,
        logEntry.itemName,
        logEntry.quantity,
        logEntry.pricePerUnit,
        logEntry.totalAmount,
        logEntry.timestamp
    })
end

-- Event handlers
RegisterNetEvent('blackmarket:openMarket')
AddEventHandler('blackmarket:openMarket', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    local bitcoinAmount = GetPlayerBitcoin(source)
    local inventory = GetPlayerInventory(source)
    
    TriggerClientEvent('blackmarket:openUI', source, {
        marketData = MarketData,
        bitcoinAmount = bitcoinAmount,
        inventory = inventory
    })
end)

RegisterNetEvent('blackmarket:buy')
AddEventHandler('blackmarket:buy', function(data)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    -- Security checks
    if IsPlayerOnCooldown(source) then
        xPlayer.showNotification('Transaction cooldown active!', 'error')
        return
    end
    
    local itemName = data.item
    local quantity = tonumber(data.quantity)
    local expectedPrice = tonumber(data.price)
    
    -- Validate input
    if not itemName or not quantity or not expectedPrice then
        xPlayer.showNotification('Invalid transaction data!', 'error')
        return
    end
    
    if quantity < Config.MinTransactionAmount or quantity > Config.MaxTransactionAmount then
        xPlayer.showNotification('Invalid quantity!', 'error')
        return
    end
    
    -- Check if item exists in market
    local marketItem = MarketData[itemName]
    if not marketItem then
        xPlayer.showNotification('Item not found in market!', 'error')
        return
    end
    
    -- Price validation (allow 5% tolerance for price fluctuations)
    if math.abs(marketItem.price - expectedPrice) > (marketItem.price * 0.05) then
        xPlayer.showNotification('Price has changed, please refresh!', 'error')
        return
    end
    
    local totalCost = marketItem.price * quantity
    local currentBitcoin = GetPlayerBitcoin(source)
    
    -- Check if player has enough bitcoin
    if currentBitcoin < totalCost then
        xPlayer.showNotification('Insufficient Bitcoin!', 'error')
        return
    end
    
    -- Check if market has enough supply
    if marketItem.supply < quantity then
        xPlayer.showNotification('Not enough supply in market!', 'error')
        return
    end
    
    -- Check if player has inventory space
    local item = xPlayer.getInventoryItem(itemName)
    if item.limit ~= -1 and (item.count + quantity) > item.limit then
        xPlayer.showNotification('Not enough inventory space!', 'error')
        return
    end
    
    -- Process transaction
    if UpdatePlayerBitcoin(source, -totalCost) then
        xPlayer.addInventoryItem(itemName, quantity)
        
        -- Update market dynamics
        marketItem.demand = math.min(100, marketItem.demand + (quantity * 0.5))
        marketItem.supply = math.max(1, marketItem.supply - quantity)
        
        -- Set cooldown
        SetPlayerCooldown(source)
        
        -- Log transaction
        LogTransaction(source, 'buy', itemName, quantity, marketItem.price, totalCost)
        
        xPlayer.showNotification('Purchase successful!', 'success')
        TriggerClientEvent('blackmarket:updateBitcoin', source, GetPlayerBitcoin(source))
        TriggerClientEvent('blackmarket:updateInventory', source, GetPlayerInventory(source))
        
        -- Broadcast market update to all players
        TriggerClientEvent('blackmarket:updateMarketData', -1, MarketData)
    else
        xPlayer.showNotification('Transaction failed!', 'error')
    end
end)

RegisterNetEvent('blackmarket:sell')
AddEventHandler('blackmarket:sell', function(data)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    -- Security checks
    if IsPlayerOnCooldown(source) then
        xPlayer.showNotification('Transaction cooldown active!', 'error')
        return
    end
    
    local itemName = data.item
    local quantity = tonumber(data.quantity)
    
    -- Validate input
    if not itemName or not quantity then
        xPlayer.showNotification('Invalid transaction data!', 'error')
        return
    end
    
    if quantity < Config.MinTransactionAmount or quantity > Config.MaxTransactionAmount then
        xPlayer.showNotification('Invalid quantity!', 'error')
        return
    end
    
    -- Check if item exists in market
    local marketItem = MarketData[itemName]
    if not marketItem then
        xPlayer.showNotification('Item not found in market!', 'error')
        return
    end
    
    -- Check if player has the item
    local playerItem = xPlayer.getInventoryItem(itemName)
    if not playerItem or playerItem.count < quantity then
        xPlayer.showNotification('Not enough items to sell!', 'error')
        return
    end
    
    local sellPrice = marketItem.price * Config.SellPriceMultiplier
    local totalEarned = sellPrice * quantity
    
    -- Process transaction
    if xPlayer.removeInventoryItem(itemName, quantity) then
        UpdatePlayerBitcoin(source, totalEarned)
        
        -- Update market dynamics
        marketItem.demand = math.max(1, marketItem.demand - (quantity * 0.3))
        marketItem.supply = math.min(200, marketItem.supply + quantity)
        
        -- Set cooldown
        SetPlayerCooldown(source)
        
        -- Log transaction
        LogTransaction(source, 'sell', itemName, quantity, sellPrice, totalEarned)
        
        xPlayer.showNotification('Sale successful!', 'success')
        TriggerClientEvent('blackmarket:updateBitcoin', source, GetPlayerBitcoin(source))
        TriggerClientEvent('blackmarket:updateInventory', source, GetPlayerInventory(source))
        
        -- Broadcast market update to all players
        TriggerClientEvent('blackmarket:updateMarketData', -1, MarketData)
    else
        xPlayer.showNotification('Transaction failed!', 'error')
    end
end)

-- Admin commands
RegisterCommand('blackmarket:resetprices', function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    
    -- Check if player is admin
    if xPlayer.getGroup() ~= 'admin' and xPlayer.getGroup() ~= 'superadmin' then
        xPlayer.showNotification('No permission!', 'error')
        return
    end
    
    InitializeMarketData()
    TriggerClientEvent('blackmarket:updateMarketData', -1, MarketData)
    xPlayer.showNotification('Market prices reset!', 'success')
end, false)

RegisterCommand('blackmarket:logs', function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    
    -- Check if player is admin
    if xPlayer.getGroup() ~= 'admin' and xPlayer.getGroup() ~= 'superadmin' then
        xPlayer.showNotification('No permission!', 'error')
        return
    end
    
    -- Show recent transaction logs
    local recentLogs = {}
    local count = 0
    for i = #TransactionLogs, math.max(1, #TransactionLogs - 20), -1 do
        table.insert(recentLogs, TransactionLogs[i])
        count = count + 1
        if count >= 20 then break end
    end
    
    print("^2[BlackMarket] Recent Transactions:^7")
    for _, log in ipairs(recentLogs) do
        print(string.format("^3%s^7 - %s %s %dx %s for ₿%.8f (₿%.8f each)", 
            os.date("%Y-%m-%d %H:%M:%S", log.timestamp),
            log.name,
            log.transactionType,
            log.quantity,
            log.itemName,
            log.totalAmount,
            log.pricePerUnit
        ))
    end
end, false)

-- Initialize everything when resource starts
Citizen.CreateThread(function()
    InitializeMarketData()
    
    -- Start price update loop
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(Config.PriceUpdateInterval)
            UpdateMarketPrices()
        end
    end)
end)

-- Create database table for transaction logs
MySQL.ready(function()
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS blackmarket_transactions (
            id INT AUTO_INCREMENT PRIMARY KEY,
            identifier VARCHAR(50) NOT NULL,
            name VARCHAR(100) NOT NULL,
            transaction_type ENUM('buy', 'sell') NOT NULL,
            item_name VARCHAR(50) NOT NULL,
            quantity INT NOT NULL,
            price_per_unit DECIMAL(20,8) NOT NULL,
            total_amount DECIMAL(20,8) NOT NULL,
            timestamp INT NOT NULL,
            INDEX idx_identifier (identifier),
            INDEX idx_timestamp (timestamp)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    ]])
end)

print("^2[BlackMarket] ^7ESX Server side loaded successfully!")