local var0 = class("WSMapTransform", import(".WSMapObject"))

var0.Fields = {
	transform = "userdata",
	isMoving = "boolean",
	modelOrder = "number"
}

function var0.Dispose(arg0)
	arg0:ClearModelOrder()
	arg0:Clear()
end

function var0.SetModelOrder(arg0, arg1, arg2)
	assert(arg0.transform)

	if not GetComponent(arg0.transform, typeof(Canvas)) then
		setCanvasOverrideSorting(arg0.transform, true)
	end

	local var0 = 0

	if arg0.modelOrder then
		var0 = var0 - arg0.modelOrder
	end

	arg0.modelOrder = arg1 + defaultValue(arg2, 0) * 10

	local var1 = var0 + arg0.modelOrder

	if var1 ~= 0 then
		WorldConst.ArrayEffectOrder(arg0.transform, var1)
	end
end

function var0.ClearModelOrder(arg0)
	assert(arg0.transform)
	arg0:UnloadModel()

	if arg0.modelOrder then
		WorldConst.ArrayEffectOrder(arg0.transform, -arg0.modelOrder)

		arg0.modelOrder = nil
	end
end

function var0.LoadModel(arg0, arg1, arg2, arg3, arg4, arg5)
	var0.super.LoadModel(arg0, arg1, arg2, arg3, arg4, function()
		if arg0.modelOrder then
			WorldConst.ArrayEffectOrder(arg0.model, arg0.modelOrder)
		end

		return existCall(arg5)
	end)
end

function var0.UnloadModel(arg0)
	if arg0.modelOrder and arg0.model then
		WorldConst.ArrayEffectOrder(arg0.model, -arg0.modelOrder)
	end

	var0.super.UnloadModel(arg0)
end

return var0
