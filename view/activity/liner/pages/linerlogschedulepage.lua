local var0_0 = class("LinerLogSchedulePage", import("view.base.BaseSubView"))

var0_0.SHOW_TIME_LIST = {
	{
		3,
		8
	},
	{
		8,
		12
	},
	{
		12,
		14
	},
	{
		14,
		18
	},
	{
		18,
		20
	},
	{
		20,
		25
	},
	{
		25,
		27
	}
}

function var0_0.getUIName(arg0_1)
	return "LinerLogSchedulePage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.togglesTF = arg0_2:findTF("toggles")
	arg0_2.contentTF = arg0_2:findTF("content")
	arg0_2.anim = arg0_2.contentTF:GetComponent(typeof(Animation))
	arg0_2.awardTF = arg0_2:findTF("award/mask/IconTpl")
	arg0_2.awardDesc = arg0_2:findTF("award/Text")
	arg0_2.goBtn = arg0_2:findTF("award/go")
	arg0_2.getBtn = arg0_2:findTF("award/get")
	arg0_2.gotTF = arg0_2:findTF("award/got")
end

function var0_0.OnInit(arg0_3)
	arg0_3:UpdateActivity()
	onButton(arg0_3, arg0_3.getBtn, function()
		arg0_3:emit(LinerLogBookMediator.GET_SCHEDULE_AWARD, arg0_3.activity.id, arg0_3.curIdx, arg0_3.groups[arg0_3.curIdx]:GetDrop())
	end, SFX_CONFIRM)
	onButton(arg0_3, arg0_3.goBtn, function()
		arg0_3:emit(LinerLogBookMediator.ON_CLOSE)
	end, SFX_CONFIRM)

	arg0_3.groupIds = arg0_3.activity:getConfig("config_data")[1]
	arg0_3.groups = {}

	for iter0_3, iter1_3 in ipairs(arg0_3.groupIds) do
		arg0_3.groups[iter0_3] = LinerTimeGroup.New(iter1_3)
	end

	arg0_3.itemUIList = UIItemList.New(arg0_3.contentTF, arg0_3:findTF("tpl", arg0_3.contentTF))

	arg0_3.itemUIList:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventUpdate then
			arg0_3:UpdateItem(arg1_6, arg2_6)
		end
	end)

	arg0_3.toggleUIList = UIItemList.New(arg0_3.togglesTF, arg0_3:findTF("tpl", arg0_3.togglesTF))

	arg0_3.toggleUIList:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventInit then
			local var0_7 = arg1_7 + 1

			arg2_7.name = var0_7

			local var1_7 = "DAY " .. string.format("%02d", var0_7)

			setText(arg2_7:Find("Text"), var1_7)
			setText(arg2_7:Find("selected/Text"), var1_7)
			onToggle(arg0_3, arg2_7, function(arg0_8)
				if arg0_8 then
					if arg0_3.curIdx and arg0_3.curIdx == var0_7 then
						return
					end

					arg0_3.curIdx = var0_7

					arg0_3:FlushPage(true)
				end
			end, SFX_CONFIRM)
		elseif arg0_7 == UIItemList.EventUpdate then
			local var2_7 = tonumber(arg2_7.name) > arg0_3.curDay

			setActive(arg2_7:Find("lock"), var2_7)
			SetCompomentEnabled(arg2_7, typeof(Toggle), not var2_7)

			if var2_7 then
				setActive(arg2_7:Find("selected"), false)
				setActive(arg2_7:Find("tip"), false)
			else
				setActive(arg2_7:Find("tip"), var0_0.IsTipWithGroupId(arg0_3.activity, arg0_3.groups[arg1_7 + 1].id))
			end
		end
	end)
	arg0_3.toggleUIList:align(#arg0_3.groupIds)
	triggerToggle(arg0_3:findTF(tostring(arg0_3.curDay), arg0_3.toggleUIList.container), true)
end

function var0_0.UpdateActivity(arg0_9, arg1_9)
	arg0_9.activity = arg1_9 or getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LINER)

	assert(arg0_9.activity and not arg0_9.activity:isEnd(), "not exist liner act, type: " .. ActivityConst.ACTIVITY_TYPE_LINER)

	arg0_9.finishTimeIds = arg0_9.activity:GetFinishTimeIds()
	arg0_9.timeId2ExploredIds = arg0_9.activity:GetTimeId2ExploredIds()
	arg0_9.curDay = arg0_9.activity:GetDayByIdx(arg0_9.activity:GetCurIdx())
end

function var0_0._getLogDesc(arg0_10, arg1_10)
	local var0_10 = arg1_10[1]
	local var1_10 = arg1_10[2] - 1

	if var0_10 >= 24 then
		var0_10 = var0_10 - 24
	end

	if var1_10 >= 24 then
		var1_10 = var1_10 - 24
	end

	local var2_10 = var0_10 < 12 and "AM" or "PM"
	local var3_10 = var1_10 < 12 and "AM" or "PM"
	local var4_10

	var4_10, var1_10 = var0_10 > 12 and var0_10 - 12 or var0_10, var1_10 > 12 and var1_10 - 12 or var1_10

	return string.format("%d:00 %s~%d:59 %s", var4_10, var2_10, var1_10, var3_10)
end

function var0_0._getReallyTime(arg0_11, arg1_11)
	for iter0_11, iter1_11 in ipairs(arg0_11.times) do
		local var0_11 = iter1_11:GetTime()[1]
		local var1_11 = iter1_11:GetTime()[2]

		if var0_11 < 3 then
			var0_11 = var0_11 + 24
		end

		if var1_11 <= 3 then
			var1_11 = var1_11 + 24
		end

		if var0_11 <= arg1_11[1] and var1_11 >= arg1_11[2] then
			return iter1_11
		end
	end
end

function var0_0.UpdateItem(arg0_12, arg1_12, arg2_12)
	local var0_12 = arg1_12 + 1
	local var1_12 = var0_0.SHOW_TIME_LIST[var0_12]

	setText(arg0_12:findTF("time/Text", arg2_12), arg0_12:_getLogDesc(var1_12))

	local var2_12 = arg0_12:_getReallyTime(var1_12)
	local var3_12 = table.contains(arg0_12.finishTimeIds, var2_12.id)
	local var4_12 = arg0_12:findTF("desc", arg2_12)
	local var5_12 = var3_12 and var2_12:GetAfterDesc(var0_12) or var2_12:GetBeforDesc(var0_12)

	if var3_12 and var2_12:GetType() == LinerTime.TYPE.EXPLORE then
		local var6_12 = underscore.map(arg0_12.timeId2ExploredIds[var2_12.id], function(arg0_13)
			return pg.activity_liner_room[arg0_13].name
		end)

		var5_12 = string.gsub(var5_12, "$1", table.concat(var6_12, "、"))
	end

	setText(var4_12, var5_12)
	setActive(arg0_12:findTF("time/finish", arg2_12), var3_12)
	setActive(var4_12, arg0_12.curIdx <= arg0_12.curDay)
end

function var0_0.FlushPage(arg0_14)
	arg0_14.anim:Play()
	arg0_14.toggleUIList:align(#arg0_14.groupIds)

	arg0_14.times = arg0_14.groups[arg0_14.curIdx]:GetTimeList()

	table.sort(arg0_14.times, CompareFuncs({
		function(arg0_15)
			return arg0_15.id
		end
	}))
	arg0_14.itemUIList:align(#var0_0.SHOW_TIME_LIST)

	local var0_14 = arg0_14.groups[arg0_14.curIdx]:GetDrop()

	updateDrop(arg0_14.awardTF, var0_14)
	onButton(arg0_14, arg0_14.awardTF, function()
		arg0_14:emit(BaseUI.ON_DROP, var0_14)
	end, SFX_PANEL)

	local var1_14 = arg0_14.activity:IsGotTimeAward(arg0_14.curIdx)
	local var2_14 = arg0_14.groups[arg0_14.curIdx].id
	local var3_14 = var0_0.IsTipWithGroupId(arg0_14.activity, var2_14)

	setActive(arg0_14.goBtn, not var1_14 and not var3_14)
	setActive(arg0_14.gotTF, var1_14)
	setActive(arg0_14:findTF("mask", arg0_14.awardTF), var1_14)

	local var4_14 = var1_14 and i18n("liner_schedule_award_tip2", arg0_14.curIdx) or i18n("liner_schedule_award_tip1")

	setText(arg0_14.awardDesc, var4_14)
	setActive(arg0_14.getBtn, var3_14)
	arg0_14:Show()
end

function var0_0.OnDestroy(arg0_17)
	return
end

function var0_0.IsTipWithGroupId(arg0_18, arg1_18)
	local var0_18 = table.indexof(arg0_18:GetTimeGroupIds(), arg1_18)

	if arg0_18:IsGotTimeAward(var0_18) then
		return false
	end

	local var1_18 = arg0_18:GetFinishTimeIds()

	return underscore.all(pg.activity_liner_time_group[arg1_18].ids, function(arg0_19)
		return table.contains(var1_18, arg0_19)
	end)
end

function var0_0.IsTip()
	local var0_20 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LINER)

	assert(var0_20 and not var0_20:isEnd(), "not exist liner act, type: " .. ActivityConst.ACTIVITY_TYPE_LINER)

	local var1_20 = var0_20:GetTimeGroupIds()

	return underscore.any(var1_20, function(arg0_21)
		return var0_0.IsTipWithGroupId(var0_20, arg0_21)
	end)
end

return var0_0
