local var0 = class("LevelCellData", import("model.vo.BaseVO"))

function var0.GetLine(arg0)
	return {
		row = arg0.row,
		column = arg0.column
	}
end

function var0.SetLine(arg0, arg1)
	arg0.row = arg1.row
	arg0.column = arg1.column
end

return var0
