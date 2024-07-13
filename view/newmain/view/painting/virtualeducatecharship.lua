local var0_0 = class("VirtualEducateCharShip", import("model.vo.Ship"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.educateCharId = arg1_1

	var0_0.super.Ctor(arg0_1, {
		id = 99999999,
		configId = 999024
	})

	arg0_1.templateConfig = pg.secretary_special_ship[arg1_1]
end

function var0_0.getPainting(arg0_2)
	return arg0_2.templateConfig.prefab or "tbniang"
end

function var0_0.getName(arg0_3)
	return arg0_3.templateConfig.name or ""
end

function var0_0.getPrefab(arg0_4)
	return arg0_4.templateConfig.head
end

function var0_0.GetRecordPosKey(arg0_5)
	return arg0_5.educateCharId .. "" .. arg0_5.id
end

return var0_0
