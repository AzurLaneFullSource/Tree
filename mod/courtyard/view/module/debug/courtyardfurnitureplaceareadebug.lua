local var0 = class("CourtYardFurniturePlaceareaDebug")
local var1 = true

function var0.Ctor(arg0, arg1)
	arg0.furniture = arg1
	arg0.mapGrids = {}

	arg0:Flush()
end

function var0.GetView(arg0)
	return arg0.furniture:GetHost():GetBridge():GetView()
end

function var0.Flush(arg0)
	arg0:Clear()

	local var0 = arg0:GetView():GetRect():Find("grids")
	local var1 = var1 and arg0.furniture:RawGetOffset() or Vector3.zero
	local var2 = arg0.furniture:GetCanputonPosition()

	for iter0, iter1 in ipairs(var2) do
		local var3 = arg0:GetView().poolMgr:GetGridPool():Dequeue()

		setParent(var3, var0)

		tf(var3).localScale = Vector3.one
		tf(var3).localPosition = CourtYardCalcUtil.Map2Local(iter1) + var1
		var3:GetComponent(typeof(Image)).color = Color.New(0, 0, 1, 1)

		table.insert(arg0.mapGrids, var3)
	end
end

function var0.Clear(arg0)
	for iter0, iter1 in pairs(arg0.mapGrids) do
		iter1:GetComponent(typeof(Image)).color = Color.New(1, 1, 1, 1)

		arg0:GetView().poolMgr:GetGridPool():Enqueue(iter1)
	end

	arg0.mapGrids = {}
end

function var0.Dispose(arg0)
	arg0:Clear()
end

return var0
