local var0_0 = class("MainFoldableHelper")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._tf = arg1_1
	arg0_1.foldPosition = arg0_1:InitFoldPositions(arg2_1)
end

function var0_0.IsInit(arg0_2)
	return arg0_2._tf ~= nil
end

function var0_0.InitFoldPositions(arg0_3, arg1_3)
	if not arg0_3:IsInit() then
		return nil
	end

	local var0_3 = arg0_3._tf.anchoredPosition
	local var1_3 = 1500
	local var2_3 = 200
	local var3_3 = var0_3.x
	local var4_3 = 0
	local var5_3 = var0_3.y
	local var6_3 = 0

	if arg1_3.x > 0 then
		var4_3 = var0_3.x + var1_3
	elseif arg1_3.x < 0 then
		var4_3 = var0_3.x - var1_3
	end

	if arg1_3.y > 0 then
		var6_3 = var0_3.y + var2_3
	elseif arg1_3.y < 0 then
		var6_3 = var0_3.y - var2_3
	end

	return Vector4(var3_3, var4_3, var5_3, var6_3)
end

function var0_0.Fold(arg0_4, arg1_4, arg2_4)
	if not arg0_4:IsInit() then
		return
	end

	LeanTween.cancel(arg0_4._tf.gameObject)

	local var0_4 = arg0_4.foldPosition

	if var0_4.y ~= 0 then
		local var1_4 = arg1_4 and Vector2(var0_4.x, var0_4.y) or Vector2(var0_4.y, var0_4.x)

		arg0_4:LeanTweenValue(var1_4, arg2_4, true)
	end

	if var0_4.w ~= 0 then
		local var2_4 = arg1_4 and Vector2(var0_4.z, var0_4.w) or Vector2(var0_4.w, var0_4.z)

		arg0_4:LeanTweenValue(var2_4, arg2_4, false)
	end
end

function var0_0.LeanTweenValue(arg0_5, arg1_5, arg2_5, arg3_5)
	local function var0_5(arg0_6)
		if arg3_5 then
			setAnchoredPosition(arg0_5._tf.gameObject, {
				x = arg0_6
			})
		else
			setAnchoredPosition(arg0_5._tf.gameObject, {
				y = arg0_6
			})
		end
	end

	if arg2_5 <= 0 then
		var0_5(arg1_5.y)

		return
	end

	LeanTween.value(arg0_5._tf.gameObject, arg1_5.x, arg1_5.y, arg2_5):setOnUpdate(System.Action_float(var0_5)):setEase(LeanTweenType.easeInOutExpo)
end

function var0_0.Dispose(arg0_7)
	if not arg0_7:IsInit() then
		return nil
	end

	LeanTween.cancel(arg0_7._tf.gameObject)
end

return var0_0
