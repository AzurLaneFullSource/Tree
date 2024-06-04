local var0 = class("ObjectRockB", import("view.miniGame.gameView.RyzaMiniGame.object.ObjectBreakable"))

function var0.FirePassability(arg0)
	return arg0.isWater and 2 or 1
end

function var0.InTimeRiver(arg0)
	return true
end

function var0.InitUI(arg0, arg1)
	local var0 = arg0._tf:Find("Image")

	arg0.comAnimator = arg0._tf:Find("Image"):GetComponent(typeof(Animator))

	local var1 = var0:GetComponent(typeof(DftAniEvent))

	var1:SetTriggerEvent(function()
		arg0.waterTime = arg1.waterTime or 4
	end)
	var1:SetEndEvent(function()
		arg0:Destroy()
	end)

	arg0.waterTime = 0
end

function var0.Break(arg0)
	arg0:DeregisterAll()
	arg0.comAnimator:Play("B2")
end

function var0.TimeUpdate(arg0, arg1)
	if arg0.waterTime > 0 then
		arg0.waterTime = arg0.waterTime - arg1

		if arg0.waterTime <= 0 then
			arg0.comAnimator:Play("B4")
		end
	end
end

return var0
