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

			if not var0_4 or not arg0_3.pageDic[var0_4.id] then
				warning(arg2_4.name, var0_4.id)

				return
			end

			if arg0_3.pageDic[var0_4.id] ~= nil then
				local var1_4 = arg0_3:findTF("tip", arg2_4)

				setActive(var1_4, var0_4:readyToAchieve())
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
	onButton(arg0_7, arg0_7.btnSkin, function()
		arg0_7:emit(ActivityMediator.GO_CHANGE_SHOP)
	end, SFX_PANEL)
	arg0_7:emit(ActivityMediator.SHOW_NEXT_ACTIVITY)
end

function var0_0.setActivities(arg0_13, arg1_13)
	arg0_13.activities = arg1_13 or {}
	arg0_13.shareData = arg0_13.shareData or ActivityShareData.New()
	arg0_13.pageDic = arg0_13.pageDic or {}

	for iter0_13, iter1_13 in ipairs(arg1_13) do
		arg0_13:instanceActivityPage(iter1_13)
	end

	arg0_13.activity = nil

	table.sort(arg0_13.activities, CompareFuncs({
		function(arg0_14)
			return -arg0_14:getShowPriority()
		end,
		function(arg0_15)
			return -arg0_15.id
		end
	}))
	arg0_13:flushTabs()
end

function var0_0.updateActivity(arg0_16, arg1_16)
	if ActivityConst.PageIdLink[arg1_16.id] then
		arg1_16 = getProxy(ActivityProxy):getActivityById(ActivityConst.PageIdLink[arg1_16.id])
	end

	if arg1_16:isShow() and arg1_16:isCorePage(arg0_16.contextData.coreName) and not arg1_16:isEnd() then
		arg0_16.activities[arg0_16:getActivityIndex(arg1_16.id) or #arg0_16.activities + 1] = arg1_16

		table.sort(arg0_16.activities, CompareFuncs({
			function(arg0_17)
				return -arg0_17:getShowPriority()
			end,
			function(arg0_18)
				return -arg0_18.id
			end
		}))

		if not arg0_16.pageDic[arg1_16.id] then
			arg0_16:instanceActivityPage(arg1_16)
		end

		arg0_16:flushTabs()

		if arg0_16.activity and arg0_16.activity.id == arg1_16.id then
			arg0_16.activity = arg1_16

			arg0_16.pageDic[arg1_16.id]:ActionInvoke("Flush", arg1_16)
		end
	end
end

function var0_0.updateEntrances(arg0_19)
	return
end

function var0_0.flushTabs(arg0_20)
	arg0_20.tabsList:align(#arg0_20.activities)
end

function var0_0.selectActivity(arg0_21, arg1_21)
	if arg1_21 and (not arg0_21.activity or arg0_21.activity.id ~= arg1_21.id) then
		local var0_21 = arg0_21.pageDic[arg1_21.id]

		assert(var0_21, "找不到id:" .. arg1_21.id .. "的活动页，请检查")
		var0_21:Load()
		var0_21:ActionInvoke("Flush", arg1_21)
		var0_21:ActionInvoke("ShowOrHide", true)

		if arg0_21.activity and arg0_21.activity.id ~= arg1_21.id then
			arg0_21.pageDic[arg0_21.activity.id]:ActionInvoke("ShowOrHide", false)
		end

		arg0_21.activity = arg1_21
		arg0_21.contextData.id = arg1_21.id
	end
end

function var0_0.verifyTabs(arg0_22, arg1_22)
	local var0_22 = underscore.detect(arg0_22.activities, function(arg0_23)
		return arg0_23.id == arg1_22
	end)
	local var1_22 = var0_22 and var0_22:getConfig("is_show") or 1
	local var2_22 = arg0_22.tabs:Find(tostring(var1_22))

	triggerToggle(var2_22, true)
end

function var0_0.getActClass(arg0_24, arg1_24)
	return _G[arg1_24]
end

return var0_0
