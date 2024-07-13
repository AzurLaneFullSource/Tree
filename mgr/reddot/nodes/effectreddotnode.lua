local var0_0 = class("EffectRedDotNode", import(".RedDotNode"))

function var0_0.SetData(arg0_1, arg1_1)
	if IsNil(arg0_1.gameObject) or not isActive(arg0_1.gameObject) then
		return
	end

	local var0_1

	if arg0_1.gameObject.childCount > 0 then
		var0_1 = arg0_1.gameObject:GetChild(0)
	end

	if var0_1 then
		setActive(var0_1, arg1_1)
	end

	local var1_1 = arg0_1.gameObject:Find("tip")

	if var1_1 then
		setActive(var1_1, arg1_1)

		if arg1_1 then
			arg0_1:StartAnimation(var1_1)
		end
	end
end

function var0_0.StartAnimation(arg0_2, arg1_2)
	arg0_2:RemoveTimer()

	local var0_2 = arg1_2:GetComponent(typeof(Animator))

	var0_2.enabled = true
	arg0_2.timer = Timer.New(function()
		if not var0_2 then
			return
		end

		var0_2.enabled = false
		var0_2.gameObject.transform.localEulerAngles = Vector3.zero
	end, 5, 1)

	arg0_2.timer:Start()
end

function var0_0.RemoveTimer(arg0_4)
	if arg0_4.timer then
		arg0_4.timer:Stop()

		arg0_4.timer = nil
	end
end

function var0_0.Remove(arg0_5)
	arg0_5:RemoveTimer()
end

function var0_0.Puase(arg0_6)
	arg0_6:RemoveTimer()
end

return var0_0
