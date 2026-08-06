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

	arg0_5.switchCount = 0
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

	if arg0_10.contextData.event then
		arg0_10:emit(arg0_10.contextData.event, arg0_10.contextData.data)

		arg0_10.contextData.event = nil
		arg0_10.contextData.data = nil
	end

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

function var0_0.GetOnShowEntranceData()
	var1_0 = var1_0 or require("GameCfg.activity.EntranceData")

	assert(var1_0, "Missing EntranceData.lua!")

	var1_0 = var1_0 or {}

	return (_.select(var1_0, function(arg0_30)
		return arg0_30.isShow and arg0_30.isShow()
	end))
end

function var0_0.updateEntrances(arg0_31)
	local var0_31 = var0_0.GetOnShowEntranceData()
	local var1_31 = math.max(#var0_31, 5)

	arg0_31.entranceList:make(function(arg0_32, arg1_32, arg2_32)
		if arg0_32 == UIItemList.EventUpdate then
			local var0_32 = var0_31[arg1_32 + 1]
			local var1_32 = "empty"

			removeOnButton(arg2_32)

			local var2_32 = false

			if var0_32 and table.getCount(var0_32) ~= 0 and var0_32.isShow() then
				onButton(arg0_31, arg2_32, function()
					arg0_31:emit(var0_32.event, var0_32.data[1], var0_32.data[2])
				end, SFX_PANEL)

				var1_32 = var0_32.banner

				if var0_32.isTip then
					var2_32 = var0_32.isTip()
				end
			end

			setActive(arg2_32:Find("tip"), var2_32)
			LoadImageSpriteAsync("activitybanner/" .. var1_32, arg2_32)
		end
	end)
	arg0_31.entranceList:align(var1_31)
end

function var0_0.flushTabs(arg0_34)
	arg0_34.tabsList:align(#arg0_34.activities)
end

function var0_0.selectActivity(arg0_35, arg1_35)
	if arg0_35.nextActivity == arg1_35 or not arg0_35.nextActivity and arg0_35.activity and arg1_35.id == arg0_35.activity.id then
		return
	end

	local var0_35 = {}

	if arg0_35.activity and not arg0_35.nextActivity then
		arg0_35.switchCount = arg0_35.switchCount + 1

		table.insert(var0_35, function(arg0_36)
			arg0_35.pageDic[arg0_35.activity.id]:ActionInvoke("SwitchOut", function()
				arg0_35.switchCount = arg0_35.switchCount - 1

				arg0_36()
			end)
		end)
	end

	if not arg0_35.activity or arg0_35.activity.id ~= arg1_35.id then
		local var1_35 = arg0_35.pageDic[arg1_35.id]

		assert(var1_35, "找不到id:" .. arg1_35.id .. "的活动页，请检查")

		arg0_35.switchCount = arg0_35.switchCount + 1

		table.insert(var0_35, function(arg0_38)
			var1_35:Load()
			var1_35:ActionInvoke("ShowOrHide", false)
			var1_35:CallbackInvoke(function()
				arg0_35.switchCount = arg0_35.switchCount - 1

				arg0_38()
			end)
		end)
	end

	arg0_35.nextActivity = arg1_35

	parallelAsync(var0_35, function()
		if arg0_35.switchCount > 0 then
			return
		end

		if arg0_35.activity then
			arg0_35.pageDic[arg0_35.activity.id]:ActionInvoke("ShowOrHide", false)
		end

		arg0_35.activity = arg0_35.nextActivity
		arg0_35.contextData.id = arg0_35.nextActivity.id
		arg0_35.nextActivity = nil

		local var0_40 = arg0_35.pageDic[arg0_35.activity.id]

		var0_40:ActionInvoke("ShowOrHide", true)
		var0_40:ActionInvoke("Flush", arg0_35.activity)
		setActive(arg0_35.permanentFinshMask, pg.activity_task_permanent[arg1_35.id] and arg1_35:canPermanentFinish())
	end)
end

function var0_0.checkAutoHideActivity(arg0_41)
	if arg0_41.activity and not arg0_41.activity:isShow() then
		arg0_41:removeActivity(arg0_41.activity.id)
	end
end

function var0_0.verifyTabs(arg0_42, arg1_42)
	local var0_42 = arg0_42:getActivityIndex(arg1_42) or 1
	local var1_42 = arg0_42.tabs:GetChild(var0_42 - 1)

	triggerToggle(var1_42, true)
end

function var0_0.loadActivityPanel(arg0_43, arg1_43, arg2_43)
	local var0_43 = arg2_43:getConfig("type")
	local var1_43

	if var1_43 and arg1_43 then
		arg0_43:emit(ActivityMediator.OPEN_LAYER, var1_43)
	elseif var1_43 and not arg1_43 then
		arg0_43:emit(ActivityMediator.CLOSE_LAYER, var1_43.mediator)
	else
		originalPrint("------活动id为" .. arg2_43.id .. "类型为" .. arg2_43:getConfig("type") .. "的页面不存在")
	end
end

function var0_0.getBonusWindow(arg0_44, arg1_44, arg2_44)
	local var0_44 = arg0_44._tf:Find(arg1_44)

	if not var0_44 then
		PoolMgr.GetInstance():GetUI("ActivitybonusWindow", true, function(arg0_45)
			SetParent(arg0_45, arg0_44._tf, false)

			arg0_45.name = arg1_44

			arg2_44(arg0_45)
		end)
	else
		arg2_44(var0_44)
	end
end

function var0_0.ShowWindow(arg0_46, arg1_46, arg2_46)
	local var0_46 = arg1_46.__cname

	if not arg0_46.windowList[var0_46] then
		arg0_46:getBonusWindow(var0_46, function(arg0_47)
			arg0_46.windowList[var0_46] = arg1_46.New(tf(arg0_47), arg0_46)

			arg0_46.windowList[var0_46]:Show(arg2_46)
		end)
	else
		arg0_46.windowList[var0_46]:Show(arg2_46)
	end
end

function var0_0.HideWindow(arg0_48, arg1_48)
	local var0_48 = arg1_48.__cname

	if not arg0_48.windowList[var0_48] then
		return
	end

	arg0_48.windowList[var0_48]:Hide()
end

function var0_0.ShowAwardWindow(arg0_49, arg1_49, arg2_49, arg3_49)
	arg0_49.awardWindow:ExecuteAction("Flush", arg1_49, arg2_49, arg3_49)
end

function var0_0.OnChargeSuccess(arg0_50, arg1_50)
	arg0_50.chargeTipWindow:ExecuteAction("Show", arg1_50)
end

function var0_0.willExit(arg0_51)
	arg0_51.switchCount = nil
	arg0_51.shareData = nil

	for iter0_51, iter1_51 in pairs(arg0_51.pageDic) do
		iter1_51:Destroy()
	end

	for iter2_51, iter3_51 in pairs(arg0_51.windowList) do
		iter3_51:Dispose()
	end

	if arg0_51.awardWindow then
		arg0_51.awardWindow:Destroy()

		arg0_51.awardWindow = nil
	end

	if arg0_51.chargeTipWindow then
		arg0_51.chargeTipWindow:Destroy()

		arg0_51.chargeTipWindow = nil
	end
end

return var0_0
