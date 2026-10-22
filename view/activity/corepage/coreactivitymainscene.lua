local var0_0 = class("CoreActivityMainScene", import("view.activity.ActivityMainScene"))

function var0_0.getUIName(arg0_1)
	return nil
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {}

	if arg0_2:IsImageTgName() then
		local var1_2 = getProxy(ActivityProxy):getCorePanelActivities(arg0_2.contextData.coreName)

		warning(PrintTable(var1_2))

		for iter0_2, iter1_2 in ipairs(var1_2) do
			local var2_2 = string.lower(iter1_2:getConfig("title_res_tag"))
			local var3_2 = "coreactivityuitable/" .. var2_2 .. "_text"
			local var4_2 = "coreactivityuitable/" .. var2_2 .. "_text_selected"
			local var5_2 = checkABExist(var3_2)
			local var6_2 = checkABExist(var4_2)

			if var5_2 then
				table.insert(var0_2, var3_2)
			end

			if var6_2 then
				table.insert(var0_2, var4_2)
			end
		end
	end

	table.insertto(var0_2, var0_0.super.getResource(arg0_2, arg1_2))

	return var0_2
end

var0_0.optionsPath = {
	"adapt/top/btn_home"
}

function var0_0.PlayBGM(arg0_3)
	return
end

function var0_0.init(arg0_4)
	arg0_4.btnBack = arg0_4._tf:Find("adapt/top/btn_back")
	arg0_4.btnSkin = arg0_4._tf:Find("adapt/btn_skin")
	arg0_4.pageContainer = arg0_4._tf:Find("page_list")
	arg0_4.tabs = arg0_4._tf:Find("adapt/tabs")
	arg0_4.windowList = {}
	arg0_4.awardWindow = AwardWindow.New(arg0_4._tf, arg0_4.event)
	arg0_4.chargeTipWindow = ChargeTipWindow.New(arg0_4._tf, arg0_4.event)
	arg0_4.tabsList = UIItemList.New(arg0_4.tabs, arg0_4.tabs:GetChild(0))

	arg0_4.tabsList:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventUpdate then
			local var0_5 = underscore.detect(arg0_4.activities, function(arg0_6)
				return tostring(arg0_6:getConfig("is_show")) == arg2_5.name
			end)

			if not var0_5 or var0_5:isEnd() then
				setActive(arg2_5, false)
			elseif not arg0_4.pageDic[var0_5.id] then
				warning(string.format("without page in act:", var0_5.id))
			else
				local var1_5 = arg0_4.pageDic[var0_5.id]
				local var2_5 = arg2_5:Find("tip")
				local var3_5 = var1_5:IsShowReminder()

				if var3_5 == nil then
					setActive(var2_5, var0_5:readyToAchieve())
				else
					setActive(var2_5, var3_5)
				end

				onToggle(arg0_4, arg2_5, function(arg0_7)
					if arg0_7 then
						arg0_4:selectActivity(var0_5)
					end
				end, SFX_PANEL)
			end
		end
	end)

	arg0_4.switchCount = 0
end

function var0_0.didEnter(arg0_8)
	arg0_8:bind(var0_0.UPDATE_ACTIVITY, function(arg0_9, arg1_9)
		arg0_8:updateActivity(arg1_9)
	end)
	arg0_8:bind(var0_0.GET_PAGE_BGM, function(arg0_10, arg1_10, arg2_10)
		arg2_10.bgm = arg0_8:getBGM(arg1_10) or arg0_8:getBGM()
	end)
	arg0_8:bind(var0_0.FLUSH_TABS, function()
		arg0_8:flushTabs()
	end)
	onButton(arg0_8, arg0_8.btnBack, function()
		arg0_8:emit(var0_0.ON_BACK)
	end, SOUND_BACK)

	if arg0_8.btnSkin then
		onButton(arg0_8, arg0_8.btnSkin, function()
			arg0_8:emit(ActivityMediator.GO_CHANGE_SHOP)
		end, SFX_PANEL)
	end

	arg0_8:emit(ActivityMediator.SHOW_NEXT_ACTIVITY, arg0_8.contextData.coreName)
end

function var0_0.setActivities(arg0_14, arg1_14)
	arg0_14.activities = underscore.filter(arg1_14 or {}, function(arg0_15)
		return not arg0_15:isEnd()
	end)
	arg0_14.shareData = arg0_14.shareData or ActivityShareData.New()
	arg0_14.pageDic = arg0_14.pageDic or {}

	for iter0_14, iter1_14 in ipairs(arg0_14.activities) do
		arg0_14:instanceActivityPage(iter1_14)
	end

	table.sort(arg0_14.activities, CompareFuncs({
		function(arg0_16)
			return arg0_16:getShowPriority()
		end,
		function(arg0_17)
			return -arg0_17.id
		end
	}))
	arg0_14:flushTabs()
end

function var0_0.updateActivity(arg0_18, arg1_18)
	if ActivityConst.PageIdLink[arg1_18.id] then
		arg1_18 = getProxy(ActivityProxy):getActivityById(ActivityConst.PageIdLink[arg1_18.id])
	end

	if arg1_18:isShow() and arg1_18:isCorePage(arg0_18.contextData.coreName) and not arg1_18:isEnd() then
		arg0_18.activities[arg0_18:getActivityIndex(arg1_18.id) or #arg0_18.activities + 1] = arg1_18

		table.sort(arg0_18.activities, CompareFuncs({
			function(arg0_19)
				return arg0_19:getShowPriority()
			end,
			function(arg0_20)
				return -arg0_20.id
			end
		}))

		if not arg0_18.pageDic[arg1_18.id] then
			arg0_18:instanceActivityPage(arg1_18)
		end

		arg0_18:flushTabs()

		if arg0_18.activity and arg0_18.activity.id == arg1_18.id then
			arg0_18.activity = arg1_18

			arg0_18.pageDic[arg1_18.id]:ActionInvoke("Flush", arg1_18)
			arg0_18:verifyTabs(arg0_18.activity.id)
		end
	end
end

function var0_0.instanceActivityPage(arg0_21, arg1_21)
	var0_0.super.instanceActivityPage(arg0_21, arg1_21)

	for iter0_21, iter1_21 in pairs(arg0_21.pageDic) do
		iter1_21:SetCoreActivityUI(arg0_21)
	end
end

function var0_0.updateEntrances(arg0_22)
	return
end

function var0_0.flushTabs(arg0_23)
	arg0_23.tabsList:align(arg0_23.tabs.childCount)
end

function var0_0.IsImageTgName(arg0_24)
	return false
end

function var0_0.OnToggleName(arg0_25, arg1_25, arg2_25)
	local var0_25 = arg2_25:getConfig("title_res_tag")
	local var1_25 = "coreactivityuitable/" .. var0_25 .. "_text"
	local var2_25 = "coreactivityuitable/" .. var0_25 .. "_text_selected"

	setText(arg1_25:Find("on/name"), i18n(var0_25))
	setText(arg1_25:Find("off/name"), i18n(var0_25))

	local var3_25 = arg0_25:IsImageTgName()
	local var4_25 = checkABExist(var1_25)
	local var5_25 = checkABExist(var2_25)

	setActive(arg1_25:Find("off/imgName"), var3_25 and var4_25)
	setActive(arg1_25:Find("off/name"), not var3_25 or not var4_25)
	setActive(arg1_25:Find("on/imgName"), var3_25 and var5_25)
	setActive(arg1_25:Find("on/name"), not var3_25 or not var5_25)

	if arg0_25:IsImageTgName() then
		local var6_25 = string.lower(var0_25)

		if var4_25 then
			setImageSprite(arg1_25:Find("off/imgName"), GetSpriteFromAtlas(var1_25, ""), true)
		end

		if var5_25 then
			setImageSprite(arg1_25:Find("on/imgName"), GetSpriteFromAtlas(var2_25, ""), true)
		end
	end
end

function var0_0.selectActivity(arg0_26, arg1_26)
	if arg0_26.nextActivity == arg1_26 or not arg0_26.nextActivity and arg0_26.activity and arg1_26.id == arg0_26.activity.id then
		return
	end

	local var0_26 = {}

	if arg0_26.activity and not arg0_26.nextActivity then
		arg0_26.switchCount = arg0_26.switchCount + 1

		table.insert(var0_26, function(arg0_27)
			arg0_26.pageDic[arg0_26.activity.id]:ActionInvoke("SwitchOut", function()
				arg0_26.switchCount = arg0_26.switchCount - 1

				arg0_27()
			end)
		end)
	end

	if not arg0_26.activity or arg0_26.activity.id ~= arg1_26.id then
		local var1_26 = arg0_26.pageDic[arg1_26.id]

		assert(var1_26, "找不到id:" .. arg1_26.id .. "的活动页，请检查")

		arg0_26.switchCount = arg0_26.switchCount + 1

		table.insert(var0_26, function(arg0_29)
			var1_26:Load()
			var1_26:ActionInvoke("ShowOrHide", false)
			var1_26:CallbackInvoke(function()
				arg0_26.switchCount = arg0_26.switchCount - 1

				arg0_29()
			end)
		end)
	end

	arg0_26.nextActivity = arg1_26

	parallelAsync(var0_26, function()
		if arg0_26.switchCount > 0 then
			return
		end

		if arg0_26.activity then
			arg0_26.pageDic[arg0_26.activity.id]:ActionInvoke("ShowOrHide", false)
		end

		arg0_26.activity = arg0_26.nextActivity
		arg0_26.contextData.id = arg0_26.nextActivity.id
		arg0_26.nextActivity = nil

		local var0_31 = arg0_26.pageDic[arg0_26.activity.id]

		var0_31:ActionInvoke("ShowOrHide", true)
		var0_31:ActionInvoke("Flush", arg0_26.activity)

		local var1_31 = table.indexof(arg0_26.activities, arg0_26.activity)

		arg0_26:OnPageSwitchDone(var0_31, var1_31)
	end)
end

function var0_0.OnPageSwitchDone(arg0_32, arg1_32, arg2_32)
	return
end

function var0_0.verifyTabs(arg0_33, arg1_33)
	local var0_33 = arg0_33.activities[arg0_33:getActivityIndex(arg1_33) or arg0_33:getActivityIndex(arg0_33:GetActiveActivity()) or 1]

	if var0_33 == nil then
		return
	end

	local var1_33 = var0_33:getConfig("is_show")
	local var2_33 = arg0_33.tabs:Find(tostring(var1_33))

	if var2_33 then
		triggerToggle(var2_33, true)
	end
end

function var0_0.GetActiveActivity(arg0_34)
	for iter0_34, iter1_34 in ipairs(arg0_34.activities) do
		if not iter1_34:isEnd() then
			return iter1_34.id
		end
	end
end

function var0_0.GetActivityIdByPageClass(arg0_35, arg1_35)
	for iter0_35, iter1_35 in ipairs(arg0_35.activities or {}) do
		local var0_35 = iter1_35:getConfig("page_info")

		if var0_35 and var0_35.class_name == arg1_35 then
			return iter1_35.id
		end
	end

	return nil
end

function var0_0.onBackPressed(arg0_36)
	local var0_36 = arg0_36.pageDic[arg0_36.activity.id]

	if var0_36:IsShowingPopWindow() then
		var0_36:ClosePopWindow()

		return
	end

	var0_0.super.onBackPressed(arg0_36)
end

function var0_0.getActClass(arg0_37, arg1_37)
	return _G[arg1_37]
end

return var0_0
