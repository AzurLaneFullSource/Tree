local var0_0 = class("IslandMapPage", import(".IslandBaseMapPage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.timers = {}
end

function var0_0.Flush(arg0_2)
	var0_0.super.Flush(arg0_2)

	for iter0_2, iter1_2 in pairs(arg0_2.maps) do
		if arg0_2:CheckUnlock(iter0_2) then
			arg0_2:CheckProductions(iter0_2)
			arg0_2:CheckAcceptableTask(iter0_2)
			arg0_2:CheckFinishableTask(iter0_2)
			setActive(iter1_2:Find("icon"), not isActive(iter1_2:Find("fetch")) and not isActive(iter1_2:Find("finish")) and not isActive(iter1_2:Find("fetch")))
		end
	end
end

function var0_0.OnHide(arg0_3)
	arg0_3:RemoveAllTimer()
end

function var0_0.CheckAcceptableTask(arg0_4, arg1_4)
	local function var0_4(arg0_5)
		local var0_5 = arg0_4.maps[arg1_4]

		SetActive(var0_5:Find("fetch"), arg0_5)
	end

	local var1_4 = getProxy(IslandProxy):GetIsland():GetTaskAgency():GetCanAcceptTasksByMapId(arg1_4)

	var0_4(#var1_4 > 0)
end

function var0_0.CheckFinishableTask(arg0_6, arg1_6)
	local function var0_6(arg0_7)
		local var0_7 = arg0_6.maps[arg1_6]

		SetActive(var0_7:Find("finish"), arg0_7)
	end

	local var1_6 = getProxy(IslandProxy):GetIsland():GetTaskAgency():GetCanSubmitTasksByMapId(arg1_6)

	var0_6(#var1_6 > 0)
end

function var0_0.CheckProductions(arg0_8, arg1_8)
	local function var0_8(arg0_9)
		local var0_9 = arg0_8.maps[arg1_8]

		SetActive(var0_9:Find("full"), arg0_9)
	end

	if arg0_8.timers[arg1_8] then
		arg0_8.timers[arg1_8]:Stop()

		arg0_8.timers[arg1_8] = nil
	end

	local var1_8 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetMinimumDelegationCompletionTimeByMapId(arg1_8)

	if var1_8 < 0 then
		var0_8(false)

		return
	end

	local var2_8 = var1_8 - pg.TimeMgr.GetInstance():GetServerTime()

	if var2_8 <= 0 then
		var0_8(true)

		return
	end

	arg0_8.timers[arg1_8] = Timer.New(function()
		var0_8(true)
	end, var2_8, 1)

	arg0_8.timers[arg1_8]:Start()
end

function var0_0.RemoveAllTimer(arg0_11)
	for iter0_11, iter1_11 in pairs(arg0_11.timers) do
		iter1_11:Stop()
	end

	arg0_11.timers = {}
end

function var0_0.GoDesc(arg0_12, arg1_12)
	arg0_12:OpenPage(IslandMapDescPage, arg1_12)
end

function var0_0.OnDestroy(arg0_13)
	arg0_13:RemoveAllTimer()
end

return var0_0
