local var0 = class("GetSummaryInfoCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().activityId

	pg.ConnectionMgr.GetInstance():Send(26021, {
		act_id = var0
	}, 26022, function(arg0)
		if arg0.result == 0 then
			local var0 = Summary.New(arg0)

			getProxy(PlayerProxy):setSummaryInfo(var0)
			arg0:sendNotification(GAME.GET_PLAYER_SUMMARY_INFO_DONE, Clone(var0))
		end
	end)
end

return var0
