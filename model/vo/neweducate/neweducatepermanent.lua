local var0_0 = class("NewEducatePermanent")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.id = arg1_1
	arg0_1.gameCnt = arg2_1.ng_plus_count or 1
	arg0_1.polaroids = arg2_1.polaroids or {}

	arg0_1:InitPolaroidsConfig()

	arg0_1.finishedEndings = arg2_1.active_endings or {}
	arg0_1.activatedEndings = arg2_1.endings or {}
	arg0_1.buffIds = arg2_1.tarot_archive or {}

	arg0_1:InitEntryConfig()

	arg0_1.maxRound = arg2_1.max_round

	arg0_1:InitStroyName2Id()
	arg0_1:InitSecretary()
	arg0_1:UpdateSecretaryIDs(false)
end

function var0_0.AddGameCnt(arg0_2)
	arg0_2.gameCnt = arg0_2.gameCnt + 1
end

function var0_0.GetGameCnt(arg0_3)
	return arg0_3.gameCnt
end

function var0_0.GetMaxRound(arg0_4)
	return arg0_4.maxRound
end

function var0_0.OnNextRound(arg0_5, arg1_5)
	arg0_5.maxRound = math.max(arg1_5, arg0_5.maxRound)
end

function var0_0.GetAllMemoryIds(arg0_6)
	return pg.child2_memory.get_id_list_by_character[arg0_6.id] or {}
end

function var0_0.GetUnlockMemoryIds(arg0_7)
	return underscore.select(arg0_7:GetAllMemoryIds(), function(arg0_8)
		local var0_8 = pg.child2_memory[arg0_8].lua

		return (pg.NewStoryMgr.GetInstance():IsPlayed(var0_8))
	end)
end

function var0_0.InitStroyName2Id(arg0_9)
	arg0_9.name2memoryIds = {}

	underscore.each(arg0_9:GetAllMemoryIds(), function(arg0_10)
		arg0_9.name2memoryIds[pg.child2_memory[arg0_10].lua] = arg0_10
	end)
end

function var0_0.GetMemoryIdByName(arg0_11, arg1_11)
	return arg0_11.name2memoryIds[arg1_11]
end

function var0_0.InitPolaroidsConfig(arg0_12)
	local var0_12 = pg.child2_polaroid.get_id_list_by_character[arg0_12.id]

	arg0_12.polaroidGroup2Ids = {}

	for iter0_12, iter1_12 in ipairs(var0_12) do
		local var1_12 = pg.child2_polaroid[iter1_12].group

		if not arg0_12.polaroidGroup2Ids[var1_12] then
			arg0_12.polaroidGroup2Ids[var1_12] = {}
		end

		table.insert(arg0_12.polaroidGroup2Ids[var1_12], iter1_12)
	end

	arg0_12.unlockPolaroidGroups = {}

	for iter2_12, iter3_12 in ipairs(arg0_12.polaroids) do
		local var2_12 = pg.child2_polaroid[iter3_12].group

		if not table.contains(arg0_12.unlockPolaroidGroups, var2_12) then
			table.insert(arg0_12.unlockPolaroidGroups, var2_12)
		end
	end
end

function var0_0.GetPolaroidGroup2Ids(arg0_13)
	return arg0_13.polaroidGroup2Ids
end

function var0_0.GetAllPolaroidGroups(arg0_14)
	return underscore.keys(arg0_14.polaroidGroup2Ids)
end

function var0_0.GetUnlockPolaroidGroups(arg0_15)
	return arg0_15.unlockPolaroidGroups
end

function var0_0.GetPolaroids(arg0_16)
	return arg0_16.polaroids
end

function var0_0.AddPolaroid(arg0_17, arg1_17)
	table.insert(arg0_17.polaroids, arg1_17)

	local var0_17 = pg.child2_polaroid[arg1_17].group

	if not table.contains(arg0_17.unlockPolaroidGroups, var0_17) then
		table.insert(arg0_17.unlockPolaroidGroups, var0_17)
		arg0_17:UpdateSecretaryIDs(true)
	end
end

function var0_0.GetAllEndingIds(arg0_18)
	return pg.child2_ending.get_id_list_by_character[arg0_18.id]
end

function var0_0.GetFinishedEndings(arg0_19)
	return arg0_19.finishedEndings
end

function var0_0.AddFinishedEnding(arg0_20, arg1_20)
	if table.contains(arg0_20.finishedEndings, arg1_20) then
		return
	end

	table.insert(arg0_20.finishedEndings, arg1_20)
end

function var0_0.GetActivatedEndings(arg0_21)
	return arg0_21.activatedEndings
end

function var0_0.AddActivatedEndings(arg0_22, arg1_22)
	arg0_22.activatedEndings = table.mergeArray(arg0_22.activatedEndings, arg1_22, true)

	arg0_22:UpdateSecretaryIDs(true)
end

function var0_0.GetAllBuffIds(arg0_23)
	return pg.child2_benefit_list.get_id_list_by_character[arg0_23.id] or {}
end

function var0_0.GetAllTarotIds(arg0_24)
	return underscore.select(arg0_24:GetAllBuffIds(), function(arg0_25)
		return pg.child2_benefit_list[arg0_25].type == NewEducateBuff.TYPE.TAROT and NewEducateBuff.IsVisible(arg0_25)
	end)
end

function var0_0.GetActivatedTarotIds(arg0_26)
	return underscore.select(arg0_26.buffIds, function(arg0_27)
		return pg.child2_benefit_list[arg0_27].type == NewEducateBuff.TYPE.TAROT and NewEducateBuff.IsVisible(arg0_27)
	end)
end

function var0_0.GetAllTalentIds(arg0_28)
	return underscore.select(arg0_28:GetAllBuffIds(), function(arg0_29)
		return pg.child2_benefit_list[arg0_29].type == NewEducateBuff.TYPE.TALENT and NewEducateBuff.IsVisible(arg0_29)
	end)
end

function var0_0.GetActivatedTalentIds(arg0_30)
	return underscore.select(arg0_30.buffIds, function(arg0_31)
		return pg.child2_benefit_list[arg0_31].type == NewEducateBuff.TYPE.TALENT and NewEducateBuff.IsVisible(arg0_31)
	end)
end

function var0_0.GetAllEntryIds(arg0_32)
	return underscore.select(arg0_32:GetAllBuffIds(), function(arg0_33)
		return pg.child2_benefit_list[arg0_33].type == NewEducateBuff.TYPE.ENTRY and NewEducateBuff.IsVisible(arg0_33)
	end)
end

function var0_0.InitEntryConfig(arg0_34)
	arg0_34.entryGroup2Ids = {}

	for iter0_34, iter1_34 in ipairs(arg0_34:GetAllEntryIds()) do
		local var0_34 = pg.child2_benefit_list[iter1_34].level_tag

		if not arg0_34.entryGroup2Ids[var0_34] then
			arg0_34.entryGroup2Ids[var0_34] = {}
		end

		table.insert(arg0_34.entryGroup2Ids[var0_34], iter1_34)
	end
end

function var0_0.GetEntryGroup2Ids(arg0_35)
	return arg0_35.entryGroup2Ids
end

function var0_0.GetAllEntryGroups(arg0_36)
	return underscore.keys(arg0_36.entryGroup2Ids)
end

function var0_0.GetActivatedEntryIds(arg0_37)
	return underscore.select(arg0_37.buffIds, function(arg0_38)
		return pg.child2_benefit_list[arg0_38].type == NewEducateBuff.TYPE.ENTRY and NewEducateBuff.IsVisible(arg0_38)
	end)
end

function var0_0.GetUnlockEntryGroups(arg0_39)
	local var0_39 = {}

	for iter0_39, iter1_39 in ipairs(arg0_39:GetActivatedEntryIds()) do
		local var1_39 = pg.child2_benefit_list[iter1_39].level_tag

		if not table.contains(var0_39, var1_39) then
			table.insert(var0_39, var1_39)
		end
	end

	return var0_39
end

function var0_0.IsTarotType(arg0_40)
	return #arg0_40:GetAllTarotIds() > 0
end

function var0_0.GetAllBuffCnt(arg0_41)
	return #arg0_41:GetAllTarotIds() + #arg0_41:GetAllTalentIds() + #arg0_41:GetAllEntryIds()
end

function var0_0.GetAllUnlockBuffCnt(arg0_42)
	return #arg0_42:GetActivatedTarotIds() + #arg0_42:GetActivatedTalentIds() + #arg0_42:GetActivatedEntryIds()
end

function var0_0.GetBuffIds(arg0_43)
	return arg0_43.buffIds
end

function var0_0.CheckBuffRecord(arg0_44, arg1_44)
	if not table.contains(arg0_44.buffIds, arg1_44) then
		table.insert(arg0_44.buffIds, arg1_44)
	end
end

function var0_0.InitSecretary(arg0_45)
	arg0_45.unlcokTipByPolaroidCnt = {}

	for iter0_45, iter1_45 in ipairs(pg.secretary_special_ship.all) do
		local var0_45 = pg.secretary_special_ship[iter1_45]

		if var0_45.unlock_type == EducateConst.SECRETARY_UNLCOK_TYPE_POLAROID then
			local var1_45 = var0_45.unlock[1]

			if not table.contains(arg0_45.unlcokTipByPolaroidCnt, var1_45) then
				table.insert(arg0_45.unlcokTipByPolaroidCnt, var1_45)
			end
		end
	end
end

function var0_0.CheckSecretaryID(arg0_46, arg1_46, arg2_46)
	if arg2_46 == "or" then
		for iter0_46, iter1_46 in ipairs(arg1_46) do
			if table.contains(arg0_46.activatedEndings, iter1_46[1]) then
				return true
			end
		end

		return false
	elseif arg2_46 == "and" then
		for iter2_46, iter3_46 in ipairs(arg1_46) do
			if not table.contains(arg0_46.activatedEndings, iter3_46) then
				return false
			end

			return true
		end
	end

	return false
end

function var0_0.UpdateSecretaryIDs(arg0_47, arg1_47)
	local var0_47

	if arg1_47 then
		var0_47 = Clone(NewEducateHelper.GetAllUnlockSecretaryIds())
	end

	arg0_47.unlockSecretaryIds = {}

	local var1_47 = #arg0_47.unlockPolaroidGroups

	for iter0_47, iter1_47 in ipairs(pg.secretary_special_ship.get_id_list_by_tb_id[arg0_47.id] or {}) do
		local var2_47 = pg.secretary_special_ship[iter1_47].unlock_type
		local var3_47 = pg.secretary_special_ship[iter1_47].unlock

		switch(var2_47, {
			[EducateConst.SECRETARY_UNLCOK_TYPE_DEFAULT] = function()
				return
			end,
			[EducateConst.SECRETARY_UNLCOK_TYPE_POLAROID] = function()
				if var3_47[1] and var1_47 >= var3_47[1] then
					table.insert(arg0_47.unlockSecretaryIds, iter1_47)
				end
			end,
			[EducateConst.SECRETARY_UNLCOK_TYPE_ENDING] = function()
				if var3_47[1] then
					if type(var3_47[1]) == "table" then
						if arg0_47:CheckSecretaryID(var3_47, "or") then
							table.insert(arg0_47.unlockSecretaryIds, iter1_47)
						end
					elseif type(var3_47[1]) == "number" and arg0_47:CheckSecretaryID(var3_47, "and") then
						table.insert(arg0_47.unlockSecretaryIds, iter1_47)
					end
				end
			end,
			[EducateConst.SECRETARY_UNLCOK_TYPE_SHOP] = function()
				if var3_47[1] and getProxy(ShipSkinProxy):hasSkin(var3_47[1]) then
					table.insert(arg0_47.unlockSecretaryIds, iter1_47)
				end
			end,
			[EducateConst.SECRETARY_UNLCOK_TYPE_STORY] = function()
				if var3_47[1] and pg.NewStoryMgr.GetInstance():IsPlayed(pg.NewStoryMgr.GetInstance():StoryId2StoryName(var3_47[1])) then
					table.insert(arg0_47.unlockSecretaryIds, iter1_47)
				end
			end
		})
	end

	if arg1_47 then
		getProxy(SettingsProxy):UpdateEducateCharTip(var0_47)
	end
end

function var0_0.GetUnlockSecretaryIds(arg0_53)
	return arg0_53.unlockSecretaryIds
end

return var0_0
