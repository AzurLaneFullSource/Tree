local var0_0 = class("MainActInsBtnMellowAdapt", import(".MainDifferentStyleSpActBtnAdapt"))

function var0_0.GetContainer(arg0_1)
	return arg0_1.root:Find("left")
end

function var0_0.OnInit(arg0_2)
	local var0_2 = getProxy(InstagramProxy):ShouldShowTip()

	setActive(arg0_2._tf:Find("tip"), var0_2)

	arg0_2.textTr = arg0_2._tf:Find("Text"):GetComponent(typeof(Text))
	arg0_2.systemTimeUtil = arg0_2.systemTimeUtil or SystemTimeUtil.New()

	arg0_2:AddTimer()

	local var1_2 = arg0_2._tf:GetComponent(typeof(Animation))

	if var0_2 then
		var1_2:Play("shake")
	else
		var1_2:Stop()

		arg0_2._tf.localEulerAngles = Vector3.zero
	end
end

function var0_0.AddTimer(arg0_3)
	arg0_3.systemTimeUtil:SetUp(function(arg0_4, arg1_4, arg2_4)
		arg0_3.textTr.text = arg0_4 .. ":" .. arg1_4
	end)
end

function var0_0.RemoveTimer(arg0_5)
	if arg0_5.systemTimeUtil then
		arg0_5.systemTimeUtil:Dispose()

		arg0_5.systemTimeUtil = nil
	end
end

function var0_0.OnClear(arg0_6)
	arg0_6:RemoveTimer()
end

function var0_0.OnDisable(arg0_7)
	arg0_7:RemoveTimer()
end

return var0_0
