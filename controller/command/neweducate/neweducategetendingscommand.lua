local var0_0 = class("NewEducateGetEndingsCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1 and var0_1.callback
	local var2_1 = var0_1.id

	pg.ConnectionMgr.GetInstance():Send(29003, {
		id = var2_1
	}, 29004, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(NewEducateProxy)

			var0_2:AddActivatedEndings(arg0_2.endings)

			local var1_2 = var0_2:GetCurChar():GetFSM()

			var1_2:SetStystemNo(NewEducateFSM.STYSTEM.ENDING)

			local var2_2 = NewEducateEndingState.New({
				select = 0,
				ends = arg0_2.endings
			})

			var1_2:SetState(NewEducateFSM.STYSTEM.ENDING, var2_2)
			existCall(var1_1)
			NewEducateHelper.TrackRoundEnd()
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("NewEducate_GetEndings", arg0_2.result))
		end
	end)
end

return var0_0
