local var0_0 = class("WorldItemUseCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.itemID
	local var2_1 = var0_1.count
	local var3_1 = var0_1.args

	pg.ConnectionMgr.GetInstance():Send(33301, {
		id = var1_1,
		count = var2_1,
		arg = var3_1
	}, 33302, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = {}
			local var1_2 = nowWorld()

			var1_2:GetInventoryProxy():RemoveItem(var1_1, var2_1)

			local var2_2 = WorldItem.New({
				id = var1_1,
				count = var2_1
			})

			switch(var2_2:getWorldItemType(), {
				[WorldItem.UsageBuff] = function()
					local var0_3 = var2_2:getItemBuffID()

					for iter0_3, iter1_3 in ipairs(var3_1) do
						var1_2:GetShip(iter1_3):AddBuff(var0_3, var2_2.count)
					end
				end,
				[WorldItem.UsageHPRegenerate] = function()
					local var0_4 = var2_2:getItemRegenerate() * var2_2.count

					for iter0_4, iter1_4 in ipairs(var3_1) do
						var1_2:GetShip(iter1_4):Regenerate(var0_4)
					end
				end,
				[WorldItem.UsageHPRegenerateValue] = function()
					local var0_5 = var2_2:getItemRegenerate() * var2_2.count

					for iter0_5, iter1_5 in ipairs(var3_1) do
						var1_2:GetShip(iter1_5):RegenerateValue(var0_5)
					end
				end,
				[WorldItem.UsageRecoverAp] = function()
					local var0_6 = var2_2:getItemStaminaRecover() * var2_2.count

					var1_2.staminaMgr:ExchangeStamina(var0_6)
					arg0_1:sendNotification(GAME.WORLD_STAMINA_EXCHANGE_DONE)
				end,
				[WorldItem.UsageWorldFlag] = function()
					switch(var2_2:getItemFlagKey(), {
						function()
							var1_2:SetGlobalFlag("treasure_flag", true)

							var0_2 = PlayerConst.addTranDrop(arg0_2.drop_list)
						end
					})
				end
			}, function()
				var0_2 = PlayerConst.addTranDrop(arg0_2.drop_list)
			end)
			arg0_1:sendNotification(GAME.WORLD_ITEM_USE_DONE, {
				drops = var0_2,
				item = var2_2
			})
		elseif PLATFORM_CODE == PLATFORM_CHT then
			pg.TipsMgr.GetInstance():ShowTips(i18n1("Operation Siren item usage failure:" .. arg0_2.result))
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n1("Operation Siren item usage failure:" .. arg0_2.result))
		end
	end)
end

return var0_0
