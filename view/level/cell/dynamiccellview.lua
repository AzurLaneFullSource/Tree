local var0_0 = class("DynamicCellView", import(".LevelCellView"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1)

	arg0_1.go = arg1_1
	arg0_1.tf = arg0_1.go.transform

	arg0_1:OverrideCanvas()

	arg0_1.buffer = FuncBuffer.New()
end

return var0_0
