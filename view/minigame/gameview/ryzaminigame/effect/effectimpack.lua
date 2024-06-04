local var0 = class("EffectImpack", import("view.miniGame.gameView.RyzaMiniGame.effect.TargetEffect"))

function var0.InitUI(arg0, arg1)
	arg0._tf:Find("Lockon"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		setActive(arg0._tf:Find("Lockon"), false)
		setActive(arg0._tf:Find("impack"), true)
	end)

	local var0 = arg0._tf:Find("impack"):GetComponent(typeof(DftAniEvent))

	var0:GetComponent(typeof(DftAniEvent)):SetTriggerEvent(function()
		if arg0.responder:CollideRyza(arg0) then
			arg0:Calling("hit", {
				1,
				arg0.realPos
			}, MoveRyza)
		end
	end)
	var0:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		arg0:Destroy()
	end)
end

return var0
