local var0_0 = class("IslandSeasonActivityPanel", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IslandSeasonActivityPanel"
end

function var0_0.OnLoaded(arg0_2)
	local var0_2 = arg0_2._tf:GetComponent("ItemList").prefabItem:ToTable()

	for iter0_2, iter1_2 in ipairs({
		"rtTabsContent",
		"rtTabsTpl",
		"rtPages",
		"rtPagesEmpty"
	}) do
		arg0_2[iter1_2] = var0_2[iter0_2].transform
	end
end

function var0_0.OnInit(arg0_3)
	arg0_3.tabsList = UIItemList.New(arg0_3.rtTabsContent, arg0_3.rtTabsTpl)

	arg0_3.tabsList:make(function(arg0_4, arg1_4, arg2_4)
		arg1_4 = arg1_4 + 1

		if arg0_4 == UIItemList.EventUpdate then
			local var0_4 = arg0_3.activities[arg1_4]
			local var1_4 = var0_4 and var0_4.id or 0

			arg2_4.name = var1_4

			if var0_4 then
				local var2_4 = var0_4:getIslandConfig("title_res_tag")

				setText(arg2_4:Find("on/Text"), var2_4)
				setText(arg2_4:Find("off/Text"), var2_4)
				setActive(arg2_4:Find("red"), var0_4:readyToAchieve())
			else
				setText(arg2_4:Find("on/Text"), i18n("island_no_activity"))
				setText(arg2_4:Find("on/Text/en"), i18n("island_activity_decorative_word"))
				setText(arg2_4:Find("off/Text"), i18n("island_no_activity"))
			end

			local var3_4 = arg0_3.pageDic[var1_4]

			onToggle(arg0_3, arg2_4, function(arg0_5)
				if var3_4 and arg0_5 then
					arg0_3:selectActivity(var0_4)
				end
			end, SFX_PANEL)
		end
	end)

	arg0_3.switchCount = 0
end

function var0_0.Show(arg0_6)
	var0_0.super.Show(arg0_6)
	arg0_6:Flush()
	IslandGuideChecker.CheckGuide("ISLAND_GUIDE_14")
end

function var0_0.Flush(arg0_7)
	if not arg0_7:isShowing() then
		return
	end

	if not arg0_7.activities then
		arg0_7:setActivities(getProxy(ActivityProxy):getIslandPanelActivities())
	end

	if arg0_7.activity then
		arg0_7.pageDic[arg0_7.activity.id]:ExecuteAction("ShowOrHide", true)
	else
		arg0_7:verifyTabs()
	end
end

function var0_0.verifyTabs(arg0_8, arg1_8)
	if #arg0_8.activities > 0 then
		local var0_8 = arg0_8:getActivityIndex(arg1_8) or 1
		local var1_8 = arg0_8.rtTabsContent:GetChild(var0_8 - 1)

		triggerToggle(var1_8, true)
	end
end

function var0_0.getActivityIndex(arg0_9, arg1_9)
	for iter0_9, iter1_9 in ipairs(arg0_9.activities) do
		if iter1_9.id == arg1_9 then
			return iter0_9
		end
	end

	return nil
end

function var0_0.setActivities(arg0_10, arg1_10)
	arg0_10.activities = arg1_10 or {}
	arg0_10.shareData = arg0_10.shareData or ActivityShareData.New()
	arg0_10.pageDic = arg0_10.pageDic or {}

	for iter0_10, iter1_10 in ipairs(arg1_10) do
		arg0_10:instanceActivityPage(iter1_10)
	end

	arg0_10.activity = nil

	table.sort(arg0_10.activities, CompareFuncs({
		function(arg0_11)
			return -arg0_11:getIslandConfig("is_show")
		end,
		function(arg0_12)
			return -arg0_12.id
		end
	}))
	arg0_10:flushTabs()
end

function var0_0.OnTaskUpdate(arg0_13, arg1_13)
	for iter0_13, iter1_13 in pairs(arg0_13.activities) do
		if iter1_13:getConfig("type") == ActivityConst.ACTIVITY_TYPE_TASK_LIST and _.any(_.flatten(iter1_13:getIslandConfig("config_data")), function(arg0_14)
			return arg0_14 == arg1_13
		end) then
			arg0_13:updateActivity(iter1_13)
		end
	end
end

function var0_0.updateActivity(arg0_15, arg1_15)
	local var0_15 = ActivityConst.IslandPageIdLinks[arg1_15.id]

	if var0_15 then
		for iter0_15, iter1_15 in ipairs(var0_15) do
			arg0_15:_updateActivity(getProxy(ActivityProxy):getActivityById(iter1_15))
		end
	else
		arg0_15:_updateActivity(arg1_15)
	end
end

function var0_0._updateActivity(arg0_16, arg1_16)
	if arg1_16:isIslandShow() and not arg1_16:isEnd() then
		arg0_16.activities[arg0_16:getActivityIndex(arg1_16.id) or #arg0_16.activities + 1] = arg1_16

		table.sort(arg0_16.activities, CompareFuncs({
			function(arg0_17)
				return -arg0_17:getIslandConfig("is_show")
			end,
			function(arg0_18)
				return -arg0_18.id
			end
		}))

		if not arg0_16.pageDic[arg1_16.id] then
			arg0_16:instanceActivityPage(arg1_16)
		end

		arg0_16:flushTabs()

		if arg0_16:isShowing() and arg0_16.activity and arg0_16.activity.id == arg1_16.id then
			arg0_16.activity = arg1_16

			arg0_16.pageDic[arg1_16.id]:ActionInvoke("Flush", arg1_16)
		end
	end
end

function var0_0.removeActivity(arg0_19, arg1_19)
	local var0_19 = arg0_19:getActivityIndex(arg1_19)

	if var0_19 then
		table.remove(arg0_19.activities, var0_19)
		arg0_19.pageDic[arg1_19]:Destroy()

		arg0_19.pageDic[arg1_19] = nil

		arg0_19:flushTabs()

		if arg0_19.activity and arg0_19.activity.id == arg1_19 then
			arg0_19.activity = nil

			arg0_19:verifyTabs()
		end
	end
end

function var0_0.getActClass(arg0_20, arg1_20)
	return import("Mod.Island.View.page.activity." .. arg1_20)
end

function var0_0.instanceActivityPage(arg0_21, arg1_21)
	local var0_21 = arg1_21:getIslandConfig("page_info")

	if var0_21.class_name and not arg0_21.pageDic[arg1_21.id] and not arg1_21:isEnd() then
		local var1_21 = arg0_21:getActClass(var0_21.class_name).New(arg0_21.rtPages, arg0_21.event, arg0_21.contextData)

		if var1_21:UseSecondPage(arg1_21) then
			var1_21:SetUIName(var0_21.ui_name2)
		else
			var1_21:SetUIName(var0_21.ui_name)
		end

		var1_21:SetShareData(arg0_21.shareData)

		arg0_21.pageDic[arg1_21.id] = var1_21
	end
end

function var0_0.flushTabs(arg0_22)
	setActive(arg0_22.rtPagesEmpty, #arg0_22.activities == 0)
	arg0_22.tabsList:align(math.max(#arg0_22.activities, 1))
end

function var0_0.selectActivity(arg0_23, arg1_23)
	if arg0_23.nextActivity == arg1_23 or not arg0_23.nextActivity and arg0_23.activity and arg1_23.id == arg0_23.activity.id then
		return
	end

	local var0_23 = {}

	if arg0_23.activity and not arg0_23.nextActivity then
		arg0_23.switchCount = arg0_23.switchCount + 1

		table.insert(var0_23, function(arg0_24)
			arg0_23.pageDic[arg0_23.activity.id]:ActionInvoke("SwitchOut", function()
				arg0_23.switchCount = arg0_23.switchCount - 1

				arg0_24()
			end)
		end)
	end

	if not arg0_23.activity or arg0_23.activity.id ~= arg1_23.id then
		local var1_23 = arg0_23.pageDic[arg1_23.id]

		assert(var1_23, "找不到id:" .. arg1_23.id .. "的活动页，请检查")

		arg0_23.switchCount = arg0_23.switchCount + 1

		table.insert(var0_23, function(arg0_26)
			var1_23:Load()
			var1_23:ActionInvoke("ShowOrHide", false)
			var1_23:CallbackInvoke(function()
				arg0_23.switchCount = arg0_23.switchCount - 1

				arg0_26()
			end)
		end)
	end

	arg0_23.nextActivity = arg1_23

	parallelAsync(var0_23, function()
		if arg0_23.switchCount > 0 then
			return
		end

		if arg0_23.activity then
			arg0_23.pageDic[arg0_23.activity.id]:ActionInvoke("ShowOrHide", false)
		end

		arg0_23.activity = arg0_23.nextActivity
		arg0_23.contextData.id = arg0_23.nextActivity.id
		arg0_23.nextActivity = nil

		local var0_28 = arg0_23.pageDic[arg0_23.activity.id]

		var0_28:ActionInvoke("ShowOrHide", true)
		var0_28:ActionInvoke("Flush", arg0_23.activity)
	end)
end

function var0_0.OnDestroy(arg0_29)
	arg0_29.shareData = nil

	for iter0_29, iter1_29 in pairs(arg0_29.pageDic) do
		iter1_29:Destroy()
	end

	arg0_29.pageDic = nil
	arg0_29.activities = nil
	arg0_29.switchCount = nil
end

function var0_0.OnHide(arg0_30)
	arg0_30:UnOverlayPanel(arg0_30._tf, arg0_30._parentTf)

	for iter0_30, iter1_30 in pairs(arg0_30.pageDic) do
		if iter1_30 and iter1_30:isShowing() then
			iter1_30:Hide()
		end
	end
end

return var0_0
