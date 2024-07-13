local var0_0 = class("EffectImpack", import("view.miniGame.gameView.RyzaMiniGame.effect.TargetEffect"))

function var0_0.InitUI(arg0_1, arg1_1)
	arg0_1._tf:Find("Lockon"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		setActive(arg0_1._tf:Find("Lockon"), false)
		setActive(arg0_1._tf:Find("impack"), true)
	end)

	local var0_1 = arg0_1._tf:Find("impack"):GetComponent(typeof(DftAniEvent))

	var0_1:GetComponent(typeof(DftAniEvent)):SetTriggerEvent(function()
		if arg0_1.responder:CollideRyza(arg0_1) then
			arg0_1:Calling("hit", {
				1,
				arg0_1.realPos
			}, MoveRyza)
		end
	end)
	var0_1:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		arg0_1:Destroy()
	end)
end

return var0_0
