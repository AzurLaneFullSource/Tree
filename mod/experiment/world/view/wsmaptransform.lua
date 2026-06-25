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
		SetCanvasOverrideSorting(arg0_2.transform, true)
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

	arg0_2:ModelOrderChanged()
end

function var0_0.ModelOrderChanged(arg0_3)
	return
end

function var0_0.ClearModelOrder(arg0_4)
	assert(arg0_4.transform)
	arg0_4:UnloadModel()

	if arg0_4.modelOrder then
		WorldConst.ArrayEffectOrder(arg0_4.transform, -arg0_4.modelOrder)

		arg0_4.modelOrder = nil
	end
end

function var0_0.LoadModel(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5, arg5_5)
	var0_0.super.LoadModel(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5, function()
		if arg0_5.modelOrder then
			WorldConst.ArrayEffectOrder(arg0_5.model, arg0_5.modelOrder)
		end

		return existCall(arg5_5)
	end)
end

function var0_0.UnloadModel(arg0_7)
	if arg0_7.modelOrder and arg0_7.model then
		WorldConst.ArrayEffectOrder(arg0_7.model, -arg0_7.modelOrder)
	end

	var0_0.super.UnloadModel(arg0_7)
end

return var0_0
