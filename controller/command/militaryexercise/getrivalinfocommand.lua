local var0_0 = class("GetRivalInfoCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(18104, {
		id = var0_1
	}, 18105, function(arg0_2)
		if arg0_2.info.id == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_get_player_info_erro"))
		else
			local var0_2 = Rival.New(arg0_2.info)

			arg0_1:sendNotification(GAME.GET_RIVAL_INFO_DONE, {
				rival = var0_2
			})
		end
	end)
end

return var0_0
