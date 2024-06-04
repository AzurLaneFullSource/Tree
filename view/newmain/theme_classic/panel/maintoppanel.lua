local var0 = class("MainTopPanel", import("...base.MainBasePanel"))

function var0.GetBtns(arg0)
	return {
		MainPlayerInfoBtn.New(arg0._tf, arg0.event)
	}
end

function var0.GetDirection(arg0)
	return Vector2(0, 1)
end

return var0
