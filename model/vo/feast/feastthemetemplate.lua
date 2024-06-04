local var0 = class("FeastThemeTemplate", import("model.vo.NewBackYard.BackYardSelfThemeTemplate"))

function var0.Ctor(arg0, arg1, arg2, arg3)
	var0.super.Ctor(arg0, arg1, arg2)

	arg0.mapSize = arg3
end

function var0.GetMapSize(arg0)
	return arg0.mapSize
end

return var0
