local var0 = class("MetaCharacterBreakout", import("..BaseVO"))

function var0.bindConfigTable(arg0)
	return pg.ship_meta_breakout
end

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.configId = arg0.id
	arg0.needLevel = arg0:getConfig("level")
	arg0.needRepairRate = arg0:getConfig("repair")
	arg0.needItems = {}

	table.insert(arg0.needItems, {
		itemId = arg0:getConfig("item1"),
		count = arg0:getConfig("item1_num")
	})

	arg0.needGold = arg0:getConfig("gold")
	arg0.weaponIds = arg0:getConfig("weapon_ids")
	arg0.breakoutView = arg0:getConfig("breakout_view")

	local var0 = arg0:getConfig("breakout_id")

	if var0 ~= 0 then
		arg0.nextBreakInfo = MetaCharacterBreakout.New({
			id = var0
		})
	end
end

function var0.getConsume(arg0)
	return arg0.needGold, arg0.needItems
end

function var0.getLimited(arg0)
	return arg0.needLevel, arg0.needRepairRate
end

function var0.hasNextInfo(arg0)
	return arg0.nextBreakInfo ~= nil
end

function var0.getNextInfo(arg0)
	return arg0.nextBreakInfo
end

function var0.getWeaponIds(arg0)
	return arg0.weaponIds
end

return var0
