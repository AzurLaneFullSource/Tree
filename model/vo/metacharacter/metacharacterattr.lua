local var0_0 = class("MetaCharacterAttr", import("..BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.attr = arg1_1.attr
	arg0_1.items = _.map(arg1_1.items or {}, function(arg0_2)
		return MetaRepairItem.New({
			id = arg0_2
		})
	end)
	arg0_1.level = arg1_1.level or 1
end

function var0_0.getLevelByItemId(arg0_3, arg1_3)
	local var0_3 = 1

	for iter0_3, iter1_3 in pairs(arg0_3.items) do
		if iter1_3.id == arg1_3 then
			var0_3 = iter0_3 + 1

			break
		end
	end

	return var0_3
end

function var0_0.updateCount(arg0_4, arg1_4)
	if arg1_4 > arg0_4.level then
		arg0_4.level = arg1_4
	end
end

function var0_0.hasItemId(arg0_5, arg1_5)
	return _.any(arg0_5.items, function(arg0_6)
		return arg0_6.id == arg1_5
	end)
end

function var0_0.getLevel(arg0_7)
	return arg0_7.level
end

function var0_0.isMaxLevel(arg0_8)
	return arg0_8.level > #arg0_8.items
end

function var0_0.getAddition(arg0_9)
	local var0_9 = 0

	for iter0_9 = 1, arg0_9.level - 1 do
		var0_9 = var0_9 + arg0_9.items[iter0_9]:getAdditionValue()
	end

	return var0_9
end

function var0_0.getMaxAddition(arg0_10)
	local var0_10 = 0

	for iter0_10, iter1_10 in ipairs(arg0_10.items) do
		var0_10 = var0_10 + iter1_10:getAdditionValue()
	end

	return var0_10
end

function var0_0.getRepairExp(arg0_11)
	local var0_11 = 0

	for iter0_11 = 1, arg0_11.level - 1 do
		var0_11 = var0_11 + arg0_11.items[iter0_11]:getRepairExp()
	end

	return var0_11
end

function var0_0.getItem(arg0_12)
	assert(arg0_12.items[arg0_12.level], "level : " .. arg0_12.level)

	return arg0_12.items[arg0_12.level]
end

function var0_0.getItemByLevel(arg0_13, arg1_13)
	return arg0_13.items[arg1_13]
end

function var0_0.levelUp(arg0_14)
	if not arg0_14:isMaxLevel() then
		arg0_14.level = arg0_14.level + 1
	end
end

function var0_0.isCanRepair(arg0_15)
	if arg0_15:isMaxLevel() then
		return false
	end

	local var0_15 = arg0_15:getItem()
	local var1_15 = var0_15:getItemId()

	if var0_15:getTotalCnt() <= getProxy(BagProxy):getItemCountById(var1_15) then
		return true
	else
		return false
	end
end

function var0_0.getItemCount(arg0_16)
	return #arg0_16.items
end

function var0_0.isLock(arg0_17)
	return arg0_17:getItemCount() == 0
end

return var0_0
