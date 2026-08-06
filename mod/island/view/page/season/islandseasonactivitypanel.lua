local var0_0 = class("IslandSeasonActivityPanel", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IslandSeasonActivityPanel"
end

function var0_0.OnLoaded(arg0_2)
	return
end

function var0_0.OnInit(arg0_3)
	arg0_3.tabsList = UIItemList.New(arg0_3.rtTabsContent, arg0_3.rtTabsTpl)

	arg0_3.tabsList:make(function(arg0_4, arg1_4, arg2_4)
		arg1_4 = arg1_4 + 1

		if arg0_4 == UIItemList.EventUpdate then
			local var0_4 = arg0_3.activities[arg1_4]
			local var1_4 = var0_4 and var0_4.id or 0

			arg2_4.name = var1_4

			local function var2_4(arg0_5)
				setActive(arg2_4:Find("red"), IslandSeasonRedDotHelper.TipActivity(arg0_5))
			end

			if var0_4 then
				local var3_4 = var0_4:getIslandConfig("title_res_tag")

				setText(arg2_4:Find("on/Text"), var3_4)
				setText(arg2_4:Find("off/Text"), var3_4)
				var2_4(var0_4)
			else
				setText(arg2_4:Find("on/Text"), i18n("island_no_activity"))
				setText(arg2_4:Find("on/Text/en"), i18n("island_activity_decorative_word"))
				setText(arg2_4:Find("off/Text"), i18n("island_no_activity"))
			end

			local var4_4 = arg0_3.pageDic[var1_4]

			onToggle(arg0_3, arg2_4, function(arg0_6)
				if var4_4 and arg0_6 then
					arg0_3:selectActivity(var0_4)
					var2_4(var0_4)
				end
			end, SFX_PANEL)
		end
	end)

	arg0_3.switchCount = 0
end

function var0_0.Show(arg0_7)
	var0_0.super.Show(arg0_7)
	arg0_7:Flush()
	IslandGuideChecker.CheckGuide("ISLAND_GUIDE_14")
end

function var0_0.Flush(arg0_8)
	if not arg0_8:isShowing() then
		return
	end

	if not arg0_8.activities then
		arg0_8:setActivities(getProxy(ActivityProxy):getIslandPanelActivities())
	end

	if arg0_8.activity then
		arg0_8.pageDic[arg0_8.activity.id]:ExecuteAction("ShowOrHide", true)
	else
		arg0_8:verifyTabs()
	end
end

function var0_0.verifyTabs(arg0_9, arg1_9)
	if #arg0_9.activities > 0 then
		local var0_9 = arg0_9:getActivityIndex(arg1_9) or 1
		local var1_9 = arg0_9.rtTabsContent:GetChild(var0_9 - 1)

		triggerToggle(var1_9, true)
	end
end

function var0_0.getActivityIndex(arg0_10, arg1_10)
	for iter0_10, iter1_10 in ipairs(arg0_10.activities) do
		if iter1_10.id == arg1_10 then
			return iter0_10
		end
	end

	return nil
end

function var0_0.setActivities(arg0_11, arg1_11)
	arg0_11.activities = arg1_11 or {}
	arg0_11.shareData = arg0_11.shareData or ActivityShareData.New()
	arg0_11.pageDic = arg0_11.pageDic or {}

	for iter0_11, iter1_11 in ipairs(arg1_11) do
		arg0_11:instanceActivityPage(iter1_11)
	end

	arg0_11.activity = nil

	table.sort(arg0_11.activities, CompareFuncs({
		function(arg0_12)
			return -arg0_12:getIslandConfig("is_show")
		end,
		function(arg0_13)
			return -arg0_13.id
		end
	}))
	arg0_11:flushTabs()
end

function var0_0.OnTaskUpdate(arg0_14, arg1_14)
	for iter0_14, iter1_14 in pairs(arg0_14.activities) do
		if iter1_14:getConfig("type") == ActivityConst.ACTIVITY_TYPE_TASK_LIST and _.any(_.flatten(iter1_14:getIslandConfig("config_data")), function(arg0_15)
			return arg0_15 == arg1_14
		end) then
			arg0_14:updateActivity(iter1_14)
		end
	end
end

function var0_0.updateActivity(arg0_16, arg1_16)
	local var0_16 = ActivityConst.IslandPageIdLinks[arg1_16.id]

	if var0_16 then
		for iter0_16, iter1_16 in ipairs(var0_16) do
			arg0_16:_updateActivity(getProxy(ActivityProxy):getActivityById(iter1_16))
		end
	else
		arg0_16:_updateActivity(arg1_16)
	end
end

function var0_0._updateActivity(arg0_17, arg1_17)
	if arg1_17:isIslandShow() and not arg1_17:isEnd() then
		arg0_17.activities[arg0_17:getActivityIndex(arg1_17.id) or #arg0_17.activities + 1] = arg1_17

		table.sort(arg0_17.activities, CompareFuncs({
			function(arg0_18)
				return -arg0_18:getIslandConfig("is_show")
			end,
			function(arg0_19)
				return -arg0_19.id
			end
		}))

		if not arg0_17.pageDic[arg1_17.id] then
			arg0_17:instanceActivityPage(arg1_17)
		end

		arg0_17:flushTabs()

		if arg0_17:isShowing() and arg0_17.activity and arg0_17.activity.id == arg1_17.id then
			arg0_17.activity = arg1_17

			arg0_17.pageDic[arg1_17.id]:ActionInvoke("Flush", arg1_17)
		end
	end
end

function var0_0.removeActivity(arg0_20, arg1_20)
	local var0_20 = arg0_20:getActivityIndex(arg1_20)

	if var0_20 then
		table.remove(arg0_20.activities, var0_20)
		arg0_20.pageDic[arg1_20]:Destroy()

		arg0_20.pageDic[arg1_20] = nil

		arg0_20:flushTabs()

		if arg0_20.activity and arg0_20.activity.id == arg1_20 then
			arg0_20.activity = nil

			arg0_20:verifyTabs()
		end
	end
end

function var0_0.getActClass(arg0_21, arg1_21)
	return import("Mod.Island.View.page.activity." .. arg1_21)
end

function var0_0.instanceActivityPage(arg0_22, arg1_22)
	local var0_22 = arg1_22:getIslandConfig("page_info")

	if var0_22.class_name and not arg0_22.pageDic[arg1_22.id] and not arg1_22:isEnd() then
		local var1_22 = arg0_22:getActClass(var0_22.class_name).New(arg0_22.rtPages, arg0_22.event, arg0_22.contextData)

		if var1_22:UseSecondPage(arg1_22) then
			var1_22:SetUIName(var0_22.ui_name2)
		else
			var1_22:SetUIName(var0_22.ui_name)
		end

		var1_22:SetShareData(arg0_22.shareData)

		arg0_22.pageDic[arg1_22.id] = var1_22
	end
end

function var0_0.flushTabs(arg0_23)
	setActive(arg0_23.rtPagesEmpty, #arg0_23.activities == 0)
	arg0_23.tabsList:align(math.max(#arg0_23.activities, 1))
end

function var0_0.selectActivity(arg0_24, arg1_24)
	if arg0_24.nextActivity == arg1_24 or not arg0_24.nextActivity and arg0_24.activity and arg1_24.id == arg0_24.activity.id then
		return
	end

	IslandSeasonRedDotHelper.UpdateActEnterTip(arg1_24)
	arg0_24:emit(IslandSeasonPage.UPDATE_REDDOT, IslandSeasonPage.PAGE_ACTIVITY)

	local var0_24 = {}

	if arg0_24.activity and not arg0_24.nextActivity then
		arg0_24.switchCount = arg0_24.switchCount + 1

		table.insert(var0_24, function(arg0_25)
			arg0_24.pageDic[arg0_24.activity.id]:ActionInvoke("SwitchOut", function()
				arg0_24.switchCount = arg0_24.switchCount - 1

				arg0_25()
			end)
		end)
	end

	if not arg0_24.activity or arg0_24.activity.id ~= arg1_24.id then
		local var1_24 = arg0_24.pageDic[arg1_24.id]

		assert(var1_24, "找不到id:" .. arg1_24.id .. "的活动页，请检查")

		arg0_24.switchCount = arg0_24.switchCount + 1

		table.insert(var0_24, function(arg0_27)
			var1_24:Load()
			var1_24:ActionInvoke("ShowOrHide", false)
			var1_24:CallbackInvoke(function()
				arg0_24.switchCount = arg0_24.switchCount - 1

				arg0_27()
			end)
		end)
	end

	arg0_24.nextActivity = arg1_24

	parallelAsync(var0_24, function()
		if arg0_24.switchCount > 0 then
			return
		end

		if arg0_24.activity then
			arg0_24.pageDic[arg0_24.activity.id]:ActionInvoke("ShowOrHide", false)
		end

		arg0_24.activity = arg0_24.nextActivity
		arg0_24.contextData.id = arg0_24.nextActivity.id
		arg0_24.nextActivity = nil

		local var0_29 = arg0_24.pageDic[arg0_24.activity.id]

		var0_29:ActionInvoke("ShowOrHide", true)
		var0_29:ActionInvoke("Flush", arg0_24.activity)
	end)
end

function var0_0.OnDestroy(arg0_30)
	arg0_30.shareData = nil

	for iter0_30, iter1_30 in pairs(arg0_30.pageDic) do
		iter1_30:Destroy()
	end

	arg0_30.pageDic = nil
	arg0_30.activities = nil
	arg0_30.switchCount = nil
end

function var0_0.OnHide(arg0_31)
	arg0_31:UnOverlayPanel(arg0_31._tf, arg0_31._parentTf)

	for iter0_31, iter1_31 in pairs(arg0_31.pageDic) do
		if iter1_31 and iter1_31:isShowing() then
			iter1_31:Hide()
		end
	end
end

return var0_0
