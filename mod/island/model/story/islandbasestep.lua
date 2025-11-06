local var0_0 = class("IslandBaseStep")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.script = arg2_1
	arg0_1.unitId = 0
	arg0_1.unitType = IslandConst.UNIT_LIST_OBJ
	arg0_1.characterId = arg1_1.characterId or 0
	arg0_1.animation = arg1_1.animation
	arg0_1.say = arg1_1.say or ""
	arg0_1.actorName = arg1_1.actorName
	arg0_1.withoutName = defaultValue(arg1_1.withoutName, false)
	arg0_1.withoutIcon = defaultValue(arg1_1.withoutIcon, false)
	arg0_1.customIcon = arg1_1.actorIcon
end

function var0_0.IsHideIcon(arg0_2)
	return arg0_2.withoutIcon
end

function var0_0.IsHideName(arg0_3)
	return arg0_3.withoutName
end

function var0_0.IsSameBranch(arg0_4, arg1_4)
	return true
end

function var0_0.IsPlayer(arg0_5)
	return not arg0_5.unitId or arg0_5.unitId == 0
end

function var0_0.GetActorIcon(arg0_6)
	if arg0_6.customIcon then
		return pg.island_unit_character[arg0_6.customIcon].IslandShipIcon
	end

	if arg0_6:IsPlayer() then
		return "0"
	end

	local var0_6 = pg.island_unit_character[arg0_6.characterId]

	if not var0_6 then
		return "mingshi"
	end

	return var0_6.IslandShipIcon
end

function var0_0.GetActorName(arg0_7)
	if arg0_7.actorName then
		return arg0_7.actorName
	end

	if arg0_7:IsPlayer() then
		if getProxy(PlayerProxy) then
			return getProxy(PlayerProxy):getRawData().name
		else
			return i18n("island_commander")
		end
	end

	local var0_7 = pg.island_unit_character[arg0_7.characterId]

	if not var0_7 then
		return ""
	end

	return (HXSet.hxLan(var0_7.name))
end

function var0_0.GetUnitData(arg0_8)
	return arg0_8:GenUnitData(arg0_8.unitId, arg0_8.unitType)
end

function var0_0.GenUnitData(arg0_9, arg1_9, arg2_9)
	if arg1_9 == 0 then
		return {
			id = arg1_9,
			type = IslandConst.UNIT_LIST_PLAYER,
			key = IslandConst.UNIT_LIST_PLAYER .. "_" .. arg1_9
		}
	else
		return {
			id = arg1_9,
			type = arg2_9,
			key = arg2_9 .. "_" .. arg1_9
		}
	end
end

function var0_0.GetAnimation(arg0_10)
	return arg0_10.animation
end

function var0_0.ExistAnimation(arg0_11)
	return arg0_11.animation ~= nil and arg0_11.animation ~= ""
end

function var0_0.GetSay(arg0_12)
	return (HXSet.hxLan(arg0_12.say))
end

return var0_0
