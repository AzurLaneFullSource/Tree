local var0_0 = class("LevelCellData", import("model.vo.BaseVO"))

function var0_0.GetLine(arg0_1)
	return {
		row = arg0_1.row,
		column = arg0_1.column
	}
end

function var0_0.SetLine(arg0_2, arg1_2)
	arg0_2.row = arg1_2.row
	arg0_2.column = arg1_2.column
end

return var0_0
