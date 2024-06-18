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

function var0_0.getUIName(arg0_1)
	return "BuildShipUI"
end

function var0_0.ResUISettings(arg0_2)
	return true
end

function var0_0.setPools(arg0_3, arg1_3)
	arg0_3.pools = {}

	for iter0_3, iter1_3 in ipairs(arg1_3) do
		table.insert(arg0_3.pools, iter1_3)
	end
end

function var0_0.setPlayer(arg0_4, arg1_4)
	arg0_4.contextData.player = arg1_4
end

function var0_0.setUseItem(arg0_5, arg1_5)
	arg0_5.contextData.itemVO = arg1_5 or Item.New({
		count = 0,
		id = pg.ship_data_create_material[1].use_item
	})

	if arg0_5.poolsPage and arg0_5.poolsPage:GetLoaded() then
		arg0_5.poolsPage:UpdateItem(arg0_5.contextData.itemVO.count)
	end
end

function var0_0.setStartCount(arg0_6, arg1_6)
	arg0_6.contextData.startCount = arg1_6
end

function var0_0.setFlagShip(arg0_7, arg1_7)
	arg0_7.contextData.falgShip = arg1_7
end

function var0_0.RefreshActivityBuildPool(arg0_8, arg1_8)
	arg0_8.poolsPage:RefreshActivityBuildPool(arg1_8)
end

function var0_0.RefreshFreeBuildActivity(arg0_9)
	arg0_9.poolsPage:RefreshFreeBuildActivity()
	arg0_9.poolsPage:UpdateTicket()
end

function var0_0.RefreshRegularExchangeCount(arg0_10)
	arg0_10.poolsPage:RefreshRegularExchangeCount()
end

function var0_0.init(arg0_11)
	Input.multiTouchEnabled = false
	arg0_11.blurPanel = arg0_11:findTF("blur_panel")
	arg0_11.topPanel = arg0_11:findTF("adapt/top", arg0_11.blurPanel)
	arg0_11.backBtn = arg0_11:findTF("back_btn", arg0_11.topPanel)
	arg0_11.toggles = {
		arg0_11:findTF("adapt/left_length/frame/tagRoot/build_btn", arg0_11.blurPanel),
		arg0_11:findTF("adapt/left_length/frame/tagRoot/queue_btn", arg0_11.blurPanel),
		arg0_11:findTF("adapt/left_length/frame/tagRoot/support_btn", arg0_11.blurPanel),
		arg0_11:findTF("adapt/left_length/frame/tagRoot/unseam_btn", arg0_11.blurPanel),
		arg0_11:findTF("adapt/left_length/frame/tagRoot/pray_btn", arg0_11.blurPanel),
		arg0_11:findTF("adapt/left_length/frame/tagRoot/other_build_btn", arg0_11.blurPanel)
	}
	arg0_11.tip = arg0_11.toggles[2]:Find("tip")
	arg0_11.contextData.msgbox = BuildShipMsgBox.New(arg0_11._tf, arg0_11.event)
	arg0_11.contextData.helpWindow = BuildShipHelpWindow.New(arg0_11._tf, arg0_11.event)
	arg0_11.poolsPage = BuildShipPoolsPage.New(arg0_11._tf, arg0_11.event, arg0_11.contextData)
	arg0_11.supportShipPoolPage = SupportShipPoolPage.New(arg0_11._tf, arg0_11.event, arg0_11.contextData)
end

function var0_0.didEnter(arg0_12)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_12.blurPanel, {
		groupName = LayerWeightConst.GROUP_BUILDSHIPSCENE
	})
	onButton(arg0_12, arg0_12.backBtn, function()
		arg0_12:emit(var0_0.ON_BACK)
	end, SFX_CANCEL)

	local var0_12 = arg0_12:findTF("adapt/left_length/stamp", arg0_12.blurPanel)

	setActive(var0_12, getProxy(TaskProxy):mingshiTouchFlagEnabled())
	onButton(arg0_12, var0_12, function()
		getProxy(TaskProxy):dealMingshiTouchFlag(11)
	end, SFX_CONFIRM)

	for iter0_12, iter1_12 in ipairs(arg0_12.toggles) do
		onToggle(arg0_12, iter1_12, function(arg0_15)
			arg0_12:switchPage(iter0_12, arg0_15)
		end, SFX_PANEL)
	end

	local var1_12 = getProxy(ActivityProxy)
	local var2_12 = var1_12:getActivityById(ActivityConst.ACTIVITY_PRAY_POOL)

	if var2_12 and not var2_12:isEnd() then
		setActive(arg0_12.toggles[var0_0.PAGE_PRAY], true)
	else
		setActive(arg0_12.toggles[var0_0.PAGE_PRAY], false)
	end

	if underscore.any(arg0_12.pools, function(arg0_16)
		return checkExist(var1_12:getBuildPoolActivity(arg0_16), {
			"getConfig",
			{
				"type"
			}
		}) == ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD
	end) then
		setActive(arg0_12.toggles[var0_0.PAGE_NEWSERVER], true)
	else
		setActive(arg0_12.toggles[var0_0.PAGE_NEWSERVER], false)
	end

	local var3_12 = arg0_12.contextData.page or pg.SeriesGuideMgr.GetInstance():isRunning() and var0_0.PAGE_BUILD or var0_0.PAGE_NEWSERVER

	if not isActive(arg0_12.toggles[var3_12]) then
		var3_12 = var0_0.PAGE_BUILD
	end

	triggerToggle(arg0_12.toggles[var3_12], true)
	PoolMgr.GetInstance():GetUI("al_bg01", true, function(arg0_17)
		arg0_17:SetActive(true)
		setParent(arg0_17, arg0_12._tf)
		arg0_17.transform:SetAsFirstSibling()
	end)
	TagTipHelper.SetFreeBuildMark()

	arg0_12.bulinTip = AprilFoolBulinSubView.ShowAprilFoolBulin(arg0_12, arg0_12.blurPanel)
end

function var0_0.checkPage(arg0_18)
	if arg0_18.contextData.msgbox and arg0_18.contextData.msgbox:GetLoaded() and arg0_18.contextData.msgbox:isShowing() then
		arg0_18.contextData.msgbox:Hide()
	end

	if arg0_18.contextData.helpWindow and arg0_18.contextData.helpWindow:GetLoaded() and arg0_18.contextData.helpWindow:isShowing() then
		arg0_18.contextData.helpWindow:Hide()
	end

	local var0_18 = getProxy(ActivityProxy)

	if underscore.any(arg0_18.pools, function(arg0_19)
		return checkExist(var0_18:getBuildPoolActivity(arg0_19), {
			"getConfig",
			{
				"type"
			}
		}) == ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD
	end) then
		setActive(arg0_18.toggles[var0_0.PAGE_NEWSERVER], true)
	else
		setActive(arg0_18.toggles[var0_0.PAGE_NEWSERVER], false)
	end

	if not isActive(arg0_18.toggles[var0_0.PAGE_NEWSERVER]) and arg0_18.contextData.page == var0_0.PAGE_NEWSERVER then
		triggerToggle(arg0_18.toggles[var0_0.PAGE_BUILD], true)
	else
		arg0_18.poolsPage:Flush(arg0_18.pools)
	end
end

function var0_0.switchPage(arg0_20, arg1_20, arg2_20)
	if arg2_20 then
		arg0_20.contextData.page = arg1_20 == var0_0.PAGE_UNSEAM and var0_0.PAGE_BUILD or arg1_20
	end

	if arg1_20 == var0_0.PAGE_UNSEAM then
		if arg2_20 then
			arg0_20:emit(BuildShipMediator.OPEN_DESTROY)
		end
	elseif arg1_20 == var0_0.PAGE_QUEUE then
		if arg2_20 then
			arg0_20:emit(BuildShipMediator.OPEN_PROJECT_LIST)
		else
			arg0_20:emit(BuildShipMediator.REMOVE_PROJECT_LIST)
		end
	elseif arg1_20 == var0_0.PAGE_SUPPORT then
		arg0_20.supportShipPoolPage:ExecuteAction("ShowOrHide", arg2_20)

		if arg2_20 then
			arg0_20.supportShipPoolPage:ExecuteAction("Flush")
		end
	elseif arg1_20 == var0_0.PAGE_BUILD then
		arg0_20.poolsPage:ExecuteAction("ShowOrHide", arg2_20)

		if arg2_20 then
			arg0_20.poolsPage:ExecuteAction("Flush", arg0_20.pools, false)
		end
	elseif arg1_20 == var0_0.PAGE_NEWSERVER then
		arg0_20.poolsPage:ExecuteAction("ShowOrHide", arg2_20)

		if arg2_20 then
			arg0_20.poolsPage:ExecuteAction("Flush", arg0_20.pools, true)
		end
	elseif arg1_20 == var0_0.PAGE_PRAY then
		if arg2_20 then
			arg0_20:emit(BuildShipMediator.OPEN_PRAY_PAGE)
		else
			arg0_20:emit(BuildShipMediator.CLOSE_PRAY_PAGE)
		end
	end
end

function var0_0.updateQueueTip(arg0_21, arg1_21)
	setActive(arg0_21.tip, arg1_21 > 0)
end

function var0_0.onBackPressed(arg0_22)
	if arg0_22.contextData.helpWindow:GetLoaded() and arg0_22.contextData.helpWindow:isShowing() then
		arg0_22.contextData.helpWindow:Hide()

		return
	end

	if arg0_22.contextData.msgbox:GetLoaded() and arg0_22.contextData.msgbox:isShowing() then
		arg0_22.contextData.msgbox:Hide()

		return
	end

	arg0_22:emit(var0_0.ON_BACK_PRESSED)
end

function var0_0.willExit(arg0_23)
	Input.multiTouchEnabled = true

	arg0_23.contextData.msgbox:Destroy()
	arg0_23.contextData.helpWindow:Destroy()
	arg0_23.poolsPage:Destroy()
	arg0_23.supportShipPoolPage:Destroy()
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_23.blurPanel, arg0_23._tf)
end

return var0_0
