local var0_0 = class("NewEducateHelper")

function var0_0.Config2Drop(arg0_1)
	return {
		type = arg0_1[1],
		id = arg0_1[2],
		number = arg0_1[3]
	}
end

function var0_0.Config2Drops(arg0_2)
	local var0_2 = {}

	underscore.each(arg0_2, function(arg0_3)
		table.insert(var0_2, var0_0.Config2Drop(arg0_3))
	end)

	return var0_2
end

function var0_0.Config2Condition(arg0_4)
	return {
		type = arg0_4[1],
		id = arg0_4[2],
		operator = arg0_4[3],
		number = arg0_4[4]
	}
end

function var0_0.Config2Conditions(arg0_5)
	local var0_5 = {}

	underscore.each(arg0_5, function(arg0_6)
		table.insert(var0_5, var0_0.Config2Condition(arg0_6))
	end)

	return var0_5
end

function var0_0.GetDropConfig(arg0_7)
	return switch(arg0_7.type, {
		[NewEducateConst.DROP_TYPE.ATTR] = function()
			local var0_8 = pg.child2_attr[arg0_7.id]

			assert(var0_8, "找不到child2_attr配置, id: " .. arg0_7.id)

			return var0_8
		end,
		[NewEducateConst.DROP_TYPE.RES] = function()
			local var0_9 = pg.child2_resource[arg0_7.id]

			assert(var0_9, "找不到child2_resource配置, id: " .. arg0_7.id)

			return var0_9
		end,
		[NewEducateConst.DROP_TYPE.POLAROID] = function()
			local var0_10 = pg.child2_polaroid[arg0_7.id]

			assert(var0_10, "child2_polaroid, id: " .. arg0_7.id)

			return var0_10
		end,
		[NewEducateConst.DROP_TYPE.BUFF] = function()
			local var0_11 = pg.child2_benefit_list[arg0_7.id]

			assert(var0_11, "找不到child2_benefit_list配置, id: " .. arg0_7.id)

			return var0_11
		end
	}, function()
		assert(false, "养成二期非法掉落类型:" .. arg0_7.type)
	end)
end

function var0_0.UpdateVectorItem(arg0_13, arg1_13, arg2_13)
	if arg1_13.type ~= NewEducateConst.DROP_TYPE.ATTR and arg1_13.type ~= NewEducateConst.DROP_TYPE.RES then
		pg.TipsMgr.GetInstance():ShowTips("不支持的掉落展示for Vector,请检查配置！" .. arg1_13.type)

		return
	end

	local var0_13 = arg2_13 or ""
	local var1_13 = var0_0.GetDropConfig(arg1_13)

	LoadImageSpriteAsync("neweducateicon/" .. var1_13.icon, arg0_13:Find("icon"))
	setText(arg0_13:Find("name"), var1_13.name)
	setText(arg0_13:Find("value"), var0_13 .. arg1_13.number)

	if arg0_13:Find("benefit") then
		setActive(arg0_13:Find("benefit"), arg1_13.isBenefit)
		setActive(arg0_13:Find("benefit/add"), arg1_13.number > 0)
		setActive(arg0_13:Find("benefit/reduce"), arg1_13.number < 0)
	end
end

function var0_0.UpdateItem(arg0_14, arg1_14)
	local var0_14 = var0_0.GetDropConfig(arg1_14)

	LoadImageSpriteAsync("neweducateicon/" .. var0_14.item_icon, arg0_14:Find("frame/icon"))
	setText(arg0_14:Find("frame/count_bg/count"), "x" .. arg1_14.number)
	setText(arg0_14:Find("name_bg/name"), shortenString(var0_14.name, 5))

	if arg0_14:Find("frame/benefit") then
		setActive(arg0_14:Find("frame/benefit"), arg1_14.isBenefit)
	end
end

function var0_0.NormalType2SiteType(arg0_15)
	return switch(arg0_15, {
		[NewEducateConst.SITE_NORMAL_TYPE.WORK] = function()
			return NewEducateConst.SITE_TYPE.WORK
		end,
		[NewEducateConst.SITE_NORMAL_TYPE.TRAVEL] = function()
			return NewEducateConst.SITE_TYPE.TRAVEL
		end
	})
end

function var0_0.UpdateDropsData(arg0_18)
	local var0_18 = {}
	local var1_18 = getProxy(NewEducateProxy)

	for iter0_18, iter1_18 in ipairs(arg0_18) do
		switch(iter1_18.type, {
			[NewEducateConst.DROP_TYPE.ATTR] = function()
				var1_18:UpdateAttr(iter1_18.id, iter1_18.number)
				table.insert(var0_18, iter1_18)
			end,
			[NewEducateConst.DROP_TYPE.RES] = function()
				local var0_20 = var1_18:GetCurChar():GetRes(iter1_18.id) + iter1_18.number - pg.child2_resource[iter1_18.id].max_value

				if var0_20 > 0 then
					table.insert(var0_18, setmetatable({
						overflow = var0_20
					}, {
						__index = iter1_18
					}))
				else
					table.insert(var0_18, iter1_18)
				end

				var1_18:UpdateRes(iter1_18.id, iter1_18.number)
			end,
			[NewEducateConst.DROP_TYPE.POLAROID] = function()
				var1_18:AddPolaroid(iter1_18.id, iter1_18.number)
				table.insert(var0_18, iter1_18)
			end,
			[NewEducateConst.DROP_TYPE.BUFF] = function()
				var1_18:AddBuff(iter1_18.id, iter1_18.number)
				table.insert(var0_18, iter1_18)
			end
		})
	end

	return var0_18
end

function var0_0.MergeDrops(arg0_23)
	local var0_23 = {}

	underscore.each(arg0_23.base_drop, function(arg0_24)
		table.insert(var0_23, arg0_24)
	end)
	underscore.each(arg0_23.benefit_drop, function(arg0_25)
		table.insert(var0_23, setmetatable({
			isBenefit = true
		}, {
			__index = arg0_25
		}))
	end)

	return var0_23
end

function var0_0.FilterBenefit(arg0_26)
	return underscore.select(arg0_26, function(arg0_27)
		return arg0_27.type ~= NewEducateConst.DROP_TYPE.BUFF or arg0_27.type == NewEducateConst.DROP_TYPE.BUFF and pg.child2_benefit_list[arg0_27.id].is_show == 1 and arg0_27.number > 0
	end)
end

function var0_0.GetSiteColors(arg0_28)
	local var0_28 = pg.child2_site_display[arg0_28]

	return switch(var0_28.type, {
		[NewEducateConst.SITE_TYPE.WORK] = function()
			return Color.NewHex("f6bb56"), Color.NewHex("eea221")
		end,
		[NewEducateConst.SITE_TYPE.TRAVEL] = function()
			return Color.NewHex("f6bb56"), Color.NewHex("eea221")
		end,
		[NewEducateConst.SITE_TYPE.EVENT] = function()
			return Color.NewHex("887af2"), Color.NewHex("7668e2")
		end,
		[NewEducateConst.SITE_TYPE.SHIP] = function()
			if var0_28.bg == "red" then
				return Color.NewHex("d96964"), Color.NewHex("d96964")
			elseif var0_28.bg == "blue" then
				return Color.NewHex("39bfff"), Color.NewHex("26b1f3")
			end
		end
	})
end

function var0_0.PlaySpecialStory(arg0_33, arg1_33)
	local var0_33 = getProxy(NewEducateProxy):GetCurChar()
	local var1_33 = var0_33.id .. "_" .. var0_33:GetPersonalityTag()
	local var2_33 = not pg.NewStoryMgr.GetInstance():IsPlayed(arg0_33)

	pg.NewStoryMgr.GetInstance():PlayForTb(arg0_33, var1_33, function(arg0_34, arg1_34)
		existCall(arg1_33(arg0_34, arg1_34))
	end, true)

	if var2_33 then
		getProxy(NewEducateProxy):UpdateUnlock()

		local var3_33 = var0_33:GetPermanentData():GetMemoryIdByName(arg0_33)

		if var3_33 then
			pg.m02:sendNotification(GAME.NEW_EDUCATE_TRACK, NewEducateTrackCommand.BuildDataMemory(var0_33:GetGameCnt(), var0_33:GetRoundData().round, var3_33))
		end
	end
end

function var0_0.PlaySpecialStoryList(arg0_35, arg1_35)
	local var0_35 = {}

	for iter0_35, iter1_35 in ipairs(arg0_35) do
		table.insert(var0_35, function(arg0_36)
			var0_0.PlaySpecialStory(iter1_35, arg0_36)
		end)
	end

	seriesAsync(var0_35, function()
		existCall(arg1_35)
	end)
end

function var0_0.IsPersonalDrop(arg0_38)
	return arg0_38.type == NewEducateConst.DROP_TYPE.ATTR and pg.child2_attr[arg0_38.id].type == NewEducateChar.ATTR_TYPE.PERSONALITY
end

function var0_0.GetBenefitValue(arg0_39, arg1_39)
	return math.max(0, math.floor(arg0_39 * (1 + arg1_39.ratio / 10000) + arg1_39.value))
end

function var0_0.GetNewTipKey()
	local var0_40 = getProxy(PlayerProxy):getRawData().id
	local var1_40 = pg.child2_data.all[#pg.child2_data.all]

	return NewEducateConst.NEW_EDUCATE_NEW_CHILD_TIP .. "_" .. var0_40 .. "_" .. var1_40
end

function var0_0.IsShowNewChildTip()
	if LOCK_EDUCATE_SYSTEM or LOCK_NEW_EDUCATE_SYSTEM then
		return false
	end

	local var0_41 = getProxy(PlayerProxy):getRawData()
	local var1_41 = LOCK_NEW_EDUCATE_SYSTEM and "EducateMediator" or "NewEducateSelectMediator"

	if not pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_41.level, var1_41) then
		return false
	end

	return PlayerPrefs.GetInt(var0_0.GetNewTipKey()) ~= 1
end

function var0_0.ClearShowNewChildTip()
	PlayerPrefs.SetInt(var0_0.GetNewTipKey(), 1)
end

function var0_0.ClearEventPerformance()
	local var0_43 = getProxy(PlayerProxy):getRawData().id
	local var1_43 = getProxy(NewEducateProxy):GetCurChar()
	local var2_43 = NewEducateConst.NEW_EDUCATE_EVENT_TIP .. "_" .. var0_43 .. "_" .. var1_43.id .. "_" .. var1_43:GetGameCnt() .. "_"
	local var3_43 = underscore.select(pg.child2_site_event_group.all, function(arg0_44)
		return #pg.child2_site_event_group[arg0_44].performance > 0
	end)

	underscore.each(var3_43, function(arg0_45)
		PlayerPrefs.SetInt(var2_43 .. arg0_45, 0)
	end)
end

function var0_0.TrackRoundEnd()
	local var0_46 = getProxy(NewEducateProxy):GetCurChar()
	local var1_46 = underscore.map(var0_46:GetAttrIds(), function(arg0_47)
		return var0_46:GetAttr(arg0_47)
	end) or {}
	local var2_46, var3_46 = var0_46:GetBenefitData():GetAllIds()

	pg.m02:sendNotification(GAME.NEW_EDUCATE_TRACK, NewEducateTrackCommand.BuildDataRoundEnd(var0_46.id, var0_46:GetGameCnt(), var0_46:GetRoundData().round, var0_46:GetResByType(NewEducateChar.RES_TYPE.MOOD), var0_46:GetResByType(NewEducateChar.RES_TYPE.MONEY), var0_46:GetResByType(NewEducateChar.RES_TYPE.FAVOR), var0_46:GetPersonality(), table.concat(var1_46, ","), table.concat(var2_46, ",") .. ";" .. table.concat(var3_46, ",")))
end

function var0_0.TrackEnterTime()
	if getProxy(NewEducateProxy):GetEnterTime() == 0 then
		getProxy(NewEducateProxy):RecordEnterTime()

		local var0_48 = getProxy(NewEducateProxy):GetCurChar().id

		pg.m02:sendNotification(GAME.NEW_EDUCATE_TRACK, NewEducateTrackCommand.BuildDataEnter(var0_48, 0))
	end
end

function var0_0.TrackExitTime()
	local var0_49 = getProxy(NewEducateProxy):GetEnterTime()

	if var0_49 ~= 0 then
		local var1_49 = pg.TimeMgr.GetInstance():GetServerTime() - var0_49
		local var2_49 = getProxy(NewEducateProxy):GetCurChar().id

		pg.m02:sendNotification(GAME.NEW_EDUCATE_TRACK, NewEducateTrackCommand.BuildDataEnter(var2_49, 1, var1_49))
		getProxy(NewEducateProxy):RecordEnterTime(0)
	end
end

function var0_0.GetAllUnlockSecretaryIds()
	local var0_50 = getProxy(EducateProxy):GetSecretaryIDs() or {}

	if not LOCK_NEW_EDUCATE_SYSTEM then
		local var1_50 = getProxy(NewEducateProxy)

		for iter0_50, iter1_50 in ipairs(pg.child2_data.all) do
			if var1_50:GetChar(iter1_50) and var1_50:GetChar(iter1_50):GetPermanentData() then
				local var2_50 = var1_50:GetChar(iter1_50):GetPermanentData():GetUnlockSecretaryIds()

				var0_50 = table.mergeArray(var0_50, var2_50)
			end
		end
	end

	return var0_50
end

function var0_0.GetEducateCharacterList()
	local var0_51 = {}

	for iter0_51, iter1_51 in pairs(pg.secretary_special_ship.get_id_list_by_character_id) do
		if not LOCK_NEW_EDUCATE_SYSTEM or iter0_51 == 1000 then
			table.insert(var0_51, EducateCharCharacter.New(iter0_51))
		end
	end

	return var0_51
end

function var0_0.GetSecIdBySkinId(arg0_52)
	for iter0_52, iter1_52 in ipairs(pg.secretary_special_ship.all) do
		if pg.secretary_special_ship[iter1_52].unlock_type == EducateConst.SECRETARY_UNLCOK_TYPE_SHOP and pg.secretary_special_ship[iter1_52].unlock[1] == arg0_52 then
			return iter1_52
		end
	end
end

function var0_0.GetShipNameBySecId(arg0_53)
	return pg.secretary_special_ship[arg0_53].name
end

function var0_0.IsUnlockDefaultShip(arg0_54)
	local var0_54 = pg.secretary_special_ship[arg0_54].character_id
	local var1_54 = var0_0.GetAllUnlockSecretaryIds()

	return table.contains(var1_54, var0_54)
end

function var0_0.HasAnyUnlockShip()
	local var0_55 = var0_0.GetAllUnlockSecretaryIds()

	if not var0_55 then
		return false
	end

	return _.any(var0_55, function(arg0_56)
		return pg.secretary_special_ship[arg0_56].character_id == arg0_56
	end)
end

function var0_0.UpdateUnlockBySkinId(arg0_57)
	local var0_57 = var0_0.GetSecIdBySkinId(arg0_57)
	local var1_57 = pg.secretary_special_ship[var0_57].tb_id

	if var1_57 == 0 then
		getProxy(EducateProxy):updateSecretaryIDs(true)
	else
		getProxy(NewEducateProxy):UpdateUnlock(var1_57)
	end
end

function var0_0.GetEducateCharSlotMaxCnt()
	if LOCK_EDUCATE_SYSTEM then
		return 0
	end

	if getProxy(PlayerProxy):getRawData():ExistEducateChar() or var0_0.HasAnyUnlockShip() then
		return 1
	else
		return 0
	end
end

return var0_0
