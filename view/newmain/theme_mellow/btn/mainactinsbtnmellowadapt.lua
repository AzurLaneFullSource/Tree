local var0 = class("MainActInsBtnMellowAdapt", import(".MainDifferentStyleSpActBtnAdapt"))

function var0.GetContainer(arg0)
	return arg0.root:Find("left")
end

function var0.OnInit(arg0)
	local var0 = getProxy(InstagramProxy):ShouldShowTip()

	setActive(arg0._tf:Find("tip"), var0)

	arg0.textTr = arg0._tf:Find("Text"):GetComponent(typeof(Text))
	arg0.systemTimeUtil = arg0.systemTimeUtil or SystemTimeUtil.New()

	arg0:AddTimer()

	local var1 = arg0._tf:GetComponent(typeof(Animation))

	if var0 then
		var1:Play("shake")
	else
		var1:Stop()

		arg0._tf.localEulerAngles = Vector3.zero
	end
end

function var0.AddTimer(arg0)
	arg0.systemTimeUtil:SetUp(function(arg0, arg1, arg2)
		arg0.textTr.text = arg0 .. ":" .. arg1
	end)
end

function var0.RemoveTimer(arg0)
	if arg0.systemTimeUtil then
		arg0.systemTimeUtil:Dispose()

		arg0.systemTimeUtil = nil
	end
end

function var0.OnClear(arg0)
	arg0:RemoveTimer()
end

function var0.OnDisable(arg0)
	arg0:RemoveTimer()
end

return var0
