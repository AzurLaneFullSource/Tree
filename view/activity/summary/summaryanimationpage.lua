local var0_0 = class("SummaryAnimationPage", import(".SummaryPage"))

function var0_0.OnInit(arg0_1)
	assert(false, "must be overwrite")
end

function var0_0.Show(arg0_2, arg1_2, arg2_2)
	arg2_2 = arg2_2 or arg0_2._tf

	setActive(arg0_2._tf, true)

	arg0_2.inAniming = true

	arg2_2:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_3)
		arg0_2.inAniming = nil

		if arg1_2 then
			arg1_2()
		end
	end)
end

function var0_0.inAnim(arg0_4)
	return arg0_4.inAniming
end

return var0_0
