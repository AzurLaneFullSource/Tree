local var0_0 = class("MonopolyCar2026Scene", import("..MonopolyCar2024.MonopolyCar2024Scene"))

function var0_0.getUIName(arg0_1)
	return "MonopolyCar2026UI"
end

function var0_0.NewGame(arg0_2)
	return MonopolyCar2026Game.New(arg0_2.activity, arg0_2._tf:Find("adapt"), arg0_2.event)
end

return var0_0
