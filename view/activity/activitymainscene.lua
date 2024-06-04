local var0 = class("ActivityMainScene", import("..base.BaseUI"))

var0.LOCK_ACT_MAIN = "ActivityMainScene:LOCK_ACT_MAIN"
var0.UPDATE_ACTIVITY = "ActivityMainScene:UPDATE_ACTIVITY"
var0.GET_PAGE_BGM = "ActivityMainScene.GET_PAGE_BGM"
var0.FLUSH_TABS = "ActivityMainScene.FLUSH_TABS"

function var0.preload(arg0, arg1)
	arg1()
end

function var0.getUIName(arg0)
	return "ActivityMainUI"
end

function var0.PlayBGM(arg0)
	return
end

function var0.onBackPressed(arg0)
	if arg0.locked then
		return
	end

	for iter0, iter1 in pairs(arg0.windowList) do
		if isActive(iter1._tf) then
			arg0:HideWindow(iter1.class)

			return
		end
	end

	if arg0.awardWindow and arg0.awardWindow:GetLoaded() and arg0.awardWindow:isShowing() then
		arg0.awardWindow:Hide()

		return
	end

	arg0:emit(var0.ON_BACK_PRESSED)
end

local var1

function var0.init(arg0)
	arg0.btnBack = arg0:findTF("blur_panel/adapt/top/back_btn")
	arg0.pageContainer = arg0:findTF("pages")
	arg0.permanentFinshMask = arg0:findTF("pages_finish")
	arg0.tabs = arg0:findTF("scroll/viewport/content")
	arg0.tab = arg0:findTF("tab", arg0.tabs)
	arg0.entranceList = UIItemList.New(arg0:findTF("enter/viewport/content"), arg0:findTF("enter/viewport/content/btn"))
	arg0.windowList = {}
	arg0.lockAll = arg0:findTF("blur_panel/lock_all")
	arg0.awardWindow = AwardWindow.New(arg0._tf, arg0.event)
	arg0.chargeTipWindow = ChargeTipWindow.New(arg0._tf, arg0.event)

	setActive(arg0.tab, false)
	setActive(arg0.lockAll, false)
	setActive(arg0.permanentFinshMask, false)
	setText(arg0.permanentFinshMask:Find("piece/Text"), i18n("activity_permanent_tips2"))
	onButton(arg0, arg0.permanentFinshMask:Find("piece/arrow/Image"), function()
		arg0:emit(ActivityMediator.FINISH_ACTIVITY_PERMANENT)
	end, SFX_PANEL)

	arg0.tabsList = UIItemList.New(arg0.tabs, arg0.tab)

	arg0.tabsList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0.activities[arg1 + 1]

			if arg0.pageDic[var0.id] ~= nil then
				local var1 = var0:getConfig("title_res_tag")

				if var1 then
					local var2 = arg0:findTF("red", arg2)
					local var3 = GetSpriteFromAtlas("activityuitable/" .. var1 .. "_text", "") or GetSpriteFromAtlas("activityuitable/activity_text", "")
					local var4 = GetSpriteFromAtlas("activityuitable/" .. var1 .. "_text_selected", "") or GetSpriteFromAtlas("activityuitable/activity_text_selected", "")

					setImageSprite(arg0:findTF("off/text", arg2), var3, true)
					setImageSprite(arg0:findTF("on/text", arg2), var4, true)
					setActive(var2, var0:readyToAchieve())
					onToggle(arg0, arg2, function(arg0)
						if arg0 then
							arg0:selectActivity(var0)
						end
					end, SFX_PANEL)
				else
					onToggle(arg0, arg2, function(arg0)
						arg0:loadActivityPanel(arg0, var0)
					end, SFX_PANEL)
				end
			end
		end
	end)
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.btnBack, function()
		arg0:emit(var0.ON_BACK)
	end, SOUND_BACK)
	arg0:updateEntrances()
	arg0:emit(ActivityMediator.SHOW_NEXT_ACTIVITY)
	arg0:bind(var0.LOCK_ACT_MAIN, function(arg0, arg1)
		arg0.locked = arg1

		setActive(arg0.lockAll, arg1)
	end)
	arg0:bind(var0.UPDATE_ACTIVITY, function(arg0, arg1)
		arg0:updateActivity(arg1)
	end)
	arg0:bind(var0.GET_PAGE_BGM, function(arg0, arg1, arg2)
		arg2.bgm = arg0:getBGM(arg1) or arg0:getBGM()
	end)
	arg0:bind(var0.FLUSH_TABS, function()
		arg0:flushTabs()
	end)
end

function var0.setPlayer(arg0, arg1)
	arg0.shareData:SetPlayer(arg1)
end

function var0.setFlagShip(arg0, arg1)
	arg0.shareData:SetFlagShip(arg1)
end

function var0.updateTaskLayers(arg0)
	if not arg0.activity then
		return
	end

	arg0:updateActivity(arg0.activity)
end

function var0.instanceActivityPage(arg0, arg1)
	local var0 = arg1:getConfig("page_info")

	if var0.class_name and not arg0.pageDic[arg1.id] and not arg1:isEnd() then
		local var1 = import("view.activity.subPages." .. var0.class_name).New(arg0.pageContainer, arg0.event, arg0.contextData)

		if var1:UseSecondPage(arg1) then
			var1:SetUIName(var0.ui_name2)
		else
			var1:SetUIName(var0.ui_name)
		end

		var1:SetShareData(arg0.shareData)

		arg0.pageDic[arg1.id] = var1
	end
end

function var0.setActivities(arg0, arg1)
	arg0.activities = arg1 or {}
	arg0.shareData = arg0.shareData or ActivityShareData.New()
	arg0.pageDic = arg0.pageDic or {}

	for iter0, iter1 in ipairs(arg1) do
		arg0:instanceActivityPage(iter1)
	end

	arg0.activity = nil

	table.sort(arg0.activities, function(arg0, arg1)
		local var0 = arg0:getShowPriority()
		local var1 = arg1:getShowPriority()

		if var0 == var1 then
			return arg0.id > arg1.id
		end

		return var1 < var0
	end)
	arg0:flushTabs()
end

function var0.getActivityIndex(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.activities) do
		if iter1.id == arg1 then
			return iter0
		end
	end

	return nil
end

function var0.updateActivity(arg0, arg1)
	if ActivityConst.PageIdLink[arg1.id] then
		arg1 = getProxy(ActivityProxy):getActivityById(ActivityConst.PageIdLink[arg1.id])
	end

	if arg1:isShow() and not arg1:isEnd() then
		arg0.activities[arg0:getActivityIndex(arg1.id) or #arg0.activities + 1] = arg1

		table.sort(arg0.activities, function(arg0, arg1)
			local var0 = arg0:getShowPriority()
			local var1 = arg1:getShowPriority()

			if var0 == var1 then
				return arg0.id > arg1.id
			end

			return var1 < var0
		end)

		if not arg0.pageDic[arg1.id] then
			arg0:instanceActivityPage(arg1)
		end

		arg0:flushTabs()

		if arg0.activity and arg0.activity.id == arg1.id then
			arg0.activity = arg1

			arg0.pageDic[arg1.id]:ActionInvoke("Flush", arg1)
			setActive(arg0.permanentFinshMask, pg.activity_task_permanent[arg1.id] and arg1:canPermanentFinish())
		end
	end
end

function var0.removeActivity(arg0, arg1)
	local var0 = arg0:getActivityIndex(arg1)

	if var0 then
		table.remove(arg0.activities, var0)
		arg0.pageDic[arg1]:Destroy()

		arg0.pageDic[arg1] = nil

		arg0:flushTabs()

		if arg0.activity and arg0.activity.id == arg1 then
			arg0.activity = nil

			arg0:verifyTabs()
		end
	end
end

function var0.loadLayers(arg0)
	local var0 = arg0.pageDic[arg0.activity.id]

	if var0 and var0.OnLoadLayers then
		var0:OnLoadLayers()
	end
end

function var0.removeLayers(arg0)
	local var0 = arg0.pageDic[arg0.activity.id]

	if var0 and var0.OnRemoveLayers then
		var0:OnRemoveLayers()
	end
end

function var0.GetOnShowEntranceData()
	var1 = var1 or require("GameCfg.activity.EntranceData")

	assert(var1, "Missing EntranceData.lua!")

	var1 = var1 or {}

	return (_.select(var1, function(arg0)
		return arg0.isShow and arg0.isShow()
	end))
end

function var0.updateEntrances(arg0)
	local var0 = var0.GetOnShowEntranceData()
	local var1 = math.max(#var0, 5)

	arg0.entranceList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var0[arg1 + 1]
			local var1 = "empty"

			removeOnButton(arg2)

			local var2 = false

			if var0 and table.getCount(var0) ~= 0 and var0.isShow() then
				onButton(arg0, arg2, function()
					arg0:emit(var0.event, var0.data[1], var0.data[2])
				end, SFX_PANEL)

				var1 = var0.banner

				if var0.isTip then
					var2 = var0.isTip()
				end
			end

			setActive(arg2:Find("tip"), var2)
			LoadImageSpriteAsync("activitybanner/" .. var1, arg2)
		end
	end)
	arg0.entranceList:align(var1)
end

function var0.flushTabs(arg0)
	arg0.tabsList:align(#arg0.activities)
end

function var0.selectActivity(arg0, arg1)
	if arg1 and (not arg0.activity or arg0.activity.id ~= arg1.id) then
		local var0 = arg0.pageDic[arg1.id]

		assert(var0, "找不到id:" .. arg1.id .. "的活动页，请检查")
		var0:Load()
		var0:ActionInvoke("Flush", arg1)
		var0:ActionInvoke("ShowOrHide", true)

		if arg0.activity and arg0.activity.id ~= arg1.id then
			arg0.pageDic[arg0.activity.id]:ActionInvoke("ShowOrHide", false)
		end

		arg0.activity = arg1
		arg0.contextData.id = arg1.id

		setActive(arg0.permanentFinshMask, pg.activity_task_permanent[arg1.id] and arg1:canPermanentFinish())
	end
end

function var0.verifyTabs(arg0, arg1)
	local var0 = arg0:getActivityIndex(arg1) or 1
	local var1 = arg0.tabs:GetChild(var0 - 1)

	triggerToggle(var1, true)
end

function var0.loadActivityPanel(arg0, arg1, arg2)
	local var0 = arg2:getConfig("type")
	local var1

	if var1 and arg1 then
		arg0:emit(ActivityMediator.OPEN_LAYER, var1)
	elseif var1 and not arg1 then
		arg0:emit(ActivityMediator.CLOSE_LAYER, var1.mediator)
	else
		originalPrint("------活动id为" .. arg2.id .. "类型为" .. arg2:getConfig("type") .. "的页面不存在")
	end
end

function var0.getBonusWindow(arg0, arg1, arg2)
	local var0 = arg0:findTF(arg1)

	if not var0 then
		PoolMgr.GetInstance():GetUI("ActivitybonusWindow", true, function(arg0)
			SetParent(arg0, arg0._tf, false)

			arg0.name = arg1

			arg2(arg0)
		end)
	else
		arg2(var0)
	end
end

function var0.ShowWindow(arg0, arg1, arg2)
	local var0 = arg1.__cname

	if not arg0.windowList[var0] then
		arg0:getBonusWindow(var0, function(arg0)
			arg0.windowList[var0] = arg1.New(tf(arg0), arg0)

			arg0.windowList[var0]:Show(arg2)
		end)
	else
		arg0.windowList[var0]:Show(arg2)
	end
end

function var0.HideWindow(arg0, arg1)
	local var0 = arg1.__cname

	if not arg0.windowList[var0] then
		return
	end

	arg0.windowList[var0]:Hide()
end

function var0.ShowAwardWindow(arg0, arg1, arg2, arg3)
	arg0.awardWindow:ExecuteAction("Flush", arg1, arg2, arg3)
end

function var0.OnChargeSuccess(arg0, arg1)
	arg0.chargeTipWindow:ExecuteAction("Show", arg1)
end

function var0.willExit(arg0)
	arg0.shareData = nil

	for iter0, iter1 in pairs(arg0.pageDic) do
		iter1:Destroy()
	end

	for iter2, iter3 in pairs(arg0.windowList) do
		iter3:Dispose()
	end

	if arg0.awardWindow then
		arg0.awardWindow:Destroy()

		arg0.awardWindow = nil
	end

	if arg0.chargeTipWindow then
		arg0.chargeTipWindow:Destroy()

		arg0.chargeTipWindow = nil
	end
end

return var0
