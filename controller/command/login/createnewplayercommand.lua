local var0 = class("CreateNewPlayerCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.nickname
	local var2 = var0.shipId

	if var1 == "" then
		pg.TipsMgr.GetInstance():ShowTips(i18n("login_createNewPlayer_error_nameNull"))
	end

	pg.ConnectionMgr.GetInstance():Send(10024, {
		nick_name = var1,
		ship_id = var2,
		device_id = pg.SdkMgr.GetInstance():GetDeviceId()
	}, 10025, function(arg0)
		if arg0.result == 0 then
			print("created new player: " .. arg0.user_id)
			pg.TrackerMgr.GetInstance():Tracking(TRACKING_ROLE_CREATE, nil, arg0.user_id)
			getProxy(SettingsProxy):SetSelectedShipId(var2)
			arg0:sendNotification(GAME.CREATE_NEW_PLAYER_DONE, arg0.user_id)
			pg.TipsMgr.GetInstance():ShowTips(i18n("create_player_success"))
		elseif arg0.result == 6 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("login_createNewPlayer_full"))
		elseif arg0.result == 18 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("system_database_busy"))
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result])
		end
	end, false)
end

return var0
