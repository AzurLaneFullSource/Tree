local var0 = class("DynamicCellView", import(".LevelCellView"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0)

	arg0.go = arg1
	arg0.tf = arg0.go.transform

	arg0:OverrideCanvas()

	arg0.buffer = FuncBuffer.New()
end

return var0
