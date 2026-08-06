local var0_0 = class("IslandGlobalBuffAgency", import(".IslandBaseAgency"))

function var0_0.OnInit(arg0_1, arg1_1)
	local var0_1 = arg1_1.global_buff or {}

	arg0_1.shipIds = var0_1.forever_list
	arg0_1.statusBuffDic = {}

	for iter0_1, iter1_1 in ipairs(var0_1.limit_list or {}) do
		arg0_1:_AddBuff(arg0_1.statusBuffDic, iter1_1)
	end
end

function var0_0.InitShipSkillGlobalBuff(arg0_2)
	local var0_2 = getProxy(IslandProxy):GetIsland():GetCharacterAgency()

	arg0_2.skillBuffDic = {}

	for iter0_2, iter1_2 in ipairs(arg0_2.shipIds) do
		local var1_2 = var0_2:GetShipById(iter1_2):GetSkill():GetEffectIds()

		for iter2_2, iter3_2 in ipairs(var1_2) do
			arg0_2:_AddBuff(arg0_2.skillBuffDic, {
				isSkill = true,
				id = iter3_2
			})
		end
	end
end

function var0_0.OnShipSkillUnlock(arg0_3, arg1_3)
	local var0_3 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg1_3):GetSkill():GetEffectIds()
	local var1_3 = arg0_3:_SelectGlobalType(var0_3)

	if #var1_3 > 0 then
		underscore.each(var1_3, function(arg0_4)
			arg0_3:_AddBuff(arg0_3.skillBuffDic, {
				isSkill = true,
				id = arg0_4
			})
		end)
		table.insert(arg0_3.shipIds, arg1_3)
	end
end

function var0_0.OnShipSkillUpgrade(arg0_5, arg1_5)
	local var0_5 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg1_5):GetSkill()
	local var1_5 = var0_5:GetLastEffectIds()
	local var2_5 = var0_5:GetEffectIds()

	if table.contains(arg0_5.shipIds, arg1_5) then
		underscore.each(arg0_5:_SelectGlobalType(var1_5), function(arg0_6)
			arg0_5:_RemoveById(arg0_5.skillBuffDic, arg0_6)
		end)
		table.removebyvalue(arg0_5.shipIds, arg1_5)
	end

	local var3_5 = arg0_5:_SelectGlobalType(var2_5)

	if #var3_5 > 0 then
		underscore.each(var3_5, function(arg0_7)
			arg0_5:_AddBuff(arg0_5.skillBuffDic, {
				isSkill = true,
				id = arg0_7
			})
		end)
		table.insert(arg0_5.shipIds, arg1_5)
	end
end

function var0_0.GetBuffsByType(arg0_8, arg1_8)
	local var0_8 = underscore.select(arg0_8.statusBuffDic[arg1_8] or {}, function(arg0_9)
		return not arg0_9:IsExpiration()
	end)

	return table.mergeArray(var0_8, arg0_8.skillBuffDic[arg1_8] or {})
end

function var0_0._AddBuff(arg0_10, arg1_10, arg2_10)
	local var0_10 = IslandShipStatus.New(arg2_10)
	local var1_10 = var0_10:GetBuffType()

	if not arg1_10[var1_10] then
		arg1_10[var1_10] = {}
	end

	table.insert(arg1_10[var1_10], var0_10)
end

function var0_0._RemoveById(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg1_11[pg.island_buff_template[arg2_11].buff_type]
	local var1_11 = underscore.detect(var0_11, function(arg0_12)
		return arg0_12.id == arg2_11
	end)

	table.removebyvalue(var0_11, var1_11)
end

function var0_0._SelectGlobalType(arg0_13, arg1_13)
	return underscore.select(arg1_13, function(arg0_14)
		return IslandBuffType.IsGlobalType(pg.island_buff_template[arg0_14].buff_type)
	end)
end

return var0_0
