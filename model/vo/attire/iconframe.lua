local var0 = class("IconFrame", import(".AttireFrame"))

function var0.GetIcon(arg0)
	return "IconFrame/" .. arg0
end

function var0.bindConfigTable(arg0)
	return pg.item_data_frame
end

function var0.getType(arg0)
	return AttireConst.TYPE_ICON_FRAME
end

function var0.getDropType(arg0)
	return DROP_TYPE_ICON_FRAME
end

function var0.getPrefabName(arg0)
	return arg0:getConfig("id")
end

function var0.getIcon(arg0)
	return var0.GetIcon(arg0:getPrefabName())
end

return var0
