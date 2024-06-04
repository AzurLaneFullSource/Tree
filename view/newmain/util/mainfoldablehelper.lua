local var0 = class("MainFoldableHelper")

function var0.Ctor(arg0, arg1, arg2)
	arg0._tf = arg1
	arg0.foldPosition = arg0:InitFoldPositions(arg2)
end

function var0.IsInit(arg0)
	return arg0._tf ~= nil
end

function var0.InitFoldPositions(arg0, arg1)
	if not arg0:IsInit() then
		return nil
	end

	local var0 = arg0._tf.anchoredPosition
	local var1 = 1500
	local var2 = 200
	local var3 = var0.x
	local var4 = 0
	local var5 = var0.y
	local var6 = 0

	if arg1.x > 0 then
		var4 = var0.x + var1
	elseif arg1.x < 0 then
		var4 = var0.x - var1
	end

	if arg1.y > 0 then
		var6 = var0.y + var2
	elseif arg1.y < 0 then
		var6 = var0.y - var2
	end

	return Vector4(var3, var4, var5, var6)
end

function var0.Fold(arg0, arg1, arg2)
	if not arg0:IsInit() then
		return
	end

	LeanTween.cancel(arg0._tf.gameObject)

	local var0 = arg0.foldPosition

	if var0.y ~= 0 then
		local var1 = arg1 and Vector2(var0.x, var0.y) or Vector2(var0.y, var0.x)

		arg0:LeanTweenValue(var1, arg2, true)
	end

	if var0.w ~= 0 then
		local var2 = arg1 and Vector2(var0.z, var0.w) or Vector2(var0.w, var0.z)

		arg0:LeanTweenValue(var2, arg2, false)
	end
end

function var0.LeanTweenValue(arg0, arg1, arg2, arg3)
	local function var0(arg0)
		if arg3 then
			setAnchoredPosition(arg0._tf.gameObject, {
				x = arg0
			})
		else
			setAnchoredPosition(arg0._tf.gameObject, {
				y = arg0
			})
		end
	end

	if arg2 <= 0 then
		var0(arg1.y)

		return
	end

	LeanTween.value(arg0._tf.gameObject, arg1.x, arg1.y, arg2):setOnUpdate(System.Action_float(var0)):setEase(LeanTweenType.easeInOutExpo)
end

function var0.Dispose(arg0)
	if not arg0:IsInit() then
		return nil
	end

	LeanTween.cancel(arg0._tf.gameObject)
end

return var0
