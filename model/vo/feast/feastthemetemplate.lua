local var0_0 = class("FeastThemeTemplate", import("model.vo.NewBackYard.BackYardSelfThemeTemplate"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.mapSize = arg3_1
end

function var0_0.GetMapSize(arg0_2)
	return arg0_2.mapSize
end

return var0_0
