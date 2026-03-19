local var0_0 = class("NewEducateEnterAssessCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1 and var0_1.callback
	local var2_1 = var0_1.id

	pg.ConnectionMgr.GetInstance():Send(29050, {
		id = var2_1
	}, 29051, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(NewEducateProxy):GetCurChar():GetFSM()

			var0_2:SetCurNode(0)
			var0_2:SetSystemNo(NewEducateFSM.SYSTEM.ASSESS)

			local var1_2 = getProxy(NewEducateProxy):GetCurChar():GetAssessRankIdx()
			local var2_2 = NewEducateAssessState.New({
				is_finished = var1_2 == 0 and 1 or 0
			})

			var0_2:SetState(NewEducateFSM.SYSTEM.ASSESS, var2_2)

			local var3_2 = NewEducateDropHelper.HandleDrops(arg0_2.drop)

			arg0_1:sendNotification(GAME.NEW_EDUCATE_ENTER_ASSESS_DONE, {
				drops = var3_2,
				callback = var1_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips("NewEducate_EnterAssess: " .. arg0_2.result)
		end
	end)
end

return var0_0
