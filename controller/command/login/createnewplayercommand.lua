local var0_0 = class("CreateNewPlayerCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.nickname
	local var2_1 = var0_1.shipId

	if var1_1 == "" then
		pg.TipsMgr.GetInstance():ShowTips(i18n("login_createNewPlayer_error_nameNull"))
	end

	pg.ConnectionMgr.GetInstance():Send(10024, {
		nick_name = var1_1,
		ship_id = var2_1,
		device_id = pg.SdkMgr.GetInstance():GetDeviceId()
	}, 10025, function(arg0_2)
		if arg0_2.result == 0 then
			print("created new player: " .. arg0_2.user_id)
			pg.TrackerMgr.GetInstance():Tracking(TRACKING_ROLE_CREATE, nil, arg0_2.user_id)
			getProxy(SettingsProxy):SetSelectedShipId(var2_1)
			arg0_1:sendNotification(GAME.CREATE_NEW_PLAYER_DONE, arg0_2.user_id)
			pg.TipsMgr.GetInstance():ShowTips(i18n("create_player_success"))
		elseif arg0_2.result == 6 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("login_createNewPlayer_full"))
		elseif arg0_2.result == 18 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("system_database_busy"))
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result])
		end
	end, false)
end

return var0_0
