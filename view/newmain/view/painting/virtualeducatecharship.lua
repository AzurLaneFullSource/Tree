local var0 = class("VirtualEducateCharShip", import("model.vo.Ship"))

function var0.Ctor(arg0, arg1)
	arg0.educateCharId = arg1

	var0.super.Ctor(arg0, {
		id = 99999999,
		configId = 999024
	})

	arg0.templateConfig = pg.secretary_special_ship[arg1]
end

function var0.getPainting(arg0)
	return arg0.templateConfig.prefab or "tbniang"
end

function var0.getName(arg0)
	return arg0.templateConfig.name or ""
end

function var0.getPrefab(arg0)
	return arg0.templateConfig.head
end

function var0.GetRecordPosKey(arg0)
	return arg0.educateCharId .. "" .. arg0.id
end

return var0
