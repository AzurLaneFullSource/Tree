local var0 = class("ObjectTreasureR", import("view.miniGame.gameView.RyzaMiniGame.object.TargetObject"))

function var0.FirePassability(arg0)
	return 2
end

function var0.InitUI(arg0, arg1)
	arg0._tf:Find("Image"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		arg0:TryDrop(arg1.drop, "Drop_Treasure_R")
		arg0:Destroy()
	end)
end

function var0.InitRegister(arg0, arg1)
	arg0:Register("touch", function()
		arg0:DeregisterAll()
		arg0._tf:Find("Image"):GetComponent(typeof(Animator)):Play("Open")
	end, {
		{
			0,
			0
		}
	})
end

return var0
