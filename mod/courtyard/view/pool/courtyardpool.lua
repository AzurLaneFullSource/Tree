local var0 = class("CourtYardPool")

function var0.Ctor(arg0, arg1, arg2, arg3, arg4)
	arg0.prefab = arg2
	arg0.parentTF = arg1

	GetOrAddComponent(arg0.prefab, typeof(CanvasGroup))
	arg0.prefab.transform:SetParent(arg0.parentTF, false)

	arg0.layer = arg0.parentTF.gameObject.layer
	arg0.items = {}
	arg0.max = arg4
	arg0.initCnt = arg3

	arg0:Init()
end

function var0.Init(arg0)
	for iter0 = 1, arg0.initCnt do
		arg0:NewItem()
	end
end

function var0.Enqueue(arg0, arg1)
	if #arg0.items >= arg0.max then
		Object.Destroy(arg1)
	else
		arg1.transform.localPosition = Vector3.one

		setActiveViaLayer(arg1.transform, false)
		arg1.transform:SetParent(arg0.parentTF, true)
		table.insert(arg0.items, arg1)
	end
end

function var0.Dequeue(arg0)
	if #arg0.items <= 0 then
		arg0:NewItem()
	end

	local var0 = table.remove(arg0.items, 1)

	setActiveViaLayer(var0.transform, true)

	return var0
end

function var0.NewItem(arg0)
	local var0 = Object.Instantiate(arg0.prefab)

	var0.transform.localScale = Vector3.one

	arg0:Enqueue(var0)
end

function var0.Dispose(arg0)
	for iter0, iter1 in ipairs(arg0.items) do
		Object.Destroy(iter1)
	end

	arg0.items = nil
	arg0.prefab = nil
end

return var0
