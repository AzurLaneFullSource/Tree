local var0_0 = class("TacticRoomBuilding", import(".NavalAcademyBuilding"))

function var0_0.GetGameObjectName(arg0_1)
	return "tacticRoom"
end

function var0_0.GetTitle(arg0_2)
	return i18n("school_title_xueyuan")
end

function var0_0.OnClick(arg0_3)
	arg0_3:emit(NavalAcademyMediator.ON_OPEN_TACTICROOM)
end

function var0_0.IsTip(arg0_4)
	local var0_4 = getProxy(NavalAcademyProxy):getStudents()

	if #var0_4 <= 0 then
		return false
	end

	local var1_4 = pg.TimeMgr.GetInstance():GetServerTime()
	local var2_4

	for iter0_4, iter1_4 in pairs(var0_4) do
		local var3_4 = iter1_4:getFinishTime() - var1_4

		if not var2_4 or var3_4 < var2_4 then
			var2_4 = var3_4
		end

		if var3_4 <= 0 then
			return true
		end
	end

	arg0_4:RemoveTimer()

	if var2_4 and var2_4 > 0 then
		arg0_4:AddTimer(var2_4)
	end

	return false
end

function var0_0.AddTimer(arg0_5, arg1_5)
	arg0_5.timer = Timer.New(function()
		arg0_5:RefreshTip()
	end, arg1_5, 1)

	arg0_5.timer:Start()
end

function var0_0.RemoveTimer(arg0_7)
	if arg0_7.timer then
		arg0_7.timer:Stop()

		arg0_7.timer = nil
	end
end

function var0_0.Dispose(arg0_8)
	var0_0.super.Dispose(arg0_8)
	arg0_8:RemoveTimer()
end

return var0_0
