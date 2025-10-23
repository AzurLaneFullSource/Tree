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
	if arg1_13:isIslandShow() and not arg1_13:isEnd() then
		arg0_13.activities[arg0_13:getActivityIndex(arg1_13.id) or #arg0_13.activities + 1] = arg1_13

		table.sort(arg0_13.activities, CompareFuncs({
			function(arg0_14)
				return -arg0_14:getIslandConfig("is_show")
			end,
			function(arg0_15)
				return -arg0_15.id
			end
		}))

		if not arg0_13.pageDic[arg1_13.id] then
			arg0_13:instanceActivityPage(arg1_13)
		end

		arg0_13:flushTabs()

		if arg0_13:isShowing() and arg0_13.activity and arg0_13.activity.id == arg1_13.id then
			arg0_13.activity = arg1_13

			arg0_13.pageDic[arg1_13.id]:ActionInvoke("Flush", arg1_13)
		end
	end
end

function var0_0.removeActivity(arg0_16, arg1_16)
	local var0_16 = arg0_16:getActivityIndex(arg1_16)

	if var0_16 then
		table.remove(arg0_16.activities, var0_16)
		arg0_16.pageDic[arg1_16]:Destroy()

		arg0_16.pageDic[arg1_16] = nil

		arg0_16:flushTabs()

		if arg0_16.activity and arg0_16.activity.id == arg1_16 then
			arg0_16.activity = nil

			arg0_16:verifyTabs()
		end
	end
end

function var0_0.getActClass(arg0_17, arg1_17)
	return import("Mod.Island.View.page.activity." .. arg1_17)
end

function var0_0.instanceActivityPage(arg0_18, arg1_18)
	local var0_18 = arg1_18:getIslandConfig("page_info")

	if var0_18.class_name and not arg0_18.pageDic[arg1_18.id] and not arg1_18:isEnd() then
		local var1_18 = arg0_18:getActClass(var0_18.class_name).New(arg0_18.rtPages, arg0_18.event, arg0_18.contextData)

		if var1_18:UseSecondPage(arg1_18) then
			var1_18:SetUIName(var0_18.ui_name2)
		else
			var1_18:SetUIName(var0_18.ui_name)
		end

		var1_18:SetShareData(arg0_18.shareData)

		arg0_18.pageDic[arg1_18.id] = var1_18
	end
end

function var0_0.flushTabs(arg0_19)
	setActive(arg0_19.rtPagesEmpty, #arg0_19.activities == 0)
	arg0_19.tabsList:align(math.max(#arg0_19.activities, 1))
end

function var0_0.selectActivity(arg0_20, arg1_20)
	if arg0_20.nextActivity == arg1_20 or not arg0_20.nextActivity and arg0_20.activity and arg1_20.id == arg0_20.activity.id then
		return
	end

	local var0_20 = {}

	if arg0_20.activity and not arg0_20.nextActivity then
		arg0_20.switchCount = arg0_20.switchCount + 1

		table.insert(var0_20, function(arg0_21)
			arg0_20.pageDic[arg0_20.activity.id]:ActionInvoke("SwitchOut", function()
				arg0_20.switchCount = arg0_20.switchCount - 1

				arg0_21()
			end)
		end)
	end

	if not arg0_20.activity or arg0_20.activity.id ~= arg1_20.id then
		local var1_20 = arg0_20.pageDic[arg1_20.id]

		assert(var1_20, "找不到id:" .. arg1_20.id .. "的活动页，请检查")

		arg0_20.switchCount = arg0_20.switchCount + 1

		table.insert(var0_20, function(arg0_23)
			var1_20:Load()
			var1_20:ActionInvoke("ShowOrHide", false)
			var1_20:CallbackInvoke(function()
				arg0_20.switchCount = arg0_20.switchCount - 1

				arg0_23()
			end)
		end)
	end

	arg0_20.nextActivity = arg1_20

	parallelAsync(var0_20, function()
		if arg0_20.switchCount > 0 then
			return
		end

		if arg0_20.activity then
			arg0_20.pageDic[arg0_20.activity.id]:ActionInvoke("ShowOrHide", false)
		end

		arg0_20.activity = arg0_20.nextActivity
		arg0_20.contextData.id = arg0_20.nextActivity.id
		arg0_20.nextActivity = nil

		local var0_25 = arg0_20.pageDic[arg0_20.activity.id]

		var0_25:ActionInvoke("Flush", arg0_20.activity)
		var0_25:ActionInvoke("ShowOrHide", true)
	end)
end

function var0_0.OnDestroy(arg0_26)
	arg0_26.shareData = nil

	for iter0_26, iter1_26 in pairs(arg0_26.pageDic) do
		iter1_26:Destroy()
	end

	arg0_26.pageDic = nil
	arg0_26.activities = nil
	arg0_26.switchCount = nil
end

return var0_0
