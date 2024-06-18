local var0_0 = class("IconFrame", import(".AttireFrame"))

function var0_0.GetIcon(arg0_1)
	return "IconFrame/" .. arg0_1
end

function var0_0.bindConfigTable(arg0_2)
	return pg.item_data_frame
end

function var0_0.getType(arg0_3)
	return AttireConst.TYPE_ICON_FRAME
end

function var0_0.getDropType(arg0_4)
	return DROP_TYPE_ICON_FRAME
end

function var0_0.getPrefabName(arg0_5)
	return arg0_5:getConfig("id")
end

function var0_0.getIcon(arg0_6)
	return var0_0.GetIcon(arg0_6:getPrefabName())
end

return var0_0
