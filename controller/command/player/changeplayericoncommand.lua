local var0 = class("ChangePlayerIconCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.characterId
	local var2 = var0.characterId
	local var3 = var0.skinPage
	local var4 = var0.callback
	local var5 = getProxy(PlayerProxy)
	local var6 = var5:getData()

	if type(var1) == "number" then
		if var6.character == var1 then
			if var3 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("change_skin_secretary_ship"))
			end

			return
		else
			var2 = {}

			for iter0 = 1, #var6.characters do
				var2[iter0] = var6.characters[iter0]
			end

			for iter1 = 1, #var2 do
				if var2[iter1] == var1 then
					var2[1], var2[iter1] = var2[iter1], var2[1]
				end
			end

			var2[1] = var1
		end
	end

	if #var2 <= 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_error"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(11011, {
		character = var2
	}, 11012, function(arg0)
		if arg0.result == 0 then
			var0.UpdayePlayerCharas(var6, var2)
			var5:updatePlayer(var6)
			pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inAdmiral")

			if var3 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("change_skin_secretary_ship"))
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("player_changePlayerIcon_ok"))
			end

			arg0:sendNotification(GAME.CHANGE_PLAYER_ICON_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("player_changePlayerIcon", arg0.result))
		end

		if var4 then
			var4()
		end
	end)
end

function var0.UpdayePlayerCharas(arg0, arg1)
	local var0 = getProxy(BayProxy):getShipById(arg1[1])

	arg0.character = arg1[1]
	arg0.characters = arg1
	arg0.icon = var0.configId
	arg0.skinId = var0.skinId
end

return var0
