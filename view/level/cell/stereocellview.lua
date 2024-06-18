local var0_0 = class("StereoCellView", import("view.level.cell.LevelCellView"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1)

	arg0_1.assetName = nil
	arg0_1.line = {
		row = arg1_1,
		column = arg2_1
	}
	arg0_1.buffer = FuncBuffer.New()
end

function var0_0.UpdateGO(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg0_2:GetLoader():GetRequestPackage("main")

	if var0_2 and var0_2.name == arg0_2.assetName then
		return
	end

	arg0_2.buffer:Clear()
	arg0_2.buffer:SetNotifier(nil)
	arg0_2:GetLoader():GetPrefab(arg1_2, arg2_2, function(arg0_3)
		arg0_2.go = arg0_3
		arg0_2.tf = arg0_2.go.transform

		arg0_2:OnLoaded(arg0_3)
		arg0_2.buffer:SetNotifier(arg0_2)
		arg0_2.buffer:ExcuteAll()
		arg0_2:OverrideCanvas()
		arg0_2:ResetCanvasOrder()
	end, "main")
end

function var0_0.OnLoaded(arg0_4, arg1_4)
	return
end

return var0_0
