local var0 = class("ColoringProxy", import(".NetProxy"))

function var0.register(arg0)
	arg0.colorGroups = {}
	arg0.colorItems = {}
end

function var0.netUpdateData(arg0, arg1)
	arg0.startTime = arg1.start_time

	local var0 = {}

	_.each(arg1.award_list, function(arg0)
		var0[arg0.id] = _.map(arg0.award_list, function(arg0)
			return {
				type = arg0.type,
				id = arg0.id,
				count = arg0.number
			}
		end)
	end)

	local var1 = {}
	local var2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_COLORING_ALPHA)

	if var2 and not var2:isEnd() then
		var1 = var2:getConfig("config_data")
	end

	arg0.colorGroups = {}

	_.each(var1, function(arg0)
		local var0 = arg0[1]
		local var1 = arg0[2]
		local var2 = ColorGroup.New(var0)

		if var2:canBeCustomised() and COLORING_ACTIVITY_CUSTOMIZED_BANNED then
			return
		end

		var2:setHasAward(var1 > 0)

		if var0 == arg1.id then
			_.each(arg1.cell_list, function(arg0)
				var2:setFill(arg0.row, arg0.column, arg0.color)
			end)
		end

		local var3 = var0[var0] or {}

		var2:setDrops(var3)

		if var1 > 0 and #var3 > 0 then
			var2:setState(ColorGroup.StateAchieved)
		elseif var0 < arg1.id or var2:isAllFill() then
			var2:setState(ColorGroup.StateFinish)
		end

		table.insert(arg0.colorGroups, var2)
	end)

	local var3 = 0

	for iter0 = #arg0.colorGroups, 1, -1 do
		local var4 = arg0.colorGroups[iter0]:getState()

		if var4 == ColorGroup.StateFinish or var4 == ColorGroup.StateAchieved then
			var3 = iter0

			break
		end
	end

	for iter1 = var3 - 1, 1, -1 do
		local var5 = arg0.colorGroups[iter1]

		if not var5:getState() then
			var5:setState(ColorGroup.StateFinish)
		end
	end

	if var3 + 1 <= #arg0.colorGroups then
		arg0.colorGroups[var3 + 1]:setState(var3 == 0 and ColorGroup.StateColoring or ColorGroup.StateLock)
	end

	for iter2 = var3 + 2, #arg0.colorGroups do
		local var6 = arg0.colorGroups[iter2]

		if not var6:getState() then
			var6:setState(ColorGroup.StateLock)
		end
	end

	arg0:checkState()

	arg0.colorItems = {}

	for iter3, iter4 in ipairs(arg1.color_list) do
		arg0.colorItems[iter4.id] = iter4.number
	end
end

function var0.getColorItems(arg0)
	return arg0.colorItems
end

function var0.getColorGroups(arg0)
	return arg0.colorGroups
end

function var0.getColorGroup(arg0, arg1)
	return _.detect(arg0.colorGroups, function(arg0)
		return arg0.id == arg1
	end)
end

function var0.checkState(arg0)
	local var0 = false
	local var1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_COLORING_ALPHA)

	if var1 and not var1:isEnd() then
		local var2 = pg.TimeMgr.GetInstance()
		local var3 = var2:DiffDay(arg0.startTime, var2:GetServerTime()) + 1

		for iter0, iter1 in ipairs(arg0.colorGroups) do
			if iter1:getState() == ColorGroup.StateColoring and iter1:isAllFill() then
				iter1:setState(ColorGroup.StateFinish)

				var0 = true

				break
			elseif iter0 < var3 and iter1:getState() == ColorGroup.StateAchieved then
				local var4 = arg0.colorGroups[iter0 + 1]

				if var4 and var4:getState() == ColorGroup.StateLock then
					var4:setState(ColorGroup.StateColoring)

					var0 = true

					break
				end
			end
		end
	end

	return var0
end

function var0.CheckTodayTip(arg0)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_COLORING_ALPHA)

	if var0 and not var0:isEnd() and arg0.startTime then
		local var1 = pg.TimeMgr.GetInstance()
		local var2 = math.min(var1:DiffDay(arg0.startTime, var1:GetServerTime()) + 1, #arg0.colorGroups)
		local var3 = arg0:GetViewedPage()

		for iter0, iter1 in ipairs(arg0.colorGroups) do
			if var2 < iter0 then
				break
			end

			if iter1:getState() == ColorGroup.StateLock then
				break
			end

			if iter1:getState() ~= ColorGroup.StateAchieved and not iter1:canBeCustomised() then
				if var3 < iter0 then
					return true
				end

				if iter1:getState() == ColorGroup.StateFinish or iter1:HasEnoughItem2FillAll(arg0:getColorItems()) then
					return true
				end

				break
			end
		end
	end
end

function var0.IsALLAchieve(arg0)
	if #arg0.colorGroups == 0 then
		return false
	end

	return _.all(arg0.colorGroups, function(arg0)
		return arg0:canBeCustomised() or arg0:getState() == ColorGroup.StateAchieved
	end)
end

function var0.GetViewedPage(arg0)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_COLORING_ALPHA)

	if not var0 or var0:isEnd() then
		return 0
	end

	local var1 = getProxy(PlayerProxy):getRawData()

	return PlayerPrefs.GetInt("pixelDraw_maxPage_" .. var0.id .. "_" .. var1.id, 0)
end

function var0.SetViewedPage(arg0, arg1)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_COLORING_ALPHA)

	if not var0 or var0:isEnd() then
		return
	end

	if arg1 <= arg0:GetViewedPage() then
		return
	end

	local var1 = getProxy(PlayerProxy):getRawData()

	return PlayerPrefs.SetInt("pixelDraw_maxPage_" .. var0.id .. "_" .. var1.id, arg1)
end

return var0
