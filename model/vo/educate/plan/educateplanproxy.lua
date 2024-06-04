local var0 = class("EducatePlanProxy")

var0.INDEX2BG = {
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

function var0.Ctor(arg0)
	arg0.allPlans = {}

	local var0 = pg.child_plan.all

	for iter0, iter1 in ipairs(var0) do
		table.insert(arg0.allPlans, EducatePlan.New(iter1))
	end

	arg0.gridColorCfg = pg.child_data[1].plan_color
end

function var0.GetCfgPlans(arg0)
	return arg0.allPlans
end

function var0.SetUp(arg0, arg1)
	arg0:initHistory(arg1.history or {})

	arg0.selectedPlans = arg1.selectedPlans or {}

	if #arg0.selectedPlans > 0 then
		arg0:initGridData()
	else
		arg0.gridData = {}
	end

	arg0.playerId = getProxy(PlayerProxy):getRawData().id
end

function var0.GetGridBgName(arg0, arg1, arg2)
	local var0 = 1

	underscore.each(arg0.gridColorCfg, function(arg0)
		underscore.each(arg0[1], function(arg0)
			if arg0[1] == arg1 and arg0[2] == arg2 then
				var0 = arg0[2]

				return
			end
		end)
	end)

	return var0.INDEX2BG[var0]
end

function var0.initHistory(arg0, arg1)
	arg0.history = {}

	for iter0, iter1 in ipairs(arg1) do
		arg0.history[iter1.plan_id] = iter1.count
	end
end

function var0.UpdateHistory(arg0, arg1)
	for iter0, iter1 in pairs(arg0.gridData) do
		for iter2, iter3 in pairs(iter1) do
			if iter3:IsPlan() then
				if not arg0.history[iter3.id] then
					arg0.history[iter3.id] = 0
				end

				arg0.history[iter3.id] = arg0.history[iter3.id] + 1
			end
		end
	end
end

function var0.GetHistoryCntById(arg0, arg1)
	return arg0.history[arg1] or 0
end

function var0.initGridData(arg0)
	arg0.gridData = {}

	for iter0, iter1 in ipairs(arg0.selectedPlans) do
		if not arg0.gridData[iter1.day] then
			arg0.gridData[iter1.day] = {}
		end

		if iter1.value[1] then
			local var0 = iter1.value[1].spec_event_id
			local var1 = iter1.value[1].plan_id

			if var0 and var0 ~= 0 then
				getProxy(EducateProxy):GetEventProxy():AddFinishSpecEvent(var0)

				arg0.gridData[iter1.day][iter1.index] = EducateGrid.New({
					id = var0,
					type = EducateGrid.TYPE_EVENT
				})
			elseif var1 and var1 ~= 0 then
				arg0.gridData[iter1.day][iter1.index] = EducateGrid.New({
					id = var1,
					type = EducateGrid.TYPE_PLAN
				})
			end
		end
	end
end

function var0.SetGridData(arg0, arg1)
	arg0.selectedPlans = arg1

	arg0:initGridData()
end

function var0.GetGridData(arg0)
	return arg0.gridData
end

function var0.GetCost(arg0)
	local var0 = 0
	local var1 = 0

	for iter0, iter1 in pairs(arg0.gridData) do
		for iter2, iter3 in pairs(iter1) do
			if iter3:IsPlan() then
				local var2, var3 = iter3.data:GetCost()

				var0 = var0 + var2
				var1 = var1 + var3
			end
		end
	end

	return var0, var1
end

function var0.CheckExcute(arg0)
	return #arg0.selectedPlans > 0
end

function var0.GetShowPlans(arg0, arg1, arg2, arg3)
	return underscore.select(arg0.allPlans, function(arg0)
		local var0 = arg0:getConfig("pre")[1]

		return arg0:IsShow(arg1, arg2, arg3) and arg0:IsMatchPre(arg0:GetHistoryCntById(var0))
	end)
end

function var0.ClearLocalPlansData(arg0)
	local var0 = getProxy(EducateProxy):GetCharData():GetNextWeekPlanCnt()

	for iter0 = 1, 6 do
		for iter1 = 1, 3 do
			local var1 = iter1 <= var0 and EducateGrid.TYPE_EMPTY or EducateGrid.TYPE_LOCK
			local var2 = 0 .. "_" .. var1

			PlayerPrefs.SetString(EducateConst.PLANS_DATA_KEY .. arg0.playerId .. "_" .. iter0 .. "_" .. iter1, var2)
		end
	end
end

function var0.GetRecommendPlan(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
	local var0 = arg0:GetShowPlans(arg3:GetNextWeekStage(), arg1, arg2)
	local var1 = arg3.money - arg4
	local var2 = arg3.mood - arg5

	for iter0, iter1 in ipairs(arg7) do
		table.sort(var0, CompareFuncs({
			function(arg0)
				return -arg0:GetAttrResultValue(iter1)
			end,
			function(arg0)
				return arg0.id
			end
		}))

		for iter2, iter3 in ipairs(var0) do
			local var3, var4, var5 = iter3:GetCost()

			if var3 <= var1 and var4 <= var2 and var5 <= arg6 and iter3:IsMatchAttr(arg3) and iter3:IsMatchPre(arg0:GetHistoryCntById(iter3.id)) then
				return iter3
			end
		end
	end

	return nil
end

function var0.OnExecutePlanDone(arg0)
	arg0.selectedPlans = {}
end

function var0.OnNewWeek(arg0)
	return
end

function var0.GridData2ProtData(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0) do
		for iter2, iter3 in pairs(iter1) do
			if iter3:IsPlan() then
				table.insert(var0, {
					day = iter0,
					index = iter2,
					value = {
						{
							event_id = 0,
							spec_event_id = 0,
							plan_id = iter3.id
						}
					}
				})
			end

			if iter3:IsEvent() then
				table.insert(var0, {
					day = iter0,
					index = iter2,
					value = {
						{
							event_id = 0,
							plan_id = 0,
							spec_event_id = iter3.id
						}
					}
				})
			end
		end
	end

	return var0
end

return var0
