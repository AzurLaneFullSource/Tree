local var0 = class("StereoCellView", import("view.level.cell.LevelCellView"))

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0)

	arg0.assetName = nil
	arg0.line = {
		row = arg1,
		column = arg2
	}
	arg0.buffer = FuncBuffer.New()
end

function var0.UpdateGO(arg0, arg1, arg2)
	local var0 = arg0:GetLoader():GetRequestPackage("main")

	if var0 and var0.name == arg0.assetName then
		return
	end

	arg0.buffer:Clear()
	arg0.buffer:SetNotifier(nil)
	arg0:GetLoader():GetPrefab(arg1, arg2, function(arg0)
		arg0.go = arg0
		arg0.tf = arg0.go.transform

		arg0:OnLoaded(arg0)
		arg0.buffer:SetNotifier(arg0)
		arg0.buffer:ExcuteAll()
		arg0:OverrideCanvas()
		arg0:ResetCanvasOrder()
	end, "main")
end

function var0.OnLoaded(arg0, arg1)
	return
end

return var0
