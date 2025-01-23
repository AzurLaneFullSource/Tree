local var0_0 = class("NewEducateScheduleSkipCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().id

	pg.ConnectionMgr.GetInstance():Send(29046, {
		id = var0_1
	}, 29047, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(NewEducateProxy):GetCurChar():GetFSM():GetState(NewEducateFSM.STYSTEM.PLAN):MarkFinish()

			local var0_2 = NewEducateHelper.MergeDrops(arg0_2.drop)

			NewEducateHelper.UpdateDropsData(var0_2)
			arg0_1:sendNotification(GAME.NEW_EDUCATE_GET_EXTRA_DROP, {
				id = var0_1,
				scheduleDrops = NewEducateHelper.FilterBenefit(var0_2)
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("NewEducate_Schedule_Skip: ", arg0_2.result))
		end
	end)
end

return var0_0
