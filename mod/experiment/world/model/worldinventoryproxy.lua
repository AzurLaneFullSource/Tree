local var0_0 = class("WorldInventoryProxy", import("...BaseEntity"))

var0_0.Fields = {
	data = "table"
}
var0_0.EventUpdateItem = "WorldInventoryProxy.EventUpdateItem"

function var0_0.Build(arg0_1)
	arg0_1.data = {}
end

function var0_0.Setup(arg0_2, arg1_2)
	for iter0_2, iter1_2 in ipairs(arg1_2) do
		local var0_2 = WorldItem.New(iter1_2)

		arg0_2.data[var0_2.id] = var0_2

		arg0_2:DispatchEvent(var0_0.EventUpdateItem, var0_2:clone())
	end
end

function var0_0.GetItem(arg0_3, arg1_3)
	return arg0_3.data[arg1_3]
end

function var0_0.GetItemCount(arg0_4, arg1_4)
	local var0_4 = arg0_4:GetItem(arg1_4)

	return var0_4 and var0_4.count or 0
end

function var0_0.AddItem(arg0_5, arg1_5, arg2_5)
	local var0_5 = arg0_5:GetItem(arg1_5)

	if var0_5 then
		var0_5.count = var0_5.count + arg2_5
	else
		var0_5 = WorldItem.New({
			id = arg1_5,
			count = arg2_5
		})
		arg0_5.data[arg1_5] = var0_5
	end

	arg0_5:DispatchEvent(var0_0.EventUpdateItem, var0_5:clone())
end

function var0_0.RemoveItem(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg0_6:GetItem(arg1_6)

	if var0_6 then
		arg2_6 = arg2_6 or var0_6.count

		assert(arg2_6 <= var0_6.count, "item count not enough: " .. var0_6.id)

		var0_6.count = var0_6.count - arg2_6

		if var0_6.count == 0 then
			arg0_6.data[arg1_6] = nil
		end

		arg0_6:DispatchEvent(var0_0.EventUpdateItem, var0_6:clone())
	end
end

function var0_0.UpdateItem(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg0_7:GetItem(arg1_7)

	if var0_7 then
		var0_7.count = arg2_7

		arg0_7:DispatchEvent(var0_0.EventUpdateItem, var0_7:clone())
	end
end

function var0_0.GetItemList(arg0_8)
	return _(arg0_8.data):chain():values():filter(function(arg0_9)
		return arg0_9.count > 0
	end):value()
end

function var0_0.CalcResetExchangeResource(arg0_10)
	local var0_10 = {}

	for iter0_10, iter1_10 in pairs(arg0_10.data) do
		local var1_10 = {
			type = iter1_10:getConfig("item_transform_item_type"),
			id = iter1_10:getConfig("item_transform_item_id"),
			count = iter1_10:getConfig("item_transform_item_number")
		}

		if var1_10.type > 0 then
			var0_10[var1_10.type] = var0_10[var1_10.type] or {}
			var0_10[var1_10.type][var1_10.id] = defaultValue(var0_10[var1_10.type][var1_10.id], 0) + math.floor(iter1_10.count / iter1_10:getConfig("item_transform_num")) * var1_10.count
		end
	end

	return var0_10
end

function var0_0.GetItemsByType(arg0_11, arg1_11)
	return underscore.filter(arg0_11:GetItemList(), function(arg0_12)
		return arg0_12:getWorldItemType() == arg1_11
	end)
end

return var0_0
