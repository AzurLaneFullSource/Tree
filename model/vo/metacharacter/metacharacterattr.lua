local var0 = class("MetaCharacterAttr", import("..BaseVO"))

function var0.Ctor(arg0, arg1)
	arg0.attr = arg1.attr
	arg0.items = _.map(arg1.items or {}, function(arg0)
		return MetaRepairItem.New({
			id = arg0
		})
	end)
	arg0.level = arg1.level or 1
end

function var0.getLevelByItemId(arg0, arg1)
	local var0 = 1

	for iter0, iter1 in pairs(arg0.items) do
		if iter1.id == arg1 then
			var0 = iter0 + 1

			break
		end
	end

	return var0
end

function var0.updateCount(arg0, arg1)
	if arg1 > arg0.level then
		arg0.level = arg1
	end
end

function var0.hasItemId(arg0, arg1)
	return _.any(arg0.items, function(arg0)
		return arg0.id == arg1
	end)
end

function var0.getLevel(arg0)
	return arg0.level
end

function var0.isMaxLevel(arg0)
	return arg0.level > #arg0.items
end

function var0.getAddition(arg0)
	local var0 = 0

	for iter0 = 1, arg0.level - 1 do
		var0 = var0 + arg0.items[iter0]:getAdditionValue()
	end

	return var0
end

function var0.getMaxAddition(arg0)
	local var0 = 0

	for iter0, iter1 in ipairs(arg0.items) do
		var0 = var0 + iter1:getAdditionValue()
	end

	return var0
end

function var0.getRepairExp(arg0)
	local var0 = 0

	for iter0 = 1, arg0.level - 1 do
		var0 = var0 + arg0.items[iter0]:getRepairExp()
	end

	return var0
end

function var0.getItem(arg0)
	assert(arg0.items[arg0.level], "level : " .. arg0.level)

	return arg0.items[arg0.level]
end

function var0.getItemByLevel(arg0, arg1)
	return arg0.items[arg1]
end

function var0.levelUp(arg0)
	if not arg0:isMaxLevel() then
		arg0.level = arg0.level + 1
	end
end

function var0.isCanRepair(arg0)
	if arg0:isMaxLevel() then
		return false
	end

	local var0 = arg0:getItem()
	local var1 = var0:getItemId()

	if var0:getTotalCnt() <= getProxy(BagProxy):getItemCountById(var1) then
		return true
	else
		return false
	end
end

function var0.getItemCount(arg0)
	return #arg0.items
end

function var0.isLock(arg0)
	return arg0:getItemCount() == 0
end

return var0
