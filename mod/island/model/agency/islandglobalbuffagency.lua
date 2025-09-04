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

	for iter0_3, iter1_3 in ipairs(var0_3) do
		arg0_3:_AddBuff(arg0_3.skillBuffDic, {
			isSkill = true,
			id = iter1_3
		})
	end

	table.insert(arg0_3.shipIds, arg1_3)
end

function var0_0.OnShipSkillUpgrade(arg0_4, arg1_4)
	local var0_4 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg1_4):GetSkill()
	local var1_4 = var0_4:GetLastEffectIds()
	local var2_4 = var0_4:GetEffectIds()

	if table.contains(arg0_4.shipIds, arg1_4) then
		underscore.each(arg0_4:_SelectGlobalType(var1_4), function(arg0_5)
			arg0_4:_RemoveById(arg0_4.skillBuffDic, arg0_5)
		end)
		table.removebyvalue(arg0_4.shipIds, arg1_4)
	end

	local var3_4 = arg0_4:_SelectGlobalType(var2_4)

	if #var3_4 > 0 then
		underscore.each(var3_4, function(arg0_6)
			arg0_4:_AddBuff(arg0_4.skillBuffDic, {
				isSkill = true,
				id = arg0_6
			})
		end)
		table.insert(arg0_4.shipIds, arg1_4)
	end
end

function var0_0.GetBuffsByType(arg0_7, arg1_7)
	local var0_7 = underscore.select(arg0_7.statusBuffDic[arg1_7] or {}, function(arg0_8)
		return not arg0_8:IsExpiration()
	end)

	return table.mergeArray(var0_7, arg0_7.skillBuffDic[arg1_7] or {})
end

function var0_0._AddBuff(arg0_9, arg1_9, arg2_9)
	local var0_9 = IslandShipStatus.New(arg2_9)
	local var1_9 = var0_9:GetBuffType()

	if not arg1_9[var1_9] then
		arg1_9[var1_9] = {}
	end

	table.insert(arg1_9[var1_9], var0_9)
end

function var0_0._RemoveById(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg1_10[pg.island_buff_template[arg2_10].buff_type]
	local var1_10 = underscore.detect(var0_10, function(arg0_11)
		return arg0_11.id == arg2_10
	end)

	table.removebyvalue(var0_10, var1_10)
end

function var0_0._SelectGlobalType(arg0_12, arg1_12)
	return underscore.select(arg1_12, function(arg0_13)
		return IslandBuffType.IsGlobalType(pg.island_buff_template[arg0_13].buff_type)
	end)
end

return var0_0
