local var0_0 = class("NewEducatePermanent")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.id = arg1_1
	arg0_1.gameCnt = arg2_1.ng_plus_count or 1
	arg0_1.polaroids = arg2_1.polaroids or {}

	arg0_1:InitPolaroidsConfig()

	arg0_1.finishedEndings = arg2_1.active_endings or {}
	arg0_1.activatedEndings = arg2_1.endings or {}

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

function var0_0.GetAllMemoryIds(arg0_4)
	return pg.child2_memory.get_id_list_by_character[arg0_4.id]
end

function var0_0.GetUnlockMemoryIds(arg0_5)
	return underscore.select(arg0_5:GetAllMemoryIds(), function(arg0_6)
		local var0_6 = pg.child2_memory[arg0_6].lua

		return (pg.NewStoryMgr.GetInstance():IsPlayed(var0_6))
	end)
end

function var0_0.InitStroyName2Id(arg0_7)
	arg0_7.name2memoryIds = {}

	underscore.each(arg0_7:GetAllMemoryIds(), function(arg0_8)
		arg0_7.name2memoryIds[pg.child2_memory[arg0_8].lua] = arg0_8
	end)
end

function var0_0.GetMemoryIdByName(arg0_9, arg1_9)
	return arg0_9.name2memoryIds[arg1_9]
end

function var0_0.InitPolaroidsConfig(arg0_10)
	local var0_10 = pg.child2_polaroid.get_id_list_by_character[arg0_10.id]

	arg0_10.polaroidGroup2Ids = {}

	for iter0_10, iter1_10 in ipairs(var0_10) do
		local var1_10 = pg.child2_polaroid[iter1_10].group

		if not arg0_10.polaroidGroup2Ids[var1_10] then
			arg0_10.polaroidGroup2Ids[var1_10] = {}
		end

		table.insert(arg0_10.polaroidGroup2Ids[var1_10], iter1_10)
	end

	arg0_10.unlockPolaroidGroups = {}

	for iter2_10, iter3_10 in ipairs(arg0_10.polaroids) do
		local var2_10 = pg.child2_polaroid[iter3_10].group

		if not table.contains(arg0_10.unlockPolaroidGroups, var2_10) then
			table.insert(arg0_10.unlockPolaroidGroups, var2_10)
		end
	end
end

function var0_0.GetPolaroidGroup2Ids(arg0_11)
	return arg0_11.polaroidGroup2Ids
end

function var0_0.GetAllPolaroidGroups(arg0_12)
	return underscore.keys(arg0_12.polaroidGroup2Ids)
end

function var0_0.GetUnlockPolaroidGroups(arg0_13)
	return arg0_13.unlockPolaroidGroups
end

function var0_0.GetPolaroids(arg0_14)
	return arg0_14.polaroids
end

function var0_0.AddPolaroid(arg0_15, arg1_15)
	table.insert(arg0_15.polaroids, arg1_15)

	local var0_15 = pg.child2_polaroid[arg1_15].group

	if not table.contains(arg0_15.unlockPolaroidGroups, var0_15) then
		table.insert(arg0_15.unlockPolaroidGroups, var0_15)
		arg0_15:UpdateSecretaryIDs(true)
	end
end

function var0_0.GetAllEndingIds(arg0_16)
	return pg.child2_ending.get_id_list_by_character[arg0_16.id]
end

function var0_0.GetFinishedEndings(arg0_17)
	return arg0_17.finishedEndings
end

function var0_0.AddFinishedEnding(arg0_18, arg1_18)
	if table.contains(arg0_18.finishedEndings, arg1_18) then
		return
	end

	table.insert(arg0_18.finishedEndings, arg1_18)
end

function var0_0.GetActivatedEndings(arg0_19)
	return arg0_19.activatedEndings
end

function var0_0.AddActivatedEndings(arg0_20, arg1_20)
	arg0_20.activatedEndings = table.mergeArray(arg0_20.activatedEndings, arg1_20, true)

	arg0_20:UpdateSecretaryIDs(true)
end

function var0_0.InitSecretary(arg0_21)
	arg0_21.unlcokTipByPolaroidCnt = {}

	for iter0_21, iter1_21 in ipairs(pg.secretary_special_ship.all) do
		local var0_21 = pg.secretary_special_ship[iter1_21]

		if var0_21.unlock_type == EducateConst.SECRETARY_UNLCOK_TYPE_POLAROID then
			local var1_21 = var0_21.unlock[1]

			if not table.contains(arg0_21.unlcokTipByPolaroidCnt, var1_21) then
				table.insert(arg0_21.unlcokTipByPolaroidCnt, var1_21)
			end
		end
	end
end

function var0_0.CheckSecretaryID(arg0_22, arg1_22, arg2_22)
	if arg2_22 == "or" then
		for iter0_22, iter1_22 in ipairs(arg1_22) do
			if table.contains(arg0_22.activatedEndings, iter1_22[1]) then
				return true
			end
		end

		return false
	elseif arg2_22 == "and" then
		for iter2_22, iter3_22 in ipairs(arg1_22) do
			if not table.contains(arg0_22.activatedEndings, iter3_22) then
				return false
			end

			return true
		end
	end

	return false
end

function var0_0.UpdateSecretaryIDs(arg0_23, arg1_23)
	local var0_23

	if arg1_23 then
		var0_23 = Clone(NewEducateHelper.GetAllUnlockSecretaryIds())
	end

	arg0_23.unlockSecretaryIds = {}

	local var1_23 = #arg0_23.unlockPolaroidGroups

	for iter0_23, iter1_23 in ipairs(pg.secretary_special_ship.get_id_list_by_tb_id[arg0_23.id]) do
		local var2_23 = pg.secretary_special_ship[iter1_23].unlock_type
		local var3_23 = pg.secretary_special_ship[iter1_23].unlock

		switch(var2_23, {
			[EducateConst.SECRETARY_UNLCOK_TYPE_DEFAULT] = function()
				return
			end,
			[EducateConst.SECRETARY_UNLCOK_TYPE_POLAROID] = function()
				if var3_23[1] and var1_23 >= var3_23[1] then
					table.insert(arg0_23.unlockSecretaryIds, iter1_23)
				end
			end,
			[EducateConst.SECRETARY_UNLCOK_TYPE_ENDING] = function()
				if var3_23[1] then
					if type(var3_23[1]) == "table" then
						if arg0_23:CheckSecretaryID(var3_23, "or") then
							table.insert(arg0_23.unlockSecretaryIds, iter1_23)
						end
					elseif type(var3_23[1]) == "number" and arg0_23:CheckSecretaryID(var3_23, "and") then
						table.insert(arg0_23.unlockSecretaryIds, iter1_23)
					end
				end
			end,
			[EducateConst.SECRETARY_UNLCOK_TYPE_SHOP] = function()
				if var3_23[1] and getProxy(ShipSkinProxy):hasSkin(var3_23[1]) then
					table.insert(arg0_23.unlockSecretaryIds, iter1_23)
				end
			end,
			[EducateConst.SECRETARY_UNLCOK_TYPE_STORY] = function()
				if var3_23[1] and pg.NewStoryMgr.GetInstance():IsPlayed(pg.NewStoryMgr.GetInstance():StoryId2StoryName(var3_23[1])) then
					table.insert(arg0_23.unlockSecretaryIds, iter1_23)
				end
			end
		})
	end

	if arg1_23 then
		getProxy(SettingsProxy):UpdateEducateCharTip(var0_23)
	end
end

function var0_0.GetUnlockSecretaryIds(arg0_29)
	return arg0_29.unlockSecretaryIds
end

return var0_0
