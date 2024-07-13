local var0_0 = class("MainTopPanel", import("...base.MainBasePanel"))

function var0_0.GetBtns(arg0_1)
	return {
		MainPlayerInfoBtn.New(arg0_1._tf, arg0_1.event)
	}
end

function var0_0.GetDirection(arg0_2)
	return Vector2(0, 1)
end

return var0_0
