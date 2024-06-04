local var0 = class("SummaryAnimationPage", import(".SummaryPage"))

function var0.OnInit(arg0)
	assert(false, "must be overwrite")
end

function var0.Show(arg0, arg1, arg2)
	arg2 = arg2 or arg0._tf

	setActive(arg0._tf, true)

	arg0.inAniming = true

	arg2:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0)
		arg0.inAniming = nil

		if arg1 then
			arg1()
		end
	end)
end

function var0.inAnim(arg0)
	return arg0.inAniming
end

return var0
