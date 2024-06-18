local var0_0 = class("ObjectRockB", import("view.miniGame.gameView.RyzaMiniGame.object.ObjectBreakable"))

function var0_0.FirePassability(arg0_1)
	return arg0_1.isWater and 2 or 1
end

function var0_0.InTimeRiver(arg0_2)
	return true
end

function var0_0.InitUI(arg0_3, arg1_3)
	local var0_3 = arg0_3._tf:Find("Image")

	arg0_3.comAnimator = arg0_3._tf:Find("Image"):GetComponent(typeof(Animator))

	local var1_3 = var0_3:GetComponent(typeof(DftAniEvent))

	var1_3:SetTriggerEvent(function()
		arg0_3.waterTime = arg1_3.waterTime or 4
	end)
	var1_3:SetEndEvent(function()
		arg0_3:Destroy()
	end)

	arg0_3.waterTime = 0
end

function var0_0.Break(arg0_6)
	arg0_6:DeregisterAll()
	arg0_6.comAnimator:Play("B2")
end

function var0_0.TimeUpdate(arg0_7, arg1_7)
	if arg0_7.waterTime > 0 then
		arg0_7.waterTime = arg0_7.waterTime - arg1_7

		if arg0_7.waterTime <= 0 then
			arg0_7.comAnimator:Play("B4")
		end
	end
end

return var0_0
