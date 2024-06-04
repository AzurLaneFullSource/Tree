local var0 = class("TacticRoomBuilding", import(".NavalAcademyBuilding"))

function var0.GetGameObjectName(arg0)
	return "tacticRoom"
end

function var0.GetTitle(arg0)
	return i18n("school_title_xueyuan")
end

function var0.OnClick(arg0)
	arg0:emit(NavalAcademyMediator.ON_OPEN_TACTICROOM)
end

function var0.IsTip(arg0)
	local var0 = getProxy(NavalAcademyProxy):getStudents()

	if #var0 <= 0 then
		return false
	end

	local var1 = pg.TimeMgr.GetInstance():GetServerTime()
	local var2

	for iter0, iter1 in pairs(var0) do
		local var3 = iter1:getFinishTime() - var1

		if not var2 or var3 < var2 then
			var2 = var3
		end

		if var3 <= 0 then
			return true
		end
	end

	arg0:RemoveTimer()

	if var2 and var2 > 0 then
		arg0:AddTimer(var2)
	end

	return false
end

function var0.AddTimer(arg0, arg1)
	arg0.timer = Timer.New(function()
		arg0:RefreshTip()
	end, arg1, 1)

	arg0.timer:Start()
end

function var0.RemoveTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.Dispose(arg0)
	var0.super.Dispose(arg0)
	arg0:RemoveTimer()
end

return var0
