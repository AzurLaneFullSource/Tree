local var0_0 = class("CourtYardFurniturePlaceareaDebug")
local var1_0 = true

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.furniture = arg1_1
	arg0_1.mapGrids = {}

	arg0_1:Flush()
end

function var0_0.GetView(arg0_2)
	return arg0_2.furniture:GetHost():GetBridge():GetView()
end

function var0_0.Flush(arg0_3)
	arg0_3:Clear()

	local var0_3 = arg0_3:GetView():GetRect():Find("grids")
	local var1_3 = var1_0 and arg0_3.furniture:RawGetOffset() or Vector3.zero
	local var2_3 = arg0_3.furniture:GetCanputonPosition()

	for iter0_3, iter1_3 in ipairs(var2_3) do
		local var3_3 = arg0_3:GetView().poolMgr:GetGridPool():Dequeue()

		setParent(var3_3, var0_3)

		tf(var3_3).localScale = Vector3.one
		tf(var3_3).localPosition = CourtYardCalcUtil.Map2Local(iter1_3) + var1_3
		var3_3:GetComponent(typeof(Image)).color = Color.New(0, 0, 1, 1)

		table.insert(arg0_3.mapGrids, var3_3)
	end
end

function var0_0.Clear(arg0_4)
	for iter0_4, iter1_4 in pairs(arg0_4.mapGrids) do
		iter1_4:GetComponent(typeof(Image)).color = Color.New(1, 1, 1, 1)

		arg0_4:GetView().poolMgr:GetGridPool():Enqueue(iter1_4)
	end

	arg0_4.mapGrids = {}
end

function var0_0.Dispose(arg0_5)
	arg0_5:Clear()
end

return var0_0
