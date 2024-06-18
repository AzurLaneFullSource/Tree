local var0_0 = class("EducateCharGroup")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1

	local var0_1 = pg.secretary_special_ship.get_id_list_by_group[arg1_1]

	arg0_1.charIdList = {}

	for iter0_1, iter1_1 in ipairs(var0_1) do
		if pg.secretary_special_ship[iter1_1].secrerary_show == 1 then
			table.insert(arg0_1.charIdList, iter1_1)
		end
	end
end

function var0_0.GetSortWeight(arg0_2)
	local var0_2 = arg0_2:GetShowId()

	return pg.secretary_special_ship[var0_2].type
end

function var0_0.GetCharIdList(arg0_3)
	return arg0_3.charIdList
end

function var0_0.GetTitle(arg0_4)
	local var0_4 = arg0_4:GetShowId()

	if pg.secretary_special_ship[var0_4].type == 1 then
		return i18n("secretary_special_title_age")
	else
		return i18n("secretary_special_title_physiognomy")
	end
end

function var0_0.GetUnlockDesc(arg0_5)
	local var0_5 = arg0_5:GetShowId()

	return pg.secretary_special_ship[var0_5].unlock_desc
end

function var0_0.GetSpriteName(arg0_6)
	local var0_6 = arg0_6:GetShowId()
	local var1_6 = pg.secretary_special_ship[var0_6].type

	return "label_" .. var1_6
end

function var0_0.GetShowId(arg0_7)
	return (_.detect(arg0_7.charIdList, function(arg0_8)
		return pg.secretary_special_ship[arg0_8].type ~= 0
	end))
end

function var0_0.GetShowPainting(arg0_9)
	local var0_9 = arg0_9:GetShowId()

	assert(var0_9)

	return pg.secretary_special_ship[var0_9].prefab
end

function var0_0.IsSelected(arg0_10, arg1_10)
	return _.any(arg0_10.charIdList, function(arg0_11)
		return arg1_10 == arg0_11
	end)
end

function var0_0.IsLock(arg0_12)
	local var0_12 = getProxy(EducateProxy):GetSecretaryIDs()
	local var1_12 = {}

	for iter0_12, iter1_12 in ipairs(var0_12) do
		var1_12[iter1_12] = true
	end

	return _.all(arg0_12.charIdList, function(arg0_13)
		return not var1_12[arg0_13]
	end)
end

function var0_0.ShouldTip(arg0_14)
	local var0_14 = getProxy(SettingsProxy)

	return _.any(arg0_14.charIdList, function(arg0_15)
		return var0_14:_ShouldEducateCharTip(arg0_15)
	end)
end

return var0_0
