local var0 = class("GuideFindUIPlayer", import(".GuidePlayer"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.topContainer = arg1:Find("top")
	arg0.fingerTF = arg1:Find("top/finger")
	arg0.fingerXyz = arg0.fingerTF:Find("Xyz")
	arg0.fingerAnim = arg0.fingerXyz:GetComponent(typeof(Animator))
end

function var0.OnExecution(arg0, arg1, arg2)
	seriesAsync({
		function(arg0)
			arg0:DuplicateNode(arg1, arg0)
		end
	}, arg2)
end

function var0.DuplicateNode(arg0, arg1, arg2)
	local var0 = arg1:GetEventUI()

	arg0:ClearFingerTimer()
	arg0:SearchUI(var0, function(arg0)
		if not arg0 and var0.notfoundSkip then
			arg2()

			return
		end

		if not arg0 then
			pg.NewGuideMgr.GetInstance():Stop()

			return
		end

		local var0, var1 = arg0.uiDuplicator:Duplicate(arg0, var0.settings), arg0

		if var0.childIndex then
			var1 = var1:GetChild(var0.childIndex)
			var0 = var0:GetChild(var0.childIndex)
		elseif var0.eventPath then
			var1 = GameObject.Find(var0.eventPath) or arg0
		end

		arg0.fingerTimer = Timer.New(function()
			arg0:UpdateFinger(var0, var0)
		end, 0.05, -1)

		arg0.fingerTimer:Start()
		arg0.fingerTimer:func()

		local var2 = var0.triggerData

		arg0.eventTrigger = GuideEventTrigger.New(var2.type, var0, var1, var2.arg, arg2)
	end)
end

function var0.NextOne(arg0)
	if arg0.eventTrigger then
		arg0.eventTrigger:Trigger()
	end
end

function var0.UpdateFinger(arg0, arg1, arg2)
	local var0 = arg1.pivot - Vector2(0.5, 0.5)
	local var1 = Vector2(arg1.sizeDelta.x * var0.x, arg1.sizeDelta.y * var0.y)

	SetActive(arg0.fingerTF, not arg2.fingerPos or not arg2.fingerPos.hideFinger)

	local var2 = Vector2(arg1.sizeDelta.x / 2, -arg1.sizeDelta.y / 2) - var1
	local var3 = arg2.scale and 1 / arg2.scale or 1

	arg0.fingerTF.localScale = Vector3(var3, var3, 1)

	local var4 = arg2.fingerPos and Vector3(arg2.fingerPos.posX, arg2.fingerPos.posY, 0) or Vector3(var2.x, var2.y, 0)
	local var5 = Vector3(0, 0, 0)

	if arg2.fingerPos then
		var5 = Vector3(arg2.fingerPos.rotateX or 0, arg2.fingerPos.rotateY or 0, arg2.fingerPos.rotateZ or 0)
	end

	local var6 = arg1.localPosition + var4
	local var7 = arg1.parent:TransformPoint(var6)
	local var8 = arg0.topContainer:InverseTransformPoint(var7)

	arg0.fingerTF.localPosition = var8
	arg0.fingerTF.localEulerAngles = var5

	if arg2.slipAnim and not LeanTween.isTweening(arg0.fingerXyz.gameObject) then
		arg0.fingerAnim.enabled = false

		LeanTween.value(arg0.fingerXyz.gameObject, 0, -200, 1):setOnUpdate(System.Action_float(function(arg0)
			arg0.fingerXyz.localPosition = Vector3(arg0, 0, 0)
		end)):setRepeat(-1)
	elseif not arg2.slipAnim and LeanTween.isTweening(arg0.fingerXyz.gameObject) then
		LeanTween.cancel(arg0.fingerXyz.gameObject)
	else
		arg0.fingerXyz.localPosition = Vector3.zero
	end
end

function var0.ClearFingerTimer(arg0)
	if arg0.fingerTimer then
		arg0.fingerTimer:Stop()

		arg0.fingerTimer = nil
	end
end

function var0.OnClear(arg0)
	if arg0.eventTrigger then
		arg0.eventTrigger:Clear()

		arg0.eventTrigger = nil
	end

	setActive(arg0.fingerTF, false)

	arg0.fingerTF.localScale = Vector3(1, 1, 1)

	arg0:ClearFingerTimer()
	LeanTween.cancel(arg0.fingerXyz.gameObject)

	arg0.fingerXyz.localPosition = Vector3.zero
	arg0.fingerAnim.enabled = true
end

return var0
