local var0_0 = class("CourtYardGridAgent", import(".CourtYardAgent"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.grids = {}
end

function var0_0.Reset(arg0_2, arg1_2)
	table.clear(arg0_2.grids)

	for iter0_2, iter1_2 in ipairs(arg1_2) do
		local var0_2 = arg0_2:GetPool():Dequeue()

		var0_2.transform:SetParent(arg0_2.selectedModule.gridsTF)

		var0_2.transform.localScale = Vector3(1, 1, 1)

		table.insert(arg0_2.grids, var0_2)
		arg0_2:UpdatePositionAndColor(var0_2, iter1_2)
	end
end

function var0_0.Flush(arg0_3, arg1_3)
	for iter0_3, iter1_3 in ipairs(arg1_3) do
		local var0_3 = arg0_3.grids[iter0_3]

		assert(var0_3)
		arg0_3:UpdatePositionAndColor(var0_3, iter1_3)
	end
end

function var0_0.UpdatePositionAndColor(arg0_4, arg1_4, arg2_4)
	local var0_4 = CourtYardCalcUtil.Map2Local(arg2_4.position) + arg2_4.offset

	arg1_4.transform.localPosition = CourtYardCalcUtil.TrPosition2LocalPos(arg0_4.gridsTF, arg1_4.transform.parent, Vector3(var0_4.x, var0_4.y, 0))

	local var1_4 = arg0_4:GetColor(arg2_4.flag)

	arg1_4:GetComponent(typeof(Image)).color = var1_4
end

function var0_0.Clear(arg0_5)
	for iter0_5, iter1_5 in ipairs(arg0_5.grids) do
		iter1_5.transform.localScale = Vector3(1, 1, 1)
		iter1_5.transform.eulerAngles = Vector3.zero
		iter1_5:GetComponent(typeof(Image)).color = Color.New(1, 1, 1, 1)

		arg0_5:GetPool():Enqueue(iter1_5)
	end

	arg0_5.grids = {}
end

function var0_0.GetPool(arg0_6)
	return arg0_6:GetView().poolMgr:GetGridPool()
end

function var0_0.GetColor(arg0_7, arg1_7)
	return ({
		CourtYardConst.BACKYARD_GREEN,
		CourtYardConst.BACKYARD_RED,
		CourtYardConst.BACKYARD_BLUE
	})[arg1_7]
end

function var0_0.Dispose(arg0_8)
	var0_0.super.Dispose(arg0_8)
	arg0_8:Clear()
end

return var0_0
