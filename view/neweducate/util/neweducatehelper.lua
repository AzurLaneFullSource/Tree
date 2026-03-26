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
		end,
		[NewEducateConst.DROP_TYPE.TAROT] = function()
			local var0_12 = pg.child2_benefit_list[arg0_7.id]

			assert(var0_12, "找不到child2_benefit_list配置, id: " .. arg0_7.id)

			return var0_12
		end
	}, function()
		assert(false, "养成二期非法掉落类型:" .. arg0_7.type)
	end)
end

function var0_0.GetDropIcon(arg0_14)
	local var0_14 = var0_0.GetDropConfig(arg0_14)

	return switch(arg0_14.type, {
		[NewEducateConst.DROP_TYPE.TAROT] = function()
			return var0_14.item_icon_little
		end
	}, function()
		return var0_14.item_icon
	end)
end

function var0_0.UpdateVectorItem(arg0_17, arg1_17, arg2_17)
	if arg1_17.type ~= NewEducateConst.DROP_TYPE.ATTR and arg1_17.type ~= NewEducateConst.DROP_TYPE.RES then
		pg.TipsMgr.GetInstance():ShowTips("不支持的掉落展示for Vector,请检查配置！" .. arg1_17.type)

		return
	end

	local var0_17 = arg2_17 or ""
	local var1_17 = var0_0.GetDropConfig(arg1_17)

	LoadImageSpriteAsync("neweducateicon/" .. var1_17.icon, arg0_17:Find("icon"))
	setText(arg0_17:Find("name"), var1_17.name)
	setText(arg0_17:Find("value"), var0_17 .. arg1_17.number)

	if arg0_17:Find("benefit") then
		setActive(arg0_17:Find("benefit"), arg1_17.isBenefit)
		setActive(arg0_17:Find("benefit/add"), arg1_17.number > 0)
		setActive(arg0_17:Find("benefit/reduce"), arg1_17.number < 0)
	end
end

function var0_0.UpdateItem(arg0_18, arg1_18)
	local var0_18 = var0_0.GetDropConfig(arg1_18)

	LoadImageSpriteAsync("neweducateicon/" .. var0_0.GetDropIcon(arg1_18), arg0_18:Find("frame/icon"))
	setText(arg0_18:Find("frame/count_bg/count"), arg1_18.number)
	setText(arg0_18:Find("name_bg/name"), shortenString(var0_18.name, 5))

	if arg0_18:Find("frame/benefit") then
		setActive(arg0_18:Find("frame/benefit"), arg1_18.isBenefit)
	end
end

function var0_0.NormalType2SiteType(arg0_19)
	return switch(arg0_19, {
		[NewEducateConst.SITE_NORMAL_TYPE.WORK] = function()
			return NewEducateConst.SITE_TYPE.WORK
		end,
		[NewEducateConst.SITE_NORMAL_TYPE.TRAVEL] = function()
			return NewEducateConst.SITE_TYPE.TRAVEL
		end
	})
end

function var0_0.FilterBenefit(arg0_22)
	return underscore.select(arg0_22, function(arg0_23)
		return arg0_23.type ~= NewEducateConst.DROP_TYPE.BUFF or arg0_23.type == NewEducateConst.DROP_TYPE.BUFF and pg.child2_benefit_list[arg0_23.id].is_show == 1 and arg0_23.number > 0
	end)
end

function var0_0.MergeDrops(arg0_24)
	local var0_24 = {}

	for iter0_24, iter1_24 in ipairs(arg0_24) do
		if not var0_24[iter1_24.type] then
			var0_24[iter1_24.type] = {}
		end

		var0_24[iter1_24.type][iter1_24.id] = (var0_24[iter1_24.type][iter1_24.id] or 0) + iter1_24.number
	end

	local var1_24 = {}

	for iter2_24, iter3_24 in pairs(var0_24) do
		for iter4_24, iter5_24 in pairs(iter3_24) do
			table.insert(var1_24, {
				type = iter2_24,
				id = iter4_24,
				number = iter5_24
			})
		end
	end

	return var1_24
end

function var0_0.GetSiteColors(arg0_25)
	local var0_25 = pg.child2_site_display[arg0_25]

	return switch(var0_25.type, {
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
			if var0_25.bg == "red" then
				return Color.NewHex("d96964"), Color.NewHex("d96964")
			elseif var0_25.bg == "blue" then
				return Color.NewHex("39bfff"), Color.NewHex("26b1f3")
			end
		end
	})
end

function var0_0.PlaySpecialStory(arg0_30, arg1_30)
	local var0_30 = getProxy(NewEducateProxy):GetCurChar()
	local var1_30 = var0_30.id .. "_" .. var0_30:GetPersonalityTag()
	local var2_30 = not pg.NewStoryMgr.GetInstance():IsPlayed(arg0_30)

	pg.NewStoryMgr.GetInstance():PlayForTb(arg0_30, var1_30, function(arg0_31, arg1_31)
		existCall(arg1_30(arg0_31, arg1_31))
	end, true)

	if var2_30 then
		getProxy(NewEducateProxy):UpdateUnlock()

		local var3_30 = var0_30:GetPermanentData():GetMemoryIdByName(arg0_30)

		if var3_30 then
			pg.m02:sendNotification(GAME.NEW_EDUCATE_TRACK, NewEducateTrackCommand.BuildDataMemory(var0_30:GetGameCnt(), var0_30:GetRoundData().round, var3_30))
		end
	end
end

function var0_0.PlaySpecialStoryList(arg0_32, arg1_32)
	local var0_32 = {}

	for iter0_32, iter1_32 in ipairs(arg0_32) do
		table.insert(var0_32, function(arg0_33)
			var0_0.PlaySpecialStory(iter1_32, arg0_33)
		end)
	end

	seriesAsync(var0_32, function()
		existCall(arg1_32)
	end)
end

function var0_0.IsPersonalDrop(arg0_35)
	return arg0_35.type == NewEducateConst.DROP_TYPE.ATTR and pg.child2_attr[arg0_35.id].type == NewEducateChar.ATTR_TYPE.PERSONALITY
end

function var0_0.GetBenefitValue(arg0_36, arg1_36)
	return math.max(0, math.floor(arg0_36 * (1 + arg1_36.ratio / 10000) + arg1_36.value))
end

function var0_0.GetTarotDetailDescKey()
	local var0_37 = getProxy(PlayerProxy):getRawData().id
	local var1_37 = getProxy(NewEducateProxy):GetCurChar().id

	return NewEducateConst.NEW_EDUCATE_TAROT_DETAIL_DESC .. "_" .. var0_37 .. "_" .. var1_37
end

function var0_0.IsShowTarotDeatilDesc()
	return PlayerPrefs.GetInt(var0_0.GetTarotDetailDescKey()) == 1
end

function var0_0.SetTarotDeatilDescData(arg0_39)
	PlayerPrefs.SetInt(var0_0:GetTarotDetailDescKey(), arg0_39 and 1 or 0)
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

function var0_0.ClearEventPerformance(arg0_43)
	local var0_43 = getProxy(PlayerProxy):getRawData().id
	local var1_43 = NewEducateConst.NEW_EDUCATE_EVENT_TIP .. "_" .. var0_43 .. "_" .. arg0_43.id .. "_" .. arg0_43:GetGameCnt() .. "_"
	local var2_43 = underscore.select(pg.child2_site_event_group.all, function(arg0_44)
		return #pg.child2_site_event_group[arg0_44].performance > 0
	end)

	underscore.each(var2_43, function(arg0_45)
		PlayerPrefs.SetInt(var1_43 .. arg0_45, 0)
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

function var0_0.ReqDataForServer()
	local var0_59 = {}

	if not LOCK_EDUCATE_SYSTEM then
		table.insert(var0_59, function(arg0_60)
			pg.ConnectionMgr.GetInstance():Send(27000, {
				type = 1
			}, 27001, arg0_60)
		end)
	end

	if not LOCK_NEW_EDUCATE_SYSTEM then
		for iter0_59, iter1_59 in ipairs(pg.child2_data.all) do
			table.insert(var0_59, function(arg0_61)
				pg.ConnectionMgr.GetInstance():Send(29001, {
					id = iter1_59
				}, 29002, arg0_61)
			end)
		end
	end

	seriesAsync(var0_59, function()
		return
	end)
end

return var0_0
