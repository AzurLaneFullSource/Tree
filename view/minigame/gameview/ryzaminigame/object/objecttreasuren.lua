local var0_0 = class("ObjectTreasureN", import("view.miniGame.gameView.RyzaMiniGame.object.ObjectBreakable"))

function var0_0.InitRegister(arg0_1, arg1_1)
	var0_0.super.InitRegister(arg0_1, arg1_1)
	arg0_1:Register("touch", function()
		arg0_1:DeregisterAll()
		arg0_1._tf:Find("Image"):GetComponent(typeof(Animator)):Play("Open")
	end, {
		{
			0,
			0
		}
	})
end

return var0_0
