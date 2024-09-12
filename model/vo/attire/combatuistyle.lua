local var0_0 = class("CombatUIStyle", import(".AttireFrame"))

function var0_0.GetIcon(arg0_1)
	return "CombatUIStyle/" .. arg0_1
end

function var0_0.bindConfigTable(arg0_2)
	return pg.item_data_battleui
end

function var0_0.getType(arg0_3)
	return AttireConst.TYPE_COMBAT_UI_STYLE
end

function var0_0.getDropType(arg0_4)
	return DROP_TYPE_COMBAT_UI_STYLE
end

function var0_0.getPrefabName(arg0_5)
	return arg0_5:getConfig("id")
end

function var0_0.getIcon(arg0_6)
	return var0_0.GetIcon(arg0_6:getPrefabName())
end

function var0_0.updateData(arg0_7)
	return
end

function var0_0.isOwned(arg0_8)
	return arg0_8:bindConfigTable()[arg0_8.id].is_unlock == 0 or arg0_8.owned
end

function var0_0.isNew(arg0_9)
	return arg0_9.new == true
end

function var0_0.setNew(arg0_10)
	arg0_10.new = true
end

function var0_0.setUnlock(arg0_11)
	arg0_11.owned = true

	if arg0_11.lock then
		arg0_11.lock = false

		arg0_11:setNew()
	end
end

function var0_0.setLock(arg0_12)
	arg0_12.lock = true
end

return var0_0
