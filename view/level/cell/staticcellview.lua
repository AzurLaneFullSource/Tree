local var0_0 = class("StaticCellView", import("view.level.cell.LevelCellView"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1)

	arg0_1.parent = arg1_1
	arg0_1.go = nil
	arg0_1.tf = nil
	arg0_1.info = nil
end

function var0_0.PrepareBase(arg0_2, arg1_2)
	arg0_2.go = GameObject.New(arg1_2)

	arg0_2.go:AddComponent(typeof(RectTransform))
	setParent(arg0_2.go, arg0_2.parent)

	arg0_2.tf = tf(arg0_2.go)
	arg0_2.tf.sizeDelta = arg0_2.parent.sizeDelta

	arg0_2:OverrideCanvas()
	arg0_2:ResetCanvasOrder()
end

function var0_0.DestroyGO(arg0_3)
	if arg0_3.loader then
		arg0_3.loader:ClearRequests()
	end

	if not IsNil(arg0_3.go) then
		Destroy(arg0_3.go)

		arg0_3.go = nil
		arg0_3.tf = nil
	end
end

function var0_0.Update(arg0_4)
	assert(false, "not implemented")
end

function var0_0.Clear(arg0_5)
	arg0_5.parent = nil
	arg0_5.info = nil

	arg0_5:DestroyGO()
end

return var0_0
