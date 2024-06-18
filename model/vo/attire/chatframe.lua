local var0_0 = class("ChatFrame", import(".AttireFrame"))

function var0_0.GetIcon(arg0_1)
	return "ChatFrame/" .. arg0_1
end

function var0_0.getType(arg0_2)
	return AttireConst.TYPE_CHAT_FRAME
end

function var0_0.bindConfigTable(arg0_3)
	return pg.item_data_chat
end

function var0_0.getPrefabName(arg0_4)
	if arg0_4:getConfig("id") == 0 then
		return arg0_4:getConfig("id") .. "_self"
	else
		return arg0_4:getConfig("id") .. "_self"
	end
end

function var0_0.getDropType(arg0_5)
	return DROP_TYPE_CHAT_FRAME
end

function var0_0.getIcon(arg0_6)
	return var0_0.GetIcon(arg0_6:getPrefabName())
end

return var0_0
