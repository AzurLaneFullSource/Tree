ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleSceneObject")

var0_0.Battle.BattleSceneObject = var1_0
var1_0.__name = "BattleSceneObject"

function var1_0.Ctor(arg0_1)
	return
end

function var1_0.GetGO(arg0_2)
	return arg0_2._go
end

function var1_0.GetTf(arg0_3)
	return arg0_3._tf
end

function var1_0.SetGO(arg0_4, arg1_4)
	arg0_4._go = arg1_4
	arg0_4._tf = arg1_4.transform
end

function var1_0.GetCldBoxSize(arg0_5)
	assert(false, arg0_5.__name .. ".GetCldBoxSize: this function should be override!!!")
end

function var1_0.GetCldBox(arg0_6)
	assert(false, arg0_6.__name .. ".GetCldBox: this function should be override!!!")
end

function var1_0.GetCldData(arg0_7)
	assert(false, arg0_7.__name .. ".GetCldData: this function should be override!!!")
end

function var1_0.GetGOPosition(arg0_8)
	return arg0_8._tf.localPosition
end

function var1_0.CameraOrthogonal(arg0_9, arg1_9)
	arg0_9._tf.localRotation = arg1_9.transform.localRotation
end

function var1_0.Dispose(arg0_10)
	arg0_10._tf = nil

	var0_0.Battle.BattleResourceManager.GetInstance():DestroyOb(arg0_10._go)

	arg0_10._go = nil
end
