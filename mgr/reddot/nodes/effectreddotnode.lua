local var0 = class("EffectRedDotNode", import(".RedDotNode"))

function var0.SetData(arg0, arg1)
	if IsNil(arg0.gameObject) or not isActive(arg0.gameObject) then
		return
	end

	local var0

	if arg0.gameObject.childCount > 0 then
		var0 = arg0.gameObject:GetChild(0)
	end

	if var0 then
		setActive(var0, arg1)
	end

	local var1 = arg0.gameObject:Find("tip")

	if var1 then
		setActive(var1, arg1)

		if arg1 then
			arg0:StartAnimation(var1)
		end
	end
end

function var0.StartAnimation(arg0, arg1)
	arg0:RemoveTimer()

	local var0 = arg1:GetComponent(typeof(Animator))

	var0.enabled = true
	arg0.timer = Timer.New(function()
		if not var0 then
			return
		end

		var0.enabled = false
		var0.gameObject.transform.localEulerAngles = Vector3.zero
	end, 5, 1)

	arg0.timer:Start()
end

function var0.RemoveTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.Remove(arg0)
	arg0:RemoveTimer()
end

function var0.Puase(arg0)
	arg0:RemoveTimer()
end

return var0
