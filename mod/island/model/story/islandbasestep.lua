local var0_0 = class("IslandBaseStep")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.unitId = 0
	arg0_1.characterId = arg1_1.characterId or 0
	arg0_1.animation = arg1_1.animation
	arg0_1.say = arg1_1.say or ""
end

function var0_0.IsSameBranch(arg0_2, arg1_2)
	return true
end

function var0_0.IsPlayer(arg0_3)
	return not arg0_3.unitId or arg0_3.unitId == 0
end

function var0_0.GetActorIcon(arg0_4)
	if arg0_4:IsPlayer() then
		return nil
	end

	local var0_4 = pg.island_unit_character[arg0_4.characterId]

	if not var0_4 then
		return nil
	end

	local var1_4 = var0_4.shipId
	local var2_4 = pg.ship_skin_template[var1_4]

	if not var2_4 then
		return nil
	end

	return var2_4.prefab
end

function var0_0.GetActorName(arg0_5)
	if arg0_5:IsPlayer() then
		return i18n1("指挥官")
	end

	local var0_5 = pg.island_unit_character[arg0_5.characterId]

	if not var0_5 then
		return ""
	end

	return var0_5.name
end

function var0_0.GetUnitId(arg0_6)
	return arg0_6.unitId
end

function var0_0.GetAnimation(arg0_7)
	return arg0_7.animation
end

function var0_0.ExistAnimation(arg0_8)
	return arg0_8.animation ~= nil and arg0_8.animation ~= ""
end

function var0_0.GetSay(arg0_9)
	return arg0_9.say
end

return var0_0
