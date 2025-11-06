local var0_0 = class("IslandTargetTracker")
local var1_0 = {
	200,
	200
}
local var2_0 = 25

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._tf = arg1_1
	arg0_1.distanceTr = arg0_1._tf

	setActive(arg0_1.distanceTr, true)

	arg0_1.cg = GetOrAddComponent(arg0_1.distanceTr, typeof(CanvasGroup))
	arg0_1.cg.alpha = 0
	arg0_1.arrTr = findTF(arg0_1.distanceTr, "arr")
	arg0_1.distanceTxt = arg0_1.distanceTr:Find("Text"):GetComponent(typeof(Text))
	arg0_1.screenSize = Vector2(Screen.width, Screen.height)
	arg0_1.screenCenter = Vector2(arg0_1.screenSize.x * 0.5, arg0_1.screenSize.y * 0.5)
	arg0_1.radiusOfEllipse = Vector2(var1_0[1], var1_0[2])
	arg0_1.lines = {}
	arg0_1.targetPosition = Vector3.zero
	arg0_1.lerpSpeed = 25
	arg0_1.showHudDic = {}
end

function var0_0.Tracking(arg0_2, arg1_2, arg2_2, arg3_2)
	arg0_2:SetUp(arg1_2, arg2_2, arg3_2)
end

function var0_0.UnTracking(arg0_3)
	arg0_3:Clear()
end

function var0_0.Update(arg0_4, arg1_4)
	if arg0_4.cg.alpha == 0 then
		return
	end

	if arg1_4 then
		arg0_4:AdjustTargetPosition(arg1_4)
	end

	arg0_4.distanceTr.localPosition = Vector3.Lerp(arg0_4.distanceTr.localPosition, arg0_4.targetPosition, Time.deltaTime * arg0_4.lerpSpeed)
end

function var0_0.GetShowTargetPosition(arg0_5)
	return arg0_5.cg.alpha ~= 0 and arg0_5.targetPosition or nil
end

function var0_0.AdjustTargetPosition(arg0_6, arg1_6)
	local var0_6 = math.rad2Deg * math.atan2(arg1_6.x - 1, arg1_6.y)
	local var1_6 = math.rad2Deg * math.atan2(arg0_6.targetPosition.x - 1, arg0_6.targetPosition.y)

	if math.abs(var1_6 - var0_6) < var2_0 then
		local var2_6, var3_6 = arg0_6:RotatePoint(arg1_6.x, arg1_6.y, var2_0)

		arg0_6.targetPosition = Vector3(var2_6, var3_6, 0)
	end
end

function var0_0.RotatePoint(arg0_7, arg1_7, arg2_7, arg3_7)
	local var0_7 = math.deg2Rad * arg3_7

	return arg1_7 * math.cos(var0_7) - arg2_7 * math.sin(var0_7), arg1_7 * math.sin(var0_7) + arg2_7 * math.cos(var0_7)
end

function var0_0.Disable(arg0_8)
	arg0_8.isDisable = true
	arg0_8.cg.alpha = 0
end

function var0_0.Enable(arg0_9)
	arg0_9.isDisable = false
end

function var0_0.OnShowHud(arg0_10, arg1_10)
	arg0_10.showHudDic[arg1_10] = true
end

function var0_0.OnHideHud(arg0_11, arg1_11)
	arg0_11.showHudDic[arg1_11] = nil
end

function var0_0.SetUp(arg0_12, arg1_12, arg2_12, arg3_12)
	arg0_12:ShutDown()

	arg0_12.trackId = arg3_12
	arg0_12.timer = FrameTimer.New(function()
		if IsNil(arg2_12) then
			arg0_12.cg.alpha = 0

			return
		end

		local var0_13 = arg2_12.transform.position
		local var1_13 = IslandCalcUtil.IsInViewport(var0_13)
		local var2_13 = not arg0_12.isDisable and (not var1_13 or not arg0_12.showHudDic[arg0_12.trackId])

		arg0_12.cg.alpha = var2_13 and 1 or 0

		if not var2_13 then
			return
		end

		local var3_13 = Vector3.Distance(var0_13, arg1_12.transform.position)

		arg0_12.distanceTxt.text = math.ceil(var3_13) .. "M"

		local var4_13, var5_13 = arg0_12:CalcPosition(arg2_12.transform)

		arg0_12.targetPosition = Vector3(var4_13.x, var4_13.y, 0)
		arg0_12.arrTr.localEulerAngles = Vector3(0, 0, var5_13)
	end, 1, -1)

	arg0_12.timer:Start()
end

function var0_0.CalcPosition(arg0_14, arg1_14)
	local var0_14 = IslandCameraMgr.instance._mainCamera
	local var1_14 = var0_14:WorldToScreenPoint(arg1_14.transform.position)
	local var2_14 = var0_14.gameObject.transform.forward
	local var3_14 = (arg1_14.transform.position - var0_14.gameObject.transform.position).normalized

	if Vector3.Dot(var2_14, var3_14) <= 0 then
		local var4_14 = arg0_14.screenSize.x - var1_14.x
		local var5_14 = arg0_14.screenSize.y - var1_14.y

		var1_14 = Vector3(var4_14, var5_14, 0)
	end

	local var6_14 = Vector2(var1_14.x, var1_14.y) - arg0_14.screenCenter

	if math.pow(var6_14.x / arg0_14.radiusOfEllipse.x, 2) + math.pow(var6_14.y / arg0_14.radiusOfEllipse.y, 2) > 1 then
		local var7_14 = var6_14.y / (var6_14.x + 1e-07)
		local var8_14 = Mathf.Pow(arg0_14.radiusOfEllipse.x * arg0_14.radiusOfEllipse.y, 2)
		local var9_14 = Mathf.Pow(arg0_14.radiusOfEllipse.y, 2) + Mathf.Pow(var7_14, 2) * Mathf.Pow(arg0_14.radiusOfEllipse.x, 2)
		local var10_14 = math.sqrt(var8_14 / var9_14)

		if math.sign(var10_14) ~= math.sign(var6_14.x) then
			var10_14 = -1 * var10_14
		end

		local var11_14 = var10_14 * var7_14

		return Vector2(var10_14, var11_14), IslandCalcUtil.SignedAngle(Vector2.up, Vector2(var6_14.x, var6_14.y))
	else
		return var6_14, IslandCalcUtil.SignedAngle(Vector2.up, Vector2(var6_14.x, var6_14.y))
	end
end

function var0_0.ClearLine(arg0_15)
	for iter0_15, iter1_15 in pairs(arg0_15.lines) do
		Object.Destroy(iter1_15.gameObject)
	end

	arg0_15.lines = {}
end

function var0_0.ShutDown(arg0_16)
	if arg0_16.timer then
		arg0_16.timer:Stop()

		arg0_16.timer = nil
	end

	arg0_16.cg.alpha = 0
	arg0_16.trackId = nil

	arg0_16:ClearLine()
end

function var0_0.Clear(arg0_17)
	arg0_17:ShutDown()
end

function var0_0.Dispose(arg0_18)
	arg0_18.showHudDic = nil

	arg0_18:Clear()
end

return var0_0
