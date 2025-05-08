local var0_0 = class("IslandTargetTracker")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._tf = arg1_1
	arg0_1.distanceTr = findTF(arg0_1._tf, "distance")
	arg0_1.arrTr = findTF(arg0_1.distanceTr, "arr")
	arg0_1.distanceTxt = arg0_1.distanceTr:Find("Text"):GetComponent(typeof(Text))

	setActive(arg0_1.distanceTr, false)

	arg0_1.screenSize = Vector2(Screen.width, Screen.height)
	arg0_1.screenCenter = Vector2(arg0_1.screenSize.x * 0.5, arg0_1.screenSize.y * 0.5)
	arg0_1.radiusOfEllipse = Vector2(200, 180)
	arg0_1.lines = {}
end

function var0_0.Tracking(arg0_2, arg1_2, arg2_2)
	arg0_2:SetUp(arg1_2, arg2_2)
end

function var0_0.UnTracking(arg0_3)
	arg0_3:Clear()
end

function var0_0.SetUp(arg0_4, arg1_4, arg2_4)
	arg0_4:ShutDown()
	setActive(arg0_4.distanceTr, true)

	arg0_4.timer = Timer.New(function()
		local var0_5 = Vector3.Distance(arg2_4.transform.position, arg1_4.transform.position)

		setActive(arg0_4.distanceTr, true)

		arg0_4.distanceTxt.text = math.ceil(var0_5) .. "M"

		local var1_5 = arg0_4:CalcPostion(arg2_4.transform)

		arg0_4.distanceTr.localPosition = var1_5

		local var2_5 = IslandCalcUtil.SignedAngle(Vector2.up, Vector2(var1_5.x, var1_5.y))

		arg0_4.distanceTr.localEulerAngles = Vector3(0, 0, var2_5)
	end, Time.deltaTime, -1)

	arg0_4.timer:Start()
end

function var0_0.CalcPostion(arg0_6, arg1_6)
	local var0_6 = IslandCameraMgr.instance._mainCamera
	local var1_6 = var0_6:WorldToScreenPoint(arg1_6.transform.position)
	local var2_6 = var0_6.gameObject.transform.forward
	local var3_6 = (arg1_6.transform.position - var0_6.gameObject.transform.position).normalized

	if Vector3.Dot(var2_6, var3_6) <= 0 then
		local var4_6 = arg0_6.screenSize.x - var1_6.x
		local var5_6 = arg0_6.screenSize.y - var1_6.y

		var1_6 = Vector3(var4_6, var5_6, 0)
		inSceneOut = true
	end

	local var6_6 = Vector2(var1_6.x, var1_6.y) - arg0_6.screenCenter

	if math.pow(var6_6.x / arg0_6.radiusOfEllipse.x, 2) + math.pow(var6_6.y / arg0_6.radiusOfEllipse.y, 2) > 1 then
		local var7_6 = var6_6.y / (var6_6.x + 1e-07)
		local var8_6 = Mathf.Pow(arg0_6.radiusOfEllipse.x * arg0_6.radiusOfEllipse.y, 2)
		local var9_6 = Mathf.Pow(arg0_6.radiusOfEllipse.y, 2) + Mathf.Pow(var7_6, 2) * Mathf.Pow(arg0_6.radiusOfEllipse.x, 2)
		local var10_6 = math.sqrt(var8_6 / var9_6)

		if math.sign(var10_6) ~= math.sign(var6_6.x) then
			var10_6 = -1 * var10_6
		end

		local var11_6 = var10_6 * var7_6

		return Vector2(var10_6, var11_6)
	else
		return var6_6
	end
end

function var0_0.DrawLine(arg0_7, arg1_7, arg2_7)
	local var0_7 = IslandCalcUtil.GetNavPath(arg1_7, arg2_7)

	local function var1_7(arg0_8, arg1_8)
		local var0_8 = 1
		local var1_8 = var0_7[arg1_8 + 1] or arg2_7
		local var2_8 = var0_7[arg1_8]
		local var3_8 = (var1_8 - var2_8).normalized
		local var4_8 = Quaternion.FromToRotation(arg0_8.transform.right * -1, var3_8)
		local var5_8 = Vector3.Distance(var1_8, var2_8)

		return var4_8, var5_8
	end

	for iter0_7, iter1_7 in ipairs(var0_7) do
		local var2_7 = Object.Instantiate(arg0_7.lineTpl)
		local var3_7, var4_7 = var1_7(var2_7, iter0_7)

		var2_7.transform.rotation = var2_7.transform.rotation * var3_7
		var2_7.transform.localScale = Vector3(var4_7, 1, 1)

		local var5_7 = var2_7.transform.right * -1 * (var4_7 * 0.5)

		var2_7.transform.position = iter1_7 + var5_7

		table.insert(arg0_7.lines, var2_7)
	end
end

function var0_0.ClearLine(arg0_9)
	for iter0_9, iter1_9 in pairs(arg0_9.lines) do
		Object.Destroy(iter1_9.gameObject)
	end

	arg0_9.lines = {}
end

function var0_0.ShutDown(arg0_10)
	if arg0_10.timer then
		arg0_10.timer:Stop()

		arg0_10.timer = nil
	end

	setActive(arg0_10.distanceTr, false)
	arg0_10:ClearLine()
end

function var0_0.Clear(arg0_11)
	arg0_11:ShutDown()
end

function var0_0.Dispose(arg0_12)
	arg0_12:Clear()
end

return var0_0
