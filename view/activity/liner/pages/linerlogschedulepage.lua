local var0 = class("LinerLogSchedulePage", import("view.base.BaseSubView"))

var0.SHOW_TIME_LIST = {
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

function var0.getUIName(arg0)
	return "LinerLogSchedulePage"
end

function var0.OnLoaded(arg0)
	arg0.togglesTF = arg0:findTF("toggles")
	arg0.contentTF = arg0:findTF("content")
	arg0.anim = arg0.contentTF:GetComponent(typeof(Animation))
	arg0.awardTF = arg0:findTF("award/mask/IconTpl")
	arg0.awardDesc = arg0:findTF("award/Text")
	arg0.goBtn = arg0:findTF("award/go")
	arg0.getBtn = arg0:findTF("award/get")
	arg0.gotTF = arg0:findTF("award/got")
end

function var0.OnInit(arg0)
	arg0:UpdateActivity()
	onButton(arg0, arg0.getBtn, function()
		arg0:emit(LinerLogBookMediator.GET_SCHEDULE_AWARD, arg0.activity.id, arg0.curIdx, arg0.groups[arg0.curIdx]:GetDrop())
	end, SFX_CONFIRM)
	onButton(arg0, arg0.goBtn, function()
		arg0:emit(LinerLogBookMediator.ON_CLOSE)
	end, SFX_CONFIRM)

	arg0.groupIds = arg0.activity:getConfig("config_data")[1]
	arg0.groups = {}

	for iter0, iter1 in ipairs(arg0.groupIds) do
		arg0.groups[iter0] = LinerTimeGroup.New(iter1)
	end

	arg0.itemUIList = UIItemList.New(arg0.contentTF, arg0:findTF("tpl", arg0.contentTF))

	arg0.itemUIList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:UpdateItem(arg1, arg2)
		end
	end)

	arg0.toggleUIList = UIItemList.New(arg0.togglesTF, arg0:findTF("tpl", arg0.togglesTF))

	arg0.toggleUIList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventInit then
			local var0 = arg1 + 1

			arg2.name = var0

			local var1 = "DAY " .. string.format("%02d", var0)

			setText(arg2:Find("Text"), var1)
			setText(arg2:Find("selected/Text"), var1)
			onToggle(arg0, arg2, function(arg0)
				if arg0 then
					if arg0.curIdx and arg0.curIdx == var0 then
						return
					end

					arg0.curIdx = var0

					arg0:FlushPage(true)
				end
			end, SFX_CONFIRM)
		elseif arg0 == UIItemList.EventUpdate then
			local var2 = tonumber(arg2.name) > arg0.curDay

			setActive(arg2:Find("lock"), var2)
			SetCompomentEnabled(arg2, typeof(Toggle), not var2)

			if var2 then
				setActive(arg2:Find("selected"), false)
				setActive(arg2:Find("tip"), false)
			else
				setActive(arg2:Find("tip"), var0.IsTipWithGroupId(arg0.activity, arg0.groups[arg1 + 1].id))
			end
		end
	end)
	arg0.toggleUIList:align(#arg0.groupIds)
	triggerToggle(arg0:findTF(tostring(arg0.curDay), arg0.toggleUIList.container), true)
end

function var0.UpdateActivity(arg0, arg1)
	arg0.activity = arg1 or getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LINER)

	assert(arg0.activity and not arg0.activity:isEnd(), "not exist liner act, type: " .. ActivityConst.ACTIVITY_TYPE_LINER)

	arg0.finishTimeIds = arg0.activity:GetFinishTimeIds()
	arg0.timeId2ExploredIds = arg0.activity:GetTimeId2ExploredIds()
	arg0.curDay = arg0.activity:GetDayByIdx(arg0.activity:GetCurIdx())
end

function var0._getLogDesc(arg0, arg1)
	local var0 = arg1[1]
	local var1 = arg1[2] - 1

	if var0 >= 24 then
		var0 = var0 - 24
	end

	if var1 >= 24 then
		var1 = var1 - 24
	end

	local var2 = var0 < 12 and "AM" or "PM"
	local var3 = var1 < 12 and "AM" or "PM"
	local var4

	var4, var1 = var0 > 12 and var0 - 12 or var0, var1 > 12 and var1 - 12 or var1

	return string.format("%d:00 %s~%d:59 %s", var4, var2, var1, var3)
end

function var0._getReallyTime(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.times) do
		local var0 = iter1:GetTime()[1]
		local var1 = iter1:GetTime()[2]

		if var0 < 3 then
			var0 = var0 + 24
		end

		if var1 <= 3 then
			var1 = var1 + 24
		end

		if var0 <= arg1[1] and var1 >= arg1[2] then
			return iter1
		end
	end
end

function var0.UpdateItem(arg0, arg1, arg2)
	local var0 = arg1 + 1
	local var1 = var0.SHOW_TIME_LIST[var0]

	setText(arg0:findTF("time/Text", arg2), arg0:_getLogDesc(var1))

	local var2 = arg0:_getReallyTime(var1)
	local var3 = table.contains(arg0.finishTimeIds, var2.id)
	local var4 = arg0:findTF("desc", arg2)
	local var5 = var3 and var2:GetAfterDesc(var0) or var2:GetBeforDesc(var0)

	if var3 and var2:GetType() == LinerTime.TYPE.EXPLORE then
		local var6 = underscore.map(arg0.timeId2ExploredIds[var2.id], function(arg0)
			return pg.activity_liner_room[arg0].name
		end)

		var5 = string.gsub(var5, "$1", table.concat(var6, "、"))
	end

	setText(var4, var5)
	setActive(arg0:findTF("time/finish", arg2), var3)
	setActive(var4, arg0.curIdx <= arg0.curDay)
end

function var0.FlushPage(arg0)
	arg0.anim:Play()
	arg0.toggleUIList:align(#arg0.groupIds)

	arg0.times = arg0.groups[arg0.curIdx]:GetTimeList()

	table.sort(arg0.times, CompareFuncs({
		function(arg0)
			return arg0.id
		end
	}))
	arg0.itemUIList:align(#var0.SHOW_TIME_LIST)

	local var0 = arg0.groups[arg0.curIdx]:GetDrop()

	updateDrop(arg0.awardTF, var0)
	onButton(arg0, arg0.awardTF, function()
		arg0:emit(BaseUI.ON_DROP, var0)
	end, SFX_PANEL)

	local var1 = arg0.activity:IsGotTimeAward(arg0.curIdx)
	local var2 = arg0.groups[arg0.curIdx].id
	local var3 = var0.IsTipWithGroupId(arg0.activity, var2)

	setActive(arg0.goBtn, not var1 and not var3)
	setActive(arg0.gotTF, var1)
	setActive(arg0:findTF("mask", arg0.awardTF), var1)

	local var4 = var1 and i18n("liner_schedule_award_tip2", arg0.curIdx) or i18n("liner_schedule_award_tip1")

	setText(arg0.awardDesc, var4)
	setActive(arg0.getBtn, var3)
	arg0:Show()
end

function var0.OnDestroy(arg0)
	return
end

function var0.IsTipWithGroupId(arg0, arg1)
	local var0 = table.indexof(arg0:GetTimeGroupIds(), arg1)

	if arg0:IsGotTimeAward(var0) then
		return false
	end

	local var1 = arg0:GetFinishTimeIds()

	return underscore.all(pg.activity_liner_time_group[arg1].ids, function(arg0)
		return table.contains(var1, arg0)
	end)
end

function var0.IsTip()
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LINER)

	assert(var0 and not var0:isEnd(), "not exist liner act, type: " .. ActivityConst.ACTIVITY_TYPE_LINER)

	local var1 = var0:GetTimeGroupIds()

	return underscore.any(var1, function(arg0)
		return var0.IsTipWithGroupId(var0, arg0)
	end)
end

return var0
