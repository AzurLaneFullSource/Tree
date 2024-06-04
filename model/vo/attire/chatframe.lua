local var0 = class("ChatFrame", import(".AttireFrame"))

function var0.GetIcon(arg0)
	return "ChatFrame/" .. arg0
end

function var0.getType(arg0)
	return AttireConst.TYPE_CHAT_FRAME
end

function var0.bindConfigTable(arg0)
	return pg.item_data_chat
end

function var0.getPrefabName(arg0)
	if arg0:getConfig("id") == 0 then
		return arg0:getConfig("id") .. "_self"
	else
		return arg0:getConfig("id") .. "_self"
	end
end

function var0.getDropType(arg0)
	return DROP_TYPE_CHAT_FRAME
end

function var0.getIcon(arg0)
	return var0.GetIcon(arg0:getPrefabName())
end

return var0
