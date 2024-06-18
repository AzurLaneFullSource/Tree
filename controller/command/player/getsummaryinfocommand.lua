local var0_0 = class("GetSummaryInfoCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().activityId

	pg.ConnectionMgr.GetInstance():Send(26021, {
		act_id = var0_1
	}, 26022, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = Summary.New(arg0_2)

			getProxy(PlayerProxy):setSummaryInfo(var0_2)
			arg0_1:sendNotification(GAME.GET_PLAYER_SUMMARY_INFO_DONE, Clone(var0_2))
		end
	end)
end

return var0_0
