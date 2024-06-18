local var0_0 = class("WallCell", StereoCellView)

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.direction = arg3_1
	arg0_1.anchor = arg4_1
	arg0_1.BanCount = 0
	arg0_1.WallPrefabs = nil
	arg0_1.girdParent = nil
end

function var0_0.GetOrder(arg0_2)
	return ChapterConst.CellPriorityFleet
end

function var0_0.OverrideCanvas(arg0_3)
	pg.ViewUtils.SetLayer(tf(arg0_3.go), Layer.UI)
end

function var0_0.ResetCanvasOrder(arg0_4)
	pg.ViewUtils.SetSortingOrder(arg0_4.tf, math.floor(arg0_4.line.row * 0.5) * ChapterConst.PriorityPerRow + arg0_4:GetOrder())
end

function var0_0.RefreshDirection(arg0_5)
	setParent(arg0_5.tf, arg0_5.girdParent.cellRoot)

	arg0_5.tf.localRotation = Quaternion.Euler(arg0_5.direction and 0.1 or -90, 90, -90)
	arg0_5.tf.anchoredPosition3D = arg0_5.anchor
end

function var0_0.SetAsset(arg0_6, arg1_6)
	if not arg1_6 or #arg1_6 == 0 then
		return
	end

	arg0_6.assetName = arg1_6

	arg0_6:UpdateView()
end

function var0_0.UpdateView(arg0_7)
	arg0_7:UpdateGO("effect/" .. arg0_7.assetName, arg0_7.assetName)
	arg0_7.buffer:RefreshDirection()
end

return var0_0
