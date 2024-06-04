local var0 = class("WorldItemUseCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.itemID
	local var2 = var0.count
	local var3 = var0.args

	pg.ConnectionMgr.GetInstance():Send(33301, {
		id = var1,
		count = var2,
		arg = var3
	}, 33302, function(arg0)
		if arg0.result == 0 then
			local var0 = {}
			local var1 = nowWorld()

			var1:GetInventoryProxy():RemoveItem(var1, var2)

			local var2 = WorldItem.New({
				id = var1,
				count = var2
			})

			switch(var2:getWorldItemType(), {
				[WorldItem.UsageBuff] = function()
					local var0 = var2:getItemBuffID()

					for iter0, iter1 in ipairs(var3) do
						var1:GetShip(iter1):AddBuff(var0, var2.count)
					end
				end,
				[WorldItem.UsageHPRegenerate] = function()
					local var0 = var2:getItemRegenerate() * var2.count

					for iter0, iter1 in ipairs(var3) do
						var1:GetShip(iter1):Regenerate(var0)
					end
				end,
				[WorldItem.UsageHPRegenerateValue] = function()
					local var0 = var2:getItemRegenerate() * var2.count

					for iter0, iter1 in ipairs(var3) do
						var1:GetShip(iter1):RegenerateValue(var0)
					end
				end,
				[WorldItem.UsageRecoverAp] = function()
					local var0 = var2:getItemStaminaRecover() * var2.count

					var1.staminaMgr:ExchangeStamina(var0)
					arg0:sendNotification(GAME.WORLD_STAMINA_EXCHANGE_DONE)
				end,
				[WorldItem.UsageWorldFlag] = function()
					switch(var2:getItemFlagKey(), {
						function()
							var1:SetGlobalFlag("treasure_flag", true)

							var0 = PlayerConst.addTranDrop(arg0.drop_list)
						end
					})
				end
			}, function()
				var0 = PlayerConst.addTranDrop(arg0.drop_list)
			end)
			arg0:sendNotification(GAME.WORLD_ITEM_USE_DONE, {
				drops = var0,
				item = var2
			})
		elseif PLATFORM_CODE == PLATFORM_CHT then
			pg.TipsMgr.GetInstance():ShowTips(i18n1("Operation Siren item usage failure:" .. arg0.result))
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n1("Operation Siren item usage failure:" .. arg0.result))
		end
	end)
end

return var0
