local var0_0 = class("ChangePlayerIconCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.skinPage
	local var2_1 = var0_1.after
	local var3_1 = var0_1.callback
	local var4_1 = getProxy(PlayerProxy)
	local var5_1 = var4_1:getData()
	local var6_1 = var5_1:GetShipPhantomMarks()

	if #var2_1 <= 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_error"))

		return
	end

	if #var6_1 == #var2_1 and underscore.all(underscore.keys(var2_1), function(arg0_2)
		return var6_1[arg0_2] == var2_1[arg0_2]
	end) then
		if var1_1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("change_skin_secretary_ship"))
		end

		existCall(var3_1)

		return
	end

	for iter0_1 = #var2_1, 1, -1 do
		for iter1_1 = iter0_1 - 1, 1, -1 do
			print(var2_1[iter0_1], var2_1[iter1_1])

			if var2_1[iter0_1] == var2_1[iter1_1] then
				table.remove(var2_1, iter0_1)

				break
			end
		end
	end

	local var7_1 = underscore.map(var2_1, function(arg0_3)
		local var0_3, var1_3 = ShipPhantom.UnpackMark(arg0_3)

		return {
			key = var0_3,
			value = var1_3
		}
	end)

	pg.ConnectionMgr.GetInstance():Send(11011, {
		character = var7_1
	}, 11012, function(arg0_4)
		if arg0_4.result == 0 then
			var0_0.UpdayePlayerCharas(var5_1, var7_1)
			var4_1:updatePlayer(var5_1)
			pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inAdmiral")

			if var1_1 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("change_skin_secretary_ship"))
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("player_changePlayerIcon_ok"))
			end

			arg0_1:sendNotification(GAME.CHANGE_PLAYER_ICON_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("player_changePlayerIcon", arg0_4.result))
		end

		existCall(var3_1)
	end)
end

function var0_0.UpdayePlayerCharas(arg0_5, arg1_5)
	arg0_5.characters = underscore.map(arg1_5, function(arg0_6)
		return arg0_6.key
	end)
	arg0_5.phantoms = underscore.map(arg1_5, function(arg0_7)
		return arg0_7.value
	end)
	arg0_5.character = arg0_5.characters[1]
	arg0_5.phantomId = arg0_5.phantoms[1] or 0

	local var0_5 = ShipPhantom.Change(getProxy(BayProxy):getShipById(arg0_5.character), arg0_5.phantoms[1])

	arg0_5.icon = var0_5.configId
	arg0_5.skinId = var0_5:getSkinId()
end

return var0_0
