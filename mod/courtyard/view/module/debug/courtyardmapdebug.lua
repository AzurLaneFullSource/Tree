local var0_0 = class("CourtYardMapDebug")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.map = arg1_1
	arg0_1.mapGrids = {}
	arg0_1.r = arg2_1 and arg2_1.r or 0
	arg0_1.g = arg2_1 and arg2_1.g or 0
	arg0_1.b = arg2_1 and arg2_1.b or 0

	arg0_1:Init()
end

function var0_0.GetView(arg0_2)
	return arg0_2.map:GetHost():GetBridge():GetView()
end

function var0_0.Init(arg0_3)
	local var0_3 = arg0_3:GetView():GetRect():Find("grids")
	local var1_3 = arg0_3.map.minSizeX
	local var2_3 = arg0_3.map.minSizeY
	local var3_3 = arg0_3.map.sizeX
	local var4_3 = arg0_3.map.sizeY

	for iter0_3 = var1_3, var3_3 do
		local var5_3 = {}

		for iter1_3 = var2_3, var4_3 do
			local var6_3 = arg0_3:GetView().poolMgr:GetGridPool():Dequeue()

			setParent(var6_3, var0_3)

			tf(var6_3).localScale = Vector3.one
			tf(var6_3).localPosition = CourtYardCalcUtil.Map2Local(Vector2(iter0_3, iter1_3))
			var6_3:GetComponent(typeof(Image)).color = (iter1_3 == var4_3 or iter0_3 == var3_3) and Color.New(1, 1, 0, 0.5) or Color.New(0, 1, 0, 1)
			var5_3[iter1_3] = var6_3
		end

		arg0_3.mapGrids[iter0_3] = var5_3
	end

	arg0_3:Flush()
end

function var0_0.Flush(arg0_4)
	local var0_4 = arg0_4.map.sizeX
	local var1_4 = arg0_4.map.sizeY

	for iter0_4, iter1_4 in pairs(arg0_4.mapGrids) do
		for iter2_4, iter3_4 in pairs(iter1_4) do
			local var2_4 = arg0_4.map:IsEmptyPosition(Vector2(iter0_4, iter2_4))
			local var3_4 = iter3_4:GetComponent(typeof(Image))
			local var4_4

			if var2_4 then
				var4_4 = (iter2_4 == var1_4 or iter0_4 == var0_4) and Color.New(1, 1, 0, 0.5) or Color.New(0, 1, 0, 1)
			else
				var4_4 = Color.New(arg0_4.r, arg0_4.g, arg0_4.b, var3_4.color.a)
			end

			var3_4.color = var4_4
		end
	end
end

function var0_0.Clear(arg0_5)
	for iter0_5, iter1_5 in pairs(arg0_5.mapGrids) do
		for iter2_5, iter3_5 in pairs(iter1_5) do
			iter3_5:GetComponent(typeof(Image)).color = Color.New(0, 1, 0, 1)

			arg0_5:GetView().poolMgr:GetGridPool():Enqueue(iter3_5)
		end
	end

	arg0_5.mapGrids = {}
end

function var0_0.Dispose(arg0_6)
	arg0_6:Clear()
end

return var0_0
