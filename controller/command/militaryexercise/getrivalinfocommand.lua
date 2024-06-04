local var0 = class("GetRivalInfoCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	pg.ConnectionMgr.GetInstance():Send(18104, {
		id = var0
	}, 18105, function(arg0)
		if arg0.info.id == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_get_player_info_erro"))
		else
			local var0 = Rival.New(arg0.info)

			arg0:sendNotification(GAME.GET_RIVAL_INFO_DONE, {
				rival = var0
			})
		end
	end)
end

return var0
