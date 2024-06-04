local var0 = class("ValentineQteGamePoolMgr")

function var0.Ctor(arg0, arg1, arg2, arg3)
	arg0.tpl = arg1
	arg0.initCnt = arg2
	arg0.maxCnt = arg3
	arg0.items = {}

	setActive(arg0.tpl, false)
	arg0:Init()
end

function var0.Init(arg0)
	for iter0 = 1, arg0.initCnt do
		local var0 = arg0:NewItem()

		table.insert(arg0.items, var0)
	end
end

function var0.NewItem(arg0)
	local var0 = Instantiate(arg0.tpl)

	SetParent(var0, arg0.tpl.transform.parent)

	return var0
end

function var0.Dequeue(arg0)
	local var0

	if #arg0.items > 0 then
		var0 = table.remove(arg0.items, 1)
	else
		var0 = arg0:NewItem()
	end

	setActive(var0, true)

	return var0
end

function var0.Enqueue(arg0, arg1)
	if #arg0.items >= arg0.maxCnt then
		arg0:DestroyItem(arg1)
	else
		setActive(arg1, false)
		SetParent(arg1, arg0.tpl.transform.parent)
		table.insert(arg0.items, arg1.gameObject)
	end
end

function var0.DestroyItem(arg0, arg1)
	Object.Destroy(go(arg1))
end

function var0.Destroy(arg0)
	for iter0, iter1 in ipairs(arg0.items) do
		arg0:DestroyItem(iter1)
	end

	arg0.items = nil
end

return var0
