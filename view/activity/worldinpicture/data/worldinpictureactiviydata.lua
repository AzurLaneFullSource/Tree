local var0_0 = class("WorldInPictureActiviyData")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.activity = arg1_1
	arg0_1.config = pg.activity_event_grid[arg1_1.data1]
	arg0_1.travelPoint = arg1_1.data2
	arg0_1.drawPoint = arg1_1.data3
	arg0_1.travelList = arg1_1.data1_list
	arg0_1.drawList = arg1_1.data2_list
	arg0_1.awardList = arg1_1.data3_list
	arg0_1.size = arg0_1.config.map
	arg0_1.drawAreaList = {}
	arg0_1.drawAreaAnimList = {}

	for iter0_1, iter1_1 in ipairs(arg0_1.config.zone) do
		table.insert(arg0_1.drawAreaAnimList, arg0_1.config.zone_anim_Pos[iter0_1])
		table.insert(arg0_1.drawAreaList, arg0_1:WarpDrawArea(iter1_1))
	end

	arg0_1.boxItems = {}

	for iter2_1, iter3_1 in ipairs(arg0_1.config.box) do
		local var0_1 = iter3_1[1]
		local var1_1 = iter3_1[2]

		if not arg0_1.boxItems[var0_1] then
			arg0_1.boxItems[var0_1] = {}
		end

		arg0_1.boxItems[var0_1][var1_1] = true
	end
end

function var0_0.WarpDrawArea(arg0_2, arg1_2)
	local var0_2 = arg1_2[1]
	local var1_2 = arg1_2[2]
	local var2_2 = arg1_2[3]
	local var3_2 = arg1_2[4]
	local var4_2 = {}

	for iter0_2 = var0_2, var2_2 do
		for iter1_2 = var1_2, var3_2 do
			table.insert(var4_2, Vector2(iter0_2, iter1_2))
		end
	end

	return var4_2
end

function var0_0.GetMapRowAndColumn(arg0_3)
	return arg0_3.size[1], arg0_3.size[2]
end

function var0_0.GetTravelPoint(arg0_4)
	return arg0_4.travelPoint
end

function var0_0.GetDrawPoint(arg0_5)
	return arg0_5.drawPoint
end

function var0_0.GetTravelProgress(arg0_6)
	return #arg0_6.travelList
end

function var0_0.GetMaxTravelCnt(arg0_7)
	local var0_7, var1_7 = arg0_7:GetMapRowAndColumn()

	return var0_7 * var1_7
end

function var0_0.IsTravelAll(arg0_8)
	return arg0_8:GetTravelProgress() >= arg0_8:GetMaxTravelCnt()
end

function var0_0.GetDrawProgress(arg0_9)
	return #arg0_9.drawList
end

function var0_0.GetMaxDrawCnt(arg0_10)
	return #arg0_10.drawAreaList
end

function var0_0.IsDrawAll(arg0_11)
	return arg0_11:GetDrawProgress() >= arg0_11:GetMaxDrawCnt()
end

function var0_0.GetTravelList(arg0_12)
	return arg0_12.travelList
end

function var0_0.GetDrawList(arg0_13)
	return arg0_13.drawList
end

function var0_0.GetAwardList(arg0_14)
	return arg0_14.awardList
end

function var0_0.IsFirstTravel(arg0_15)
	return #arg0_15.travelList == 1
end

function var0_0.OutSide(arg0_16, arg1_16, arg2_16)
	local var0_16, var1_16 = arg0_16:GetMapRowAndColumn()

	return arg1_16 <= 0 or arg2_16 <= 0 or var0_16 < arg1_16 or var1_16 < arg2_16
end

function var0_0.IsOpened(arg0_17, arg1_17, arg2_17)
	local var0_17, var1_17 = arg0_17:GetMapRowAndColumn()
	local var2_17 = (arg1_17 - 1) * var1_17 + arg2_17

	return not arg0_17:OutSide(arg1_17, arg2_17) and table.contains(arg0_17.travelList, var2_17)
end

function var0_0.CanSelect(arg0_18, arg1_18, arg2_18)
	if #arg0_18.travelList == 0 then
		return true
	end

	if arg0_18:IsOpened(arg1_18, arg2_18) then
		return false
	end

	local var0_18 = {
		Vector2(arg1_18 + 1, arg2_18),
		Vector2(arg1_18, arg2_18 + 1),
		Vector2(arg1_18 - 1, arg2_18),
		Vector2(arg1_18, arg2_18 - 1)
	}

	return _.any(var0_18, function(arg0_19)
		return arg0_18:IsOpened(arg0_19.x, arg0_19.y)
	end)
end

function var0_0.ExistBox(arg0_20, arg1_20, arg2_20)
	return arg0_20.boxItems[arg1_20] and arg0_20.boxItems[arg1_20][arg2_20] == true
end

function var0_0.AnyAreaCanDraw(arg0_21)
	return _.any(arg0_21.drawAreaList, function(arg0_22)
		return not arg0_21:IsDrawed(arg0_22[1].x, arg0_22[1].y) and _.all(arg0_22, function(arg0_23)
			return arg0_21:IsOpened(arg0_23.x, arg0_23.y)
		end)
	end)
end

function var0_0.GetDrawableArea(arg0_24, arg1_24, arg2_24)
	return _.detect(arg0_24.drawAreaList, function(arg0_25)
		return arg0_25[1] == Vector2(arg1_24, arg2_24)
	end)
end

function var0_0.GetDrawableAreasState(arg0_26)
	return _.map(arg0_26.drawAreaList, function(arg0_27)
		local var0_27 = not arg0_26:IsDrawed(arg0_27[1].x, arg0_27[1].y) and _.all(arg0_27, function(arg0_28)
			return arg0_26:IsOpened(arg0_28.x, arg0_28.y)
		end)

		return {
			position = arg0_27[1],
			open = var0_27
		}
	end)
end

function var0_0.GetDrawIndex(arg0_29, arg1_29, arg2_29)
	local var0_29 = -1

	for iter0_29, iter1_29 in ipairs(arg0_29.drawAreaList) do
		if _.any(iter1_29, function(arg0_30)
			return arg0_30 == Vector2(arg1_29, arg2_29)
		end) then
			var0_29 = iter0_29

			break
		end
	end

	return var0_29
end

function var0_0.IsDrawed(arg0_31, arg1_31, arg2_31)
	local var0_31 = arg0_31:GetDrawIndex(arg1_31, arg2_31)

	return table.contains(arg0_31.drawList, var0_31)
end

function var0_0.CanDraw(arg0_32, arg1_32, arg2_32)
	if arg0_32:IsDrawed(arg1_32, arg2_32) then
		return false
	end

	local var0_32

	for iter0_32, iter1_32 in ipairs(arg0_32.drawAreaList) do
		if _.any(iter1_32, function(arg0_33)
			return arg0_33 == Vector2(arg1_32, arg2_32)
		end) then
			var0_32 = iter1_32

			break
		end
	end

	if not var0_32 then
		return false
	end

	return (_.all(var0_32, function(arg0_34)
		return arg0_32:IsOpened(arg0_34.x, arg0_34.y)
	end))
end

function var0_0.Convert2DrawAreaHead(arg0_35, arg1_35, arg2_35)
	local var0_35
	local var1_35

	for iter0_35, iter1_35 in ipairs(arg0_35.drawAreaList) do
		if _.any(iter1_35, function(arg0_36)
			return arg0_36 == Vector2(arg1_35, arg2_35)
		end) then
			var0_35 = iter1_35
			var1_35 = iter0_35

			break
		end
	end

	assert(var0_35)

	return var0_35[1].x, var0_35[1].y, var1_35
end

function var0_0.GetDrawAnimData(arg0_37, arg1_37, arg2_37)
	local var0_37 = arg0_37:GetDrawIndex(arg1_37, arg2_37)

	return arg0_37.drawAreaAnimList[var0_37]
end

function var0_0.FindNextTravelable(arg0_38)
	if arg0_38:GetTravelPoint() <= 0 then
		return nil
	end

	local var0_38, var1_38 = arg0_38:GetMapRowAndColumn()

	for iter0_38 = 1, var0_38 do
		for iter1_38 = 1, var1_38 do
			if arg0_38:CanSelect(iter0_38, iter1_38) then
				local var2_38 = (iter0_38 - 1) * var1_38 + iter1_38

				return Vector2(iter0_38, iter1_38), var2_38
			end
		end
	end

	return nil
end

function var0_0.FindNextDrawableAreaHead(arg0_39)
	if arg0_39:GetDrawPoint() <= 0 then
		return nil
	end

	for iter0_39, iter1_39 in ipairs(arg0_39.drawAreaList) do
		if not arg0_39:IsDrawed(iter1_39[1].x, iter1_39[1].y) and _.all(iter1_39, function(arg0_40)
			return arg0_39:IsOpened(arg0_40.x, arg0_40.y)
		end) then
			return iter1_39[1], iter0_39
		end
	end

	return nil
end

return var0_0
