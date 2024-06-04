local var0 = class("StaticCellView", import("view.level.cell.LevelCellView"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0)

	arg0.parent = arg1
	arg0.go = nil
	arg0.tf = nil
	arg0.info = nil
end

function var0.PrepareBase(arg0, arg1)
	arg0.go = GameObject.New(arg1)

	arg0.go:AddComponent(typeof(RectTransform))
	setParent(arg0.go, arg0.parent)

	arg0.tf = tf(arg0.go)
	arg0.tf.sizeDelta = arg0.parent.sizeDelta

	arg0:OverrideCanvas()
	arg0:ResetCanvasOrder()
end

function var0.DestroyGO(arg0)
	if arg0.loader then
		arg0.loader:ClearRequests()
	end

	if not IsNil(arg0.go) then
		Destroy(arg0.go)

		arg0.go = nil
		arg0.tf = nil
	end
end

function var0.Update(arg0)
	assert(false, "not implemented")
end

function var0.Clear(arg0)
	arg0.parent = nil
	arg0.info = nil

	arg0:DestroyGO()
end

return var0
