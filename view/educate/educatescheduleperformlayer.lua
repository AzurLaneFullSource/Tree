local var0_0 = class("EducateSchedulePerformLayer", import(".base.EducateBaseUI"))
local var1_0 = {
	"FFFFFF",
	"79D3FE",
	"818183"
}
local var2_0 = {
	"39BFFF",
	"39BFFF",
	"2D2E2F"
}

function var0_0.getUIName(arg0_1)
	return "EducateSchedulePerformUI"
end

function var0_0.init(arg0_2)
	arg0_2:initData()
	arg0_2:findUI()
end

function var0_0.initData(arg0_3)
	arg0_3.planCnt = getProxy(EducateProxy):GetCharData():GetNextWeekPlanCnt()
	arg0_3.curDay = 1
	arg0_3.curIndex = 1
	arg0_3.events = arg0_3.contextData.events
	arg0_3.drops = {}
	arg0_3.isSkip = arg0_3.contextData.skip

	underscore.each(arg0_3.contextData.plan_results, function(arg0_4)
		if not arg0_3.drops[arg0_4.day] then
			arg0_3.drops[arg0_4.day] = {}
		end

		arg0_3.drops[arg0_4.day][arg0_4.index] = {
			plan_drops = arg0_4.plan_drops,
			event_drops = arg0_4.event_drops,
			spec_event_drops = arg0_4.spec_event_drops
		}
	end)

	arg0_3.showGrids = arg0_3.contextData.gridData
	arg0_3.showEventIds = {}

	underscore.each(arg0_3.events, function(arg0_5)
		if not arg0_3.showEventIds[arg0_5.day] then
			arg0_3.showEventIds[arg0_5.day] = {}
		end

		arg0_3.showEventIds[arg0_5.day][arg0_5.index] = arg0_5.value[1].event_id
	end)
end

function var0_0.findUI(arg0_6)
	arg0_6.windowsTF = arg0_6:findTF("anim_root/window")
	arg0_6.leftTF = arg0_6:findTF("left", arg0_6.windowsTF)

	setText(arg0_6:findTF("title/Text", arg0_6.leftTF), i18n("child_plan_perform_title"))

	arg0_6.dayUIList = UIItemList.New(arg0_6:findTF("content", arg0_6.leftTF), arg0_6:findTF("content/day_tpl", arg0_6.leftTF))
	arg0_6.rightTF = arg0_6:findTF("right", arg0_6.windowsTF)
	arg0_6.planNameTF = arg0_6:findTF("name", arg0_6.rightTF)
end

function var0_0.didEnter(arg0_7)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_7._tf, {
		groupName = arg0_7:getGroupNameFromData(),
		weight = arg0_7:getWeightFromData() + 1
	})
	pg.PerformMgr.GetInstance():SetParamForUI(arg0_7.__cname)
	arg0_7:initDayList()
	arg0_7:playWeek(function()
		arg0_7:emit(var0_0.ON_CLOSE)
	end)
end

function var0_0.initDayList(arg0_9)
	arg0_9.dayUIList:make(function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventInit then
			local var0_10 = arg1_10 + 1

			arg2_10.name = var0_10

			setText(arg0_9:findTF("Text", arg2_10), EducateHelper.GetWeekStrByNumber(var0_10))

			for iter0_10 = 1, 3 do
				local var1_10 = arg0_9:findTF("phase" .. iter0_10, arg2_10)

				setActive(var1_10, iter0_10 == arg0_9.planCnt)
			end
		elseif arg0_10 == UIItemList.EventUpdate then
			local var2_10 = arg1_10 + 1

			setActive(arg0_9:findTF("selected", arg2_10), arg0_9.curDay == var2_10)

			local var3_10 = arg0_9:findTF("Text", arg2_10)
			local var4_10 = "FFFFFF"
			local var5_10 = "FFFFFF"

			if var2_10 < arg0_9.curDay then
				var4_10 = var1_0[1]
				var5_10 = var2_0[1]
			elseif arg0_9.curDay == var2_10 then
				var4_10 = var1_0[2]
				var5_10 = var2_0[3]
			else
				var4_10 = var1_0[3]
				var5_10 = var2_0[3]
			end

			setTextColor(var3_10, Color.NewHex(var4_10))

			local var6_10 = arg0_9:findTF("phase" .. arg0_9.planCnt, arg2_10)

			for iter1_10 = 1, var6_10.childCount do
				local var7_10 = var5_10

				if arg0_9.curDay == var2_10 and iter1_10 <= arg0_9.curIndex then
					var7_10 = var2_0[2]
				end

				setImageColor(var6_10:GetChild(iter1_10 - 1), Color.NewHex(var7_10))
			end
		end
	end)
	arg0_9:updateLeft()
end

function var0_0.updateLeft(arg0_11)
	arg0_11.dayUIList:align(6)
end

function var0_0.playWeek(arg0_12, arg1_12)
	arg0_12.curDay = 1
	arg0_12.curIndex = 1

	arg0_12:emit(EducateSchedulePerformMediator.WEEKDAY_UPDATE, arg0_12.curDay)

	local var0_12 = {}

	for iter0_12 = 1, 6 do
		for iter1_12 = 1, 3 do
			local var1_12 = arg0_12.drops[iter0_12][iter1_12] or {}
			local var2_12 = arg0_12.showEventIds[iter0_12] and arg0_12.showEventIds[iter0_12][iter1_12] and arg0_12.showEventIds[iter0_12][iter1_12] ~= 0

			if arg0_12.showGrids[iter0_12] and arg0_12.showGrids[iter0_12][iter1_12] then
				local var3_12 = arg0_12.showGrids[iter0_12][iter1_12]

				table.insert(var0_12, function(arg0_13)
					arg0_12.curDay = iter0_12
					arg0_12.curIndex = iter1_12

					arg0_12:emit(EducateSchedulePerformMediator.WEEKDAY_UPDATE, arg0_12.curDay)
					arg0_12:updateLeft()
					setText(arg0_12.planNameTF, var3_12:GetName())

					local var0_13 = var3_12:IsPlan() and var1_12.plan_drops or var1_12.spec_event_drops

					if arg0_12.isSkip then
						if not var3_12:IsPlan() or var2_12 then
							pg.PerformMgr.GetInstance():PlayGroupNoHide(var3_12:GetPerformance(), arg0_13, var0_13 or {})
						else
							arg0_13()
						end
					else
						pg.PerformMgr.GetInstance():PlayGroupNoHide(var3_12:GetPerformance(), arg0_13, var0_13 or {})
					end
				end)
			end

			if var2_12 then
				local var4_12 = arg0_12.showEventIds[iter0_12][iter1_12]

				table.insert(var0_12, function(arg0_14)
					pg.PerformMgr.GetInstance():PlayGroupNoHide(pg.child_event[var4_12].performance, arg0_14, var1_12.event_drops or {})
				end)
			end
		end
	end

	pg.PerformMgr.GetInstance():Show()
	seriesAsync(var0_12, function()
		pg.PerformMgr.GetInstance():Hide()
		onNextTick(function()
			if arg1_12 then
				arg1_12()
			end
		end)
	end)
end

function var0_0.onBackPressed(arg0_17)
	return
end

function var0_0.willExit(arg0_18)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_18._tf)
	pg.PerformMgr.GetInstance():SetParamForUI("Default")

	if arg0_18.contextData.onExit then
		arg0_18.contextData.onExit()
	end
end

return var0_0
