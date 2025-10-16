local var0_0 = class("CoreActivityMainScene", import("view.activity.ActivityMainScene"))

function var0_0.getUIName(arg0_1)
	return nil
end

var0_0.optionsPath = {
	"adapt/top/btn_home"
}

function var0_0.PlayBGM(arg0_2)
	return
end

function var0_0.init(arg0_3)
	arg0_3.btnBack = arg0_3._tf:Find("adapt/top/btn_back")
	arg0_3.btnSkin = arg0_3._tf:Find("adapt/btn_skin")
	arg0_3.pageContainer = arg0_3._tf:Find("page_list")
	arg0_3.tabs = arg0_3._tf:Find("adapt/tabs")
	arg0_3.windowList = {}
	arg0_3.awardWindow = AwardWindow.New(arg0_3._tf, arg0_3.event)
	arg0_3.chargeTipWindow = ChargeTipWindow.New(arg0_3._tf, arg0_3.event)
	arg0_3.tabsList = UIItemList.New(arg0_3.tabs, arg0_3.tabs:GetChild(0))

	arg0_3.tabsList:make(function(arg0_4, arg1_4, arg2_4)
		if arg0_4 == UIItemList.EventUpdate then
			local var0_4 = underscore.detect(arg0_3.activities, function(arg0_5)
				return tostring(arg0_5:getConfig("is_show")) == arg2_4.name
			end)

			if not var0_4 or var0_4:isEnd() then
				setActive(arg2_4, false)
			elseif not arg0_3.pageDic[var0_4.id] then
				warning(string.format("without page in act:", var0_4.id))
			else
				local var1_4 = arg0_3.pageDic[var0_4.id]
				local var2_4 = arg2_4:Find("tip")
				local var3_4 = var1_4:IsShowReminder()

				if var3_4 == nil then
					setActive(var2_4, var0_4:readyToAchieve())
				else
					setActive(var2_4, var3_4)
				end

				onToggle(arg0_3, arg2_4, function(arg0_6)
					if arg0_6 then
						arg0_3:selectActivity(var0_4)
					end
				end, SFX_PANEL)
			end
		end
	end)
end

function var0_0.didEnter(arg0_7)
	arg0_7:bind(var0_0.UPDATE_ACTIVITY, function(arg0_8, arg1_8)
		arg0_7:updateActivity(arg1_8)
	end)
	arg0_7:bind(var0_0.GET_PAGE_BGM, function(arg0_9, arg1_9, arg2_9)
		arg2_9.bgm = arg0_7:getBGM(arg1_9) or arg0_7:getBGM()
	end)
	arg0_7:bind(var0_0.FLUSH_TABS, function()
		arg0_7:flushTabs()
	end)
	onButton(arg0_7, arg0_7.btnBack, function()
		arg0_7:emit(var0_0.ON_BACK)
	end, SOUND_BACK)

	if arg0_7.btnSkin then
		onButton(arg0_7, arg0_7.btnSkin, function()
			arg0_7:emit(ActivityMediator.GO_CHANGE_SHOP)
		end, SFX_PANEL)
	end

	arg0_7:emit(ActivityMediator.SHOW_NEXT_ACTIVITY, arg0_7.contextData.coreName)
end

function var0_0.setActivities(arg0_13, arg1_13)
	arg0_13.activities = underscore.filter(arg1_13 or {}, function(arg0_14)
		return not arg0_14:isEnd()
	end)
	arg0_13.shareData = arg0_13.shareData or ActivityShareData.New()
	arg0_13.pageDic = arg0_13.pageDic or {}

	for iter0_13, iter1_13 in ipairs(arg0_13.activities) do
		arg0_13:instanceActivityPage(iter1_13)
	end

	table.sort(arg0_13.activities, CompareFuncs({
		function(arg0_15)
			return arg0_15:getShowPriority()
		end,
		function(arg0_16)
			return -arg0_16.id
		end
	}))
	arg0_13:flushTabs()
end

function var0_0.updateActivity(arg0_17, arg1_17)
	if ActivityConst.PageIdLink[arg1_17.id] then
		arg1_17 = getProxy(ActivityProxy):getActivityById(ActivityConst.PageIdLink[arg1_17.id])
	end

	if arg1_17:isShow() and arg1_17:isCorePage(arg0_17.contextData.coreName) and not arg1_17:isEnd() then
		arg0_17.activities[arg0_17:getActivityIndex(arg1_17.id) or #arg0_17.activities + 1] = arg1_17

		table.sort(arg0_17.activities, CompareFuncs({
			function(arg0_18)
				return -arg0_18:getShowPriority()
			end,
			function(arg0_19)
				return -arg0_19.id
			end
		}))

		if not arg0_17.pageDic[arg1_17.id] then
			arg0_17:instanceActivityPage(arg1_17)
		end

		arg0_17:flushTabs()

		if arg0_17.activity and arg0_17.activity.id == arg1_17.id then
			arg0_17.activity = arg1_17

			arg0_17.pageDic[arg1_17.id]:ActionInvoke("Flush", arg1_17)
			arg0_17:verifyTabs(arg0_17.activity.id)
		end
	end
end

function var0_0.instanceActivityPage(arg0_20, arg1_20)
	var0_0.super.instanceActivityPage(arg0_20, arg1_20)

	for iter0_20, iter1_20 in pairs(arg0_20.pageDic) do
		iter1_20:SetCoreActivityUI(arg0_20)
	end
end

function var0_0.updateEntrances(arg0_21)
	return
end

function var0_0.flushTabs(arg0_22)
	arg0_22.tabsList:align(arg0_22.tabs.childCount)
end

function var0_0.selectActivity(arg0_23, arg1_23)
	if arg1_23 and (not arg0_23.activity or arg0_23.activity.id ~= arg1_23.id) then
		local var0_23 = arg0_23.pageDic[arg1_23.id]

		assert(var0_23, "找不到id:" .. arg1_23.id .. "的活动页，请检查")
		var0_23:Load()
		var0_23:ActionInvoke("Flush", arg1_23)
		var0_23:ActionInvoke("ShowOrHide", true)

		if arg0_23.activity and arg0_23.activity.id ~= arg1_23.id then
			arg0_23.pageDic[arg0_23.activity.id]:ActionInvoke("ShowOrHide", false)
		end

		arg0_23.activity = arg1_23
		arg0_23.contextData.id = arg1_23.id
	end
end

function var0_0.verifyTabs(arg0_24, arg1_24)
	local var0_24 = arg0_24.activities[arg0_24:getActivityIndex(arg1_24) or arg0_24:getActivityIndex(arg0_24:GetActiveActivity()) or 1]

	if var0_24 == nil then
		return
	end

	local var1_24 = var0_24:getConfig("is_show")
	local var2_24 = arg0_24.tabs:Find(tostring(var1_24))

	triggerToggle(var2_24, true)
end

function var0_0.GetActiveActivity(arg0_25)
	for iter0_25, iter1_25 in ipairs(arg0_25.activities) do
		if not iter1_25:isEnd() then
			return iter1_25.id
		end
	end
end

function var0_0.onBackPressed(arg0_26)
	local var0_26 = arg0_26.pageDic[arg0_26.activity.id]

	if var0_26:IsShowingPopWindow() then
		var0_26:ClosePopWindow()

		return
	end

	var0_0.super.onBackPressed(arg0_26)
end

function var0_0.getActClass(arg0_27, arg1_27)
	return _G[arg1_27]
end

return var0_0
