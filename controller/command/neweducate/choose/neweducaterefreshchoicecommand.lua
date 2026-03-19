local var0_0 = class("NewEducateRefreshChoiceCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.idx
	local var3_1 = getProxy(NewEducateProxy):GetCurChar()

	if var3_1:GetResByType(NewEducateChar.RES_TYPE.REFRESH_CHOICE) <= 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(29105, {
		id = var1_1,
		index = var2_1
	}, 29106, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(NewEducateProxy):GetCurChar():GetFSM():GetPriorityState()

			var0_2:UpdataData(arg0_2.cache)
			getProxy(NewEducateProxy):Cost({
				number = 1,
				type = NewEducateConst.DROP_TYPE.RES,
				id = var3_1:GetResIdByType(NewEducateChar.RES_TYPE.REFRESH_CHOICE)
			})
			arg0_1:sendNotification(GAME.NEW_EDUCATE_REFRESH_CHOICE_DONE, {
				idx = var2_1,
				newId = var0_2:GetChoices()[var2_1]
			})
		else
			pg.TipsMgr.GetInstance():ShowTips("NewEducate_RefreshChoice_Error: " .. arg0_2.result)
		end
	end)
end

return var0_0
