local var0_0 = class("NewEducateGiveUpChoiceCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().id

	pg.ConnectionMgr.GetInstance():Send(29101, {
		id = var0_1
	}, 29102, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(NewEducateProxy):GetCurChar():GetFSM()

			var0_2:GetPriorityState():MarkFinish()
			var0_2:CheckPriorityStystem()

			local var1_2 = NewEducateDropHelper.HandleDrops(arg0_2.drop)

			arg0_1:sendNotification(GAME.NEW_EDUCATE_GIVE_UP_CHOICE_DONE, {
				drops = var1_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips("NewEducate_GiveUpChoice_Error: " .. arg0_2.result)
		end
	end)
end

return var0_0
