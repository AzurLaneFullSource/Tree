local var0 = class("WallCell", StereoCellView)

function var0.Ctor(arg0, arg1, arg2, arg3, arg4)
	var0.super.Ctor(arg0, arg1, arg2)

	arg0.direction = arg3
	arg0.anchor = arg4
	arg0.BanCount = 0
	arg0.WallPrefabs = nil
	arg0.girdParent = nil
end

function var0.GetOrder(arg0)
	return ChapterConst.CellPriorityFleet
end

function var0.OverrideCanvas(arg0)
	pg.ViewUtils.SetLayer(tf(arg0.go), Layer.UI)
end

function var0.ResetCanvasOrder(arg0)
	pg.ViewUtils.SetSortingOrder(arg0.tf, math.floor(arg0.line.row * 0.5) * ChapterConst.PriorityPerRow + arg0:GetOrder())
end

function var0.RefreshDirection(arg0)
	setParent(arg0.tf, arg0.girdParent.cellRoot)

	arg0.tf.localRotation = Quaternion.Euler(arg0.direction and 0.1 or -90, 90, -90)
	arg0.tf.anchoredPosition3D = arg0.anchor
end

function var0.SetAsset(arg0, arg1)
	if not arg1 or #arg1 == 0 then
		return
	end

	arg0.assetName = arg1

	arg0:UpdateView()
end

function var0.UpdateView(arg0)
	arg0:UpdateGO("effect/" .. arg0.assetName, arg0.assetName)
	arg0.buffer:RefreshDirection()
end

return var0
