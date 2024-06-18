local var0_0 = class("", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().shipId

	if not var0_1 then
		return
	end

	local var1_1 = getProxy(BayProxy)
	local var2_1 = var1_1:getShipById(var0_1)

	if not var2_1 then
		return
	end

	local var3_1, var4_1 = var2_1:canUpgradeMaxLevel()

	if not var3_1 then
		pg.TipsMgr.GetInstance():ShowTips(var4_1)

		return
	end

	pg.ConnectionMgr.GetInstance():Send(12038, {
		ship_id = var0_1
	}, 12039, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = Clone(var2_1)
			local var1_2 = var2_1:getNextMaxLevelConsume()
			local var2_2 = var2_1:getNextMaxLevel()

			var2_1:updateMaxLevel(var2_2)
			_.each(var1_2, function(arg0_3)
				arg0_1:sendNotification(GAME.CONSUME_ITEM, arg0_3)
			end)
			var2_1:addExp(0, true)
			arg0_1:sendNotification(GAME.UPGRADE_MAX_LEVEL_DONE, {
				oldShip = var0_2,
				newShip = var2_1,
				callback = function()
					var1_1:updateShip(var2_1)
				end
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_buildShip_error", arg0_2.result))
		end
	end)
end

return var0_0
