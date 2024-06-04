local var0 = require("Mgr/Pool/PoolUtil")
local var1 = class("PoolPlural")
local var2 = "UnityEngine.GameObject"

function var1.Ctor(arg0, arg1, arg2)
	local var0 = getmetatable(arg1)

	if not var0 or var0[".name"] ~= var2 then
		warning("Poolplural should use gameobject as prefab not transform " .. (arg1 and arg1.name or "NIL"))
	end

	arg0.prefab = arg1
	arg0.capacity = arg2
	arg0.index = 0
	arg0.items = {}
	arg0.balance = 0
end

function var1.Enqueue(arg0, arg1, arg2)
	arg0.balance = arg0.balance - 1

	if arg2 or #arg0.items >= arg0.capacity then
		var0.Destroy(arg1)

		return true
	else
		table.insert(arg0.items, arg1)

		return false
	end
end

function var1.Dequeue(arg0)
	arg0.balance = arg0.balance + 1

	local var0

	while IsNil(var0) and #arg0.items > 0 do
		var0 = table.remove(arg0.items)
	end

	if IsNil(var0) then
		var0 = arg0:NewItem()
	end

	return var0
end

function var1.NewItem(arg0)
	return Object.Instantiate(arg0.prefab)
end

function var1.AllReturned(arg0)
	return arg0.balance == 0
end

function var1.ClearPrefab(arg0, arg1)
	var0.Destroy(arg0.prefab, arg1)

	arg0.prefab = nil
end

function var1.ClearItems(arg0, arg1)
	for iter0 = 1, #arg0.items do
		var0.Destroy(arg0.items[iter0], arg1)
	end

	table.clear(arg0.items)

	arg0.balance = 0
end

function var1.Clear(arg0, arg1)
	arg0:ClearPrefab(arg1)
	arg0:ClearItems(arg1)
end

return var1
