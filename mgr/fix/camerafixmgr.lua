pg = pg or {}
pg.CameraFixMgr = singletonClass("CameraFixMgr", import("view.base.BaseEventLogic"))

local var0_0 = pg.CameraFixMgr

var0_0.ASPECT_RATIO_UPDATE = "aspect_ratio_update"

function var0_0.Init(arg0_1, arg1_1)
	arg0_1.targetRatio = 1.77777777777778

	arg0_1:AddListener()
	arg0_1:Adapt()
	arg1_1()
end

function var0_0.AddListener(arg0_2)
	arg0_2:Clear()

	function arg0_2.adaptCall(arg0_3)
		arg0_2:AfterCall(arg0_3)
	end

	CameraMgr.instance:AddListener(arg0_2.adaptCall)
end

function var0_0.Adapt(arg0_4)
	CameraMgr.instance:Adapt()
end

function var0_0.AfterCall(arg0_5, arg1_5)
	arg0_5.targetRatio = arg1_5
	arg0_5.currentWidth = Screen.width
	arg0_5.currentHeight = Screen.height

	local var0_5 = arg0_5.currentWidth / arg0_5.currentHeight

	if var0_5 < arg0_5.targetRatio then
		arg0_5.actualWidth = arg0_5.currentWidth
		arg0_5.actualHeight = arg0_5.currentWidth / arg0_5.targetRatio

		local var1_5 = (arg0_5.currentHeight - arg0_5.actualHeight) * 0.5

		arg0_5.leftBottomVector = Vector3(0, var1_5, 0)
		arg0_5.rightTopVector = Vector3(arg0_5.currentWidth, arg0_5.currentHeight - var1_5, 0)
	else
		arg0_5.actualWidth = arg0_5.currentHeight * arg0_5.targetRatio
		arg0_5.actualHeight = arg0_5.currentHeight

		local var2_5 = (arg0_5.currentWidth - arg0_5.actualWidth) * 0.5

		arg0_5.leftBottomVector = Vector3(var2_5, 0, 0)
		arg0_5.rightTopVector = Vector3(arg0_5.currentWidth - var2_5, arg0_5.currentHeight, 0)
	end

	local var3_5 = NotchAdapt.CheckNotchRatio

	if var0_5 > ADAPT_NOTICE and var3_5 < arg0_5.targetRatio then
		arg0_5.notchAdaptWidth = arg0_5.currentHeight * var3_5
		arg0_5.notchAdaptHeight = arg0_5.currentHeight

		local var4_5 = (arg0_5.currentWidth - arg0_5.notchAdaptWidth) * 0.5

		arg0_5.notchAdaptLBVector = Vector3(var4_5, 0, 0)
		arg0_5.notchAdaptRTVector = Vector3(arg0_5.currentWidth - var4_5, arg0_5.currentHeight, 0)
	else
		arg0_5.notchAdaptWidth = arg0_5.actualWidth
		arg0_5.notchAdaptHeight = arg0_5.actualHeight
		arg0_5.notchAdaptLBVector = arg0_5.leftBottomVector
		arg0_5.notchAdaptRTVector = arg0_5.rightTopVector
	end

	arg0_5:emit(var0_0.ASPECT_RATIO_UPDATE, arg0_5.targetRatio)
end

function var0_0.GetBattleUIRatio(arg0_6)
	return arg0_6.targetRatio
end

function var0_0.GetCurrentWidth(arg0_7)
	return arg0_7.currentWidth
end

function var0_0.GetCurrentHeight(arg0_8)
	return arg0_8.currentHeight
end

function var0_0.SetForceRatio(arg0_9, arg1_9)
	if not arg1_9 then
		CameraMgr.instance:SetForceRatio(-1)
	else
		CameraMgr.instance:SetForceRatio(arg1_9)
	end
end

function var0_0.BlockCameraRatioControll(arg0_10, arg1_10)
	local var0_10 = CameraMgr.instance

	if arg1_10 then
		local var1_10 = System.Array.CreateInstance(typeof("System.Single"), 2)

		var1_10[0] = 0
		var1_10[1] = 100

		ReflectionHelp.RefSetField(var0_10:GetType(), "AspectRatioRange", var0_10, var1_10)
	else
		local var2_10 = System.Array.CreateInstance(typeof("System.Single"), 2)

		var2_10[0] = 1.33333333333333
		var2_10[1] = 2.33333333333333

		ReflectionHelp.RefSetField(var0_10:GetType(), "AspectRatioRange", var0_10, var2_10)
	end

	arg0_10:Adapt()
end

function var0_0.Clear(arg0_11)
	if arg0_11.adaptCall then
		CameraMgr.instance:RemoveListener(arg0_11.adaptCall)

		arg0_11.adaptCall = nil
	end
end

function var0_0.Dispose(arg0_12)
	arg0_12:Clear()
end
