local var0 = class("", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().shipId

	if not var0 then
		return
	end

	local var1 = getProxy(BayProxy)
	local var2 = var1:getShipById(var0)

	if not var2 then
		return
	end

	local var3, var4 = var2:canUpgradeMaxLevel()

	if not var3 then
		pg.TipsMgr.GetInstance():ShowTips(var4)

		return
	end

	pg.ConnectionMgr.GetInstance():Send(12038, {
		ship_id = var0
	}, 12039, function(arg0)
		if arg0.result == 0 then
			local var0 = Clone(var2)
			local var1 = var2:getNextMaxLevelConsume()
			local var2 = var2:getNextMaxLevel()

			var2:updateMaxLevel(var2)
			_.each(var1, function(arg0)
				arg0:sendNotification(GAME.CONSUME_ITEM, arg0)
			end)
			var2:addExp(0, true)
			arg0:sendNotification(GAME.UPGRADE_MAX_LEVEL_DONE, {
				oldShip = var0,
				newShip = var2,
				callback = function()
					var1:updateShip(var2)
				end
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_buildShip_error", arg0.result))
		end
	end)
end

return var0
