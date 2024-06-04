local var0 = class("EducateHelper")

function var0.GetItemAddDrops(arg0)
	local var0 = pg.child_item[arg0.id].display
	local var1 = {}

	underscore.each(var0, function(arg0)
		assert(arg0[1] == EducateConst.DROP_TYPE_ATTR or arg0[1] == EducateConst.DROP_TYPE_RES, "非法道具增益, item id:" .. arg0.id)
		table.insert(var1, {
			type = arg0[1],
			id = arg0[2],
			number = arg0[3] * arg0.number
		})
	end)

	return var1
end

function var0.UpdateDropsData(arg0)
	local var0 = getProxy(EducateProxy)

	for iter0, iter1 in ipairs(arg0) do
		switch(iter1.type, {
			[EducateConst.DROP_TYPE_ATTR] = function()
				var0:UpdateAttr(iter1.id, iter1.number)
			end,
			[EducateConst.DROP_TYPE_RES] = function()
				var0:UpdateRes(iter1.id, iter1.number)
			end,
			[EducateConst.DROP_TYPE_ITEM] = function()
				var0:AddItem(iter1.id, iter1.number)

				local var0 = var0.GetItemAddDrops(iter1)

				var0.UpdateDropsData(var0)
			end,
			[EducateConst.DROP_TYPE_MEMORY] = function()
				var0:AddMemory(iter1.id, iter1.number)
			end,
			[EducateConst.DROP_TYPE_POLAROID] = function()
				var0:AddPolaroid(iter1.id)
			end,
			[EducateConst.DROP_TYPE_BUFF] = function()
				var0:AddBuff(iter1.id)
			end
		})
	end
end

function var0.UpdateDropShow(arg0, arg1)
	if arg1.type == EducateConst.DROP_TYPE_MEMORY or arg1.type == EducateConst.DROP_TYPE_POLAROID then
		pg.TipsMgr.GetInstance():ShowTips(string.format("不支持的掉落展示for Item,请检查配置！type:%d, id:%d", arg1.type, arg1.id))

		return
	end

	local var0 = var0.GetDropConfig(arg1)

	LoadImageSpriteAsync("educateprops/" .. var0.icon, findTF(arg0, "frame/icon"))
	setText(findTF(arg0, "frame/count_bg/count"), "x" .. arg1.number)
	setText(findTF(arg0, "name_bg/name"), shortenString(var0.name, 5))

	if arg1.type == EducateConst.DROP_TYPE_ITEM then
		local var1 = EducateItem.RARITY2FRAME[var0.rarity]

		GetImageSpriteFromAtlasAsync("ui/educatecommonui_atlas", var1, findTF(arg0, "frame"))
	end
end

function var0.GetDropConfig(arg0)
	return switch(arg0.type, {
		[EducateConst.DROP_TYPE_ATTR] = function()
			local var0 = pg.child_attr[arg0.id]

			assert(var0, "找不到child_attr配置, id: " .. arg0.id)

			return var0
		end,
		[EducateConst.DROP_TYPE_RES] = function()
			local var0 = pg.child_resource[arg0.id]

			assert(var0, "找不到child_resource配置, id: " .. arg0.id)

			return var0
		end,
		[EducateConst.DROP_TYPE_ITEM] = function()
			local var0 = pg.child_item[arg0.id]

			assert(var0, "找不到child_item配置, id: " .. arg0.id)

			return var0
		end,
		[EducateConst.DROP_TYPE_MEMORY] = function()
			local var0 = pg.child_memory[arg0.id]

			assert(var0, "找不到child_memory配置, id: " .. arg0.id)

			return var0
		end,
		[EducateConst.DROP_TYPE_POLAROID] = function()
			local var0 = pg.child_polaroid[arg0.id]

			assert(var0, "找不到child_polaroid配置, id: " .. arg0.id)

			return var0
		end,
		[EducateConst.DROP_TYPE_BUFF] = function()
			local var0 = pg.child_buff[arg0.id]

			assert(var0, "找不到child_buff配置, id: " .. arg0.id)

			return var0
		end
	})
end

function var0.GetColorForAttrDrop(arg0)
	if arg0.type == EducateConst.DROP_TYPE_RES then
		return Color.NewHex("6FD9C4")
	elseif arg0.type == EducateConst.DROP_TYPE_ATTR then
		local var0 = getProxy(EducateProxy):GetCharData():GetAttrTypeById(arg0.id)

		if var0 == EducateChar.ATTR_TYPE_MAJOR then
			return Color.NewHex("5DC9FD")
		elseif var0 == EducateChar.ATTR_TYPE_PERSONALITY then
			return Color.NewHex("6FD9C4")
		elseif var0 == EducateChar.ATTR_TYPE_MINOR then
			return Color.NewHex("8CA1EE")
		end
	end

	return Color.NewHex("39BFFF")
end

function var0.UpdateDropShowForAttr(arg0, arg1)
	if arg1.type ~= EducateConst.DROP_TYPE_ATTR and arg1.type ~= EducateConst.DROP_TYPE_RES then
		pg.TipsMgr.GetInstance():ShowTips(string.format("不支持的掉落展示for Attr,请检查配置！type:%d, id:%d", arg1.type, arg1.id))

		return
	end

	setImageColor(arg0, var0.GetColorForAttrDrop(arg1))

	local var0 = arg1.type == EducateConst.DROP_TYPE_ATTR and "attr_" or "res_"
	local var1 = arg1.number > 0 and "+" or ""
	local var2 = var0.GetDropConfig(arg1)

	setActive(findTF(arg0, "icon"), true)
	GetImageSpriteFromAtlasAsync("ui/educatecommonui_atlas", var0 .. arg1.id, findTF(arg0, "icon"))
	setText(findTF(arg0, "name"), var2.name)
	setText(findTF(arg0, "value"), var1 .. arg1.number)
end

function var0.FilterDropByTypes(arg0, arg1)
	return underscore.select(arg0, function(arg0)
		return table.contains(arg1, arg0.type)
	end)
end

function var0.GetDialogueShowDrops(arg0)
	return var0.FilterDropByTypes(arg0, {
		EducateConst.DROP_TYPE_ATTR,
		EducateConst.DROP_TYPE_RES,
		EducateConst.DROP_TYPE_BUFF
	})
end

function var0.GetCommonShowDrops(arg0)
	return var0.FilterDropByTypes(arg0, {
		EducateConst.DROP_TYPE_ITEM,
		EducateConst.DROP_TYPE_POLAROID
	})
end

function var0.UpdateAvatarShow(arg0, arg1, arg2)
	setImageSprite(findTF(arg0, "mask/Image"), LoadSprite("squareicon/" .. arg2), true)

	local var0 = 0

	for iter0, iter1 in ipairs(arg1) do
		local var1 = findTF(arg0, "progress/" .. iter1[1])
		local var2 = iter1[2] - 0.005

		setFillAmount(var1, var2)
		setLocalEulerAngles(var1, Vector3(0, 0, -360 * var0))

		var0 = var0 + var2 + 0.005
	end
end

function var0.GetTimeFromCfg(arg0)
	return {
		month = arg0[1],
		week = arg0[2],
		day = arg0[3]
	}
end

function var0.IsSameDay(arg0, arg1)
	return arg0.month == arg1.month and arg0.week == arg1.week and arg0.day == arg1.day
end

function var0.CfgTime2Time(arg0)
	return {
		month = arg0[1][1],
		week = arg0[1][2] or 1,
		day = arg0[1][3] or 1
	}, {
		month = arg0[2][1],
		week = arg0[2][2] or 4,
		day = arg0[2][3] or 7
	}
end

function var0.IsBeforeTime(arg0, arg1)
	if arg0.month < arg1.month then
		return true
	end

	if arg0.month == arg1.month and arg0.week < arg1.week then
		return true
	end

	if arg0.month == arg1.month and arg0.week == arg1.week and arg0.day < arg1.day then
		return true
	end

	return false
end

function var0.IsAfterTime(arg0, arg1)
	if arg0.month > arg1.month then
		return true
	end

	if arg0.month == arg1.month and arg0.week > arg1.week then
		return true
	end

	if arg0.month == arg1.month and arg0.week == arg1.week and arg0.day > arg1.day then
		return true
	end

	return false
end

function var0.InTime(arg0, arg1, arg2)
	return not var0.IsBeforeTime(arg0, arg1) and not var0.IsAfterTime(arg0, arg2)
end

function var0.GetTimeAfterDays(arg0, arg1)
	local var0 = {
		month = arg0.month,
		week = arg0.week,
		day = arg0.day,
		day = arg0.day + arg1
	}

	while var0.day > 7 or var0.week > 4 do
		if var0.day > 7 then
			var0.day = var0.day - 7
			var0.week = var0.week + 1
		end

		if var0.week > 4 then
			var0.week = var0.week - 4
			var0.month = var0.month + 1
		end
	end

	return var0
end

function var0.GetTimeAfterWeeks(arg0, arg1)
	local var0 = {
		month = arg0.month,
		week = arg0.week,
		day = arg0.day
	}

	var0.week = var0.week + arg1

	while var0.week > 4 do
		var0.week = var0.week - 4
		var0.month = var0.month + 1
	end

	return var0
end

function var0.GetDaysBetweenTimes(arg0, arg1)
	return (arg1.month - arg0.month) * 28 + (arg1.week - arg0.week) * 7 + (arg1.day - arg0.day)
end

function var0.GetWeekIdxWithTime(arg0)
	return (arg0.month - 1) * 4 + arg0.week
end

function var0.GetShowMonthNumber(arg0)
	return arg0 > 12 and arg0 - 12 or arg0
end

function var0.GetWeekByNumber(arg0)
	if arg0 == 7 then
		return i18n("word_day")
	else
		return i18n("number_" .. arg0)
	end
end

function var0.GetWeekStrByNumber(arg0)
	return i18n("word_week_day" .. arg0)
end

function var0.InUnlockTime(arg0, arg1)
	if arg0.month > arg1[1] then
		return true
	end

	if arg0.month == arg1[1] and arg0.week > arg1[2] then
		return true
	end

	if arg0.month == arg1[1] and arg0.week == arg1[2] and arg0.day >= arg1[3] then
		return true
	end

	return false
end

function var0.IsSystemUnlock(arg0)
	local var0 = getProxy(EducateProxy):IsFirstGame()
	local var1 = EducateConst.SYSTEM_UNLOCK_CONFIG[arg0]

	if not var0 and var1[2] then
		return true
	end

	local var2 = getProxy(EducateProxy):GetCurTime()
	local var3 = pg.gameset[var1[1]].description

	return var0.InUnlockTime(var2, var3)
end

function var0.IsShowNature()
	local var0, var1 = var0.CfgTime2Time(pg.gameset.child_charactor_time.description)

	return var0.InTime(getProxy(EducateProxy):GetCurTime(), var0, var1)
end

function var0.IsSiteUnlock(arg0, arg1)
	local var0 = pg.child_site[arg0]
	local var1 = getProxy(EducateProxy):GetCurTime()
	local var2 = arg1 and var0.unlock_time_1 or var0.unlock_time_2

	return var0.InUnlockTime(var1, var2)
end

function var0.IsMatchSubType(arg0, arg1)
	if arg0 == "" then
		return false
	end

	if type(arg0) == "table" then
		return table.contains(arg0, arg1)
	elseif type(arg0) == "string" then
		return arg1 == tonumber(arg0)
	end

	return false
end

function var0.ReqEducateDataCheck(arg0)
	if LOCK_EDUCATE_SYSTEM then
		arg0()

		return
	end

	local var0 = {}

	if not getProxy(EducateProxy):CheckDataRequestEnd() then
		table.insert(var0, function(arg0)
			pg.m02:sendNotification(GAME.EDUCATE_REQUEST, {
				callback = arg0
			})
		end)
	end

	seriesAsync(var0, arg0)
end

return var0
