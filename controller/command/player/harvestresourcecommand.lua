local var0_0 = class("HarvestResourceCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = id2res(var0_1)
	local var2_1 = getProxy(PlayerProxy)
	local var3_1 = var2_1:getData()
	local var4_1

	if var0_1 == 1 then
		var4_1 = var3_1:getLevelMaxGold()
	elseif var0_1 == 2 then
		var4_1 = var3_1:getLevelMaxOil()
	else
		assert(false)
	end

	if var4_1 <= var3_1[var1_1] then
		pg.TipsMgr.GetInstance():ShowTips(i18n("player_harvestResource_error_fullBag"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(11013, {
		number = 0,
		type = var0_1
	}, 11014, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = var4_1 - var3_1[var1_1]
			local var1_2 = 0

			if var0_2 < var3_1[var1_1 .. "Field"] then
				var1_2 = var0_2

				var3_1:addResources({
					[var1_1] = var0_2
				})

				var3_1[var1_1 .. "Field"] = var3_1[var1_1 .. "Field"] - var0_2
			else
				var1_2 = var3_1[var1_1 .. "Field"]

				var3_1:addResources({
					[var1_1] = var3_1[var1_1 .. "Field"]
				})

				var3_1[var1_1 .. "Field"] = 0
			end

			var2_1:updatePlayer(var3_1)
			arg0_1:sendNotification(GAME.HARVEST_RES_DONE, {
				type = var0_1,
				outPut = var1_2
			})
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_ACADEMY_GETMATERIAL)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("player_harvestResource", arg0_2.result))
		end
	end)
end

return var0_0
