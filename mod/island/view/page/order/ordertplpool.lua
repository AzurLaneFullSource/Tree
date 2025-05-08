local var0_0 = class("OrderTplPool")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1.initCnt = arg2_1
	arg0_1.maxCnt = arg3_1
	arg0_1.prefab = arg1_1.gameObject
	arg0_1.root = arg1_1.parent
	arg0_1.items = {}

	arg0_1:Init()
end

function var0_0.NewItem(arg0_2)
	return Object.Instantiate(arg0_2.prefab)
end

function var0_0.Init(arg0_3)
	for iter0_3 = 1, arg0_3.initCnt do
		local var0_3 = arg0_3:NewItem()

		arg0_3:Enqueue(var0_3)
	end
end

function var0_0.Enqueue(arg0_4, arg1_4)
	if #arg0_4.items + 1 > arg0_4.maxCnt then
		Object.Destroy(arg1_4)
	else
		setParent(arg1_4, arg0_4.root)

		arg1_4.transform.localPosition = Vector3.zero

		table.insert(arg0_4.items, arg1_4)
	end
end

function var0_0.Dequeue(arg0_5)
	local var0_5

	if #arg0_5.items > 0 then
		var0_5 = table.remove(arg0_5.items, 1)
	else
		var0_5 = arg0_5:NewItem()
	end

	return var0_5
end

function var0_0.Dispose(arg0_6)
	for iter0_6, iter1_6 in ipairs(arg0_6.items) do
		Object.Destroy(iter1_6)
	end

	arg0_6.items = {}
	arg0_6.prefab = nil
end

return var0_0
