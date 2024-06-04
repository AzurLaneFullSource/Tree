local var0 = class("CourtYardMapDebug")

function var0.Ctor(arg0, arg1, arg2)
	arg0.map = arg1
	arg0.mapGrids = {}
	arg0.r = arg2 and arg2.r or 0
	arg0.g = arg2 and arg2.g or 0
	arg0.b = arg2 and arg2.b or 0

	arg0:Init()
end

function var0.GetView(arg0)
	return arg0.map:GetHost():GetBridge():GetView()
end

function var0.Init(arg0)
	local var0 = arg0:GetView():GetRect():Find("grids")
	local var1 = arg0.map.minSizeX
	local var2 = arg0.map.minSizeY
	local var3 = arg0.map.sizeX
	local var4 = arg0.map.sizeY

	for iter0 = var1, var3 do
		local var5 = {}

		for iter1 = var2, var4 do
			local var6 = arg0:GetView().poolMgr:GetGridPool():Dequeue()

			setParent(var6, var0)

			tf(var6).localScale = Vector3.one
			tf(var6).localPosition = CourtYardCalcUtil.Map2Local(Vector2(iter0, iter1))
			var6:GetComponent(typeof(Image)).color = (iter1 == var4 or iter0 == var3) and Color.New(1, 1, 0, 0.5) or Color.New(0, 1, 0, 1)
			var5[iter1] = var6
		end

		arg0.mapGrids[iter0] = var5
	end

	arg0:Flush()
end

function var0.Flush(arg0)
	local var0 = arg0.map.sizeX
	local var1 = arg0.map.sizeY

	for iter0, iter1 in pairs(arg0.mapGrids) do
		for iter2, iter3 in pairs(iter1) do
			local var2 = arg0.map:IsEmptyPosition(Vector2(iter0, iter2))
			local var3 = iter3:GetComponent(typeof(Image))
			local var4

			if var2 then
				var4 = (iter2 == var1 or iter0 == var0) and Color.New(1, 1, 0, 0.5) or Color.New(0, 1, 0, 1)
			else
				var4 = Color.New(arg0.r, arg0.g, arg0.b, var3.color.a)
			end

			var3.color = var4
		end
	end
end

function var0.Clear(arg0)
	for iter0, iter1 in pairs(arg0.mapGrids) do
		for iter2, iter3 in pairs(iter1) do
			iter3:GetComponent(typeof(Image)).color = Color.New(0, 1, 0, 1)

			arg0:GetView().poolMgr:GetGridPool():Enqueue(iter3)
		end
	end

	arg0.mapGrids = {}
end

function var0.Dispose(arg0)
	arg0:Clear()
end

return var0
