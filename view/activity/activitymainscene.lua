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

	arg0_4:emit(var0_0.ON_BACK_PRESSED)
end

local var1_0

function var0_0.init(arg0_5)
	arg0_5.btnBack = arg0_5:findTF("blur_panel/adapt/top/back_btn")
	arg0_5.pageContainer = arg0_5:findTF("pages")
	arg0_5.permanentFinshMask = arg0_5:findTF("pages_finish")
	arg0_5.tabs = arg0_5:findTF("scroll/viewport/content")
	arg0_5.tab = arg0_5:findTF("tab", arg0_5.tabs)
	arg0_5.entranceList = UIItemList.New(arg0_5:findTF("enter/viewport/content"), arg0_5:findTF("enter/viewport/content/btn"))
	arg0_5.windowList = {}
	arg0_5.lockAll = arg0_5:findTF("blur_panel/lock_all")
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

			if arg0_5.pageDic[var0_7.id] ~= nil then
				local var1_7 = var0_7:getConfig("title_res_tag")

				if var1_7 then
					local var2_7 = arg0_5:findTF("red", arg2_7)
					local var3_7 = GetSpriteFromAtlas("activityuitable/" .. var1_7 .. "_text", "") or GetSpriteFromAtlas("activityuitable/activity_text", "")
					local var4_7 = GetSpriteFromAtlas("activityuitable/" .. var1_7 .. "_text_selected", "") or GetSpriteFromAtlas("activityuitable/activity_text_selected", "")

					setImageSprite(arg0_5:findTF("off/text", arg2_7), var3_7, true)
					setImageSprite(arg0_5:findTF("on/text", arg2_7), var4_7, true)
					setActive(var2_7, var0_7:readyToAchieve())
					onToggle(arg0_5, arg2_7, function(arg0_8)
						if arg0_8 then
							arg0_5:selectActivity(var0_7)
						end
					end, SFX_PANEL)
				else
					onToggle(arg0_5, arg2_7, function(arg0_9)
						arg0_5:loadActivityPanel(arg0_9, var0_7)
					end, SFX_PANEL)
				end
			end
		end
	end)
end

function var0_0.didEnter(arg0_10)
	onButton(arg0_10, arg0_10.btnBack, function()
		arg0_10:emit(var0_0.ON_BACK)
	end, SOUND_BACK)
	arg0_10:updateEntrances()
	arg0_10:emit(ActivityMediator.SHOW_NEXT_ACTIVITY)
	arg0_10:bind(var0_0.LOCK_ACT_MAIN, function(arg0_12, arg1_12)
		arg0_10.locked = arg1_12

		setActive(arg0_10.lockAll, arg1_12)
	end)
	arg0_10:bind(var0_0.UPDATE_ACTIVITY, function(arg0_13, arg1_13)
		arg0_10:updateActivity(arg1_13)
	end)
	arg0_10:bind(var0_0.GET_PAGE_BGM, function(arg0_14, arg1_14, arg2_14)
		arg2_14.bgm = arg0_10:getBGM(arg1_14) or arg0_10:getBGM()
	end)
	arg0_10:bind(var0_0.FLUSH_TABS, function()
		arg0_10:flushTabs()
	end)
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

function var0_0.instanceActivityPage(arg0_19, arg1_19)
	local var0_19 = arg1_19:getConfig("page_info")

	if var0_19.class_name and not arg0_19.pageDic[arg1_19.id] and not arg1_19:isEnd() then
		local var1_19 = import("view.activity.subPages." .. var0_19.class_name).New(arg0_19.pageContainer, arg0_19.event, arg0_19.contextData)

		if var1_19:UseSecondPage(arg1_19) then
			var1_19:SetUIName(var0_19.ui_name2)
		else
			var1_19:SetUIName(var0_19.ui_name)
		end

		var1_19:SetShareData(arg0_19.shareData)

		arg0_19.pageDic[arg1_19.id] = var1_19
	end
end

function var0_0.setActivities(arg0_20, arg1_20)
	arg0_20.activities = arg1_20 or {}
	arg0_20.shareData = arg0_20.shareData or ActivityShareData.New()
	arg0_20.pageDic = arg0_20.pageDic or {}

	for iter0_20, iter1_20 in ipairs(arg1_20) do
		arg0_20:instanceActivityPage(iter1_20)
	end

	arg0_20.activity = nil

	table.sort(arg0_20.activities, function(arg0_21, arg1_21)
		local var0_21 = arg0_21:getShowPriority()
		local var1_21 = arg1_21:getShowPriority()

		if var0_21 == var1_21 then
			return arg0_21.id > arg1_21.id
		end

		return var1_21 < var0_21
	end)
	arg0_20:flushTabs()
end

function var0_0.getActivityIndex(arg0_22, arg1_22)
	for iter0_22, iter1_22 in ipairs(arg0_22.activities) do
		if iter1_22.id == arg1_22 then
			return iter0_22
		end
	end

	return nil
end

function var0_0.updateActivity(arg0_23, arg1_23)
	if ActivityConst.PageIdLink[arg1_23.id] then
		arg1_23 = getProxy(ActivityProxy):getActivityById(ActivityConst.PageIdLink[arg1_23.id])
	end

	if arg1_23:isShow() and not arg1_23:isEnd() then
		arg0_23.activities[arg0_23:getActivityIndex(arg1_23.id) or #arg0_23.activities + 1] = arg1_23

		table.sort(arg0_23.activities, function(arg0_24, arg1_24)
			local var0_24 = arg0_24:getShowPriority()
			local var1_24 = arg1_24:getShowPriority()

			if var0_24 == var1_24 then
				return arg0_24.id > arg1_24.id
			end

			return var1_24 < var0_24
		end)

		if not arg0_23.pageDic[arg1_23.id] then
			arg0_23:instanceActivityPage(arg1_23)
		end

		arg0_23:flushTabs()

		if arg0_23.activity and arg0_23.activity.id == arg1_23.id then
			arg0_23.activity = arg1_23

			arg0_23.pageDic[arg1_23.id]:ActionInvoke("Flush", arg1_23)
			setActive(arg0_23.permanentFinshMask, pg.activity_task_permanent[arg1_23.id] and arg1_23:canPermanentFinish())
		end
	end
end

function var0_0.removeActivity(arg0_25, arg1_25)
	local var0_25 = arg0_25:getActivityIndex(arg1_25)

	if var0_25 then
		table.remove(arg0_25.activities, var0_25)
		arg0_25.pageDic[arg1_25]:Destroy()

		arg0_25.pageDic[arg1_25] = nil

		arg0_25:flushTabs()

		if arg0_25.activity and arg0_25.activity.id == arg1_25 then
			arg0_25.activity = nil

			arg0_25:verifyTabs()
		end
	end
end

function var0_0.loadLayers(arg0_26)
	local var0_26 = arg0_26.pageDic[arg0_26.activity.id]

	if var0_26 and var0_26.OnLoadLayers then
		var0_26:OnLoadLayers()
	end
end

function var0_0.removeLayers(arg0_27)
	local var0_27 = arg0_27.pageDic[arg0_27.activity.id]

	if var0_27 and var0_27.OnRemoveLayers then
		var0_27:OnRemoveLayers()
	end
end

function var0_0.GetOnShowEntranceData()
	var1_0 = var1_0 or require("GameCfg.activity.EntranceData")

	assert(var1_0, "Missing EntranceData.lua!")

	var1_0 = var1_0 or {}

	return (_.select(var1_0, function(arg0_29)
		return arg0_29.isShow and arg0_29.isShow()
	end))
end

function var0_0.updateEntrances(arg0_30)
	local var0_30 = var0_0.GetOnShowEntranceData()
	local var1_30 = math.max(#var0_30, 5)

	arg0_30.entranceList:make(function(arg0_31, arg1_31, arg2_31)
		if arg0_31 == UIItemList.EventUpdate then
			local var0_31 = var0_30[arg1_31 + 1]
			local var1_31 = "empty"

			removeOnButton(arg2_31)

			local var2_31 = false

			if var0_31 and table.getCount(var0_31) ~= 0 and var0_31.isShow() then
				onButton(arg0_30, arg2_31, function()
					arg0_30:emit(var0_31.event, var0_31.data[1], var0_31.data[2])
				end, SFX_PANEL)

				var1_31 = var0_31.banner

				if var0_31.isTip then
					var2_31 = var0_31.isTip()
				end
			end

			setActive(arg2_31:Find("tip"), var2_31)
			LoadImageSpriteAsync("activitybanner/" .. var1_31, arg2_31)
		end
	end)
	arg0_30.entranceList:align(var1_30)
end

function var0_0.flushTabs(arg0_33)
	arg0_33.tabsList:align(#arg0_33.activities)
end

function var0_0.selectActivity(arg0_34, arg1_34)
	if arg1_34 and (not arg0_34.activity or arg0_34.activity.id ~= arg1_34.id) then
		local var0_34 = arg0_34.pageDic[arg1_34.id]

		assert(var0_34, "找不到id:" .. arg1_34.id .. "的活动页，请检查")
		var0_34:Load()
		var0_34:ActionInvoke("Flush", arg1_34)
		var0_34:ActionInvoke("ShowOrHide", true)

		if arg0_34.activity and arg0_34.activity.id ~= arg1_34.id then
			arg0_34.pageDic[arg0_34.activity.id]:ActionInvoke("ShowOrHide", false)
		end

		arg0_34.activity = arg1_34
		arg0_34.contextData.id = arg1_34.id

		setActive(arg0_34.permanentFinshMask, pg.activity_task_permanent[arg1_34.id] and arg1_34:canPermanentFinish())
	end
end

function var0_0.checkAutoHideActivity(arg0_35)
	if arg0_35.activity and not arg0_35.activity:isShow() then
		arg0_35:removeActivity(arg0_35.activity.id)
	end
end

function var0_0.verifyTabs(arg0_36, arg1_36)
	local var0_36 = arg0_36:getActivityIndex(arg1_36) or 1
	local var1_36 = arg0_36.tabs:GetChild(var0_36 - 1)

	triggerToggle(var1_36, true)
end

function var0_0.loadActivityPanel(arg0_37, arg1_37, arg2_37)
	local var0_37 = arg2_37:getConfig("type")
	local var1_37

	if var1_37 and arg1_37 then
		arg0_37:emit(ActivityMediator.OPEN_LAYER, var1_37)
	elseif var1_37 and not arg1_37 then
		arg0_37:emit(ActivityMediator.CLOSE_LAYER, var1_37.mediator)
	else
		originalPrint("------活动id为" .. arg2_37.id .. "类型为" .. arg2_37:getConfig("type") .. "的页面不存在")
	end
end

function var0_0.getBonusWindow(arg0_38, arg1_38, arg2_38)
	local var0_38 = arg0_38:findTF(arg1_38)

	if not var0_38 then
		PoolMgr.GetInstance():GetUI("ActivitybonusWindow", true, function(arg0_39)
			SetParent(arg0_39, arg0_38._tf, false)

			arg0_39.name = arg1_38

			arg2_38(arg0_39)
		end)
	else
		arg2_38(var0_38)
	end
end

function var0_0.ShowWindow(arg0_40, arg1_40, arg2_40)
	local var0_40 = arg1_40.__cname

	if not arg0_40.windowList[var0_40] then
		arg0_40:getBonusWindow(var0_40, function(arg0_41)
			arg0_40.windowList[var0_40] = arg1_40.New(tf(arg0_41), arg0_40)

			arg0_40.windowList[var0_40]:Show(arg2_40)
		end)
	else
		arg0_40.windowList[var0_40]:Show(arg2_40)
	end
end

function var0_0.HideWindow(arg0_42, arg1_42)
	local var0_42 = arg1_42.__cname

	if not arg0_42.windowList[var0_42] then
		return
	end

	arg0_42.windowList[var0_42]:Hide()
end

function var0_0.ShowAwardWindow(arg0_43, arg1_43, arg2_43, arg3_43)
	arg0_43.awardWindow:ExecuteAction("Flush", arg1_43, arg2_43, arg3_43)
end

function var0_0.OnChargeSuccess(arg0_44, arg1_44)
	arg0_44.chargeTipWindow:ExecuteAction("Show", arg1_44)
end

function var0_0.willExit(arg0_45)
	arg0_45.shareData = nil

	for iter0_45, iter1_45 in pairs(arg0_45.pageDic) do
		iter1_45:Destroy()
	end

	for iter2_45, iter3_45 in pairs(arg0_45.windowList) do
		iter3_45:Dispose()
	end

	if arg0_45.awardWindow then
		arg0_45.awardWindow:Destroy()

		arg0_45.awardWindow = nil
	end

	if arg0_45.chargeTipWindow then
		arg0_45.chargeTipWindow:Destroy()

		arg0_45.chargeTipWindow = nil
	end
end

return var0_0
