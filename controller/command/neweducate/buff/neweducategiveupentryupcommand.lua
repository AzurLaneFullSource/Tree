local var0_0 = class("NewEducateGiveUpEntryUpCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().id

	pg.ConnectionMgr.GetInstance():Send(29124, {
		id = var0_1
	}, 29125, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(NewEducateProxy):GetCurChar():GetFSM()

			var0_2:GetPriorityState():MarkFinish()
			var0_2:CheckPriorityStystem()
			arg0_1:sendNotification(GAME.NEW_EDUCATE_GIVE_UP_ENTRY_UP_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips("NewEducate_GiveUpEntry_Error: " .. arg0_2.result)
		end
	end)
end

return var0_0
