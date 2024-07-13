local var0_0 = class("ObjectBreakable", import("view.miniGame.gameView.RyzaMiniGame.object.TargetObject"))

function var0_0.FirePassability(arg0_1)
	return 1
end

function var0_0.InitUI(arg0_2, arg1_2)
	arg0_2._tf:Find("Image"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		arg0_2:TryDrop(arg1_2.drop, "Drop")
		arg0_2:Destroy()
	end)
end

function var0_0.InitRegister(arg0_4, arg1_4)
	arg0_4:Register("burn", function()
		arg0_4:Break()
	end, {
		{
			0,
			0
		}
	})
	arg0_4:Register("break", function()
		arg0_4:Break()
	end, {})
end

function var0_0.Break(arg0_7)
	arg0_7:DeregisterAll()
	arg0_7._tf:Find("Image"):GetComponent(typeof(Animator)):Play("Break")
end

return var0_0
