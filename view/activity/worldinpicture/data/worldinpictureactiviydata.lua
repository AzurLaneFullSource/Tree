local var0 = class("WorldInPictureActiviyData")

function var0.Ctor(arg0, arg1)
	arg0.activity = arg1
	arg0.config = pg.activity_event_grid[arg1.data1]
	arg0.travelPoint = arg1.data2
	arg0.drawPoint = arg1.data3
	arg0.travelList = arg1.data1_list
	arg0.drawList = arg1.data2_list
	arg0.awardList = arg1.data3_list
	arg0.size = arg0.config.map
	arg0.drawAreaList = {}
	arg0.drawAreaAnimList = {}

	for iter0, iter1 in ipairs(arg0.config.zone) do
		table.insert(arg0.drawAreaAnimList, arg0.config.zone_anim_Pos[iter0])
		table.insert(arg0.drawAreaList, arg0:WarpDrawArea(iter1))
	end

	arg0.boxItems = {}

	for iter2, iter3 in ipairs(arg0.config.box) do
		local var0 = iter3[1]
		local var1 = iter3[2]

		if not arg0.boxItems[var0] then
			arg0.boxItems[var0] = {}
		end

		arg0.boxItems[var0][var1] = true
	end
end

function var0.WarpDrawArea(arg0, arg1)
	local var0 = arg1[1]
	local var1 = arg1[2]
	local var2 = arg1[3]
	local var3 = arg1[4]
	local var4 = {}

	for iter0 = var0, var2 do
		for iter1 = var1, var3 do
			table.insert(var4, Vector2(iter0, iter1))
		end
	end

	return var4
end

function var0.GetMapRowAndColumn(arg0)
	return arg0.size[1], arg0.size[2]
end

function var0.GetTravelPoint(arg0)
	return arg0.travelPoint
end

function var0.GetDrawPoint(arg0)
	return arg0.drawPoint
end

function var0.GetTravelProgress(arg0)
	return #arg0.travelList
end

function var0.GetMaxTravelCnt(arg0)
	local var0, var1 = arg0:GetMapRowAndColumn()

	return var0 * var1
end

function var0.IsTravelAll(arg0)
	return arg0:GetTravelProgress() >= arg0:GetMaxTravelCnt()
end

function var0.GetDrawProgress(arg0)
	return #arg0.drawList
end

function var0.GetMaxDrawCnt(arg0)
	return #arg0.drawAreaList
end

function var0.IsDrawAll(arg0)
	return arg0:GetDrawProgress() >= arg0:GetMaxDrawCnt()
end

function var0.GetTravelList(arg0)
	return arg0.travelList
end

function var0.GetDrawList(arg0)
	return arg0.drawList
end

function var0.GetAwardList(arg0)
	return arg0.awardList
end

function var0.IsFirstTravel(arg0)
	return #arg0.travelList == 1
end

function var0.OutSide(arg0, arg1, arg2)
	local var0, var1 = arg0:GetMapRowAndColumn()

	return arg1 <= 0 or arg2 <= 0 or var0 < arg1 or var1 < arg2
end

function var0.IsOpened(arg0, arg1, arg2)
	local var0, var1 = arg0:GetMapRowAndColumn()
	local var2 = (arg1 - 1) * var1 + arg2

	return not arg0:OutSide(arg1, arg2) and table.contains(arg0.travelList, var2)
end

function var0.CanSelect(arg0, arg1, arg2)
	if #arg0.travelList == 0 then
		return true
	end

	if arg0:IsOpened(arg1, arg2) then
		return false
	end

	local var0 = {
		Vector2(arg1 + 1, arg2),
		Vector2(arg1, arg2 + 1),
		Vector2(arg1 - 1, arg2),
		Vector2(arg1, arg2 - 1)
	}

	return _.any(var0, function(arg0)
		return arg0:IsOpened(arg0.x, arg0.y)
	end)
end

function var0.ExistBox(arg0, arg1, arg2)
	return arg0.boxItems[arg1] and arg0.boxItems[arg1][arg2] == true
end

function var0.AnyAreaCanDraw(arg0)
	return _.any(arg0.drawAreaList, function(arg0)
		return not arg0:IsDrawed(arg0[1].x, arg0[1].y) and _.all(arg0, function(arg0)
			return arg0:IsOpened(arg0.x, arg0.y)
		end)
	end)
end

function var0.GetDrawableArea(arg0, arg1, arg2)
	return _.detect(arg0.drawAreaList, function(arg0)
		return arg0[1] == Vector2(arg1, arg2)
	end)
end

function var0.GetDrawableAreasState(arg0)
	return _.map(arg0.drawAreaList, function(arg0)
		local var0 = not arg0:IsDrawed(arg0[1].x, arg0[1].y) and _.all(arg0, function(arg0)
			return arg0:IsOpened(arg0.x, arg0.y)
		end)

		return {
			position = arg0[1],
			open = var0
		}
	end)
end

function var0.GetDrawIndex(arg0, arg1, arg2)
	local var0 = -1

	for iter0, iter1 in ipairs(arg0.drawAreaList) do
		if _.any(iter1, function(arg0)
			return arg0 == Vector2(arg1, arg2)
		end) then
			var0 = iter0

			break
		end
	end

	return var0
end

function var0.IsDrawed(arg0, arg1, arg2)
	local var0 = arg0:GetDrawIndex(arg1, arg2)

	return table.contains(arg0.drawList, var0)
end

function var0.CanDraw(arg0, arg1, arg2)
	if arg0:IsDrawed(arg1, arg2) then
		return false
	end

	local var0

	for iter0, iter1 in ipairs(arg0.drawAreaList) do
		if _.any(iter1, function(arg0)
			return arg0 == Vector2(arg1, arg2)
		end) then
			var0 = iter1

			break
		end
	end

	if not var0 then
		return false
	end

	return (_.all(var0, function(arg0)
		return arg0:IsOpened(arg0.x, arg0.y)
	end))
end

function var0.Convert2DrawAreaHead(arg0, arg1, arg2)
	local var0
	local var1

	for iter0, iter1 in ipairs(arg0.drawAreaList) do
		if _.any(iter1, function(arg0)
			return arg0 == Vector2(arg1, arg2)
		end) then
			var0 = iter1
			var1 = iter0

			break
		end
	end

	assert(var0)

	return var0[1].x, var0[1].y, var1
end

function var0.GetDrawAnimData(arg0, arg1, arg2)
	local var0 = arg0:GetDrawIndex(arg1, arg2)

	return arg0.drawAreaAnimList[var0]
end

function var0.FindNextTravelable(arg0)
	if arg0:GetTravelPoint() <= 0 then
		return nil
	end

	local var0, var1 = arg0:GetMapRowAndColumn()

	for iter0 = 1, var0 do
		for iter1 = 1, var1 do
			if arg0:CanSelect(iter0, iter1) then
				local var2 = (iter0 - 1) * var1 + iter1

				return Vector2(iter0, iter1), var2
			end
		end
	end

	return nil
end

function var0.FindNextDrawableAreaHead(arg0)
	if arg0:GetDrawPoint() <= 0 then
		return nil
	end

	for iter0, iter1 in ipairs(arg0.drawAreaList) do
		if not arg0:IsDrawed(iter1[1].x, iter1[1].y) and _.all(iter1, function(arg0)
			return arg0:IsOpened(arg0.x, arg0.y)
		end) then
			return iter1[1], iter0
		end
	end

	return nil
end

return var0
