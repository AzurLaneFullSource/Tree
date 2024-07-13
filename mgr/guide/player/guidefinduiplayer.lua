local var0_0 = class("GuideFindUIPlayer", import(".GuidePlayer"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.topContainer = arg1_1:Find("top")
	arg0_1.fingerTF = arg1_1:Find("top/finger")
	arg0_1.fingerXyz = arg0_1.fingerTF:Find("Xyz")
	arg0_1.fingerAnim = arg0_1.fingerXyz:GetComponent(typeof(Animator))
end

function var0_0.OnExecution(arg0_2, arg1_2, arg2_2)
	seriesAsync({
		function(arg0_3)
			arg0_2:DuplicateNode(arg1_2, arg0_3)
		end
	}, arg2_2)
end

function var0_0.DuplicateNode(arg0_4, arg1_4, arg2_4)
	local var0_4 = arg1_4:GetEventUI()

	arg0_4:ClearFingerTimer()
	arg0_4:SearchUI(var0_4, function(arg0_5)
		if not arg0_5 and var0_4.notfoundSkip then
			arg2_4()

			return
		end

		if not arg0_5 then
			pg.NewGuideMgr.GetInstance():Stop()

			return
		end

		local var0_5, var1_5 = arg0_4.uiDuplicator:Duplicate(arg0_5, var0_4.settings), arg0_5

		if var0_4.childIndex then
			var1_5 = var1_5:GetChild(var0_4.childIndex)
			var0_5 = var0_5:GetChild(var0_4.childIndex)
		elseif var0_4.eventPath then
			var1_5 = GameObject.Find(var0_4.eventPath) or arg0_5
		end

		arg0_4.fingerTimer = Timer.New(function()
			arg0_4:UpdateFinger(var0_5, var0_4)
		end, 0.05, -1)

		arg0_4.fingerTimer:Start()
		arg0_4.fingerTimer:func()

		local var2_5 = var0_4.triggerData

		arg0_4.eventTrigger = GuideEventTrigger.New(var2_5.type, var0_5, var1_5, var2_5.arg, arg2_4)
	end)
end

function var0_0.NextOne(arg0_7)
	if arg0_7.eventTrigger then
		arg0_7.eventTrigger:Trigger()
	end
end

function var0_0.UpdateFinger(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg1_8.pivot - Vector2(0.5, 0.5)
	local var1_8 = Vector2(arg1_8.sizeDelta.x * var0_8.x, arg1_8.sizeDelta.y * var0_8.y)

	SetActive(arg0_8.fingerTF, not arg2_8.fingerPos or not arg2_8.fingerPos.hideFinger)

	local var2_8 = Vector2(arg1_8.sizeDelta.x / 2, -arg1_8.sizeDelta.y / 2) - var1_8
	local var3_8 = arg2_8.scale and 1 / arg2_8.scale or 1

	arg0_8.fingerTF.localScale = Vector3(var3_8, var3_8, 1)

	local var4_8 = arg2_8.fingerPos and Vector3(arg2_8.fingerPos.posX, arg2_8.fingerPos.posY, 0) or Vector3(var2_8.x, var2_8.y, 0)
	local var5_8 = Vector3(0, 0, 0)

	if arg2_8.fingerPos then
		var5_8 = Vector3(arg2_8.fingerPos.rotateX or 0, arg2_8.fingerPos.rotateY or 0, arg2_8.fingerPos.rotateZ or 0)
	end

	local var6_8 = arg1_8.localPosition + var4_8
	local var7_8 = arg1_8.parent:TransformPoint(var6_8)
	local var8_8 = arg0_8.topContainer:InverseTransformPoint(var7_8)

	arg0_8.fingerTF.localPosition = var8_8
	arg0_8.fingerTF.localEulerAngles = var5_8

	if arg2_8.slipAnim and not LeanTween.isTweening(arg0_8.fingerXyz.gameObject) then
		arg0_8.fingerAnim.enabled = false

		LeanTween.value(arg0_8.fingerXyz.gameObject, 0, -200, 1):setOnUpdate(System.Action_float(function(arg0_9)
			arg0_8.fingerXyz.localPosition = Vector3(arg0_9, 0, 0)
		end)):setRepeat(-1)
	elseif not arg2_8.slipAnim and LeanTween.isTweening(arg0_8.fingerXyz.gameObject) then
		LeanTween.cancel(arg0_8.fingerXyz.gameObject)
	else
		arg0_8.fingerXyz.localPosition = Vector3.zero
	end
end

function var0_0.ClearFingerTimer(arg0_10)
	if arg0_10.fingerTimer then
		arg0_10.fingerTimer:Stop()

		arg0_10.fingerTimer = nil
	end
end

function var0_0.OnClear(arg0_11)
	if arg0_11.eventTrigger then
		arg0_11.eventTrigger:Clear()

		arg0_11.eventTrigger = nil
	end

	setActive(arg0_11.fingerTF, false)

	arg0_11.fingerTF.localScale = Vector3(1, 1, 1)

	arg0_11:ClearFingerTimer()
	LeanTween.cancel(arg0_11.fingerXyz.gameObject)

	arg0_11.fingerXyz.localPosition = Vector3.zero
	arg0_11.fingerAnim.enabled = true
end

return var0_0
