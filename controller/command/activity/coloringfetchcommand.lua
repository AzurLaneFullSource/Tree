local var0_0 = class("ColoringFetchCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().activityId

	pg.ConnectionMgr.GetInstance():Send(26008, {
		act_id = var0_1
	}, 26001, function(arg0_2)
		getProxy(ColoringProxy):netUpdateData(arg0_2)
		arg0_1:sendNotification(GAME.COLORING_FETCH_DONE)
	end)
end

return var0_0
