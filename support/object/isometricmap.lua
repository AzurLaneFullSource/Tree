pg = pg or {}

local var0_0 = pg
local var1_0 = class("IsometricMap")

var0_0.IsometricMap = var1_0

function var1_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.sizeX = arg1_1
	arg0_1.sizeY = arg2_1
	arg0_1.depths = {}
	arg0_1.dependInfo = {}
	arg0_1.allItems = {}
	arg0_1.sortedFlag = false
	arg0_1.sortedItems = {}

	arg0_1:ResetDepth()
end

function var1_0.SetAfterFunc(arg0_2, arg1_2)
	arg0_2.afterSortFunc = arg1_2
end

function var1_0.GetDepth(arg0_3, arg1_3, arg2_3)
	return arg0_3.depths[arg0_3:GetIndex(arg1_3, arg2_3)]
end

function var1_0.InsertChar(arg0_4, arg1_4)
	local var0_4 = arg0_4:GetDepth(arg1_4.posX, arg1_4.posY)

	arg1_4:SetDepth(var0_4)

	for iter0_4, iter1_4 in ipairs(arg0_4.sortedItems) do
		if var0_4 > iter1_4.posZ then
			table.insert(arg0_4.sortedItems, iter0_4, arg1_4)
			arg0_4:checkCharByIndex()

			return iter0_4 - 1
		end
	end

	local var1_4 = #arg0_4.sortedItems

	table.insert(arg0_4.sortedItems, var1_4 + 1, arg1_4)
	arg0_4:checkCharByIndex()

	return var1_4
end

function var1_0.checkCharByIndex(arg0_5)
	for iter0_5 = 1, #arg0_5.sortedItems do
		local var0_5 = math.min(iter0_5 + 1, #arg0_5.sortedItems)

		assert(arg0_5.sortedItems[iter0_5].posZ >= arg0_5.sortedItems[var0_5].posZ, "舰娘插入队列位置错误")
	end
end

function var1_0.RemoveChar(arg0_6, arg1_6)
	table.removebyvalue(arg0_6.sortedItems, arg1_6)
end

function var1_0.CreateItem(arg0_7, arg1_7, arg2_7, arg3_7)
	return {
		maxX = 0,
		posY = 0,
		sortedFlag = true,
		maxY = 0,
		posZ = 0,
		posX = 0,
		ob = arg3_7,
		sizeX = arg1_7,
		sizeY = arg2_7,
		SetPos = function(arg0_8, arg1_8, arg2_8)
			arg0_8.posX = arg1_8
			arg0_8.posY = arg2_8
			arg0_8.maxX = arg1_8 + arg0_8.sizeX - 1
			arg0_8.maxY = arg2_8 + arg0_8.sizeY - 1
		end,
		SetDepth = function(arg0_9, arg1_9)
			arg0_9.posZ = arg1_9
		end
	}
end

function var1_0.GetIndex(arg0_10, arg1_10, arg2_10)
	return (arg2_10 - 1) * arg0_10.sizeX + arg1_10
end

function var1_0.ResetDepth(arg0_11)
	local var0_11 = arg0_11.depths

	for iter0_11 = 1, arg0_11.sizeX do
		for iter1_11 = 1, arg0_11.sizeY do
			var0_11[arg0_11:GetIndex(iter0_11, iter1_11)] = iter0_11 + iter1_11 - 1
		end
	end
end

function var1_0.AddDepth(arg0_12, arg1_12, arg2_12, arg3_12)
	local var0_12 = arg0_12.depths

	for iter0_12 = 1, arg1_12 do
		for iter1_12 = 1, arg2_12 do
			local var1_12 = arg0_12:GetIndex(iter0_12, iter1_12)

			var0_12[var1_12] = var0_12[var1_12] + arg3_12
		end
	end
end

function var1_0.ModifyDepth(arg0_13, arg1_13)
	local var0_13 = arg0_13.depths
	local var1_13 = arg1_13.posX
	local var2_13 = arg1_13.posY
	local var3_13 = arg1_13.maxX
	local var4_13 = arg1_13.maxY
	local var5_13 = var0_13[arg0_13:GetIndex(var3_13, var2_13)]
	local var6_13 = var0_13[arg0_13:GetIndex(var1_13, var4_13)]

	if var5_13 == var6_13 then
		arg1_13:SetDepth(var5_13)

		return
	end

	if var5_13 < var6_13 then
		if var1_13 > 1 then
			local var7_13 = var5_13 - 1 - var0_13[arg0_13:GetIndex(var1_13 - 1, var4_13)]

			if var7_13 < 0 then
				arg0_13:AddDepth(var1_13 - 1, var4_13, var7_13)
			end
		end

		arg1_13:SetDepth(var5_13)

		return
	else
		if var2_13 > 1 then
			local var8_13 = var6_13 - 1 - var0_13[arg0_13:GetIndex(var3_13, var2_13 - 1)]

			if var8_13 < 0 then
				arg0_13:AddDepth(var3_13, var2_13 - 1, var8_13)
			end
		end

		arg1_13:SetDepth(var6_13)

		return
	end
end

function var1_0.PlaceItem(arg0_14, arg1_14, arg2_14, arg3_14)
	arg3_14:SetPos(arg1_14, arg2_14)

	local var0_14 = arg3_14.maxX
	local var1_14 = arg3_14.maxY
	local var2_14 = {}

	arg0_14.dependInfo[arg3_14] = var2_14

	for iter0_14, iter1_14 in ipairs(arg0_14.allItems) do
		if arg1_14 <= iter1_14.maxX and arg2_14 <= iter1_14.maxY then
			var2_14[#var2_14 + 1] = iter1_14
		elseif var0_14 >= iter1_14.posX and var1_14 >= iter1_14.posY then
			table.insert(arg0_14.dependInfo[iter1_14], arg3_14)
		end
	end

	table.insert(arg0_14.allItems, arg3_14)

	arg3_14.sortedFlag = arg0_14.sortedFlag

	arg0_14:SortAndCalcDepth()

	local var3_14 = arg0_14.afterSortFunc

	if var3_14 then
		var3_14(arg0_14.sortedItems)
	end
end

function var1_0.sortItemByDepth(arg0_15, arg1_15)
	return arg0_15.posZ > arg1_15.posZ
end

function var1_0.SortAndCalcDepth(arg0_16)
	local var0_16 = {}

	arg0_16.sortedItems = var0_16
	arg0_16.sortedFlag = not arg0_16.sortedFlag

	for iter0_16, iter1_16 in ipairs(arg0_16.allItems) do
		arg0_16:AddItemAndDepend(iter1_16)
	end

	arg0_16:ResetDepth()

	for iter2_16, iter3_16 in ipairs(var0_16) do
		arg0_16:ModifyDepth(iter3_16)
	end

	table.sort(var0_16, var1_0.sortItemByDepth)
end

function var1_0.AddItemAndDepend(arg0_17, arg1_17)
	if arg1_17.sortedFlag == arg0_17.sortedFlag then
		return
	end

	for iter0_17, iter1_17 in ipairs(arg0_17.dependInfo[arg1_17]) do
		arg0_17:AddItemAndDepend(iter1_17)
	end

	table.insert(arg0_17.sortedItems, arg1_17)
	assert(arg1_17.sortedFlag ~= arg0_17.sortedFlag, "依赖关系产生了循环！")

	arg1_17.sortedFlag = arg0_17.sortedFlag
end

function var1_0.RemoveItem(arg0_18, arg1_18)
	local var0_18 = arg1_18.posX
	local var1_18 = arg1_18.posY
	local var2_18 = arg1_18.maxX
	local var3_18 = arg1_18.maxY

	table.removebyvalue(arg0_18.allItems, arg1_18)

	local var4_18 = arg0_18.dependInfo

	var4_18[arg1_18] = nil

	for iter0_18, iter1_18 in ipairs(arg0_18.allItems) do
		if var2_18 >= iter1_18.posX and var3_18 >= iter1_18.posY then
			table.removebyvalue(var4_18[iter1_18], arg1_18)
		end
	end

	arg1_18:SetPos(0, 0)
	arg0_18:SortAndCalcDepth()
	table.removebyvalue(arg0_18.sortedItems, arg1_18)
end
