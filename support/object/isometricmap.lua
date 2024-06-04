pg = pg or {}

local var0 = pg
local var1 = class("IsometricMap")

var0.IsometricMap = var1

function var1.Ctor(arg0, arg1, arg2)
	arg0.sizeX = arg1
	arg0.sizeY = arg2
	arg0.depths = {}
	arg0.dependInfo = {}
	arg0.allItems = {}
	arg0.sortedFlag = false
	arg0.sortedItems = {}

	arg0:ResetDepth()
end

function var1.SetAfterFunc(arg0, arg1)
	arg0.afterSortFunc = arg1
end

function var1.GetDepth(arg0, arg1, arg2)
	return arg0.depths[arg0:GetIndex(arg1, arg2)]
end

function var1.InsertChar(arg0, arg1)
	local var0 = arg0:GetDepth(arg1.posX, arg1.posY)

	arg1:SetDepth(var0)

	for iter0, iter1 in ipairs(arg0.sortedItems) do
		if var0 > iter1.posZ then
			table.insert(arg0.sortedItems, iter0, arg1)
			arg0:checkCharByIndex()

			return iter0 - 1
		end
	end

	local var1 = #arg0.sortedItems

	table.insert(arg0.sortedItems, var1 + 1, arg1)
	arg0:checkCharByIndex()

	return var1
end

function var1.checkCharByIndex(arg0)
	for iter0 = 1, #arg0.sortedItems do
		local var0 = math.min(iter0 + 1, #arg0.sortedItems)

		assert(arg0.sortedItems[iter0].posZ >= arg0.sortedItems[var0].posZ, "舰娘插入队列位置错误")
	end
end

function var1.RemoveChar(arg0, arg1)
	table.removebyvalue(arg0.sortedItems, arg1)
end

function var1.CreateItem(arg0, arg1, arg2, arg3)
	return {
		maxX = 0,
		posY = 0,
		sortedFlag = true,
		maxY = 0,
		posZ = 0,
		posX = 0,
		ob = arg3,
		sizeX = arg1,
		sizeY = arg2,
		SetPos = function(arg0, arg1, arg2)
			arg0.posX = arg1
			arg0.posY = arg2
			arg0.maxX = arg1 + arg0.sizeX - 1
			arg0.maxY = arg2 + arg0.sizeY - 1
		end,
		SetDepth = function(arg0, arg1)
			arg0.posZ = arg1
		end
	}
end

function var1.GetIndex(arg0, arg1, arg2)
	return (arg2 - 1) * arg0.sizeX + arg1
end

function var1.ResetDepth(arg0)
	local var0 = arg0.depths

	for iter0 = 1, arg0.sizeX do
		for iter1 = 1, arg0.sizeY do
			var0[arg0:GetIndex(iter0, iter1)] = iter0 + iter1 - 1
		end
	end
end

function var1.AddDepth(arg0, arg1, arg2, arg3)
	local var0 = arg0.depths

	for iter0 = 1, arg1 do
		for iter1 = 1, arg2 do
			local var1 = arg0:GetIndex(iter0, iter1)

			var0[var1] = var0[var1] + arg3
		end
	end
end

function var1.ModifyDepth(arg0, arg1)
	local var0 = arg0.depths
	local var1 = arg1.posX
	local var2 = arg1.posY
	local var3 = arg1.maxX
	local var4 = arg1.maxY
	local var5 = var0[arg0:GetIndex(var3, var2)]
	local var6 = var0[arg0:GetIndex(var1, var4)]

	if var5 == var6 then
		arg1:SetDepth(var5)

		return
	end

	if var5 < var6 then
		if var1 > 1 then
			local var7 = var5 - 1 - var0[arg0:GetIndex(var1 - 1, var4)]

			if var7 < 0 then
				arg0:AddDepth(var1 - 1, var4, var7)
			end
		end

		arg1:SetDepth(var5)

		return
	else
		if var2 > 1 then
			local var8 = var6 - 1 - var0[arg0:GetIndex(var3, var2 - 1)]

			if var8 < 0 then
				arg0:AddDepth(var3, var2 - 1, var8)
			end
		end

		arg1:SetDepth(var6)

		return
	end
end

function var1.PlaceItem(arg0, arg1, arg2, arg3)
	arg3:SetPos(arg1, arg2)

	local var0 = arg3.maxX
	local var1 = arg3.maxY
	local var2 = {}

	arg0.dependInfo[arg3] = var2

	for iter0, iter1 in ipairs(arg0.allItems) do
		if arg1 <= iter1.maxX and arg2 <= iter1.maxY then
			var2[#var2 + 1] = iter1
		elseif var0 >= iter1.posX and var1 >= iter1.posY then
			table.insert(arg0.dependInfo[iter1], arg3)
		end
	end

	table.insert(arg0.allItems, arg3)

	arg3.sortedFlag = arg0.sortedFlag

	arg0:SortAndCalcDepth()

	local var3 = arg0.afterSortFunc

	if var3 then
		var3(arg0.sortedItems)
	end
end

function var1.sortItemByDepth(arg0, arg1)
	return arg0.posZ > arg1.posZ
end

function var1.SortAndCalcDepth(arg0)
	local var0 = {}

	arg0.sortedItems = var0
	arg0.sortedFlag = not arg0.sortedFlag

	for iter0, iter1 in ipairs(arg0.allItems) do
		arg0:AddItemAndDepend(iter1)
	end

	arg0:ResetDepth()

	for iter2, iter3 in ipairs(var0) do
		arg0:ModifyDepth(iter3)
	end

	table.sort(var0, var1.sortItemByDepth)
end

function var1.AddItemAndDepend(arg0, arg1)
	if arg1.sortedFlag == arg0.sortedFlag then
		return
	end

	for iter0, iter1 in ipairs(arg0.dependInfo[arg1]) do
		arg0:AddItemAndDepend(iter1)
	end

	table.insert(arg0.sortedItems, arg1)
	assert(arg1.sortedFlag ~= arg0.sortedFlag, "依赖关系产生了循环！")

	arg1.sortedFlag = arg0.sortedFlag
end

function var1.RemoveItem(arg0, arg1)
	local var0 = arg1.posX
	local var1 = arg1.posY
	local var2 = arg1.maxX
	local var3 = arg1.maxY

	table.removebyvalue(arg0.allItems, arg1)

	local var4 = arg0.dependInfo

	var4[arg1] = nil

	for iter0, iter1 in ipairs(arg0.allItems) do
		if var2 >= iter1.posX and var3 >= iter1.posY then
			table.removebyvalue(var4[iter1], arg1)
		end
	end

	arg1:SetPos(0, 0)
	arg0:SortAndCalcDepth()
	table.removebyvalue(arg0.sortedItems, arg1)
end
