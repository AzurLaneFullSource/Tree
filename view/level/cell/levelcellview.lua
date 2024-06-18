local var0_0 = class("LevelCellView")

function var0_0.Ctor(arg0_1)
	arg0_1.go = nil
	arg0_1.tf = nil
	arg0_1.orderTable = {}
end

function var0_0.SetActive(arg0_2, arg1_2)
	setActive(arg0_2.go, arg1_2)
end

function var0_0.GetOrder(arg0_3)
	return ChapterConst.CellPriorityNone
end

function var0_0.SetLoader(arg0_4, arg1_4)
	assert(not arg0_4.loader, "repeatly Set loader")

	arg0_4.loader = arg1_4
end

function var0_0.GetLoader(arg0_5)
	arg0_5.loader = arg0_5.loader or AutoLoader.New()

	return arg0_5.loader
end

function var0_0.ClearLoader(arg0_6)
	if arg0_6.loader then
		arg0_6.loader:Clear()
	end
end

function var0_0.GetLine(arg0_7)
	return arg0_7.line
end

function var0_0.SetLine(arg0_8, arg1_8)
	arg0_8.line = {
		row = arg1_8.row,
		column = arg1_8.column
	}
end

function var0_0.OverrideCanvas(arg0_9)
	pg.ViewUtils.SetLayer(tf(arg0_9.go), Layer.UI)

	arg0_9.canvas = GetOrAddComponent(arg0_9.go, typeof(Canvas))
	arg0_9.canvas.overrideSorting = true
end

function var0_0.ResetCanvasOrder(arg0_10)
	if not arg0_10.canvas then
		return
	end

	local var0_10 = arg0_10.line.row * ChapterConst.PriorityPerRow + arg0_10:GetOrder()

	pg.ViewUtils.SetSortingOrder(arg0_10.tf, var0_10)
end

function var0_0.GetCurrentOrder(arg0_11)
	return arg0_11.line.row * ChapterConst.PriorityPerRow + arg0_11:GetOrder()
end

function var0_0.AddCanvasOrder(arg0_12, arg1_12, arg2_12)
	arg1_12 = tf(arg1_12)

	local var0_12 = arg1_12:GetComponents(typeof(Renderer))

	for iter0_12 = 0, var0_12.Length - 1 do
		var0_12[iter0_12].sortingOrder = (arg0_12.orderTable[var0_12[iter0_12]] or 0) + arg2_12
	end

	local var1_12 = arg1_12:GetComponent(typeof(Canvas))

	if var1_12 then
		var1_12.sortingOrder = (arg0_12.orderTable[var1_12] or 0) + arg2_12
	end

	for iter1_12 = 0, arg1_12.childCount - 1 do
		arg0_12:AddCanvasOrder(arg1_12:GetChild(iter1_12), arg2_12)
	end
end

function var0_0.RecordCanvasOrder(arg0_13, arg1_13)
	arg1_13 = tf(arg1_13)

	local var0_13 = arg1_13:GetComponents(typeof(Renderer))

	for iter0_13 = 0, var0_13.Length - 1 do
		local var1_13 = var0_13[iter0_13]

		arg0_13.orderTable[var0_13[iter0_13]] = var0_13[iter0_13].sortingOrder
	end

	local var2_13 = arg1_13:GetComponent(typeof(Canvas))

	if var2_13 then
		arg0_13.orderTable[var2_13] = var2_13.sortingOrder
	end

	for iter1_13 = 0, arg1_13.childCount - 1 do
		arg0_13:RecordCanvasOrder(arg1_13:GetChild(iter1_13))
	end
end

function var0_0.RefreshLinePosition(arg0_14, arg1_14, arg2_14)
	if arg2_14 then
		arg0_14:SetLine(arg2_14)
		arg0_14:ResetCanvasOrder()
	end

	arg0_14.tf.anchoredPosition = arg1_14.theme:GetLinePosition(arg0_14.line.row, arg0_14.line.column)
end

function var0_0.Clear(arg0_15)
	for iter0_15, iter1_15 in pairs(arg0_15.orderTable) do
		if not IsNil(iter0_15) then
			iter0_15.sortingOrder = iter1_15
		end
	end

	table.clear(arg0_15.orderTable)
	arg0_15:ClearLoader()
end

return var0_0
