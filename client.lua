-- BlackMarket ESX Client Side
ESX = exports['es_extended']:getSharedObject()


RegisterCommand('testMessageVue', function()
    exports.fd_laptop:sendAppMessage('fd_laptop_vue_template', {
        action = "test",
        data = {
            test = "test"
        }
    })
end, false)

-- Configuration
local Config = {
    -- Access locations (where players can access the black market)
    AccessLocations = {
        {
            name = "Alley Access Point",
            coords = vector3(-1172.69, -1572.23, 4.66),
            radius = 2.0,
            blip = {
                sprite = 500,
                color = 1,
                scale = 0.8,
                label = "Underground Access"
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
                label = "Underground Access"
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
                label = "Underground Access"
            }
        }
    },
    
    -- Security settings
    RequiredItem = nil, -- Set to an item name if you want to require a specific item for access
    RequiredJob = nil, -- Set to a job name if you want to restrict access to specific jobs
    
    -- UI settings
    UIResource = GetCurrentResourceName(),
    UIPath = "html/index.html"
}

-- Global variables
local isUIOpen = false
local currentMarketData = {}
local playerBitcoin = 0
local playerInventory = {}
local accessPoints = {}

-- Utility functions
function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
        local factor = (string.len(text)) / 370
        DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 75)
    end
end

function ShowNotification(message, type)
    if type == "success" then
        ESX.ShowNotification(message, "success")
    elseif type == "error" then
        ESX.ShowNotification(message, "error")
    else
        ESX.ShowNotification(message, "info")
    end
end

function HasAccessToBlackMarket()
    local PlayerData = ESX.GetPlayerData()
    
    -- Check if player has required item
    if Config.RequiredItem then
        local hasItem = false
        for _, item in pairs(PlayerData.inventory) do
            if item.name == Config.RequiredItem and item.count > 0 then
                hasItem = true
                break
            end
        end
        if not hasItem then
            return false, "You need a " .. Config.RequiredItem .. " to access the black market"
        end
    end
    
    -- Check if player has required job
    if Config.RequiredJob then
        if PlayerData.job and PlayerData.job.name ~= Config.RequiredJob then
            return false, "You don't have access to this market"
        end
    end
    
    return true, "Access granted"
end

function CreateBlips()
    for _, location in pairs(Config.AccessLocations) do
        local blip = AddBlipForCoord(location.coords.x, location.coords.y, location.coords.z)
        SetBlipSprite(blip, location.blip.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, location.blip.scale)
        SetBlipColour(blip, location.blip.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(location.blip.label)
        EndTextCommandSetBlipName(blip)
    end
end

function CreateAccessPoints()
    for i, location in pairs(Config.AccessLocations) do
        accessPoints[i] = {
            coords = location.coords,
            radius = location.radius,
            name = location.name,
            isInRange = false
        }
    end
end

function OpenBlackMarket()
    local hasAccess, message = HasAccessToBlackMarket()
    if not hasAccess then
        ShowNotification(message, "error")
        return
    end
    
    -- Request market data from server
    TriggerServerEvent('blackmarket:openMarket')
end

function CloseBlackMarket()
    if isUIOpen then
        isUIOpen = false
        SetNuiFocus(false, false)
        SendNUIMessage({
            action = "closeUI"
        })
    end
end

function SendTransactionToServer(transactionType, itemName, quantity, price)
    if transactionType == "buy" then
        TriggerServerEvent('blackmarket:buy', {
            item = itemName,
            quantity = quantity,
            price = price
        })
    elseif transactionType == "sell" then
        TriggerServerEvent('blackmarket:sell', {
            item = itemName,
            quantity = quantity
        })
    end
end

-- NUI Callbacks
RegisterNUICallback('buyItem', function(data, cb)
    SendTransactionToServer('buy', data.item, data.quantity, data.price)
    cb('ok')
end)

RegisterNUICallback('sellItem', function(data, cb)
    SendTransactionToServer('sell', data.item, data.quantity)
    cb('ok')
end)

RegisterNUICallback('closeUI', function(data, cb)
    CloseBlackMarket()
    cb('ok')
end)

RegisterNUICallback('refreshMarket', function(data, cb)
    TriggerServerEvent('blackmarket:openMarket')
    cb('ok')
end)

-- Event handlers
RegisterNetEvent('blackmarket:openUI')
AddEventHandler('blackmarket:openUI', function(data)
    if not data then return end
    
    currentMarketData = data.marketData
    playerBitcoin = data.bitcoinAmount
    playerInventory = data.inventory
    
    isUIOpen = true
    SetNuiFocus(true, true)
    
    -- Convert market data to format expected by UI
    local marketItems = {}
    for itemName, itemData in pairs(currentMarketData) do
        table.insert(marketItems, {
            name = itemData.label,
            itemName = itemName,
            category = itemData.category,
            rarity = itemData.rarity,
            price = itemData.price,
            priceChange = itemData.priceChange,
            demand = itemData.demand,
            supply = itemData.supply,
            emoji = itemData.emoji,
            description = itemData.description
        })
    end
    
    SendNUIMessage({
        action = "openUI",
        marketData = marketItems,
        bitcoinAmount = playerBitcoin,
        inventory = playerInventory
    })
end)

RegisterNetEvent('blackmarket:updateMarketData')
AddEventHandler('blackmarket:updateMarketData', function(marketData)
    if not isUIOpen then return end
    
    currentMarketData = marketData
    
    -- Convert market data to format expected by UI
    local marketItems = {}
    for itemName, itemData in pairs(currentMarketData) do
        table.insert(marketItems, {
            name = itemData.label,
            itemName = itemName,
            category = itemData.category,
            rarity = itemData.rarity,
            price = itemData.price,
            priceChange = itemData.priceChange,
            demand = itemData.demand,
            supply = itemData.supply,
            emoji = itemData.emoji,
            description = itemData.description
        })
    end
    
    SendNUIMessage({
        action = "updateMarket",
        marketData = marketItems
    })
end)

RegisterNetEvent('blackmarket:updateBitcoin')
AddEventHandler('blackmarket:updateBitcoin', function(amount)
    playerBitcoin = amount
    if isUIOpen then
        SendNUIMessage({
            action = "updateBitcoin",
            amount = amount
        })
    end
end)

RegisterNetEvent('blackmarket:updateInventory')
AddEventHandler('blackmarket:updateInventory', function(inventory)
    playerInventory = inventory
    if isUIOpen then
        SendNUIMessage({
            action = "updateInventory",
            inventory = inventory
        })
    end
end)

-- Main thread for handling access points
Citizen.CreateThread(function()
    CreateBlips()
    CreateAccessPoints()
    
    while true do
        local sleep = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        
        for i, accessPoint in pairs(accessPoints) do
            local distance = #(playerCoords - accessPoint.coords)
            
            if distance <= accessPoint.radius then
                sleep = 0
                
                if not accessPoint.isInRange then
                    accessPoint.isInRange = true
                end
                
                -- Draw 3D text
                DrawText3D(accessPoint.coords.x, accessPoint.coords.y, accessPoint.coords.z + 0.5, 
                          "[E] Access Black Market")
                
                -- Check for input
                if IsControlJustReleased(0, 38) then -- E key
                    OpenBlackMarket()
                end
            else
                if accessPoint.isInRange then
                    accessPoint.isInRange = false
                end
            end
        end
        
        Citizen.Wait(sleep)
    end
end)

-- Handle UI focus and input
Citizen.CreateThread(function()
    while true do
        if isUIOpen then
            DisableControlAction(0, 1, true) -- Mouse look
            DisableControlAction(0, 2, true) -- Mouse look
            DisableControlAction(0, 142, true) -- Attack
            DisableControlAction(0, 18, true) -- Enter
            DisableControlAction(0, 322, true) -- ESC
            DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
            
            -- Close UI with ESC
            if IsControlJustReleased(0, 322) then
                CloseBlackMarket()
            end
        end
        
        Citizen.Wait(0)
    end
end)

-- Commands for testing (remove in production)
RegisterCommand('blackmarket', function()
    OpenBlackMarket()
end, false)

RegisterCommand('bmclose', function()
    CloseBlackMarket()
end, false)

-- Cleanup when resource stops
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        CloseBlackMarket()
    end
end)

-- Initialize when player spawns
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    Citizen.Wait(2000)
    CreateBlips()
    CreateAccessPoints()
end)

print("^2[BlackMarket] ^7ESX Client side loaded successfully!")