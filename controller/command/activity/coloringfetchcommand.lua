local var0 = class("ColoringFetchCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().activityId

	pg.ConnectionMgr.GetInstance():Send(26008, {
		act_id = var0
	}, 26001, function(arg0)
		getProxy(ColoringProxy):netUpdateData(arg0)
		arg0:sendNotification(GAME.COLORING_FETCH_DONE)
	end)
end

return var0
