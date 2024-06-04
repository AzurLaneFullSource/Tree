local var0 = class("ObjectTreasureN", import("view.miniGame.gameView.RyzaMiniGame.object.ObjectBreakable"))

function var0.InitRegister(arg0, arg1)
	var0.super.InitRegister(arg0, arg1)
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
