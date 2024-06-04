local var0 = class("ObjectBreakable", import("view.miniGame.gameView.RyzaMiniGame.object.TargetObject"))

function var0.FirePassability(arg0)
	return 1
end

function var0.InitUI(arg0, arg1)
	arg0._tf:Find("Image"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		arg0:TryDrop(arg1.drop, "Drop")
		arg0:Destroy()
	end)
end

function var0.InitRegister(arg0, arg1)
	arg0:Register("burn", function()
		arg0:Break()
	end, {
		{
			0,
			0
		}
	})
	arg0:Register("break", function()
		arg0:Break()
	end, {})
end

function var0.Break(arg0)
	arg0:DeregisterAll()
	arg0._tf:Find("Image"):GetComponent(typeof(Animator)):Play("Break")
end

return var0
