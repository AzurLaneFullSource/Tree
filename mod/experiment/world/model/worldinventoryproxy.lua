local var0 = class("WorldInventoryProxy", import("...BaseEntity"))

var0.Fields = {
	data = "table"
}
var0.EventUpdateItem = "WorldInventoryProxy.EventUpdateItem"

function var0.Build(arg0)
	arg0.data = {}
end

function var0.Setup(arg0, arg1)
	for iter0, iter1 in ipairs(arg1) do
		local var0 = WorldItem.New(iter1)

		arg0.data[var0.id] = var0

		arg0:DispatchEvent(var0.EventUpdateItem, var0:clone())
	end
end

function var0.GetItem(arg0, arg1)
	return arg0.data[arg1]
end

function var0.GetItemCount(arg0, arg1)
	local var0 = arg0:GetItem(arg1)

	return var0 and var0.count or 0
end

function var0.AddItem(arg0, arg1, arg2)
	local var0 = arg0:GetItem(arg1)

	if var0 then
		var0.count = var0.count + arg2
	else
		var0 = WorldItem.New({
			id = arg1,
			count = arg2
		})
		arg0.data[arg1] = var0
	end

	arg0:DispatchEvent(var0.EventUpdateItem, var0:clone())
end

function var0.RemoveItem(arg0, arg1, arg2)
	local var0 = arg0:GetItem(arg1)

	if var0 then
		arg2 = arg2 or var0.count

		assert(arg2 <= var0.count, "item count not enough: " .. var0.id)

		var0.count = var0.count - arg2

		if var0.count == 0 then
			arg0.data[arg1] = nil
		end

		arg0:DispatchEvent(var0.EventUpdateItem, var0:clone())
	end
end

function var0.UpdateItem(arg0, arg1, arg2)
	local var0 = arg0:GetItem(arg1)

	if var0 then
		var0.count = arg2

		arg0:DispatchEvent(var0.EventUpdateItem, var0:clone())
	end
end

function var0.GetItemList(arg0)
	return _(arg0.data):chain():values():filter(function(arg0)
		return arg0.count > 0
	end):value()
end

function var0.CalcResetExchangeResource(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.data) do
		local var1 = {
			type = iter1:getConfig("item_transform_item_type"),
			id = iter1:getConfig("item_transform_item_id"),
			count = iter1:getConfig("item_transform_item_number")
		}

		if var1.type > 0 then
			var0[var1.type] = var0[var1.type] or {}
			var0[var1.type][var1.id] = defaultValue(var0[var1.type][var1.id], 0) + math.floor(iter1.count / iter1:getConfig("item_transform_num")) * var1.count
		end
	end

	return var0
end

function var0.GetItemsByType(arg0, arg1)
	return underscore.filter(arg0:GetItemList(), function(arg0)
		return arg0:getWorldItemType() == arg1
	end)
end

return var0
