local var0_0 = class("ActivityMainScene", import("..base.BaseUI"))

var0_0.LOCK_ACT_MAIN = "ActivityMainScene:LOCK_ACT_MAIN"
var0_0.UPDATE_ACTIVITY = "ActivityMainScene:UPDATE_ACTIVITY"
var0_0.GET_PAGE_BGM = "ActivityMainScene.GET_PAGE_BGM"
var0_0.FLUSH_TABS = "ActivityMainScene.FLUSH_TABS"

function var0_0.getResource(arg0_1, arg1_1)
	local var0_1 = {
		"activitybanner",
		"activityuitable",
		"ui/ActivitybonusWindow",
		"ui/ActivitybonusWindow_nonPt",
		"ui/ChargeTipUI",
		"ui/MonthCardTipWindow",
		"ui/GiftPackageTipWindow",
		"ui/CrusingTipWindow",
		"ui/iconcolorful",
		"activitybanner/empty",
		"activityuitable/activity_text",
		"activityuitable/activity_text_selected"
	}

	local function var1_1(arg0_2)
		if not table.contains(var0_1, arg0_2) then
			table.insert(var0_1, arg0_2)
		end
	end

	for iter0_1, iter1_1 in ipairs(getProxy(ActivityProxy):getPanelActivities()) do
		local var2_1 = iter1_1:getConfig("title_res_tag")

		if noEmptyStr(var2_1) then
			var1_1("activityuitable/" .. var2_1 .. "_text")
			var1_1("activityuitable/" .. var2_1 .. "_text_selected")
		end
	end

	local var3_1 = getProxy(ActivityPermanentProxy):getActivityIdsByType(ActivityPermanentProxy.TYPE_NORMAL_ACTIVITY)

	for iter2_1, iter3_1 in ipairs(var3_1) do
		local var4_1 = pg.activity_task_permanent[iter3_1].id
		local var5_1 = pg.activity_template[var4_1].title_res_tag

		if noEmptyStr(var5_1) then
			var1_1("activityuitable/" .. var5_1 .. "_text")
			var1_1("activityuitable/" .. var5_1 .. "_text_selected")
		end
	end

	for iter4_1, iter5_1 in ipairs(var0_0.GetOnShowEntranceData()) do
		var1_1("activitybanner/" .. iter5_1.banner)
	end

	table.insertto(var0_1, var0_0.super.getResource(arg0_1))

	return var0_1
end

function var0_0.getUIName(arg0_3)
	return "ActivityMainUI"
end

function var0_0.PlayBGM(arg0_4)
	return
end

function var0_0.onBackPressed(arg0_5)
	if arg0_5.locked then
		return
	end

	for iter0_5, iter1_5 in pairs(arg0_5.windowList) do
		if isActive(iter1_5._tf) then
			arg0_5:HideWindow(iter1_5.class)

			return
		end
	end

	if arg0_5.awardWindow and arg0_5.awardWindow:GetLoaded() and arg0_5.awardWindow:isShowing() then
		arg0_5.awardWindow:Hide()

		return
	end

	for iter2_5, iter3_5 in pairs(arg0_5.pageDic) do
		if iter3_5.onBackPressed and iter3_5:onBackPressed() then
			return
		end
	end

	arg0_5:emit(var0_0.ON_BACK_PRESSED)
end

local var1_0

function var0_0.init(arg0_6)
	arg0_6.entranceList = UIItemList.New(arg0_6.entranceContent, arg0_6.entranceTpl)
	arg0_6.windowList = {}
	arg0_6.awardWindow = AwardWindow.New(arg0_6._tf, arg0_6.event)
	arg0_6.chargeTipWindow = ChargeTipWindow.New(arg0_6._tf, arg0_6.event)

	setActive(arg0_6.tab, false)
	setActive(arg0_6.lockAll, false)
	setActive(arg0_6.permanentFinshMask, false)
	setText(arg0_6.permanentFinshMask:Find("piece/Text"), i18n("activity_permanent_tips2"))
	onButton(arg0_6, arg0_6.permanentFinshMask:Find("piece/arrow/Image"), function()
		arg0_6:emit(ActivityMediator.FINISH_ACTIVITY_PERMANENT)
	end, SFX_PANEL)

	arg0_6.tabsList = UIItemList.New(arg0_6.tabs, arg0_6.tab)

	arg0_6.tabsList:make(function(arg0_8, arg1_8, arg2_8)
		if arg0_8 == UIItemList.EventUpdate then
			local var0_8 = arg0_6.activities[arg1_8 + 1]

			arg2_8.name = var0_8.id

			local var1_8 = var0_8:getConfig("title_res_tag")

			if var1_8 then
				local var2_8 = arg2_8:Find("red")
				local var3_8 = GetSpriteFromAtlas("activityuitable/" .. var1_8 .. "_text", "") or GetSpriteFromAtlas("activityuitable/activity_text", "")
				local var4_8 = GetSpriteFromAtlas("activityuitable/" .. var1_8 .. "_text_selected", "") or GetSpriteFromAtlas("activityuitable/activity_text_selected", "")

				setImageSprite(arg2_8:Find("off/text"), var3_8, true)
				setImageSprite(arg2_8:Find("on/text"), var4_8, true)
				setActive(var2_8, var0_8:readyToAchieve())
				onToggle(arg0_6, arg2_8, function(arg0_9)
					if arg0_9 then
						arg0_6:selectActivity(var0_8)
					end
				end, SFX_PANEL)
			end

			local var5_8 = arg0_6.pageDic[var0_8.id]

			onToggle(arg0_6, arg2_8, function(arg0_10)
				if var5_8 then
					if arg0_10 then
						arg0_6:selectActivity(var0_8)
					end
				else
					arg0_6:loadActivityPanel(arg0_10, var0_8)
				end
			end, SFX_PANEL)
		end
	end)

	arg0_6.switchCount = 0
end

function var0_0.didEnter(arg0_11)
	arg0_11:bind(var0_0.LOCK_ACT_MAIN, function(arg0_12, arg1_12)
		arg0_11.locked = arg1_12

		setActive(arg0_11.lockAll, arg1_12)
	end)
	arg0_11:bind(var0_0.UPDATE_ACTIVITY, function(arg0_13, arg1_13)
		arg0_11:updateActivity(arg1_13)
	end)
	arg0_11:bind(var0_0.GET_PAGE_BGM, function(arg0_14, arg1_14, arg2_14)
		arg2_14.bgm = arg0_11:getBGM(arg1_14) or arg0_11:getBGM()
	end)
	arg0_11:bind(var0_0.FLUSH_TABS, function()
		arg0_11:flushTabs()
	end)
	getProxy(CommanderManualProxy):TaskProgressAdd(2020, 1)
	onButton(arg0_11, arg0_11.btnBack, function()
		arg0_11:emit(var0_0.ON_BACK)
	end, SOUND_BACK)
	arg0_11:updateEntrances()
	arg0_11:emit(ActivityMediator.SHOW_NEXT_ACTIVITY)

	if arg0_11.contextData.event then
		arg0_11:emit(arg0_11.contextData.event, arg0_11.contextData.data)

		arg0_11.contextData.event = nil
		arg0_11.contextData.data = nil
	end

	pg.CameraFixMgr.GetInstance():Adapt()
end

function var0_0.setPlayer(arg0_17, arg1_17)
	arg0_17.shareData:SetPlayer(arg1_17)
end

function var0_0.setFlagShip(arg0_18, arg1_18)
	arg0_18.shareData:SetFlagShip(arg1_18)
end

function var0_0.updateTaskLayers(arg0_19)
	if not arg0_19.activity then
		return
	end

	arg0_19:updateActivity(arg0_19.activity)
end

function var0_0.getActClass(arg0_20, arg1_20)
	local var0_20, var1_20 = pcall(import, "view.activity.subPages." .. arg1_20)

	if not var0_20 then
		local var2_20, var3_20 = pcall(import, "view.activity.Remaster.re." .. arg1_20)

		var1_20 = var3_20

		if not var2_20 then
			error("模块未找到: " .. arg1_20)
		end
	end

	return var1_20
end

function var0_0.instanceActivityPage(arg0_21, arg1_21)
	local var0_21 = arg1_21:getConfig("page_info")

	if var0_21.class_name and not arg0_21.pageDic[arg1_21.id] and not arg1_21:isEnd() then
		local var1_21 = arg0_21:getActClass(var0_21.class_name).New(arg0_21.pageContainer, arg0_21.event, arg0_21.contextData)

		if var1_21:UseSecondPage(arg1_21) then
			var1_21:SetUIName(var0_21.ui_name2)
		else
			var1_21:SetUIName(var0_21.ui_name)
		end

		var1_21:SetShareData(arg0_21.shareData)

		arg0_21.pageDic[arg1_21.id] = var1_21
	end
end

function var0_0.setActivities(arg0_22, arg1_22)
	arg0_22.activities = underscore.filter(arg1_22 or {}, function(arg0_23)
		return arg0_23:checkPageABExist()
	end)
	arg0_22.shareData = arg0_22.shareData or ActivityShareData.New()
	arg0_22.pageDic = arg0_22.pageDic or {}

	for iter0_22, iter1_22 in ipairs(arg1_22) do
		arg0_22:instanceActivityPage(iter1_22)
	end

	arg0_22.activity = nil

	table.sort(arg0_22.activities, CompareFuncs({
		function(arg0_24)
			return -arg0_24:getShowPriority()
		end,
		function(arg0_25)
			return -arg0_25.id
		end
	}))
	arg0_22:flushTabs()
end

function var0_0.getActivityIndex(arg0_26, arg1_26)
	for iter0_26, iter1_26 in ipairs(arg0_26.activities) do
		if iter1_26.id == arg1_26 then
			return iter0_26
		end
	end

	return nil
end

function var0_0.updateActivity(arg0_27, arg1_27)
	if ActivityConst.PageIdLink[arg1_27.id] then
		arg1_27 = getProxy(ActivityProxy):getActivityById(ActivityConst.PageIdLink[arg1_27.id])
	end

	if arg1_27:isShow() and arg1_27:isCorePage(arg0_27.contextData.coreName or "") and not arg1_27:isEnd() and arg1_27:checkPageABExist() then
		arg0_27.activities[arg0_27:getActivityIndex(arg1_27.id) or #arg0_27.activities + 1] = arg1_27

		table.sort(arg0_27.activities, CompareFuncs({
			function(arg0_28)
				return -arg0_28:getShowPriority()
			end,
			function(arg0_29)
				return -arg0_29.id
			end
		}))

		if not arg0_27.pageDic[arg1_27.id] then
			arg0_27:instanceActivityPage(arg1_27)
		end

		arg0_27:flushTabs()

		if arg0_27.activity and arg0_27.activity.id == arg1_27.id then
			arg0_27.activity = arg1_27

			arg0_27.pageDic[arg1_27.id]:ActionInvoke("Flush", arg1_27)
			setActive(arg0_27.permanentFinshMask, pg.activity_task_permanent[arg1_27.id] and arg1_27:canPermanentFinish())
		end
	end
end

function var0_0.removeActivity(arg0_30, arg1_30)
	local var0_30 = arg0_30:getActivityIndex(arg1_30)

	if var0_30 then
		table.remove(arg0_30.activities, var0_30)
		arg0_30.pageDic[arg1_30]:Destroy()

		arg0_30.pageDic[arg1_30] = nil

		arg0_30:flushTabs()

		if arg0_30.activity and arg0_30.activity.id == arg1_30 then
			arg0_30.activity = nil

			arg0_30:verifyTabs()
		end
	end
end

function var0_0.GetOnShowEntranceData()
	var1_0 = var1_0 or require("GameCfg.activity.EntranceData")

	assert(var1_0, "Missing EntranceData.lua!")

	var1_0 = var1_0 or {}

	local var0_31 = _.select(var1_0, function(arg0_32)
		return arg0_32.isShow and arg0_32.isShow()
	end)
	local var1_31 = var0_0.createEntranceData()

	table.insertto(var0_31, var1_31)

	return var0_31
end

function var0_0.createEntranceData()
	local var0_33 = {}

	for iter0_33, iter1_33 in ipairs(pg.activity_entrance.all) do
		local var1_33 = pg.activity_entrance[iter1_33]

		if pg.TimeMgr.GetInstance():inTime(var1_33.time) then
			local var2_33 = {
				event = ActivityMediator.EVENT_GO_SCENE,
				data = {
					SCENE.ACTIVITY,
					{
						id = var1_33.act_ids[1]
					}
				},
				banner = var1_33.banner,
				isShow = function()
					for iter0_34, iter1_34 in ipairs(var1_33.act_ids) do
						local var0_34 = getProxy(ActivityProxy):getActivityById(iter1_34)

						if var0_34 and not var0_34:isEnd() then
							return true
						end
					end

					return false
				end,
				isTip = function()
					for iter0_35, iter1_35 in ipairs(var1_33.act_ids) do
						local var0_35 = getProxy(ActivityProxy):getActivityById(iter1_35)

						if Activity.IsActivityReady(var0_35) then
							return true
						end
					end

					return false
				end
			}

			table.insert(var0_33, var2_33)
		end
	end

	return var0_33
end

function var0_0.updateEntrances(arg0_36)
	local var0_36 = var0_0.GetOnShowEntranceData()
	local var1_36 = math.max(#var0_36, 5)

	arg0_36.entranceList:make(function(arg0_37, arg1_37, arg2_37)
		if arg0_37 == UIItemList.EventUpdate then
			local var0_37 = var0_36[arg1_37 + 1]
			local var1_37 = "empty"

			removeOnButton(arg2_37)

			local var2_37 = false

			if var0_37 and table.getCount(var0_37) ~= 0 and var0_37.isShow() then
				onButton(arg0_36, arg2_37, function()
					arg0_36:emit(var0_37.event, var0_37.data[1], var0_37.data[2])
				end, SFX_PANEL)

				var1_37 = var0_37.banner

				if var0_37.isTip then
					var2_37 = var0_37.isTip()
				end
			end

			setActive(arg2_37:Find("tip"), var2_37)
			LoadImageSpriteAsync("activitybanner/" .. var1_37, arg2_37)
		end
	end)
	arg0_36.entranceList:align(var1_36)
end

function var0_0.flushTabs(arg0_39)
	arg0_39.tabsList:align(#arg0_39.activities)
end

function var0_0.selectActivity(arg0_40, arg1_40)
	if arg0_40.nextActivity == arg1_40 or not arg0_40.nextActivity and arg0_40.activity and arg1_40.id == arg0_40.activity.id then
		return
	end

	local var0_40 = {}

	if arg0_40.activity and not arg0_40.nextActivity then
		arg0_40.switchCount = arg0_40.switchCount + 1

		table.insert(var0_40, function(arg0_41)
			arg0_40.pageDic[arg0_40.activity.id]:ActionInvoke("SwitchOut", function()
				arg0_40.switchCount = arg0_40.switchCount - 1

				arg0_41()
			end)
		end)
	end

	if not arg0_40.activity or arg0_40.activity.id ~= arg1_40.id then
		local var1_40 = arg0_40.pageDic[arg1_40.id]

		assert(var1_40, "找不到id:" .. arg1_40.id .. "的活动页，请检查")

		arg0_40.switchCount = arg0_40.switchCount + 1

		table.insert(var0_40, function(arg0_43)
			var1_40:Load()
			var1_40:ActionInvoke("ShowOrHide", false)
			var1_40:CallbackInvoke(function()
				arg0_40.switchCount = arg0_40.switchCount - 1

				arg0_43()
			end)
		end)
	end

	arg0_40.nextActivity = arg1_40

	parallelAsync(var0_40, function()
		if arg0_40.switchCount > 0 then
			return
		end

		if arg0_40.activity then
			arg0_40.pageDic[arg0_40.activity.id]:ActionInvoke("ShowOrHide", false)
		end

		arg0_40.activity = arg0_40.nextActivity
		arg0_40.contextData.id = arg0_40.nextActivity.id
		arg0_40.nextActivity = nil

		local var0_45 = arg0_40.pageDic[arg0_40.activity.id]

		var0_45:ActionInvoke("ShowOrHide", true)
		var0_45:ActionInvoke("Flush", arg0_40.activity)
		setActive(arg0_40.permanentFinshMask, pg.activity_task_permanent[arg1_40.id] and arg1_40:canPermanentFinish())
	end)
end

function var0_0.checkAutoHideActivity(arg0_46)
	if arg0_46.activity and not arg0_46.activity:isShow() then
		arg0_46:removeActivity(arg0_46.activity.id)
	end
end

function var0_0.verifyTabs(arg0_47, arg1_47)
	local var0_47 = arg0_47:getActivityIndex(arg1_47) or 1
	local var1_47 = arg0_47.tabs:GetChild(var0_47 - 1)

	triggerToggle(var1_47, true)
end

function var0_0.loadActivityPanel(arg0_48, arg1_48, arg2_48)
	local var0_48 = arg2_48:getConfig("type")
	local var1_48

	if var1_48 and arg1_48 then
		arg0_48:emit(ActivityMediator.OPEN_LAYER, var1_48)
	elseif var1_48 and not arg1_48 then
		arg0_48:emit(ActivityMediator.CLOSE_LAYER, var1_48.mediator)
	else
		originalPrint("------活动id为" .. arg2_48.id .. "类型为" .. arg2_48:getConfig("type") .. "的页面不存在")
	end
end

function var0_0.getBonusWindow(arg0_49, arg1_49, arg2_49)
	local var0_49 = arg0_49._tf:Find(arg1_49)

	if not var0_49 then
		PoolMgr.GetInstance():GetUI("ActivitybonusWindow", true, function(arg0_50)
			SetParent(arg0_50, arg0_49._tf, false)

			arg0_50.name = arg1_49

			arg2_49(arg0_50)
		end)
	else
		arg2_49(var0_49)
	end
end

function var0_0.ShowWindow(arg0_51, arg1_51, arg2_51)
	local var0_51 = arg1_51.__cname

	if not arg0_51.windowList[var0_51] then
		arg0_51:getBonusWindow(var0_51, function(arg0_52)
			arg0_51.windowList[var0_51] = arg1_51.New(tf(arg0_52), arg0_51)

			arg0_51.windowList[var0_51]:Show(arg2_51)
		end)
	else
		arg0_51.windowList[var0_51]:Show(arg2_51)
	end
end

function var0_0.HideWindow(arg0_53, arg1_53)
	local var0_53 = arg1_53.__cname

	if not arg0_53.windowList[var0_53] then
		return
	end

	arg0_53.windowList[var0_53]:Hide()
end

function var0_0.ShowAwardWindow(arg0_54, arg1_54, arg2_54, arg3_54, arg4_54)
	arg0_54.awardWindow:ExecuteAction("Flush", arg1_54, arg2_54, arg3_54, arg4_54)
end

function var0_0.OnChargeSuccess(arg0_55, arg1_55)
	arg0_55.chargeTipWindow:ExecuteAction("Show", arg1_55)
end

function var0_0.willExit(arg0_56)
	arg0_56.switchCount = nil
	arg0_56.shareData = nil

	for iter0_56, iter1_56 in pairs(arg0_56.pageDic) do
		iter1_56:Destroy()
	end

	for iter2_56, iter3_56 in pairs(arg0_56.windowList) do
		iter3_56:Dispose()
	end

	if arg0_56.awardWindow then
		arg0_56.awardWindow:Destroy()

		arg0_56.awardWindow = nil
	end

	if arg0_56.chargeTipWindow then
		arg0_56.chargeTipWindow:Destroy()

		arg0_56.chargeTipWindow = nil
	end
end

return var0_0
