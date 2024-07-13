local var0_0 = class("ChangePlayerIconCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.characterId
	local var2_1 = var0_1.characterId
	local var3_1 = var0_1.skinPage
	local var4_1 = var0_1.callback
	local var5_1 = getProxy(PlayerProxy)
	local var6_1 = var5_1:getData()

	if type(var1_1) == "number" then
		if var6_1.character == var1_1 then
			if var3_1 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("change_skin_secretary_ship"))
			end

			return
		else
			var2_1 = {}

			for iter0_1 = 1, #var6_1.characters do
				var2_1[iter0_1] = var6_1.characters[iter0_1]
			end

			for iter1_1 = 1, #var2_1 do
				if var2_1[iter1_1] == var1_1 then
					var2_1[1], var2_1[iter1_1] = var2_1[iter1_1], var2_1[1]
				end
			end

			var2_1[1] = var1_1
		end
	end

	if #var2_1 <= 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_error"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(11011, {
		character = var2_1
	}, 11012, function(arg0_2)
		if arg0_2.result == 0 then
			var0_0.UpdayePlayerCharas(var6_1, var2_1)
			var5_1:updatePlayer(var6_1)
			pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inAdmiral")

			if var3_1 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("change_skin_secretary_ship"))
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("player_changePlayerIcon_ok"))
			end

			arg0_1:sendNotification(GAME.CHANGE_PLAYER_ICON_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("player_changePlayerIcon", arg0_2.result))
		end

		if var4_1 then
			var4_1()
		end
	end)
end

function var0_0.UpdayePlayerCharas(arg0_3, arg1_3)
	local var0_3 = getProxy(BayProxy):getShipById(arg1_3[1])

	arg0_3.character = arg1_3[1]
	arg0_3.characters = arg1_3
	arg0_3.icon = var0_3.configId
	arg0_3.skinId = var0_3.skinId
end

return var0_0
