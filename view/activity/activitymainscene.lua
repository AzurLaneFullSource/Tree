local var0_0 = class("ActivityMainScene", import("..base.BaseUI"))

var0_0.LOCK_ACT_MAIN = "ActivityMainScene:LOCK_ACT_MAIN"
var0_0.UPDATE_ACTIVITY = "ActivityMainScene:UPDATE_ACTIVITY"
var0_0.GET_PAGE_BGM = "ActivityMainScene.GET_PAGE_BGM"
var0_0.FLUSH_TABS = "ActivityMainScene.FLUSH_TABS"

function var0_0.preload(arg0_1, arg1_1)
	arg1_1()
end

function var0_0.getUIName(arg0_2)
	return "ActivityMainUI"
end

function var0_0.PlayBGM(arg0_3)
	return
end

function var0_0.onBackPressed(arg0_4)
	if arg0_4.locked then
		return
	end

	for iter0_4, iter1_4 in pairs(arg0_4.windowList) do
		if isActive(iter1_4._tf) then
			arg0_4:HideWindow(iter1_4.class)

			return
		end
	end

	if arg0_4.awardWindow and arg0_4.awardWindow:GetLoaded() and arg0_4.awardWindow:isShowing() then
		arg0_4.awardWindow:Hide()

		return
	end

	for iter2_4, iter3_4 in pairs(arg0_4.pageDic) do
		if iter3_4.onBackPressed and iter3_4:onBackPressed() then
			return
		end
	end

	arg0_4:emit(var0_0.ON_BACK_PRESSED)
end

local var1_0

function var0_0.init(arg0_5)
	local var0_5 = arg0_5._tf:GetComponent(typeof(ItemList)).prefabItem:ToTable()

	for iter0_5, iter1_5 in ipairs({
		"btnBack",
		"pageContainer",
		"permanentFinshMask",
		"tabs",
		"tab",
		"entranceContent",
		"entranceTpl",
		"lockAll"
	}) do
		arg0_5[iter1_5] = var0_5[iter0_5].transform
	end

	arg0_5.entranceList = UIItemList.New(arg0_5.entranceContent, arg0_5.entranceTpl)
	arg0_5.windowList = {}
	arg0_5.awardWindow = AwardWindow.New(arg0_5._tf, arg0_5.event)
	arg0_5.chargeTipWindow = ChargeTipWindow.New(arg0_5._tf, arg0_5.event)

	setActive(arg0_5.tab, false)
	setActive(arg0_5.lockAll, false)
	setActive(arg0_5.permanentFinshMask, false)
	setText(arg0_5.permanentFinshMask:Find("piece/Text"), i18n("activity_permanent_tips2"))
	onButton(arg0_5, arg0_5.permanentFinshMask:Find("piece/arrow/Image"), function()
		arg0_5:emit(ActivityMediator.FINISH_ACTIVITY_PERMANENT)
	end, SFX_PANEL)

	arg0_5.tabsList = UIItemList.New(arg0_5.tabs, arg0_5.tab)

	arg0_5.tabsList:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventUpdate then
			local var0_7 = arg0_5.activities[arg1_7 + 1]

			arg2_7.name = var0_7.id

			local var1_7 = var0_7:getConfig("title_res_tag")

			if var1_7 then
				local var2_7 = arg2_7:Find("red")
				local var3_7 = GetSpriteFromAtlas("activityuitable/" .. var1_7 .. "_text", "") or GetSpriteFromAtlas("activityuitable/activity_text", "")
				local var4_7 = GetSpriteFromAtlas("activityuitable/" .. var1_7 .. "_text_selected", "") or GetSpriteFromAtlas("activityuitable/activity_text_selected", "")

				setImageSprite(arg2_7:Find("off/text"), var3_7, true)
				setImageSprite(arg2_7:Find("on/text"), var4_7, true)
				setActive(var2_7, var0_7:readyToAchieve())
				onToggle(arg0_5, arg2_7, function(arg0_8)
					if arg0_8 then
						arg0_5:selectActivity(var0_7)
					end
				end, SFX_PANEL)
			end

			local var5_7 = arg0_5.pageDic[var0_7.id]

			onToggle(arg0_5, arg2_7, function(arg0_9)
				if var5_7 then
					if arg0_9 then
						arg0_5:selectActivity(var0_7)
					end
				else
					arg0_5:loadActivityPanel(arg0_9, var0_7)
				end
			end, SFX_PANEL)
		end
	end)
end

function var0_0.didEnter(arg0_10)
	arg0_10:bind(var0_0.LOCK_ACT_MAIN, function(arg0_11, arg1_11)
		arg0_10.locked = arg1_11

		setActive(arg0_10.lockAll, arg1_11)
	end)
	arg0_10:bind(var0_0.UPDATE_ACTIVITY, function(arg0_12, arg1_12)
		arg0_10:updateActivity(arg1_12)
	end)
	arg0_10:bind(var0_0.GET_PAGE_BGM, function(arg0_13, arg1_13, arg2_13)
		arg2_13.bgm = arg0_10:getBGM(arg1_13) or arg0_10:getBGM()
	end)
	arg0_10:bind(var0_0.FLUSH_TABS, function()
		arg0_10:flushTabs()
	end)
	getProxy(CommanderManualProxy):TaskProgressAdd(2020, 1)
	onButton(arg0_10, arg0_10.btnBack, function()
		arg0_10:emit(var0_0.ON_BACK)
	end, SOUND_BACK)
	arg0_10:updateEntrances()
	arg0_10:emit(ActivityMediator.SHOW_NEXT_ACTIVITY)
	pg.CameraFixMgr.GetInstance():Adapt()
end

function var0_0.setPlayer(arg0_16, arg1_16)
	arg0_16.shareData:SetPlayer(arg1_16)
end

function var0_0.setFlagShip(arg0_17, arg1_17)
	arg0_17.shareData:SetFlagShip(arg1_17)
end

function var0_0.updateTaskLayers(arg0_18)
	if not arg0_18.activity then
		return
	end

	arg0_18:updateActivity(arg0_18.activity)
end

function var0_0.getActClass(arg0_19, arg1_19)
	return import("view.activity.subPages." .. arg1_19)
end

function var0_0.instanceActivityPage(arg0_20, arg1_20)
	local var0_20 = arg1_20:getConfig("page_info")

	if var0_20.class_name and not arg0_20.pageDic[arg1_20.id] and not arg1_20:isEnd() then
		local var1_20 = arg0_20:getActClass(var0_20.class_name).New(arg0_20.pageContainer, arg0_20.event, arg0_20.contextData)

		if var1_20:UseSecondPage(arg1_20) then
			var1_20:SetUIName(var0_20.ui_name2)
		else
			var1_20:SetUIName(var0_20.ui_name)
		end

		var1_20:SetShareData(arg0_20.shareData)

		arg0_20.pageDic[arg1_20.id] = var1_20
	end
end

function var0_0.setActivities(arg0_21, arg1_21)
	arg0_21.activities = arg1_21 or {}
	arg0_21.shareData = arg0_21.shareData or ActivityShareData.New()
	arg0_21.pageDic = arg0_21.pageDic or {}

	for iter0_21, iter1_21 in ipairs(arg1_21) do
		arg0_21:instanceActivityPage(iter1_21)
	end

	arg0_21.activity = nil

	table.sort(arg0_21.activities, CompareFuncs({
		function(arg0_22)
			return -arg0_22:getShowPriority()
		end,
		function(arg0_23)
			return -arg0_23.id
		end
	}))
	arg0_21:flushTabs()
end

function var0_0.getActivityIndex(arg0_24, arg1_24)
	for iter0_24, iter1_24 in ipairs(arg0_24.activities) do
		if iter1_24.id == arg1_24 then
			return iter0_24
		end
	end

	return nil
end

function var0_0.updateActivity(arg0_25, arg1_25)
	if ActivityConst.PageIdLink[arg1_25.id] then
		arg1_25 = getProxy(ActivityProxy):getActivityById(ActivityConst.PageIdLink[arg1_25.id])
	end

	if arg1_25:isShow() and arg1_25:isCorePage(arg0_25.contextData.coreName or "") and not arg1_25:isEnd() then
		arg0_25.activities[arg0_25:getActivityIndex(arg1_25.id) or #arg0_25.activities + 1] = arg1_25

		table.sort(arg0_25.activities, CompareFuncs({
			function(arg0_26)
				return -arg0_26:getShowPriority()
			end,
			function(arg0_27)
				return -arg0_27.id
			end
		}))

		if not arg0_25.pageDic[arg1_25.id] then
			arg0_25:instanceActivityPage(arg1_25)
		end

		arg0_25:flushTabs()

		if arg0_25.activity and arg0_25.activity.id == arg1_25.id then
			arg0_25.activity = arg1_25

			arg0_25.pageDic[arg1_25.id]:ActionInvoke("Flush", arg1_25)
			setActive(arg0_25.permanentFinshMask, pg.activity_task_permanent[arg1_25.id] and arg1_25:canPermanentFinish())
		end
	end
end

function var0_0.removeActivity(arg0_28, arg1_28)
	local var0_28 = arg0_28:getActivityIndex(arg1_28)

	if var0_28 then
		table.remove(arg0_28.activities, var0_28)
		arg0_28.pageDic[arg1_28]:Destroy()

		arg0_28.pageDic[arg1_28] = nil

		arg0_28:flushTabs()

		if arg0_28.activity and arg0_28.activity.id == arg1_28 then
			arg0_28.activity = nil

			arg0_28:verifyTabs()
		end
	end
end

function var0_0.loadLayers(arg0_29)
	local var0_29 = arg0_29.pageDic[arg0_29.activity.id]

	if var0_29 and var0_29.OnLoadLayers then
		var0_29:OnLoadLayers()
	end
end

function var0_0.removeLayers(arg0_30)
	local var0_30 = arg0_30.pageDic[arg0_30.activity.id]

	if var0_30 and var0_30.OnRemoveLayers then
		var0_30:OnRemoveLayers()
	end
end

function var0_0.GetOnShowEntranceData()
	var1_0 = var1_0 or require("GameCfg.activity.EntranceData")

	assert(var1_0, "Missing EntranceData.lua!")

	var1_0 = var1_0 or {}

	return (_.select(var1_0, function(arg0_32)
		return arg0_32.isShow and arg0_32.isShow()
	end))
end

function var0_0.updateEntrances(arg0_33)
	local var0_33 = var0_0.GetOnShowEntranceData()
	local var1_33 = math.max(#var0_33, 5)

	arg0_33.entranceList:make(function(arg0_34, arg1_34, arg2_34)
		if arg0_34 == UIItemList.EventUpdate then
			local var0_34 = var0_33[arg1_34 + 1]
			local var1_34 = "empty"

			removeOnButton(arg2_34)

			local var2_34 = false

			if var0_34 and table.getCount(var0_34) ~= 0 and var0_34.isShow() then
				onButton(arg0_33, arg2_34, function()
					arg0_33:emit(var0_34.event, var0_34.data[1], var0_34.data[2])
				end, SFX_PANEL)

				var1_34 = var0_34.banner

				if var0_34.isTip then
					var2_34 = var0_34.isTip()
				end
			end

			setActive(arg2_34:Find("tip"), var2_34)
			LoadImageSpriteAsync("activitybanner/" .. var1_34, arg2_34)
		end
	end)
	arg0_33.entranceList:align(var1_33)
end

function var0_0.flushTabs(arg0_36)
	arg0_36.tabsList:align(#arg0_36.activities)
end

function var0_0.selectActivity(arg0_37, arg1_37)
	if arg1_37 and (not arg0_37.activity or arg0_37.activity.id ~= arg1_37.id) then
		local var0_37 = arg0_37.pageDic[arg1_37.id]

		assert(var0_37, "找不到id:" .. arg1_37.id .. "的活动页，请检查")
		var0_37:Load()
		var0_37:ActionInvoke("Flush", arg1_37)
		var0_37:ActionInvoke("ShowOrHide", true)

		if arg0_37.activity and arg0_37.activity.id ~= arg1_37.id then
			arg0_37.pageDic[arg0_37.activity.id]:ActionInvoke("ShowOrHide", false)
		end

		arg0_37.activity = arg1_37
		arg0_37.contextData.id = arg1_37.id

		setActive(arg0_37.permanentFinshMask, pg.activity_task_permanent[arg1_37.id] and arg1_37:canPermanentFinish())
	end
end

function var0_0.checkAutoHideActivity(arg0_38)
	if arg0_38.activity and not arg0_38.activity:isShow() then
		arg0_38:removeActivity(arg0_38.activity.id)
	end
end

function var0_0.verifyTabs(arg0_39, arg1_39)
	local var0_39 = arg0_39:getActivityIndex(arg1_39) or 1
	local var1_39 = arg0_39.tabs:GetChild(var0_39 - 1)

	triggerToggle(var1_39, true)
end

function var0_0.loadActivityPanel(arg0_40, arg1_40, arg2_40)
	local var0_40 = arg2_40:getConfig("type")
	local var1_40

	if var1_40 and arg1_40 then
		arg0_40:emit(ActivityMediator.OPEN_LAYER, var1_40)
	elseif var1_40 and not arg1_40 then
		arg0_40:emit(ActivityMediator.CLOSE_LAYER, var1_40.mediator)
	else
		originalPrint("------活动id为" .. arg2_40.id .. "类型为" .. arg2_40:getConfig("type") .. "的页面不存在")
	end
end

function var0_0.getBonusWindow(arg0_41, arg1_41, arg2_41)
	local var0_41 = arg0_41._tf:Find(arg1_41)

	if not var0_41 then
		PoolMgr.GetInstance():GetUI("ActivitybonusWindow", true, function(arg0_42)
			SetParent(arg0_42, arg0_41._tf, false)

			arg0_42.name = arg1_41

			arg2_41(arg0_42)
		end)
	else
		arg2_41(var0_41)
	end
end

function var0_0.ShowWindow(arg0_43, arg1_43, arg2_43)
	local var0_43 = arg1_43.__cname

	if not arg0_43.windowList[var0_43] then
		arg0_43:getBonusWindow(var0_43, function(arg0_44)
			arg0_43.windowList[var0_43] = arg1_43.New(tf(arg0_44), arg0_43)

			arg0_43.windowList[var0_43]:Show(arg2_43)
		end)
	else
		arg0_43.windowList[var0_43]:Show(arg2_43)
	end
end

function var0_0.HideWindow(arg0_45, arg1_45)
	local var0_45 = arg1_45.__cname

	if not arg0_45.windowList[var0_45] then
		return
	end

	arg0_45.windowList[var0_45]:Hide()
end

function var0_0.ShowAwardWindow(arg0_46, arg1_46, arg2_46, arg3_46)
	arg0_46.awardWindow:ExecuteAction("Flush", arg1_46, arg2_46, arg3_46)
end

function var0_0.OnChargeSuccess(arg0_47, arg1_47)
	arg0_47.chargeTipWindow:ExecuteAction("Show", arg1_47)
end

function var0_0.willExit(arg0_48)
	arg0_48.shareData = nil

	for iter0_48, iter1_48 in pairs(arg0_48.pageDic) do
		iter1_48:Destroy()
	end

	for iter2_48, iter3_48 in pairs(arg0_48.windowList) do
		iter3_48:Dispose()
	end

	if arg0_48.awardWindow then
		arg0_48.awardWindow:Destroy()

		arg0_48.awardWindow = nil
	end

	if arg0_48.chargeTipWindow then
		arg0_48.chargeTipWindow:Destroy()

		arg0_48.chargeTipWindow = nil
	end
end

return var0_0
