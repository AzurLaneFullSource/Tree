local var0_0 = class("CourtYardDepthMap")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.sizeX = arg1_1
	arg0_1.sizeY = arg2_1
	arg0_1.depths = {}
	arg0_1.dependInfo = {}
	arg0_1.allItems = {}
	arg0_1.sortedFlag = false
	arg0_1.sortedItems = {}

	arg0_1:ResetDepth()
end

function var0_0.SetAfterFunc(arg0_2, arg1_2)
	arg0_2.afterSortFunc = arg1_2
end

function var0_0.GetDepth(arg0_3, arg1_3, arg2_3)
	return arg0_3.depths[arg0_3:GetIndex(arg1_3, arg2_3)]
end

function var0_0.InsertChar(arg0_4, arg1_4)
	local var0_4 = arg0_4:GetDepth(arg1_4.posX, arg1_4.posY)

	arg1_4:SetDepth(var0_4)

	for iter0_4, iter1_4 in ipairs(arg0_4.sortedItems) do
		if var0_4 > iter1_4.posZ then
			table.insert(arg0_4.sortedItems, iter0_4, arg1_4)
			arg0_4:CheckCharByIndex()

			return iter0_4 - 1
		end
	end

	local var1_4 = #arg0_4.sortedItems

	table.insert(arg0_4.sortedItems, var1_4 + 1, arg1_4)
	arg0_4:CheckCharByIndex()

	return var1_4
end

function var0_0.CheckCharByIndex(arg0_5)
	for iter0_5 = 1, #arg0_5.sortedItems do
		local var0_5 = math.min(iter0_5 + 1, #arg0_5.sortedItems)

		assert(arg0_5.sortedItems[iter0_5].posZ >= arg0_5.sortedItems[var0_5].posZ, "舰娘插入队列位置错误")
	end
end

function var0_0.RemoveChar(arg0_6, arg1_6)
	table.removebyvalue(arg0_6.sortedItems, arg1_6)
end

function var0_0.GetIndex(arg0_7, arg1_7, arg2_7)
	return (arg2_7 - 1) * arg0_7.sizeX + arg1_7
end

function var0_0.ResetDepth(arg0_8)
	local var0_8 = arg0_8.depths

	for iter0_8 = 1, arg0_8.sizeX do
		for iter1_8 = 1, arg0_8.sizeY do
			var0_8[arg0_8:GetIndex(iter0_8, iter1_8)] = iter0_8 + iter1_8 - 1
		end
	end
end

function var0_0.AddDepth(arg0_9, arg1_9, arg2_9, arg3_9)
	local var0_9 = arg0_9.depths

	for iter0_9 = 1, arg1_9 do
		for iter1_9 = 1, arg2_9 do
			local var1_9 = arg0_9:GetIndex(iter0_9, iter1_9)

			var0_9[var1_9] = var0_9[var1_9] + arg3_9
		end
	end
end

function var0_0.ModifyDepth(arg0_10, arg1_10)
	local var0_10 = arg0_10.depths
	local var1_10 = arg1_10.posX
	local var2_10 = arg1_10.posY
	local var3_10 = arg1_10.maxX
	local var4_10 = arg1_10.maxY
	local var5_10 = var0_10[arg0_10:GetIndex(var3_10, var2_10)]
	local var6_10 = var0_10[arg0_10:GetIndex(var1_10, var4_10)]

	if var5_10 == var6_10 then
		arg1_10:SetDepth(var5_10)

		return
	end

	if var5_10 < var6_10 then
		if var1_10 > 1 then
			local var7_10 = var5_10 - 1 - var0_10[arg0_10:GetIndex(var1_10 - 1, var4_10)]

			if var7_10 < 0 then
				arg0_10:AddDepth(var1_10 - 1, var4_10, var7_10)
			end
		end

		arg1_10:SetDepth(var5_10)

		return
	else
		if var2_10 > 1 then
			local var8_10 = var6_10 - 1 - var0_10[arg0_10:GetIndex(var3_10, var2_10 - 1)]

			if var8_10 < 0 then
				arg0_10:AddDepth(var3_10, var2_10 - 1, var8_10)
			end
		end

		arg1_10:SetDepth(var6_10)

		return
	end
end

function var0_0.PlaceItem(arg0_11, arg1_11)
	local var0_11 = arg1_11.maxX
	local var1_11 = arg1_11.maxY
	local var2_11 = arg1_11.posX
	local var3_11 = arg1_11.posY
	local var4_11 = {}

	arg0_11.dependInfo[arg1_11] = var4_11

	for iter0_11, iter1_11 in ipairs(arg0_11.allItems) do
		if var2_11 <= iter1_11.maxX and var3_11 <= iter1_11.maxY then
			var4_11[#var4_11 + 1] = iter1_11
		elseif var0_11 >= iter1_11.posX and var1_11 >= iter1_11.posY then
			table.insert(arg0_11.dependInfo[iter1_11], arg1_11)
		end
	end

	table.insert(arg0_11.allItems, arg1_11)

	arg1_11.sortedFlag = arg0_11.sortedFlag

	arg0_11:SortAndCalcDepth()

	local var5_11 = arg0_11.afterSortFunc

	if var5_11 then
		var5_11(arg0_11.sortedItems)
	end
end

function var0_0.sortItemByDepth(arg0_12, arg1_12)
	return arg0_12.posZ > arg1_12.posZ
end

function var0_0.SortAndCalcDepth(arg0_13)
	local var0_13 = {}

	arg0_13.sortedItems = var0_13
	arg0_13.sortedFlag = not arg0_13.sortedFlag

	for iter0_13, iter1_13 in ipairs(arg0_13.allItems) do
		arg0_13:AddItemAndDepend(iter1_13)
	end

	arg0_13:ResetDepth()

	for iter2_13, iter3_13 in ipairs(var0_13) do
		arg0_13:ModifyDepth(iter3_13)
	end

	table.sort(var0_13, var0_0.sortItemByDepth)
end

function var0_0.AddItemAndDepend(arg0_14, arg1_14)
	if arg1_14.sortedFlag == arg0_14.sortedFlag then
		return
	end

	for iter0_14, iter1_14 in ipairs(arg0_14.dependInfo[arg1_14]) do
		arg0_14:AddItemAndDepend(iter1_14)
	end

	table.insert(arg0_14.sortedItems, arg1_14)
	assert(arg1_14.sortedFlag ~= sortedFlag, "依赖关系产生了循环！")

	arg1_14.sortedFlag = arg0_14.sortedFlag
end

function var0_0.RemoveItem(arg0_15, arg1_15)
	local var0_15 = arg1_15.posX
	local var1_15 = arg1_15.posY
	local var2_15 = arg1_15.maxX
	local var3_15 = arg1_15.maxY

	table.removebyvalue(arg0_15.allItems, arg1_15)

	local var4_15 = arg0_15.dependInfo

	var4_15[arg1_15] = nil

	for iter0_15, iter1_15 in ipairs(arg0_15.allItems) do
		if var2_15 >= iter1_15.posX and var3_15 >= iter1_15.posY then
			table.removebyvalue(var4_15[iter1_15], arg1_15)
		end
	end

	arg0_15:SortAndCalcDepth()
	table.removebyvalue(arg0_15.sortedItems, arg1_15)
end

return var0_0
