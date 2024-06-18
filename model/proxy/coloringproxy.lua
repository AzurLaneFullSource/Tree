local var0_0 = class("ColoringProxy", import(".NetProxy"))

function var0_0.register(arg0_1)
	arg0_1.colorGroups = {}
	arg0_1.colorItems = {}
end

function var0_0.netUpdateData(arg0_2, arg1_2)
	arg0_2.startTime = arg1_2.start_time

	local var0_2 = {}

	_.each(arg1_2.award_list, function(arg0_3)
		var0_2[arg0_3.id] = _.map(arg0_3.award_list, function(arg0_4)
			return {
				type = arg0_4.type,
				id = arg0_4.id,
				count = arg0_4.number
			}
		end)
	end)

	local var1_2 = {}
	local var2_2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_COLORING_ALPHA)

	if var2_2 and not var2_2:isEnd() then
		var1_2 = var2_2:getConfig("config_data")
	end

	arg0_2.colorGroups = {}

	_.each(var1_2, function(arg0_5)
		local var0_5 = arg0_5[1]
		local var1_5 = arg0_5[2]
		local var2_5 = ColorGroup.New(var0_5)

		if var2_5:canBeCustomised() and COLORING_ACTIVITY_CUSTOMIZED_BANNED then
			return
		end

		var2_5:setHasAward(var1_5 > 0)

		if var0_5 == arg1_2.id then
			_.each(arg1_2.cell_list, function(arg0_6)
				var2_5:setFill(arg0_6.row, arg0_6.column, arg0_6.color)
			end)
		end

		local var3_5 = var0_2[var0_5] or {}

		var2_5:setDrops(var3_5)

		if var1_5 > 0 and #var3_5 > 0 then
			var2_5:setState(ColorGroup.StateAchieved)
		elseif var0_5 < arg1_2.id or var2_5:isAllFill() then
			var2_5:setState(ColorGroup.StateFinish)
		end

		table.insert(arg0_2.colorGroups, var2_5)
	end)

	local var3_2 = 0

	for iter0_2 = #arg0_2.colorGroups, 1, -1 do
		local var4_2 = arg0_2.colorGroups[iter0_2]:getState()

		if var4_2 == ColorGroup.StateFinish or var4_2 == ColorGroup.StateAchieved then
			var3_2 = iter0_2

			break
		end
	end

	for iter1_2 = var3_2 - 1, 1, -1 do
		local var5_2 = arg0_2.colorGroups[iter1_2]

		if not var5_2:getState() then
			var5_2:setState(ColorGroup.StateFinish)
		end
	end

	if var3_2 + 1 <= #arg0_2.colorGroups then
		arg0_2.colorGroups[var3_2 + 1]:setState(var3_2 == 0 and ColorGroup.StateColoring or ColorGroup.StateLock)
	end

	for iter2_2 = var3_2 + 2, #arg0_2.colorGroups do
		local var6_2 = arg0_2.colorGroups[iter2_2]

		if not var6_2:getState() then
			var6_2:setState(ColorGroup.StateLock)
		end
	end

	arg0_2:checkState()

	arg0_2.colorItems = {}

	for iter3_2, iter4_2 in ipairs(arg1_2.color_list) do
		arg0_2.colorItems[iter4_2.id] = iter4_2.number
	end
end

function var0_0.getColorItems(arg0_7)
	return arg0_7.colorItems
end

function var0_0.getColorGroups(arg0_8)
	return arg0_8.colorGroups
end

function var0_0.getColorGroup(arg0_9, arg1_9)
	return _.detect(arg0_9.colorGroups, function(arg0_10)
		return arg0_10.id == arg1_9
	end)
end

function var0_0.checkState(arg0_11)
	local var0_11 = false
	local var1_11 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_COLORING_ALPHA)

	if var1_11 and not var1_11:isEnd() then
		local var2_11 = pg.TimeMgr.GetInstance()
		local var3_11 = var2_11:DiffDay(arg0_11.startTime, var2_11:GetServerTime()) + 1

		for iter0_11, iter1_11 in ipairs(arg0_11.colorGroups) do
			if iter1_11:getState() == ColorGroup.StateColoring and iter1_11:isAllFill() then
				iter1_11:setState(ColorGroup.StateFinish)

				var0_11 = true

				break
			elseif iter0_11 < var3_11 and iter1_11:getState() == ColorGroup.StateAchieved then
				local var4_11 = arg0_11.colorGroups[iter0_11 + 1]

				if var4_11 and var4_11:getState() == ColorGroup.StateLock then
					var4_11:setState(ColorGroup.StateColoring)

					var0_11 = true

					break
				end
			end
		end
	end

	return var0_11
end

function var0_0.CheckTodayTip(arg0_12)
	local var0_12 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_COLORING_ALPHA)

	if var0_12 and not var0_12:isEnd() and arg0_12.startTime then
		local var1_12 = pg.TimeMgr.GetInstance()
		local var2_12 = math.min(var1_12:DiffDay(arg0_12.startTime, var1_12:GetServerTime()) + 1, #arg0_12.colorGroups)
		local var3_12 = arg0_12:GetViewedPage()

		for iter0_12, iter1_12 in ipairs(arg0_12.colorGroups) do
			if var2_12 < iter0_12 then
				break
			end

			if iter1_12:getState() == ColorGroup.StateLock then
				break
			end

			if iter1_12:getState() ~= ColorGroup.StateAchieved and not iter1_12:canBeCustomised() then
				if var3_12 < iter0_12 then
					return true
				end

				if iter1_12:getState() == ColorGroup.StateFinish or iter1_12:HasEnoughItem2FillAll(arg0_12:getColorItems()) then
					return true
				end

				break
			end
		end
	end
end

function var0_0.IsALLAchieve(arg0_13)
	if #arg0_13.colorGroups == 0 then
		return false
	end

	return _.all(arg0_13.colorGroups, function(arg0_14)
		return arg0_14:canBeCustomised() or arg0_14:getState() == ColorGroup.StateAchieved
	end)
end

function var0_0.GetViewedPage(arg0_15)
	local var0_15 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_COLORING_ALPHA)

	if not var0_15 or var0_15:isEnd() then
		return 0
	end

	local var1_15 = getProxy(PlayerProxy):getRawData()

	return PlayerPrefs.GetInt("pixelDraw_maxPage_" .. var0_15.id .. "_" .. var1_15.id, 0)
end

function var0_0.SetViewedPage(arg0_16, arg1_16)
	local var0_16 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_COLORING_ALPHA)

	if not var0_16 or var0_16:isEnd() then
		return
	end

	if arg1_16 <= arg0_16:GetViewedPage() then
		return
	end

	local var1_16 = getProxy(PlayerProxy):getRawData()

	return PlayerPrefs.SetInt("pixelDraw_maxPage_" .. var0_16.id .. "_" .. var1_16.id, arg1_16)
end

return var0_0
