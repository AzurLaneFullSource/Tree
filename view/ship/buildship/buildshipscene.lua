local var0 = class("BuildShipScene", import("...base.BaseUI"))

var0.PAGE_BUILD = 1
var0.PAGE_QUEUE = 2
var0.PAGE_SUPPORT = 3
var0.PAGE_UNSEAM = 4
var0.PAGE_PRAY = 5
var0.PAGE_NEWSERVER = 6
var0.PROJECTS = {
	SPECIAL = "special",
	ACTIVITY = "new",
	HEAVY = "heavy",
	LIGHT = "light"
}

function var0.getUIName(arg0)
	return "BuildShipUI"
end

function var0.ResUISettings(arg0)
	return true
end

function var0.setPools(arg0, arg1)
	arg0.pools = {}

	for iter0, iter1 in ipairs(arg1) do
		table.insert(arg0.pools, iter1)
	end
end

function var0.setPlayer(arg0, arg1)
	arg0.contextData.player = arg1
end

function var0.setUseItem(arg0, arg1)
	arg0.contextData.itemVO = arg1 or Item.New({
		count = 0,
		id = pg.ship_data_create_material[1].use_item
	})

	if arg0.poolsPage and arg0.poolsPage:GetLoaded() then
		arg0.poolsPage:UpdateItem(arg0.contextData.itemVO.count)
	end
end

function var0.setStartCount(arg0, arg1)
	arg0.contextData.startCount = arg1
end

function var0.setFlagShip(arg0, arg1)
	arg0.contextData.falgShip = arg1
end

function var0.RefreshActivityBuildPool(arg0, arg1)
	arg0.poolsPage:RefreshActivityBuildPool(arg1)
end

function var0.RefreshFreeBuildActivity(arg0)
	arg0.poolsPage:RefreshFreeBuildActivity()
	arg0.poolsPage:UpdateTicket()
end

function var0.RefreshRegularExchangeCount(arg0)
	arg0.poolsPage:RefreshRegularExchangeCount()
end

function var0.init(arg0)
	Input.multiTouchEnabled = false
	arg0.blurPanel = arg0:findTF("blur_panel")
	arg0.topPanel = arg0:findTF("adapt/top", arg0.blurPanel)
	arg0.backBtn = arg0:findTF("back_btn", arg0.topPanel)
	arg0.toggles = {
		arg0:findTF("adapt/left_length/frame/tagRoot/build_btn", arg0.blurPanel),
		arg0:findTF("adapt/left_length/frame/tagRoot/queue_btn", arg0.blurPanel),
		arg0:findTF("adapt/left_length/frame/tagRoot/support_btn", arg0.blurPanel),
		arg0:findTF("adapt/left_length/frame/tagRoot/unseam_btn", arg0.blurPanel),
		arg0:findTF("adapt/left_length/frame/tagRoot/pray_btn", arg0.blurPanel),
		arg0:findTF("adapt/left_length/frame/tagRoot/other_build_btn", arg0.blurPanel)
	}
	arg0.tip = arg0.toggles[2]:Find("tip")
	arg0.contextData.msgbox = BuildShipMsgBox.New(arg0._tf, arg0.event)
	arg0.contextData.helpWindow = BuildShipHelpWindow.New(arg0._tf, arg0.event)
	arg0.poolsPage = BuildShipPoolsPage.New(arg0._tf, arg0.event, arg0.contextData)
	arg0.supportShipPoolPage = SupportShipPoolPage.New(arg0._tf, arg0.event, arg0.contextData)
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():OverlayPanel(arg0.blurPanel, {
		groupName = LayerWeightConst.GROUP_BUILDSHIPSCENE
	})
	onButton(arg0, arg0.backBtn, function()
		arg0:emit(var0.ON_BACK)
	end, SFX_CANCEL)

	local var0 = arg0:findTF("adapt/left_length/stamp", arg0.blurPanel)

	setActive(var0, getProxy(TaskProxy):mingshiTouchFlagEnabled())
	onButton(arg0, var0, function()
		getProxy(TaskProxy):dealMingshiTouchFlag(11)
	end, SFX_CONFIRM)

	for iter0, iter1 in ipairs(arg0.toggles) do
		onToggle(arg0, iter1, function(arg0)
			arg0:switchPage(iter0, arg0)
		end, SFX_PANEL)
	end

	local var1 = getProxy(ActivityProxy)
	local var2 = var1:getActivityById(ActivityConst.ACTIVITY_PRAY_POOL)

	if var2 and not var2:isEnd() then
		setActive(arg0.toggles[var0.PAGE_PRAY], true)
	else
		setActive(arg0.toggles[var0.PAGE_PRAY], false)
	end

	if underscore.any(arg0.pools, function(arg0)
		return checkExist(var1:getBuildPoolActivity(arg0), {
			"getConfig",
			{
				"type"
			}
		}) == ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD
	end) then
		setActive(arg0.toggles[var0.PAGE_NEWSERVER], true)
	else
		setActive(arg0.toggles[var0.PAGE_NEWSERVER], false)
	end

	local var3 = arg0.contextData.page or pg.SeriesGuideMgr.GetInstance():isRunning() and var0.PAGE_BUILD or var0.PAGE_NEWSERVER

	if not isActive(arg0.toggles[var3]) then
		var3 = var0.PAGE_BUILD
	end

	triggerToggle(arg0.toggles[var3], true)
	PoolMgr.GetInstance():GetUI("al_bg01", true, function(arg0)
		arg0:SetActive(true)
		setParent(arg0, arg0._tf)
		arg0.transform:SetAsFirstSibling()
	end)
	TagTipHelper.SetFreeBuildMark()

	arg0.bulinTip = AprilFoolBulinSubView.ShowAprilFoolBulin(arg0, arg0.blurPanel)
end

function var0.checkPage(arg0)
	if arg0.contextData.msgbox and arg0.contextData.msgbox:GetLoaded() and arg0.contextData.msgbox:isShowing() then
		arg0.contextData.msgbox:Hide()
	end

	if arg0.contextData.helpWindow and arg0.contextData.helpWindow:GetLoaded() and arg0.contextData.helpWindow:isShowing() then
		arg0.contextData.helpWindow:Hide()
	end

	local var0 = getProxy(ActivityProxy)

	if underscore.any(arg0.pools, function(arg0)
		return checkExist(var0:getBuildPoolActivity(arg0), {
			"getConfig",
			{
				"type"
			}
		}) == ActivityConst.ACTIVITY_TYPE_NEWSERVER_BUILD
	end) then
		setActive(arg0.toggles[var0.PAGE_NEWSERVER], true)
	else
		setActive(arg0.toggles[var0.PAGE_NEWSERVER], false)
	end

	if not isActive(arg0.toggles[var0.PAGE_NEWSERVER]) and arg0.contextData.page == var0.PAGE_NEWSERVER then
		triggerToggle(arg0.toggles[var0.PAGE_BUILD], true)
	else
		arg0.poolsPage:Flush(arg0.pools)
	end
end

function var0.switchPage(arg0, arg1, arg2)
	if arg2 then
		arg0.contextData.page = arg1 == var0.PAGE_UNSEAM and var0.PAGE_BUILD or arg1
	end

	if arg1 == var0.PAGE_UNSEAM then
		if arg2 then
			arg0:emit(BuildShipMediator.OPEN_DESTROY)
		end
	elseif arg1 == var0.PAGE_QUEUE then
		if arg2 then
			arg0:emit(BuildShipMediator.OPEN_PROJECT_LIST)
		else
			arg0:emit(BuildShipMediator.REMOVE_PROJECT_LIST)
		end
	elseif arg1 == var0.PAGE_SUPPORT then
		arg0.supportShipPoolPage:ExecuteAction("ShowOrHide", arg2)

		if arg2 then
			arg0.supportShipPoolPage:ExecuteAction("Flush")
		end
	elseif arg1 == var0.PAGE_BUILD then
		arg0.poolsPage:ExecuteAction("ShowOrHide", arg2)

		if arg2 then
			arg0.poolsPage:ExecuteAction("Flush", arg0.pools, false)
		end
	elseif arg1 == var0.PAGE_NEWSERVER then
		arg0.poolsPage:ExecuteAction("ShowOrHide", arg2)

		if arg2 then
			arg0.poolsPage:ExecuteAction("Flush", arg0.pools, true)
		end
	elseif arg1 == var0.PAGE_PRAY then
		if arg2 then
			arg0:emit(BuildShipMediator.OPEN_PRAY_PAGE)
		else
			arg0:emit(BuildShipMediator.CLOSE_PRAY_PAGE)
		end
	end
end

function var0.updateQueueTip(arg0, arg1)
	setActive(arg0.tip, arg1 > 0)
end

function var0.onBackPressed(arg0)
	if arg0.contextData.helpWindow:GetLoaded() and arg0.contextData.helpWindow:isShowing() then
		arg0.contextData.helpWindow:Hide()

		return
	end

	if arg0.contextData.msgbox:GetLoaded() and arg0.contextData.msgbox:isShowing() then
		arg0.contextData.msgbox:Hide()

		return
	end

	arg0:emit(var0.ON_BACK_PRESSED)
end

function var0.willExit(arg0)
	Input.multiTouchEnabled = true

	arg0.contextData.msgbox:Destroy()
	arg0.contextData.helpWindow:Destroy()
	arg0.poolsPage:Destroy()
	arg0.supportShipPoolPage:Destroy()
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0.blurPanel, arg0._tf)
end

return var0
