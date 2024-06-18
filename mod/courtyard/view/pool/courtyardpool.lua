local var0_0 = class("CourtYardPool")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	arg0_1.prefab = arg2_1
	arg0_1.parentTF = arg1_1

	GetOrAddComponent(arg0_1.prefab, typeof(CanvasGroup))
	arg0_1.prefab.transform:SetParent(arg0_1.parentTF, false)

	arg0_1.layer = arg0_1.parentTF.gameObject.layer
	arg0_1.items = {}
	arg0_1.max = arg4_1
	arg0_1.initCnt = arg3_1

	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	for iter0_2 = 1, arg0_2.initCnt do
		arg0_2:NewItem()
	end
end

function var0_0.Enqueue(arg0_3, arg1_3)
	if #arg0_3.items >= arg0_3.max then
		Object.Destroy(arg1_3)
	else
		arg1_3.transform.localPosition = Vector3.one

		setActiveViaLayer(arg1_3.transform, false)
		arg1_3.transform:SetParent(arg0_3.parentTF, true)
		table.insert(arg0_3.items, arg1_3)
	end
end

function var0_0.Dequeue(arg0_4)
	if #arg0_4.items <= 0 then
		arg0_4:NewItem()
	end

	local var0_4 = table.remove(arg0_4.items, 1)

	setActiveViaLayer(var0_4.transform, true)

	return var0_4
end

function var0_0.NewItem(arg0_5)
	local var0_5 = Object.Instantiate(arg0_5.prefab)

	var0_5.transform.localScale = Vector3.one

	arg0_5:Enqueue(var0_5)
end

function var0_0.Dispose(arg0_6)
	for iter0_6, iter1_6 in ipairs(arg0_6.items) do
		Object.Destroy(iter1_6)
	end

	arg0_6.items = nil
	arg0_6.prefab = nil
end

return var0_0
