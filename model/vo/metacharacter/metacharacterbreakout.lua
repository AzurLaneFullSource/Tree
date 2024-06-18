local var0_0 = class("MetaCharacterBreakout", import("..BaseVO"))

function var0_0.bindConfigTable(arg0_1)
	return pg.ship_meta_breakout
end

function var0_0.Ctor(arg0_2, arg1_2)
	arg0_2.id = arg1_2.id
	arg0_2.configId = arg0_2.id
	arg0_2.needLevel = arg0_2:getConfig("level")
	arg0_2.needRepairRate = arg0_2:getConfig("repair")
	arg0_2.needItems = {}

	table.insert(arg0_2.needItems, {
		itemId = arg0_2:getConfig("item1"),
		count = arg0_2:getConfig("item1_num")
	})

	arg0_2.needGold = arg0_2:getConfig("gold")
	arg0_2.weaponIds = arg0_2:getConfig("weapon_ids")
	arg0_2.breakoutView = arg0_2:getConfig("breakout_view")

	local var0_2 = arg0_2:getConfig("breakout_id")

	if var0_2 ~= 0 then
		arg0_2.nextBreakInfo = MetaCharacterBreakout.New({
			id = var0_2
		})
	end
end

function var0_0.getConsume(arg0_3)
	return arg0_3.needGold, arg0_3.needItems
end

function var0_0.getLimited(arg0_4)
	return arg0_4.needLevel, arg0_4.needRepairRate
end

function var0_0.hasNextInfo(arg0_5)
	return arg0_5.nextBreakInfo ~= nil
end

function var0_0.getNextInfo(arg0_6)
	return arg0_6.nextBreakInfo
end

function var0_0.getWeaponIds(arg0_7)
	return arg0_7.weaponIds
end

return var0_0
