local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('qb-recycle:server:getItem', function()  
  local src = source
  local Player = QBCore.Functions.GetPlayer(src)
  local amount = math.random(1, 3)
  Player.Functions.AddItem("recycledmaterials", amount)
  TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['recycledmaterials'], 'add', amount)
end)


-------------------
-- INPUT AMOUNT --
-------------------

RegisterNetEvent("qb-recyclejob:TradeInput", function(item, amount)
  print(item, amount)
  local src = source
  local tradeamount = tonumber(amount)
  local Player = QBCore.Functions.GetPlayer(src)

  local PlayerItem = Player.Functions.GetItemByName('recycledmaterials')
  -- Check if the player even has the item
  if not PlayerItem then QBCore.Functions.Notify(source, 'You don\'t even have recycled materials') return end
  -- Check if the player has more than he put in
  if PlayerItem.amount < tradeamount then QBCore.Functions.Notify(source, 'You don\'t have enough recycled materials') return end

  local pay = (Config.ItemPrices[item].price * tradeamount)
  Player.Functions.RemoveItem('recycledmaterials', tradeamount)
  TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['recycledmaterials'], 'remove', tradeamount)
  Player.Functions.AddItem(item, pay)
  TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'add', pay)
end)

-------------------
-- TRADE ALL --
-------------------

RegisterNetEvent("qb-recyclejob:TradeAll", function(item)
  local src = source
  local Player = QBCore.Functions.GetPlayer(src)
  local amount = Player.Functions.GetItemByName("recycledmaterials").amount -- Gets amount of recycled materials
  local itemamount = Config.ItemPrices[item].price -- Gets price of each item
  local pay = (amount * itemamount)

  if item == 'cash' then
      Player.Functions.RemoveItem('recycledmaterials', amount)
      TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['recycledmaterials'], 'remove', amount)
      Player.Functions.AddMoney('cash', pay)
  else
      if Player.Functions.GetItemByName("recycledmaterials") ~= nil then
          Player.Functions.RemoveItem('recycledmaterials', amount)
          TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['recycledmaterials'], 'remove', amount)
          Player.Functions.AddItem(item, pay)
          TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'add', pay)
      end
  end
end)

