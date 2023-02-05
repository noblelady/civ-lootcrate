local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent("civ-lootcrate:server:GiveLoot", function(items)
  local Player = QBCore.Functions.GetPlayer(source)

  for i=1, #items do
    Player.Functions.AddItem(items[i], 1, false)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[items[i]], 'add')
  end
  TriggerClientEvent('QBCore:Notify', source, "Picked up the loot")
end)
