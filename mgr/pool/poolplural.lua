local var0_0 = require("Mgr/Pool/PoolUtil")
local var1_0 = class("PoolPlural")
local var2_0 = "UnityEngine.GameObject"

function var1_0.Ctor(arg0_1, arg1_1, arg2_1)
	local var0_1 = getmetatable(arg1_1)

	if not var0_1 or var0_1[".name"] ~= var2_0 then
		warning("Poolplural should use gameobject as prefab not transform " .. (arg1_1 and arg1_1.name or "NIL"))
	end

	arg0_1.prefab = arg1_1
	arg0_1.capacity = arg2_1
	arg0_1.index = 0
	arg0_1.items = {}
	arg0_1.balance = 0
end

function var1_0.Enqueue(arg0_2, arg1_2, arg2_2)
	arg0_2.balance = arg0_2.balance - 1

	if arg2_2 or #arg0_2.items >= arg0_2.capacity then
		var0_0.Destroy(arg1_2)

		return true
	else
		table.insert(arg0_2.items, arg1_2)

		return false
	end
end

function var1_0.Dequeue(arg0_3)
	arg0_3.balance = arg0_3.balance + 1

	local var0_3

	while IsNil(var0_3) and #arg0_3.items > 0 do
		var0_3 = table.remove(arg0_3.items)
	end

	if IsNil(var0_3) then
		var0_3 = arg0_3:NewItem()
	end

	return var0_3
end

function var1_0.NewItem(arg0_4)
	return Object.Instantiate(arg0_4.prefab)
end

function var1_0.AllReturned(arg0_5)
	return arg0_5.balance == 0
end

function var1_0.ClearPrefab(arg0_6)
	var0_0.Destroy(arg0_6.prefab)

	arg0_6.prefab = nil
end

function var1_0.ClearItems(arg0_7)
	for iter0_7 = 1, #arg0_7.items do
		var0_0.Destroy(arg0_7.items[iter0_7])
	end

	table.clear(arg0_7.items)

	arg0_7.balance = 0
end

function var1_0.Clear(arg0_8)
	arg0_8:ClearPrefab()
	arg0_8:ClearItems()
end

return var1_0
