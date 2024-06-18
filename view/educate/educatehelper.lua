local var0_0 = class("EducateHelper")

function var0_0.GetItemAddDrops(arg0_1)
	local var0_1 = pg.child_item[arg0_1.id].display
	local var1_1 = {}

	underscore.each(var0_1, function(arg0_2)
		assert(arg0_2[1] == EducateConst.DROP_TYPE_ATTR or arg0_2[1] == EducateConst.DROP_TYPE_RES, "非法道具增益, item id:" .. arg0_1.id)
		table.insert(var1_1, {
			type = arg0_2[1],
			id = arg0_2[2],
			number = arg0_2[3] * arg0_1.number
		})
	end)

	return var1_1
end

function var0_0.UpdateDropsData(arg0_3)
	local var0_3 = getProxy(EducateProxy)

	for iter0_3, iter1_3 in ipairs(arg0_3) do
		switch(iter1_3.type, {
			[EducateConst.DROP_TYPE_ATTR] = function()
				var0_3:UpdateAttr(iter1_3.id, iter1_3.number)
			end,
			[EducateConst.DROP_TYPE_RES] = function()
				var0_3:UpdateRes(iter1_3.id, iter1_3.number)
			end,
			[EducateConst.DROP_TYPE_ITEM] = function()
				var0_3:AddItem(iter1_3.id, iter1_3.number)

				local var0_6 = var0_0.GetItemAddDrops(iter1_3)

				var0_0.UpdateDropsData(var0_6)
			end,
			[EducateConst.DROP_TYPE_MEMORY] = function()
				var0_3:AddMemory(iter1_3.id, iter1_3.number)
			end,
			[EducateConst.DROP_TYPE_POLAROID] = function()
				var0_3:AddPolaroid(iter1_3.id)
			end,
			[EducateConst.DROP_TYPE_BUFF] = function()
				var0_3:AddBuff(iter1_3.id)
			end
		})
	end
end

function var0_0.UpdateDropShow(arg0_10, arg1_10)
	if arg1_10.type == EducateConst.DROP_TYPE_MEMORY or arg1_10.type == EducateConst.DROP_TYPE_POLAROID then
		pg.TipsMgr.GetInstance():ShowTips(string.format("不支持的掉落展示for Item,请检查配置！type:%d, id:%d", arg1_10.type, arg1_10.id))

		return
	end

	local var0_10 = var0_0.GetDropConfig(arg1_10)

	LoadImageSpriteAsync("educateprops/" .. var0_10.icon, findTF(arg0_10, "frame/icon"))
	setText(findTF(arg0_10, "frame/count_bg/count"), "x" .. arg1_10.number)
	setText(findTF(arg0_10, "name_bg/name"), shortenString(var0_10.name, 5))

	if arg1_10.type == EducateConst.DROP_TYPE_ITEM then
		local var1_10 = EducateItem.RARITY2FRAME[var0_10.rarity]

		GetImageSpriteFromAtlasAsync("ui/educatecommonui_atlas", var1_10, findTF(arg0_10, "frame"))
	end
end

function var0_0.GetDropConfig(arg0_11)
	return switch(arg0_11.type, {
		[EducateConst.DROP_TYPE_ATTR] = function()
			local var0_12 = pg.child_attr[arg0_11.id]

			assert(var0_12, "找不到child_attr配置, id: " .. arg0_11.id)

			return var0_12
		end,
		[EducateConst.DROP_TYPE_RES] = function()
			local var0_13 = pg.child_resource[arg0_11.id]

			assert(var0_13, "找不到child_resource配置, id: " .. arg0_11.id)

			return var0_13
		end,
		[EducateConst.DROP_TYPE_ITEM] = function()
			local var0_14 = pg.child_item[arg0_11.id]

			assert(var0_14, "找不到child_item配置, id: " .. arg0_11.id)

			return var0_14
		end,
		[EducateConst.DROP_TYPE_MEMORY] = function()
			local var0_15 = pg.child_memory[arg0_11.id]

			assert(var0_15, "找不到child_memory配置, id: " .. arg0_11.id)

			return var0_15
		end,
		[EducateConst.DROP_TYPE_POLAROID] = function()
			local var0_16 = pg.child_polaroid[arg0_11.id]

			assert(var0_16, "找不到child_polaroid配置, id: " .. arg0_11.id)

			return var0_16
		end,
		[EducateConst.DROP_TYPE_BUFF] = function()
			local var0_17 = pg.child_buff[arg0_11.id]

			assert(var0_17, "找不到child_buff配置, id: " .. arg0_11.id)

			return var0_17
		end
	})
end

function var0_0.GetColorForAttrDrop(arg0_18)
	if arg0_18.type == EducateConst.DROP_TYPE_RES then
		return Color.NewHex("6FD9C4")
	elseif arg0_18.type == EducateConst.DROP_TYPE_ATTR then
		local var0_18 = getProxy(EducateProxy):GetCharData():GetAttrTypeById(arg0_18.id)

		if var0_18 == EducateChar.ATTR_TYPE_MAJOR then
			return Color.NewHex("5DC9FD")
		elseif var0_18 == EducateChar.ATTR_TYPE_PERSONALITY then
			return Color.NewHex("6FD9C4")
		elseif var0_18 == EducateChar.ATTR_TYPE_MINOR then
			return Color.NewHex("8CA1EE")
		end
	end

	return Color.NewHex("39BFFF")
end

function var0_0.UpdateDropShowForAttr(arg0_19, arg1_19)
	if arg1_19.type ~= EducateConst.DROP_TYPE_ATTR and arg1_19.type ~= EducateConst.DROP_TYPE_RES then
		pg.TipsMgr.GetInstance():ShowTips(string.format("不支持的掉落展示for Attr,请检查配置！type:%d, id:%d", arg1_19.type, arg1_19.id))

		return
	end

	setImageColor(arg0_19, var0_0.GetColorForAttrDrop(arg1_19))

	local var0_19 = arg1_19.type == EducateConst.DROP_TYPE_ATTR and "attr_" or "res_"
	local var1_19 = arg1_19.number > 0 and "+" or ""
	local var2_19 = var0_0.GetDropConfig(arg1_19)

	setActive(findTF(arg0_19, "icon"), true)
	GetImageSpriteFromAtlasAsync("ui/educatecommonui_atlas", var0_19 .. arg1_19.id, findTF(arg0_19, "icon"))
	setText(findTF(arg0_19, "name"), var2_19.name)
	setText(findTF(arg0_19, "value"), var1_19 .. arg1_19.number)
end

function var0_0.FilterDropByTypes(arg0_20, arg1_20)
	return underscore.select(arg0_20, function(arg0_21)
		return table.contains(arg1_20, arg0_21.type)
	end)
end

function var0_0.GetDialogueShowDrops(arg0_22)
	return var0_0.FilterDropByTypes(arg0_22, {
		EducateConst.DROP_TYPE_ATTR,
		EducateConst.DROP_TYPE_RES,
		EducateConst.DROP_TYPE_BUFF
	})
end

function var0_0.GetCommonShowDrops(arg0_23)
	return var0_0.FilterDropByTypes(arg0_23, {
		EducateConst.DROP_TYPE_ITEM,
		EducateConst.DROP_TYPE_POLAROID
	})
end

function var0_0.UpdateAvatarShow(arg0_24, arg1_24, arg2_24)
	setImageSprite(findTF(arg0_24, "mask/Image"), LoadSprite("squareicon/" .. arg2_24), true)

	local var0_24 = 0

	for iter0_24, iter1_24 in ipairs(arg1_24) do
		local var1_24 = findTF(arg0_24, "progress/" .. iter1_24[1])
		local var2_24 = iter1_24[2] - 0.005

		setFillAmount(var1_24, var2_24)
		setLocalEulerAngles(var1_24, Vector3(0, 0, -360 * var0_24))

		var0_24 = var0_24 + var2_24 + 0.005
	end
end

function var0_0.GetTimeFromCfg(arg0_25)
	return {
		month = arg0_25[1],
		week = arg0_25[2],
		day = arg0_25[3]
	}
end

function var0_0.IsSameDay(arg0_26, arg1_26)
	return arg0_26.month == arg1_26.month and arg0_26.week == arg1_26.week and arg0_26.day == arg1_26.day
end

function var0_0.CfgTime2Time(arg0_27)
	return {
		month = arg0_27[1][1],
		week = arg0_27[1][2] or 1,
		day = arg0_27[1][3] or 1
	}, {
		month = arg0_27[2][1],
		week = arg0_27[2][2] or 4,
		day = arg0_27[2][3] or 7
	}
end

function var0_0.IsBeforeTime(arg0_28, arg1_28)
	if arg0_28.month < arg1_28.month then
		return true
	end

	if arg0_28.month == arg1_28.month and arg0_28.week < arg1_28.week then
		return true
	end

	if arg0_28.month == arg1_28.month and arg0_28.week == arg1_28.week and arg0_28.day < arg1_28.day then
		return true
	end

	return false
end

function var0_0.IsAfterTime(arg0_29, arg1_29)
	if arg0_29.month > arg1_29.month then
		return true
	end

	if arg0_29.month == arg1_29.month and arg0_29.week > arg1_29.week then
		return true
	end

	if arg0_29.month == arg1_29.month and arg0_29.week == arg1_29.week and arg0_29.day > arg1_29.day then
		return true
	end

	return false
end

function var0_0.InTime(arg0_30, arg1_30, arg2_30)
	return not var0_0.IsBeforeTime(arg0_30, arg1_30) and not var0_0.IsAfterTime(arg0_30, arg2_30)
end

function var0_0.GetTimeAfterDays(arg0_31, arg1_31)
	local var0_31 = {
		month = arg0_31.month,
		week = arg0_31.week,
		day = arg0_31.day,
		day = arg0_31.day + arg1_31
	}

	while var0_31.day > 7 or var0_31.week > 4 do
		if var0_31.day > 7 then
			var0_31.day = var0_31.day - 7
			var0_31.week = var0_31.week + 1
		end

		if var0_31.week > 4 then
			var0_31.week = var0_31.week - 4
			var0_31.month = var0_31.month + 1
		end
	end

	return var0_31
end

function var0_0.GetTimeAfterWeeks(arg0_32, arg1_32)
	local var0_32 = {
		month = arg0_32.month,
		week = arg0_32.week,
		day = arg0_32.day
	}

	var0_32.week = var0_32.week + arg1_32

	while var0_32.week > 4 do
		var0_32.week = var0_32.week - 4
		var0_32.month = var0_32.month + 1
	end

	return var0_32
end

function var0_0.GetDaysBetweenTimes(arg0_33, arg1_33)
	return (arg1_33.month - arg0_33.month) * 28 + (arg1_33.week - arg0_33.week) * 7 + (arg1_33.day - arg0_33.day)
end

function var0_0.GetWeekIdxWithTime(arg0_34)
	return (arg0_34.month - 1) * 4 + arg0_34.week
end

function var0_0.GetShowMonthNumber(arg0_35)
	return arg0_35 > 12 and arg0_35 - 12 or arg0_35
end

function var0_0.GetWeekByNumber(arg0_36)
	if arg0_36 == 7 then
		return i18n("word_day")
	else
		return i18n("number_" .. arg0_36)
	end
end

function var0_0.GetWeekStrByNumber(arg0_37)
	return i18n("word_week_day" .. arg0_37)
end

function var0_0.InUnlockTime(arg0_38, arg1_38)
	if arg0_38.month > arg1_38[1] then
		return true
	end

	if arg0_38.month == arg1_38[1] and arg0_38.week > arg1_38[2] then
		return true
	end

	if arg0_38.month == arg1_38[1] and arg0_38.week == arg1_38[2] and arg0_38.day >= arg1_38[3] then
		return true
	end

	return false
end

function var0_0.IsSystemUnlock(arg0_39)
	local var0_39 = getProxy(EducateProxy):IsFirstGame()
	local var1_39 = EducateConst.SYSTEM_UNLOCK_CONFIG[arg0_39]

	if not var0_39 and var1_39[2] then
		return true
	end

	local var2_39 = getProxy(EducateProxy):GetCurTime()
	local var3_39 = pg.gameset[var1_39[1]].description

	return var0_0.InUnlockTime(var2_39, var3_39)
end

function var0_0.IsShowNature()
	local var0_40, var1_40 = var0_0.CfgTime2Time(pg.gameset.child_charactor_time.description)

	return var0_0.InTime(getProxy(EducateProxy):GetCurTime(), var0_40, var1_40)
end

function var0_0.IsSiteUnlock(arg0_41, arg1_41)
	local var0_41 = pg.child_site[arg0_41]
	local var1_41 = getProxy(EducateProxy):GetCurTime()
	local var2_41 = arg1_41 and var0_41.unlock_time_1 or var0_41.unlock_time_2

	return var0_0.InUnlockTime(var1_41, var2_41)
end

function var0_0.IsMatchSubType(arg0_42, arg1_42)
	if arg0_42 == "" then
		return false
	end

	if type(arg0_42) == "table" then
		return table.contains(arg0_42, arg1_42)
	elseif type(arg0_42) == "string" then
		return arg1_42 == tonumber(arg0_42)
	end

	return false
end

function var0_0.ReqEducateDataCheck(arg0_43)
	if LOCK_EDUCATE_SYSTEM then
		arg0_43()

		return
	end

	local var0_43 = {}

	if not getProxy(EducateProxy):CheckDataRequestEnd() then
		table.insert(var0_43, function(arg0_44)
			pg.m02:sendNotification(GAME.EDUCATE_REQUEST, {
				callback = arg0_44
			})
		end)
	end

	seriesAsync(var0_43, arg0_43)
end

return var0_0
