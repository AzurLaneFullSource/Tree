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
	arg0_10:OnCanvasUpDate()
end

function var0_0.OnCanvasUpDate(arg0_11)
	return
end

function var0_0.GetCurrentOrder(arg0_12)
	return arg0_12.line.row * ChapterConst.PriorityPerRow + arg0_12:GetOrder()
end

function var0_0.AddCanvasOrder(arg0_13, arg1_13, arg2_13)
	arg1_13 = tf(arg1_13)

	local var0_13 = arg1_13:GetComponents(typeof(Renderer)):ToTable()

	for iter0_13, iter1_13 in ipairs(var0_13) do
		iter1_13.sortingOrder = (arg0_13.orderTable[iter1_13] or 0) + arg2_13
	end

	local var1_13 = arg1_13:GetComponent(typeof(Canvas))

	if var1_13 then
		var1_13.sortingOrder = (arg0_13.orderTable[var1_13] or 0) + arg2_13
	end

	for iter2_13 = 0, arg1_13.childCount - 1 do
		arg0_13:AddCanvasOrder(arg1_13:GetChild(iter2_13), arg2_13)
	end
end

function var0_0.RecordCanvasOrder(arg0_14, arg1_14)
	arg1_14 = tf(arg1_14)

	local var0_14 = arg1_14:GetComponents(typeof(Renderer)):ToTable()

	for iter0_14, iter1_14 in ipairs(var0_14) do
		arg0_14.orderTable[iter1_14] = iter1_14.sortingOrder
	end

	local var1_14 = arg1_14:GetComponent(typeof(Canvas))

	if var1_14 then
		arg0_14.orderTable[var1_14] = var1_14.sortingOrder
	end

	for iter2_14 = 0, arg1_14.childCount - 1 do
		arg0_14:RecordCanvasOrder(arg1_14:GetChild(iter2_14))
	end
end

function var0_0.RefreshLinePosition(arg0_15, arg1_15, arg2_15)
	if arg2_15 then
		arg0_15:SetLine(arg2_15)
		arg0_15:ResetCanvasOrder()
	end

	arg0_15.tf.anchoredPosition = arg1_15.theme:GetLinePosition(arg0_15.line.row, arg0_15.line.column)
end

function var0_0.Clear(arg0_16)
	for iter0_16, iter1_16 in pairs(arg0_16.orderTable) do
		if not IsNil(iter0_16) then
			iter0_16.sortingOrder = iter1_16
		end
	end

	table.clear(arg0_16.orderTable)
	arg0_16:ClearLoader()
end

return var0_0
