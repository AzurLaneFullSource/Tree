local var0 = class("EducateSchedulePerformLayer", import(".base.EducateBaseUI"))
local var1 = {
	"FFFFFF",
	"79D3FE",
	"818183"
}
local var2 = {
	"39BFFF",
	"39BFFF",
	"2D2E2F"
}

function var0.getUIName(arg0)
	return "EducateSchedulePerformUI"
end

function var0.init(arg0)
	arg0:initData()
	arg0:findUI()
end

function var0.initData(arg0)
	arg0.planCnt = getProxy(EducateProxy):GetCharData():GetNextWeekPlanCnt()
	arg0.curDay = 1
	arg0.curIndex = 1
	arg0.events = arg0.contextData.events
	arg0.drops = {}
	arg0.isSkip = arg0.contextData.skip

	underscore.each(arg0.contextData.plan_results, function(arg0)
		if not arg0.drops[arg0.day] then
			arg0.drops[arg0.day] = {}
		end

		arg0.drops[arg0.day][arg0.index] = {
			plan_drops = arg0.plan_drops,
			event_drops = arg0.event_drops,
			spec_event_drops = arg0.spec_event_drops
		}
	end)

	arg0.showGrids = arg0.contextData.gridData
	arg0.showEventIds = {}

	underscore.each(arg0.events, function(arg0)
		if not arg0.showEventIds[arg0.day] then
			arg0.showEventIds[arg0.day] = {}
		end

		arg0.showEventIds[arg0.day][arg0.index] = arg0.value[1].event_id
	end)
end

function var0.findUI(arg0)
	arg0.windowsTF = arg0:findTF("anim_root/window")
	arg0.leftTF = arg0:findTF("left", arg0.windowsTF)

	setText(arg0:findTF("title/Text", arg0.leftTF), i18n("child_plan_perform_title"))

	arg0.dayUIList = UIItemList.New(arg0:findTF("content", arg0.leftTF), arg0:findTF("content/day_tpl", arg0.leftTF))
	arg0.rightTF = arg0:findTF("right", arg0.windowsTF)
	arg0.planNameTF = arg0:findTF("name", arg0.rightTF)
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():OverlayPanel(arg0._tf, {
		groupName = arg0:getGroupNameFromData(),
		weight = arg0:getWeightFromData() + 1
	})
	pg.PerformMgr.GetInstance():SetParamForUI(arg0.__cname)
	arg0:initDayList()
	arg0:playWeek(function()
		arg0:emit(var0.ON_CLOSE)
	end)
end

function var0.initDayList(arg0)
	arg0.dayUIList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventInit then
			local var0 = arg1 + 1

			arg2.name = var0

			setText(arg0:findTF("Text", arg2), EducateHelper.GetWeekStrByNumber(var0))

			for iter0 = 1, 3 do
				local var1 = arg0:findTF("phase" .. iter0, arg2)

				setActive(var1, iter0 == arg0.planCnt)
			end
		elseif arg0 == UIItemList.EventUpdate then
			local var2 = arg1 + 1

			setActive(arg0:findTF("selected", arg2), arg0.curDay == var2)

			local var3 = arg0:findTF("Text", arg2)
			local var4 = "FFFFFF"
			local var5 = "FFFFFF"

			if var2 < arg0.curDay then
				var4 = var1[1]
				var5 = var2[1]
			elseif arg0.curDay == var2 then
				var4 = var1[2]
				var5 = var2[3]
			else
				var4 = var1[3]
				var5 = var2[3]
			end

			setTextColor(var3, Color.NewHex(var4))

			local var6 = arg0:findTF("phase" .. arg0.planCnt, arg2)

			for iter1 = 1, var6.childCount do
				local var7 = var5

				if arg0.curDay == var2 and iter1 <= arg0.curIndex then
					var7 = var2[2]
				end

				setImageColor(var6:GetChild(iter1 - 1), Color.NewHex(var7))
			end
		end
	end)
	arg0:updateLeft()
end

function var0.updateLeft(arg0)
	arg0.dayUIList:align(6)
end

function var0.playWeek(arg0, arg1)
	arg0.curDay = 1
	arg0.curIndex = 1

	arg0:emit(EducateSchedulePerformMediator.WEEKDAY_UPDATE, arg0.curDay)

	local var0 = {}

	for iter0 = 1, 6 do
		for iter1 = 1, 3 do
			local var1 = arg0.drops[iter0][iter1] or {}
			local var2 = arg0.showEventIds[iter0] and arg0.showEventIds[iter0][iter1] and arg0.showEventIds[iter0][iter1] ~= 0

			if arg0.showGrids[iter0] and arg0.showGrids[iter0][iter1] then
				local var3 = arg0.showGrids[iter0][iter1]

				table.insert(var0, function(arg0)
					arg0.curDay = iter0
					arg0.curIndex = iter1

					arg0:emit(EducateSchedulePerformMediator.WEEKDAY_UPDATE, arg0.curDay)
					arg0:updateLeft()
					setText(arg0.planNameTF, var3:GetName())

					local var0 = var3:IsPlan() and var1.plan_drops or var1.spec_event_drops

					if arg0.isSkip then
						if not var3:IsPlan() or var2 then
							pg.PerformMgr.GetInstance():PlayGroupNoHide(var3:GetPerformance(), arg0, var0 or {})
						else
							arg0()
						end
					else
						pg.PerformMgr.GetInstance():PlayGroupNoHide(var3:GetPerformance(), arg0, var0 or {})
					end
				end)
			end

			if var2 then
				local var4 = arg0.showEventIds[iter0][iter1]

				table.insert(var0, function(arg0)
					pg.PerformMgr.GetInstance():PlayGroupNoHide(pg.child_event[var4].performance, arg0, var1.event_drops or {})
				end)
			end
		end
	end

	pg.PerformMgr.GetInstance():Show()
	seriesAsync(var0, function()
		pg.PerformMgr.GetInstance():Hide()
		onNextTick(function()
			if arg1 then
				arg1()
			end
		end)
	end)
end

function var0.onBackPressed(arg0)
	return
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf)
	pg.PerformMgr.GetInstance():SetParamForUI("Default")

	if arg0.contextData.onExit then
		arg0.contextData.onExit()
	end
end

return var0
