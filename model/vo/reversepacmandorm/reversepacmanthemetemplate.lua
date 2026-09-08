local var0_0 = class("ReversePacmanThemeTemplate", import("model.vo.NewBackYard.BackYardSelfThemeTemplate"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.mapSize = arg3_1
end

function var0_0.GetMapSize(arg0_2)
	return arg0_2.mapSize
end

function var0_0.InitFurnitures(arg0_3, arg1_3)
	arg1_3.skipCheck = true

	return RawData2ThemeConvertor.New():GenFurnitures(arg1_3)
end

return var0_0
