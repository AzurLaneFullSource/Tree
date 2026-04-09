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

function var0_0.updateActivity(arg0_13, arg1_13)
	local var0_13 = ActivityConst.IslandPageIdLinks[arg1_13.id]

	if var0_13 then
		for iter0_13, iter1_13 in ipairs(var0_13) do
			arg0_13:_updateActivity(getProxy(ActivityProxy):getActivityById(iter1_13))
		end
	else
		arg0_13:_updateActivity(arg1_13)
	end
end

function var0_0._updateActivity(arg0_14, arg1_14)
	if arg1_14:isIslandShow() and not arg1_14:isEnd() then
		arg0_14.activities[arg0_14:getActivityIndex(arg1_14.id) or #arg0_14.activities + 1] = arg1_14

		table.sort(arg0_14.activities, CompareFuncs({
			function(arg0_15)
				return -arg0_15:getIslandConfig("is_show")
			end,
			function(arg0_16)
				return -arg0_16.id
			end
		}))

		if not arg0_14.pageDic[arg1_14.id] then
			arg0_14:instanceActivityPage(arg1_14)
		end

		arg0_14:flushTabs()

		if arg0_14:isShowing() and arg0_14.activity and arg0_14.activity.id == arg1_14.id then
			arg0_14.activity = arg1_14

			arg0_14.pageDic[arg1_14.id]:ActionInvoke("Flush", arg1_14)
		end
	end
end

function var0_0.removeActivity(arg0_17, arg1_17)
	local var0_17 = arg0_17:getActivityIndex(arg1_17)

	if var0_17 then
		table.remove(arg0_17.activities, var0_17)
		arg0_17.pageDic[arg1_17]:Destroy()

		arg0_17.pageDic[arg1_17] = nil

		arg0_17:flushTabs()

		if arg0_17.activity and arg0_17.activity.id == arg1_17 then
			arg0_17.activity = nil

			arg0_17:verifyTabs()
		end
	end
end

function var0_0.getActClass(arg0_18, arg1_18)
	return import("Mod.Island.View.page.activity." .. arg1_18)
end

function var0_0.instanceActivityPage(arg0_19, arg1_19)
	local var0_19 = arg1_19:getIslandConfig("page_info")

	if var0_19.class_name and not arg0_19.pageDic[arg1_19.id] and not arg1_19:isEnd() then
		local var1_19 = arg0_19:getActClass(var0_19.class_name).New(arg0_19.rtPages, arg0_19.event, arg0_19.contextData)

		if var1_19:UseSecondPage(arg1_19) then
			var1_19:SetUIName(var0_19.ui_name2)
		else
			var1_19:SetUIName(var0_19.ui_name)
		end

		var1_19:SetShareData(arg0_19.shareData)

		arg0_19.pageDic[arg1_19.id] = var1_19
	end
end

function var0_0.flushTabs(arg0_20)
	setActive(arg0_20.rtPagesEmpty, #arg0_20.activities == 0)
	arg0_20.tabsList:align(math.max(#arg0_20.activities, 1))
end

function var0_0.selectActivity(arg0_21, arg1_21)
	if arg0_21.nextActivity == arg1_21 or not arg0_21.nextActivity and arg0_21.activity and arg1_21.id == arg0_21.activity.id then
		return
	end

	local var0_21 = {}

	if arg0_21.activity and not arg0_21.nextActivity then
		arg0_21.switchCount = arg0_21.switchCount + 1

		table.insert(var0_21, function(arg0_22)
			arg0_21.pageDic[arg0_21.activity.id]:ActionInvoke("SwitchOut", function()
				arg0_21.switchCount = arg0_21.switchCount - 1

				arg0_22()
			end)
		end)
	end

	if not arg0_21.activity or arg0_21.activity.id ~= arg1_21.id then
		local var1_21 = arg0_21.pageDic[arg1_21.id]

		assert(var1_21, "找不到id:" .. arg1_21.id .. "的活动页，请检查")

		arg0_21.switchCount = arg0_21.switchCount + 1

		table.insert(var0_21, function(arg0_24)
			var1_21:Load()
			var1_21:ActionInvoke("ShowOrHide", false)
			var1_21:CallbackInvoke(function()
				arg0_21.switchCount = arg0_21.switchCount - 1

				arg0_24()
			end)
		end)
	end

	arg0_21.nextActivity = arg1_21

	parallelAsync(var0_21, function()
		if arg0_21.switchCount > 0 then
			return
		end

		if arg0_21.activity then
			arg0_21.pageDic[arg0_21.activity.id]:ActionInvoke("ShowOrHide", false)
		end

		arg0_21.activity = arg0_21.nextActivity
		arg0_21.contextData.id = arg0_21.nextActivity.id
		arg0_21.nextActivity = nil

		local var0_26 = arg0_21.pageDic[arg0_21.activity.id]

		var0_26:ActionInvoke("ShowOrHide", true)
		var0_26:ActionInvoke("Flush", arg0_21.activity)
	end)
end

function var0_0.OnDestroy(arg0_27)
	arg0_27.shareData = nil

	for iter0_27, iter1_27 in pairs(arg0_27.pageDic) do
		iter1_27:Destroy()
	end

	arg0_27.pageDic = nil
	arg0_27.activities = nil
	arg0_27.switchCount = nil
end

function var0_0.OnHide(arg0_28)
	arg0_28:UnOverlayPanel(arg0_28._tf, arg0_28._parentTf)
end

return var0_0
