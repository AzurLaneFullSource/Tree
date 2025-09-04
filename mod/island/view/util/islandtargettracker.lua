local var0_0 = class("IslandTargetTracker")
local var1_0 = {
	200,
	180
}

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._tf = arg1_1
	arg0_1.distanceTr = findTF(arg0_1._tf, "distance")

	setActive(arg0_1.distanceTr, true)

	arg0_1.cg = GetOrAddComponent(arg0_1.distanceTr, typeof(CanvasGroup))
	arg0_1.cg.alpha = 0
	arg0_1.arrTr = findTF(arg0_1.distanceTr, "arr")
	arg0_1.distanceTxt = arg0_1.distanceTr:Find("Text"):GetComponent(typeof(Text))
	arg0_1.screenSize = Vector2(Screen.width, Screen.height)
	arg0_1.screenCenter = Vector2(arg0_1.screenSize.x * 0.5, arg0_1.screenSize.y * 0.5)
	arg0_1.radiusOfEllipse = Vector2(var1_0[1], var1_0[2])
	arg0_1.lines = {}
	arg0_1.targetosition = Vector3.zero
	arg0_1.lerpSpeed = 25
	arg0_1.showHudDic = {}
end

function var0_0.Tracking(arg0_2, arg1_2, arg2_2, arg3_2)
	arg0_2:SetUp(arg1_2, arg2_2, arg3_2)
end

function var0_0.UnTracking(arg0_3)
	arg0_3:Clear()
end

function var0_0.Update(arg0_4)
	if arg0_4.cg.alpha == 0 then
		return
	end

	arg0_4.distanceTr.localPosition = Vector3.Lerp(arg0_4.distanceTr.localPosition, arg0_4.targetosition, Time.deltaTime * arg0_4.lerpSpeed)
end

function var0_0.Disable(arg0_5)
	arg0_5.isDisable = true
	arg0_5.cg.alpha = 0
end

function var0_0.Enable(arg0_6)
	arg0_6.isDisable = false
end

function var0_0.OnShowHud(arg0_7, arg1_7)
	arg0_7.showHudDic[arg1_7] = true
end

function var0_0.OnHideHud(arg0_8, arg1_8)
	arg0_8.showHudDic[arg1_8] = nil
end

function var0_0.SetUp(arg0_9, arg1_9, arg2_9, arg3_9)
	arg0_9:ShutDown()

	arg0_9.trackId = arg3_9
	arg0_9.timer = Timer.New(function()
		if IsNil(arg2_9) then
			arg0_9.cg.alpha = 0

			return
		end

		local var0_10 = arg2_9.transform.position
		local var1_10 = IslandCalcUtil.IsInViewport(var0_10)
		local var2_10 = not arg0_9.isDisable and (not var1_10 or not arg0_9.showHudDic[arg0_9.trackId])

		arg0_9.cg.alpha = var2_10 and 1 or 0

		if not var2_10 then
			return
		end

		local var3_10 = Vector3.Distance(var0_10, arg1_9.transform.position)

		arg0_9.distanceTxt.text = math.ceil(var3_10) .. "M"

		local var4_10, var5_10 = arg0_9:CalcPosition(arg2_9.transform)

		arg0_9.targetosition = Vector3(var4_10.x, var4_10.y, 0)
		arg0_9.arrTr.localEulerAngles = Vector3(0, 0, var5_10)
	end, Time.deltaTime, -1)

	arg0_9.timer:Start()
end

function var0_0.CalcPosition(arg0_11, arg1_11)
	local var0_11 = IslandCameraMgr.instance._mainCamera
	local var1_11 = var0_11:WorldToScreenPoint(arg1_11.transform.position)
	local var2_11 = var0_11.gameObject.transform.forward
	local var3_11 = (arg1_11.transform.position - var0_11.gameObject.transform.position).normalized

	if Vector3.Dot(var2_11, var3_11) <= 0 then
		local var4_11 = arg0_11.screenSize.x - var1_11.x
		local var5_11 = arg0_11.screenSize.y - var1_11.y

		var1_11 = Vector3(var4_11, var5_11, 0)
	end

	local var6_11 = Vector2(var1_11.x, var1_11.y) - arg0_11.screenCenter

	if math.pow(var6_11.x / arg0_11.radiusOfEllipse.x, 2) + math.pow(var6_11.y / arg0_11.radiusOfEllipse.y, 2) > 1 then
		local var7_11 = var6_11.y / (var6_11.x + 1e-07)
		local var8_11 = Mathf.Pow(arg0_11.radiusOfEllipse.x * arg0_11.radiusOfEllipse.y, 2)
		local var9_11 = Mathf.Pow(arg0_11.radiusOfEllipse.y, 2) + Mathf.Pow(var7_11, 2) * Mathf.Pow(arg0_11.radiusOfEllipse.x, 2)
		local var10_11 = math.sqrt(var8_11 / var9_11)

		if math.sign(var10_11) ~= math.sign(var6_11.x) then
			var10_11 = -1 * var10_11
		end

		local var11_11 = var10_11 * var7_11

		return Vector2(var10_11, var11_11), IslandCalcUtil.SignedAngle(Vector2.up, Vector2(var6_11.x, var6_11.y))
	else
		return var6_11, IslandCalcUtil.SignedAngle(Vector2.up, Vector2(var6_11.x, var6_11.y))
	end
end

function var0_0.DrawLine(arg0_12, arg1_12, arg2_12)
	local var0_12 = IslandCalcUtil.GetNavPath(arg1_12, arg2_12)

	local function var1_12(arg0_13, arg1_13)
		local var0_13 = 1
		local var1_13 = var0_12[arg1_13 + 1] or arg2_12
		local var2_13 = var0_12[arg1_13]
		local var3_13 = (var1_13 - var2_13).normalized
		local var4_13 = Quaternion.FromToRotation(arg0_13.transform.right * -1, var3_13)
		local var5_13 = Vector3.Distance(var1_13, var2_13)

		return var4_13, var5_13
	end

	for iter0_12, iter1_12 in ipairs(var0_12) do
		local var2_12 = Object.Instantiate(arg0_12.lineTpl)
		local var3_12, var4_12 = var1_12(var2_12, iter0_12)

		var2_12.transform.rotation = var2_12.transform.rotation * var3_12
		var2_12.transform.localScale = Vector3(var4_12, 1, 1)

		local var5_12 = var2_12.transform.right * -1 * (var4_12 * 0.5)

		var2_12.transform.position = iter1_12 + var5_12

		table.insert(arg0_12.lines, var2_12)
	end
end

function var0_0.ClearLine(arg0_14)
	for iter0_14, iter1_14 in pairs(arg0_14.lines) do
		Object.Destroy(iter1_14.gameObject)
	end

	arg0_14.lines = {}
end

function var0_0.ShutDown(arg0_15)
	if arg0_15.timer then
		arg0_15.timer:Stop()

		arg0_15.timer = nil
	end

	arg0_15.cg.alpha = 0
	arg0_15.trackId = nil

	arg0_15:ClearLine()
end

function var0_0.Clear(arg0_16)
	arg0_16:ShutDown()
end

function var0_0.Dispose(arg0_17)
	arg0_17.showHudDic = nil

	arg0_17:Clear()
end

return var0_0
