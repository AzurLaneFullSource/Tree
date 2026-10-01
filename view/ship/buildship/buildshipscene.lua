local var0_0 = class("BuildShipScene", import("...base.BaseUI"))

var0_0.PAGE_BUILD = 1
var0_0.PAGE_QUEUE = 2
var0_0.PAGE_SUPPORT = 3
var0_0.PAGE_UNSEAM = 4
var0_0.PAGE_PRAY = 5
var0_0.PAGE_NEWSERVER = 6
var0_0.PROJECTS = {
	SPECIAL = "special",
	ACTIVITY = "new",
	HEAVY = "heavy",
	LIGHT = "light"
}

function var0_0.getResource(arg0_1)
	local var0_1 = {
		"ui/al_bg01"
	}

	return table.insertto(var0_1, var0_0.super.getResource(arg0_1))
end

function var0_0.getUIName(arg0_2)
	return "BuildShipUI"
end

function var0_0.ResUISettings(arg0_3)
	return true
end

function var0_0.setPools(arg0_4, arg1_4)
	arg0_4.pools = {}

	for iter0_4, iter1_4 in ipairs(arg1_4) do
		table.insert(arg0_4.pools, iter1_4)
	end
end

function var0_0.setPlayer(arg0_5, arg1_5)
	arg0_5.contextData.player = arg1_5
end

function var0_0.setUseItem(arg0_6, arg1_6)
	arg0_6.contextData.itemVO = arg1_6 or Item.New({
		count = 0,
		id = pg.ship_data_create_material[1].use_item
	})

	if arg0_6.poolsPage and arg0_6.poolsPage:GetLoaded() then
		arg0_6.poolsPage:UpdateItem(arg0_6.contextData.itemVO.count)
	end
end

function var0_0.setStartCount(arg0_7, arg1_7)
	arg0_7.contextData.startCount = arg1_7
end

function var0_0.setFlagShip(arg0_8, arg1_8)
	arg0_8.contextData.falgShip = arg1_8
end

function var0_0.RefreshActivityBuildPool(arg0_9, arg1_9)
	arg0_9.poolsPage:RefreshActivityBuildPool(arg1_9)
end

function var0_0.RefreshFreeBuildActivity(arg0_10)
	arg0_10.poolsPage:RefreshFreeBuildActivity()
	arg0_10.poolsPage:UpdateTicket()
end

function var0_0.RefreshRegularExchangeCount(arg0_11)
	arg0_11.poolsPage:RefreshRegularExchangeCount()
end

function var0_0.init(arg0_12)
	Input.multiTouchEnabled = false
	arg0_12.blurPanel = arg0_12._tf:Find("blur_panel")
	arg0_12.topPanel = arg0_12.blurPanel:Find("adapt/top")
	arg0_12.backBtn = arg0_12.topPanel:Find("back_btn")
	arg0_12.toggles = {
		arg0_12.blurPanel:Find("adapt/left_length/frame/tagRoot/build_btn"),
		arg0_12.blurPanel:Find("adapt/left_length/frame/tagRoot/queue_btn"),
		arg0_12.blurPanel:Find("adapt/left_length/frame/tagRoot/support_btn"),
		arg0_12.blurPanel:Find("adapt/left_length/frame/tagRoot/unseam_btn"),
		arg0_12.blurPanel:Find("adapt/left_length/frame/tagRoot/pray_btn"),
		arg0_12.blurPanel:Find("adapt/left_length/frame/tagRoot/other_build_btn")
	}
	arg0_12.tip = arg0_12.toggles[2]:Find("tip")
	arg0_12.contextData.msgbox = BuildShipMsgBox.New(arg0_12._tf, arg0_12.event)
	arg0_12.contextData.helpWindow = BuildShipHelpWindow.New(arg0_12._tf, arg0_12.event)
	arg0_12.poolsPage = BuildShipPoolsPage.New(arg0_12._tf, arg0_12.event, arg0_12.contextData)
	arg0_12.supportShipPoolPage = SupportShipPoolPage.New(arg0_12._tf, arg0_12.event, arg0_12.contextData)
end

function var0_0.didEnter(arg0_13)
	arg0_13:OverlayPanel(arg0_13.blurPanel)
	onButton(arg0_13, arg0_13.backBtn, function()
		arg0_13:emit(var0_0.ON_BACK)
	end, SFX_CANCEL)

	local var0_13 = arg0_13.blurPanel:Find("adapt/left_length/stamp")

	setActive(var0_13, getProxy(TaskProxy):mingshiTouchFlagEnabled())
	onButton(arg0_13, var0_13, function()
		getProxy(TaskProxy):dealMingshiTouchFlag(11)
	end, SFX_CONFIRM)

	for iter0_13, iter1_13 in ipairs(arg0_13.toggles) do
		onToggle(arg0_13, iter1_13, function(arg0_16)
			arg0_13:switchPage(iter0_13, arg0_16)
		end, SFX_PANEL)
	end

	local var1_13 = getProxy(ActivityProxy)
	local var2_13 = var1_13:getActivityById(ActivityConst.ACTIVITY_PRAY_POOL)

	if var2_13 and not var2_13:isEnd() then
		setActive(arg0_13.toggles[var0_0.PAGE_PRAY], true)
	else
		setActive(arg0_13.toggles[var0_0.PAGE_PRAY], false)
	end

	if underscore.any(arg0_13.pools, function(arg0_17)
		return checkExist(var1_13:getBuildPoolActivity(arg0_17), {
			"getConfig",
			{
				"type"
			}
		}) == ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD
	end) then
		setActive(arg0_13.toggles[var0_0.PAGE_NEWSERVER], true)
	else
		setActive(arg0_13.toggles[var0_0.PAGE_NEWSERVER], false)
	end

	local var3_13 = arg0_13.contextData.page or pg.SeriesGuideMgr.GetInstance():isRunning() and var0_0.PAGE_BUILD or var0_0.PAGE_NEWSERVER

	if not isActive(arg0_13.toggles[var3_13]) then
		var3_13 = var0_0.PAGE_BUILD
	end

	triggerToggle(arg0_13.toggles[var3_13], true)
	PoolMgr.GetInstance():GetUI("al_bg01", true, function(arg0_18)
		arg0_18:SetActive(true)
		setParent(arg0_18, arg0_13._tf)
		arg0_18.transform:SetAsFirstSibling()
	end)
	TagTipHelper.SetFreeBuildMark()

	arg0_13.bulinTip = AprilFoolBulinSubView.ShowAprilFoolBulin(arg0_13, arg0_13.blurPanel)
end

function var0_0.checkPage(arg0_19)
	if arg0_19.contextData.msgbox and arg0_19.contextData.msgbox:GetLoaded() and arg0_19.contextData.msgbox:isShowing() then
		arg0_19.contextData.msgbox:Hide()
	end

	if arg0_19.contextData.helpWindow and arg0_19.contextData.helpWindow:GetLoaded() and arg0_19.contextData.helpWindow:isShowing() then
		arg0_19.contextData.helpWindow:Hide()
	end

	local var0_19 = getProxy(ActivityProxy)

	if underscore.any(arg0_19.pools, function(arg0_20)
		return checkExist(var0_19:getBuildPoolActivity(arg0_20), {
			"getConfig",
			{
				"type"
			}
		}) == ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD
	end) then
		setActive(arg0_19.toggles[var0_0.PAGE_NEWSERVER], true)
	else
		setActive(arg0_19.toggles[var0_0.PAGE_NEWSERVER], false)
	end

	if not isActive(arg0_19.toggles[var0_0.PAGE_NEWSERVER]) and arg0_19.contextData.page == var0_0.PAGE_NEWSERVER then
		triggerToggle(arg0_19.toggles[var0_0.PAGE_BUILD], true)
	else
		arg0_19.poolsPage:Flush(arg0_19.pools)
	end
end

function var0_0.switchPage(arg0_21, arg1_21, arg2_21)
	if arg2_21 then
		arg0_21.contextData.page = arg1_21 == var0_0.PAGE_UNSEAM and var0_0.PAGE_BUILD or arg1_21
	end

	if arg1_21 == var0_0.PAGE_UNSEAM then
		if arg2_21 then
			arg0_21:emit(BuildShipMediator.OPEN_DESTROY)
		end
	elseif arg1_21 == var0_0.PAGE_QUEUE then
		if arg2_21 then
			arg0_21:emit(BuildShipMediator.OPEN_PROJECT_LIST)
		else
			arg0_21:emit(BuildShipMediator.REMOVE_PROJECT_LIST)
		end
	elseif arg1_21 == var0_0.PAGE_SUPPORT then
		arg0_21.supportShipPoolPage:ExecuteAction("ShowOrHide", arg2_21)

		if arg2_21 then
			arg0_21.supportShipPoolPage:ExecuteAction("Flush")
		end
	elseif arg1_21 == var0_0.PAGE_BUILD then
		arg0_21.poolsPage:ExecuteAction("ShowOrHide", arg2_21)

		if arg2_21 then
			arg0_21.poolsPage:ExecuteAction("Flush", arg0_21.pools, false)
		end
	elseif arg1_21 == var0_0.PAGE_NEWSERVER then
		arg0_21.poolsPage:ExecuteAction("ShowOrHide", arg2_21)

		if arg2_21 then
			arg0_21.poolsPage:ExecuteAction("Flush", arg0_21.pools, true)
		end
	elseif arg1_21 == var0_0.PAGE_PRAY then
		if arg2_21 then
			arg0_21:emit(BuildShipMediator.OPEN_PRAY_PAGE)
		else
			arg0_21:emit(BuildShipMediator.CLOSE_PRAY_PAGE)
		end
	end
end

function var0_0.updateQueueTip(arg0_22, arg1_22)
	setActive(arg0_22.tip, arg1_22 > 0)
end

function var0_0.onBackPressed(arg0_23)
	if arg0_23.contextData.helpWindow:GetLoaded() and arg0_23.contextData.helpWindow:isShowing() then
		arg0_23.contextData.helpWindow:Hide()

		return
	end

	if arg0_23.contextData.msgbox:GetLoaded() and arg0_23.contextData.msgbox:isShowing() then
		arg0_23.contextData.msgbox:Hide()

		return
	end

	arg0_23:emit(var0_0.ON_BACK_PRESSED)
end

function var0_0.willExit(arg0_24)
	Input.multiTouchEnabled = true

	arg0_24.contextData.msgbox:Destroy()
	arg0_24.contextData.helpWindow:Destroy()
	arg0_24.poolsPage:Destroy()
	arg0_24.supportShipPoolPage:Destroy()
	arg0_24:UnOverlayPanel(arg0_24.blurPanel, arg0_24._tf)
end

return var0_0
