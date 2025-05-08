local var0_0 = class("IslandMapPage", import("...base.IslandBasePage"))

var0_0.HIDE_DESC = "IslandMapPage:HIDE_DESC"

function var0_0.getUIName(arg0_1)
	return "IslandMapUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.maps = {
		[1001] = arg0_2:findTF("bg/1001"),
		[1002] = arg0_2:findTF("bg/1002"),
		[1003] = arg0_2:findTF("bg/1003"),
		[1004] = arg0_2:findTF("bg/1004"),
		[1005] = arg0_2:findTF("bg/1005")
	}

	setText(arg0_2:findTF("adapt/title/Text"), i18n1("岛屿地图"))
end

function var0_0.OnInit(arg0_3)
	for iter0_3, iter1_3 in pairs(arg0_3.maps) do
		onButton(arg0_3, iter1_3, function()
			if not arg0_3:CheckUnlock(iter0_3) then
				return
			end

			arg0_3:ShowDesc(iter0_3)
		end, SFX_PANEL)
	end

	onButton(arg0_3, arg0_3._tf:Find("bg"), function()
		if arg0_3.selectedId then
			arg0_3:HideSelected()
		end
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf:Find("adapt/back"), function()
		arg0_3:ClosePage(IslandMapPage)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf:Find("adapt/home"), function()
		arg0_3:emit(BaseUI.ON_HOME)
	end, SFX_PANEL)
	arg0_3:bind(var0_0.HIDE_DESC, function()
		arg0_3:HideSelected()
	end)

	arg0_3.timers = {}
end

function var0_0.OnShow(arg0_9)
	arg0_9:Flush()
end

function var0_0.Flush(arg0_10)
	for iter0_10, iter1_10 in pairs(arg0_10.maps) do
		setActive(iter1_10:Find("selcted"), false)

		local var0_10 = arg0_10:CheckUnlock(iter0_10)

		setActive(iter1_10:Find("lock"), not var0_10)

		if var0_10 then
			arg0_10:CheckProductions(iter0_10)
			arg0_10:CheckAcceptableTask(iter0_10)
			arg0_10:CheckFinishableTask(iter0_10)
		else
			setActive(iter1_10:Find("full"), false)
			setActive(iter1_10:Find("finish"), false)
			setActive(iter1_10:Find("fetch"), false)
		end
	end
end

function var0_0.OnHide(arg0_11)
	arg0_11:RemoveAllTimer()
end

function var0_0.CheckUnlock(arg0_12, arg1_12)
	return (getProxy(IslandProxy):GetIsland():GetAblityAgency():IsUnlockMap(arg1_12))
end

function var0_0.CheckAcceptableTask(arg0_13, arg1_13)
	local function var0_13(arg0_14)
		local var0_14 = arg0_13.maps[arg1_13]

		SetActive(var0_14:Find("fetch"), arg0_14)
	end

	local var1_13 = getProxy(IslandProxy):GetIsland():GetTaskAgency():GetCanAcceptTasksByMapId(arg1_13)

	var0_13(#var1_13 > 0)
end

function var0_0.CheckFinishableTask(arg0_15, arg1_15)
	local function var0_15(arg0_16)
		local var0_16 = arg0_15.maps[arg1_15]

		SetActive(var0_16:Find("finish"), arg0_16)
	end

	local var1_15 = getProxy(IslandProxy):GetIsland():GetTaskAgency():GetCanSubmitTasksByMapId(arg1_15)

	var0_15(#var1_15 > 0)
end

function var0_0.CheckProductions(arg0_17, arg1_17)
	local function var0_17(arg0_18)
		local var0_18 = arg0_17.maps[arg1_17]

		SetActive(var0_18:Find("full"), arg0_18)
	end

	if arg0_17.timers[arg1_17] then
		arg0_17.timers[arg1_17]:Stop()

		arg0_17.timers[arg1_17] = nil
	end

	local var1_17 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetMinimumDelegationCompletionTimeByMapId(arg1_17)

	if var1_17 < 0 then
		var0_17(false)

		return
	end

	local var2_17 = var1_17 - pg.TimeMgr.GetInstance():GetServerTime()

	if var2_17 <= 0 then
		var0_17(true)

		return
	end

	arg0_17.timers[arg1_17] = Timer.New(function()
		var0_17(true)
	end, var2_17, 1)

	arg0_17.timers[arg1_17]:Start()
end

function var0_0.RemoveAllTimer(arg0_20)
	for iter0_20, iter1_20 in pairs(arg0_20.timers) do
		iter1_20:Stop()
	end

	arg0_20.timers = {}
end

function var0_0.ShowDesc(arg0_21, arg1_21)
	if arg0_21.selectedId then
		arg0_21:HideSelected(arg0_21.selectedId)
	end

	local var0_21 = arg0_21.maps[arg1_21]

	setActive(var0_21:Find("selcted"), true)
	arg0_21:OpenPage(IslandMapDescPage, arg1_21)

	arg0_21.selectedId = arg1_21
end

function var0_0.HideSelected(arg0_22)
	local var0_22 = arg0_22.selectedId
	local var1_22 = arg0_22.maps[var0_22]

	setActive(var1_22:Find("selcted"), false)
	arg0_22:ClosePage(IslandMapDescPage)

	arg0_22.selectedId = nil
end

function var0_0.OnDestroy(arg0_23)
	arg0_23:RemoveAllTimer()
end

return var0_0
