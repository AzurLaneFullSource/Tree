local var0_0 = class("ObjectTreasureR", import("view.miniGame.gameView.RyzaMiniGame.object.TargetObject"))

function var0_0.FirePassability(arg0_1)
	return 2
end

function var0_0.InitUI(arg0_2, arg1_2)
	arg0_2._tf:Find("Image"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		arg0_2:TryDrop(arg1_2.drop, "Drop_Treasure_R")
		arg0_2:Destroy()
	end)
end

function var0_0.InitRegister(arg0_4, arg1_4)
	arg0_4:Register("touch", function()
		arg0_4:DeregisterAll()
		arg0_4._tf:Find("Image"):GetComponent(typeof(Animator)):Play("Open")
	end, {
		{
			0,
			0
		}
	})
end

return var0_0
