local var0 = class("LevelCellView")

function var0.Ctor(arg0)
	arg0.go = nil
	arg0.tf = nil
	arg0.orderTable = {}
end

function var0.SetActive(arg0, arg1)
	setActive(arg0.go, arg1)
end

function var0.GetOrder(arg0)
	return ChapterConst.CellPriorityNone
end

function var0.SetLoader(arg0, arg1)
	assert(not arg0.loader, "repeatly Set loader")

	arg0.loader = arg1
end

function var0.GetLoader(arg0)
	arg0.loader = arg0.loader or AutoLoader.New()

	return arg0.loader
end

function var0.ClearLoader(arg0)
	if arg0.loader then
		arg0.loader:Clear()
	end
end

function var0.GetLine(arg0)
	return arg0.line
end

function var0.SetLine(arg0, arg1)
	arg0.line = {
		row = arg1.row,
		column = arg1.column
	}
end

function var0.OverrideCanvas(arg0)
	pg.ViewUtils.SetLayer(tf(arg0.go), Layer.UI)

	arg0.canvas = GetOrAddComponent(arg0.go, typeof(Canvas))
	arg0.canvas.overrideSorting = true
end

function var0.ResetCanvasOrder(arg0)
	if not arg0.canvas then
		return
	end

	local var0 = arg0.line.row * ChapterConst.PriorityPerRow + arg0:GetOrder()

	pg.ViewUtils.SetSortingOrder(arg0.tf, var0)
end

function var0.GetCurrentOrder(arg0)
	return arg0.line.row * ChapterConst.PriorityPerRow + arg0:GetOrder()
end

function var0.AddCanvasOrder(arg0, arg1, arg2)
	arg1 = tf(arg1)

	local var0 = arg1:GetComponents(typeof(Renderer))

	for iter0 = 0, var0.Length - 1 do
		var0[iter0].sortingOrder = (arg0.orderTable[var0[iter0]] or 0) + arg2
	end

	local var1 = arg1:GetComponent(typeof(Canvas))

	if var1 then
		var1.sortingOrder = (arg0.orderTable[var1] or 0) + arg2
	end

	for iter1 = 0, arg1.childCount - 1 do
		arg0:AddCanvasOrder(arg1:GetChild(iter1), arg2)
	end
end

function var0.RecordCanvasOrder(arg0, arg1)
	arg1 = tf(arg1)

	local var0 = arg1:GetComponents(typeof(Renderer))

	for iter0 = 0, var0.Length - 1 do
		local var1 = var0[iter0]

		arg0.orderTable[var0[iter0]] = var0[iter0].sortingOrder
	end

	local var2 = arg1:GetComponent(typeof(Canvas))

	if var2 then
		arg0.orderTable[var2] = var2.sortingOrder
	end

	for iter1 = 0, arg1.childCount - 1 do
		arg0:RecordCanvasOrder(arg1:GetChild(iter1))
	end
end

function var0.RefreshLinePosition(arg0, arg1, arg2)
	if arg2 then
		arg0:SetLine(arg2)
		arg0:ResetCanvasOrder()
	end

	arg0.tf.anchoredPosition = arg1.theme:GetLinePosition(arg0.line.row, arg0.line.column)
end

function var0.Clear(arg0)
	for iter0, iter1 in pairs(arg0.orderTable) do
		if not IsNil(iter0) then
			iter0.sortingOrder = iter1
		end
	end

	table.clear(arg0.orderTable)
	arg0:ClearLoader()
end

return var0
