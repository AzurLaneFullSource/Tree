local var0_0 = class("EducatePlanProxy")

var0_0.INDEX2BG = {
	{
		"empty_blue",
		"plan_name_blue"
	},
	{
		"empty_green",
		"plan_name_green"
	},
	{
		"empty_red",
		"plan_name_red"
	}
}

function var0_0.Ctor(arg0_1)
	arg0_1.allPlans = {}

	local var0_1 = pg.child_plan.all

	for iter0_1, iter1_1 in ipairs(var0_1) do
		table.insert(arg0_1.allPlans, EducatePlan.New(iter1_1))
	end

	arg0_1.gridColorCfg = pg.child_data[1].plan_color
end

function var0_0.GetCfgPlans(arg0_2)
	return arg0_2.allPlans
end

function var0_0.SetUp(arg0_3, arg1_3)
	arg0_3:initHistory(arg1_3.history or {})

	arg0_3.selectedPlans = arg1_3.selectedPlans or {}

	if #arg0_3.selectedPlans > 0 then
		arg0_3:initGridData()
	else
		arg0_3.gridData = {}
	end

	arg0_3.playerId = getProxy(PlayerProxy):getRawData().id
end

function var0_0.GetGridBgName(arg0_4, arg1_4, arg2_4)
	local var0_4 = 1

	underscore.each(arg0_4.gridColorCfg, function(arg0_5)
		underscore.each(arg0_5[1], function(arg0_6)
			if arg0_6[1] == arg1_4 and arg0_6[2] == arg2_4 then
				var0_4 = arg0_5[2]

				return
			end
		end)
	end)

	return var0_0.INDEX2BG[var0_4]
end

function var0_0.initHistory(arg0_7, arg1_7)
	arg0_7.history = {}

	for iter0_7, iter1_7 in ipairs(arg1_7) do
		arg0_7.history[iter1_7.plan_id] = iter1_7.count
	end
end

function var0_0.UpdateHistory(arg0_8, arg1_8)
	for iter0_8, iter1_8 in pairs(arg0_8.gridData) do
		for iter2_8, iter3_8 in pairs(iter1_8) do
			if iter3_8:IsPlan() then
				if not arg0_8.history[iter3_8.id] then
					arg0_8.history[iter3_8.id] = 0
				end

				arg0_8.history[iter3_8.id] = arg0_8.history[iter3_8.id] + 1
			end
		end
	end
end

function var0_0.GetHistoryCntById(arg0_9, arg1_9)
	return arg0_9.history[arg1_9] or 0
end

function var0_0.initGridData(arg0_10)
	arg0_10.gridData = {}

	for iter0_10, iter1_10 in ipairs(arg0_10.selectedPlans) do
		if not arg0_10.gridData[iter1_10.day] then
			arg0_10.gridData[iter1_10.day] = {}
		end

		if iter1_10.value[1] then
			local var0_10 = iter1_10.value[1].spec_event_id
			local var1_10 = iter1_10.value[1].plan_id

			if var0_10 and var0_10 ~= 0 then
				getProxy(EducateProxy):GetEventProxy():AddFinishSpecEvent(var0_10)

				arg0_10.gridData[iter1_10.day][iter1_10.index] = EducateGrid.New({
					id = var0_10,
					type = EducateGrid.TYPE_EVENT
				})
			elseif var1_10 and var1_10 ~= 0 then
				arg0_10.gridData[iter1_10.day][iter1_10.index] = EducateGrid.New({
					id = var1_10,
					type = EducateGrid.TYPE_PLAN
				})
			end
		end
	end
end

function var0_0.SetGridData(arg0_11, arg1_11)
	arg0_11.selectedPlans = arg1_11

	arg0_11:initGridData()
end

function var0_0.GetGridData(arg0_12)
	return arg0_12.gridData
end

function var0_0.GetCost(arg0_13)
	local var0_13 = 0
	local var1_13 = 0

	for iter0_13, iter1_13 in pairs(arg0_13.gridData) do
		for iter2_13, iter3_13 in pairs(iter1_13) do
			if iter3_13:IsPlan() then
				local var2_13, var3_13 = iter3_13.data:GetCost()

				var0_13 = var0_13 + var2_13
				var1_13 = var1_13 + var3_13
			end
		end
	end

	return var0_13, var1_13
end

function var0_0.CheckExcute(arg0_14)
	return #arg0_14.selectedPlans > 0
end

function var0_0.GetShowPlans(arg0_15, arg1_15, arg2_15, arg3_15)
	return underscore.select(arg0_15.allPlans, function(arg0_16)
		local var0_16 = arg0_16:getConfig("pre")[1]

		return arg0_16:IsShow(arg1_15, arg2_15, arg3_15) and arg0_16:IsMatchPre(arg0_15:GetHistoryCntById(var0_16))
	end)
end

function var0_0.ClearLocalPlansData(arg0_17)
	local var0_17 = getProxy(EducateProxy):GetCharData():GetNextWeekPlanCnt()

	for iter0_17 = 1, 6 do
		for iter1_17 = 1, 3 do
			local var1_17 = iter1_17 <= var0_17 and EducateGrid.TYPE_EMPTY or EducateGrid.TYPE_LOCK
			local var2_17 = 0 .. "_" .. var1_17

			PlayerPrefs.SetString(EducateConst.PLANS_DATA_KEY .. arg0_17.playerId .. "_" .. iter0_17 .. "_" .. iter1_17, var2_17)
		end
	end
end

function var0_0.GetRecommendPlan(arg0_18, arg1_18, arg2_18, arg3_18, arg4_18, arg5_18, arg6_18, arg7_18)
	local var0_18 = arg0_18:GetShowPlans(arg3_18:GetNextWeekStage(), arg1_18, arg2_18)
	local var1_18 = arg3_18.money - arg4_18
	local var2_18 = arg3_18.mood - arg5_18

	for iter0_18, iter1_18 in ipairs(arg7_18) do
		table.sort(var0_18, CompareFuncs({
			function(arg0_19)
				return -arg0_19:GetAttrResultValue(iter1_18)
			end,
			function(arg0_20)
				return arg0_20.id
			end
		}))

		for iter2_18, iter3_18 in ipairs(var0_18) do
			local var3_18, var4_18, var5_18 = iter3_18:GetCost()

			if var3_18 <= var1_18 and var4_18 <= var2_18 and var5_18 <= arg6_18 and iter3_18:IsMatchAttr(arg3_18) and iter3_18:IsMatchPre(arg0_18:GetHistoryCntById(iter3_18.id)) then
				return iter3_18
			end
		end
	end

	return nil
end

function var0_0.OnExecutePlanDone(arg0_21)
	arg0_21.selectedPlans = {}
end

function var0_0.OnNewWeek(arg0_22)
	return
end

function var0_0.GridData2ProtData(arg0_23)
	local var0_23 = {}

	for iter0_23, iter1_23 in pairs(arg0_23) do
		for iter2_23, iter3_23 in pairs(iter1_23) do
			if iter3_23:IsPlan() then
				table.insert(var0_23, {
					day = iter0_23,
					index = iter2_23,
					value = {
						{
							event_id = 0,
							spec_event_id = 0,
							plan_id = iter3_23.id
						}
					}
				})
			end

			if iter3_23:IsEvent() then
				table.insert(var0_23, {
					day = iter0_23,
					index = iter2_23,
					value = {
						{
							event_id = 0,
							plan_id = 0,
							spec_event_id = iter3_23.id
						}
					}
				})
			end
		end
	end

	return var0_23
end

return var0_0
