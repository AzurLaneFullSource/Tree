ys = ys or {}

local var0 = ys
local var1 = class("BattleSceneObject")

var0.Battle.BattleSceneObject = var1
var1.__name = "BattleSceneObject"

function var1.Ctor(arg0)
	return
end

function var1.GetGO(arg0)
	return arg0._go
end

function var1.GetTf(arg0)
	return arg0._tf
end

function var1.SetGO(arg0, arg1)
	arg0._go = arg1
	arg0._tf = arg1.transform
end

function var1.GetCldBoxSize(arg0)
	assert(false, arg0.__name .. ".GetCldBoxSize: this function should be override!!!")
end

function var1.GetCldBox(arg0)
	assert(false, arg0.__name .. ".GetCldBox: this function should be override!!!")
end

function var1.GetCldData(arg0)
	assert(false, arg0.__name .. ".GetCldData: this function should be override!!!")
end

function var1.GetGOPosition(arg0)
	return arg0._tf.localPosition
end

function var1.CameraOrthogonal(arg0, arg1)
	arg0._tf.localRotation = arg1.transform.localRotation
end

function var1.Dispose(arg0)
	arg0._tf = nil

	var0.Battle.BattleResourceManager.GetInstance():DestroyOb(arg0._go)

	arg0._go = nil
end
