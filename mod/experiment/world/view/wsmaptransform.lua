local var0_0 = class("WSMapTransform", import(".WSMapObject"))

var0_0.Fields = {
	transform = "userdata",
	isMoving = "boolean",
	modelOrder = "number"
}

function var0_0.Dispose(arg0_1)
	arg0_1:ClearModelOrder()
	arg0_1:Clear()
end

function var0_0.SetModelOrder(arg0_2, arg1_2, arg2_2)
	assert(arg0_2.transform)

	if not GetComponent(arg0_2.transform, typeof(Canvas)) then
		setCanvasOverrideSorting(arg0_2.transform, true)
	end

	local var0_2 = 0

	if arg0_2.modelOrder then
		var0_2 = var0_2 - arg0_2.modelOrder
	end

	arg0_2.modelOrder = arg1_2 + defaultValue(arg2_2, 0) * 10

	local var1_2 = var0_2 + arg0_2.modelOrder

	if var1_2 ~= 0 then
		WorldConst.ArrayEffectOrder(arg0_2.transform, var1_2)
	end
end

function var0_0.ClearModelOrder(arg0_3)
	assert(arg0_3.transform)
	arg0_3:UnloadModel()

	if arg0_3.modelOrder then
		WorldConst.ArrayEffectOrder(arg0_3.transform, -arg0_3.modelOrder)

		arg0_3.modelOrder = nil
	end
end

function var0_0.LoadModel(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4, arg5_4)
	var0_0.super.LoadModel(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4, function()
		if arg0_4.modelOrder then
			WorldConst.ArrayEffectOrder(arg0_4.model, arg0_4.modelOrder)
		end

		return existCall(arg5_4)
	end)
end

function var0_0.UnloadModel(arg0_6)
	if arg0_6.modelOrder and arg0_6.model then
		WorldConst.ArrayEffectOrder(arg0_6.model, -arg0_6.modelOrder)
	end

	var0_0.super.UnloadModel(arg0_6)
end

return var0_0
