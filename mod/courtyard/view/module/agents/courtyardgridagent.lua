local var0 = class("CourtYardGridAgent", import(".CourtYardAgent"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.grids = {}
end

function var0.Reset(arg0, arg1)
	table.clear(arg0.grids)

	for iter0, iter1 in ipairs(arg1) do
		local var0 = arg0:GetPool():Dequeue()

		var0.transform:SetParent(arg0.selectedModule.gridsTF)

		var0.transform.localScale = Vector3(1, 1, 1)

		table.insert(arg0.grids, var0)
		arg0:UpdatePositionAndColor(var0, iter1)
	end
end

function var0.Flush(arg0, arg1)
	for iter0, iter1 in ipairs(arg1) do
		local var0 = arg0.grids[iter0]

		assert(var0)
		arg0:UpdatePositionAndColor(var0, iter1)
	end
end

function var0.UpdatePositionAndColor(arg0, arg1, arg2)
	local var0 = CourtYardCalcUtil.Map2Local(arg2.position) + arg2.offset

	arg1.transform.localPosition = CourtYardCalcUtil.TrPosition2LocalPos(arg0.gridsTF, arg1.transform.parent, Vector3(var0.x, var0.y, 0))

	local var1 = arg0:GetColor(arg2.flag)

	arg1:GetComponent(typeof(Image)).color = var1
end

function var0.Clear(arg0)
	for iter0, iter1 in ipairs(arg0.grids) do
		iter1.transform.localScale = Vector3(1, 1, 1)
		iter1.transform.eulerAngles = Vector3.zero
		iter1:GetComponent(typeof(Image)).color = Color.New(1, 1, 1, 1)

		arg0:GetPool():Enqueue(iter1)
	end

	arg0.grids = {}
end

function var0.GetPool(arg0)
	return arg0:GetView().poolMgr:GetGridPool()
end

function var0.GetColor(arg0, arg1)
	return ({
		CourtYardConst.BACKYARD_GREEN,
		CourtYardConst.BACKYARD_RED,
		CourtYardConst.BACKYARD_BLUE
	})[arg1]
end

function var0.Dispose(arg0)
	var0.super.Dispose(arg0)
	arg0:Clear()
end

return var0
