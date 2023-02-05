local QBCore = exports['qb-core']:GetCoreObject()

-- Variables to store the position and heading of the crate
local cratePosition = Config.CrateLocations[math.random(1, #Config.CrateLocations)]
local crateDistrict = GetNameOfZone(cratePosition.x, cratePosition.y, cratePosition.z)
local CrateObject = nil

-- Function to spawn the crate object
local function spawnCrate()
    CrateObject = CreateObject(GetHashKey("imp_prop_impexp_boxwood_01"), cratePosition, true, false, false)
    PlaceObjectOnGroundProperly(CrateObject)
    SetEntityAsMissionEntity(CrateObject, true, false)
    FreezeEntityPosition(CrateObject, true)

    exports['qb-target']:AddEntityZone("lootcrate", CrateObject, {
      name = "crate",
      debugPoly = false
    },
    {
      options = {
        {
          label = "Open Crate",
          type = "client",
          event = "civ-lootcrate:Client:TargetCrate"
        }
      },
      distance = 2.5
    })
end

-- choose random # of items and random items
local function GetRandomLootItems()
  local lootItems = {}
  local randomAmt = math.random(1, Config.MaxLootItems)

  for i=1, randomAmt do
    table.insert(lootItems, Config.LootItems[math.random(1, #Config.LootItems)])
  end

  return lootItems
end

-- Function to give the player a random loot item
local function GiveLootItems()
    local ped = PlayerPedId()
    local lootItems = GetRandomLootItems()
    TaskPlayAnim(ped, 'amb@prop_human_bum_bin@base', 'pickup_loot', 3.0, 3.0, -1, 0, 1, 0, 0, 0)
    QBCore.Functions.Progressbar("pickupcrate", "Grabbing Loot", 3000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        ClearPedTasks(ped)
	      TriggerServerEvent('civ-lootcrate:server:GiveLoot', lootItems)
        if DoesEntityExist(CrateObject) then
          SetEntityAsNoLongerNeeded()
          exports['qb-target']:RemoveZone('lootcrate')
        end
    end, function() -- Cancel
        ClearPedTasks(ped)
        QBCore.Functions.Notify(Lang:t("notify.canceled"), "error")
    end)
end

RegisterNetEvent('civ-lootcrate:Client:TargetCrate', function()
  GiveLootItems()
  SetEntityAsNoLongerNeeded(CrateObject)
end)

-- Call the spawnCrate function when the resource is started
AddEventHandler("onClientResourceStart", function(resourceName)
  if resourceName == GetCurrentResourceName() then
      spawnCrate()
      TriggerServerEvent('qb-phone:server:sendNewMail', {
        sender = 'shroud',
        subject = 'A Prize',
        message = 'A loot crate has been placed. It is first come first serve. I think I put it around ' .. crateDistrict .. '...'
    })
  end
end)
