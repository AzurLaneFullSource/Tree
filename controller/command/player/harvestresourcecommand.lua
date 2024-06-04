local var0 = class("HarvestResourceCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = id2res(var0)
	local var2 = getProxy(PlayerProxy)
	local var3 = var2:getData()
	local var4

	if var0 == 1 then
		var4 = var3:getLevelMaxGold()
	elseif var0 == 2 then
		var4 = var3:getLevelMaxOil()
	else
		assert(false)
	end

	if var4 <= var3[var1] then
		pg.TipsMgr.GetInstance():ShowTips(i18n("player_harvestResource_error_fullBag"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(11013, {
		number = 0,
		type = var0
	}, 11014, function(arg0)
		if arg0.result == 0 then
			local var0 = var4 - var3[var1]
			local var1 = 0

			if var0 < var3[var1 .. "Field"] then
				var1 = var0

				var3:addResources({
					[var1] = var0
				})

				var3[var1 .. "Field"] = var3[var1 .. "Field"] - var0
			else
				var1 = var3[var1 .. "Field"]

				var3:addResources({
					[var1] = var3[var1 .. "Field"]
				})

				var3[var1 .. "Field"] = 0
			end

			var2:updatePlayer(var3)
			arg0:sendNotification(GAME.HARVEST_RES_DONE, {
				type = var0,
				outPut = var1
			})
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_ACADEMY_GETMATERIAL)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("player_harvestResource", arg0.result))
		end
	end)
end

return var0
