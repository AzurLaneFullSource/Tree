local var0_0 = class("ValentineQteGamePoolMgr")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1.tpl = arg1_1
	arg0_1.initCnt = arg2_1
	arg0_1.maxCnt = arg3_1
	arg0_1.items = {}

	setActive(arg0_1.tpl, false)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	for iter0_2 = 1, arg0_2.initCnt do
		local var0_2 = arg0_2:NewItem()

		table.insert(arg0_2.items, var0_2)
	end
end

function var0_0.NewItem(arg0_3)
	local var0_3 = Instantiate(arg0_3.tpl)

	SetParent(var0_3, arg0_3.tpl.transform.parent)

	return var0_3
end

function var0_0.Dequeue(arg0_4)
	local var0_4

	if #arg0_4.items > 0 then
		var0_4 = table.remove(arg0_4.items, 1)
	else
		var0_4 = arg0_4:NewItem()
	end

	setActive(var0_4, true)

	return var0_4
end

function var0_0.Enqueue(arg0_5, arg1_5)
	if #arg0_5.items >= arg0_5.maxCnt then
		arg0_5:DestroyItem(arg1_5)
	else
		setActive(arg1_5, false)
		SetParent(arg1_5, arg0_5.tpl.transform.parent)
		table.insert(arg0_5.items, arg1_5.gameObject)
	end
end

function var0_0.DestroyItem(arg0_6, arg1_6)
	Object.Destroy(go(arg1_6))
end

function var0_0.Destroy(arg0_7)
	for iter0_7, iter1_7 in ipairs(arg0_7.items) do
		arg0_7:DestroyItem(iter1_7)
	end

	arg0_7.items = nil
end

return var0_0
