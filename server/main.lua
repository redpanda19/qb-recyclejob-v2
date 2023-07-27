local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('qb-recycle:server:getItem', function()  
  local src = source
  local Player = QBCore.Functions.GetPlayer(src)
  local count = math.random(5, 15)
  local cancarry = exports.ox_inventory:CanCarryItem(src, 'recycledmaterials', count)
  print(cancarry)
  if cancarry then
      Player.Functions.AddItem("recycledmaterials", count)
      TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['recycledmaterials'], 'add', count)
  else
      print('You are Full')
  end
end)


-------------------
-- INPUT count --
-------------------
RegisterNetEvent("qb-recyclejob:TradeInput", function(item, count)
  print(item, count)
  local src = source
  local tradecount = tonumber(count)
  local Player = QBCore.Functions.GetPlayer(src)

  local PlayerItem = Player.Functions.GetItemByName('recycledmaterials')
  -- Check if the player even has the item
  if not PlayerItem then QBCore.Functions.Notify(src, 'You don\'t even have recycled materials') return end
  -- Check if the player has more than he put in
  if PlayerItem.count < tradecount then QBCore.Functions.Notify(src, 'You don\'t have enough recycled materials') return end

  local pay = (Config.ItemPrices[item].price * tradecount)
  local cantrade = exports.ox_inventory:CanCarryItem(src, item, pay)
  if cantrade then
    Player.Functions.RemoveItem('recycledmaterials', tradecount)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['recycledmaterials'], 'remove', tradecount)
    Player.Functions.AddItem(item, pay)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'add', pay)
  else
    print('Add your notify here')
  end
end)
-------------------
-- TRADE ALL --
-------------------

RegisterNetEvent("qb-recyclejob:TradeAll", function(item)
  local src = source
  local Player = QBCore.Functions.GetPlayer(src)
  local count = Player.Functions.GetItemByName("recycledmaterials").count -- Gets count of recycled materials
  local itemcount = Config.ItemPrices[item].price -- Gets price of each item
  local pay = (count * itemcount)

  if item == 'cash' then
      Player.Functions.RemoveItem('recycledmaterials', count)
      TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['recycledmaterials'], 'remove', count)
      local payment = money -- how much money player should recive in their accounts
local citizenid = Player.PlayerData.citizenid
local from = Player.PlayerData.job.name -- job name / shown as 'from' in transaction history

TriggerEvent('keep-paycheck:server:AddMoneyToPayCheck', citizenid, payment , from)('cash', pay)
  else
      if Player.Functions.GetItemByName("recycledmaterials") ~= nil then
          Player.Functions.RemoveItem('recycledmaterials', count)
          TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['recycledmaterials'], 'remove', count)
          Player.Functions.AddItem(item, pay)
          TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'add', pay)
      end
  end
end)

