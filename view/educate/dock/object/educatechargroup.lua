local var0 = class("EducateCharGroup")

function var0.Ctor(arg0, arg1)
	arg0.id = arg1

	local var0 = pg.secretary_special_ship.get_id_list_by_group[arg1]

	arg0.charIdList = {}

	for iter0, iter1 in ipairs(var0) do
		if pg.secretary_special_ship[iter1].secrerary_show == 1 then
			table.insert(arg0.charIdList, iter1)
		end
	end
end

function var0.GetSortWeight(arg0)
	local var0 = arg0:GetShowId()

	return pg.secretary_special_ship[var0].type
end

function var0.GetCharIdList(arg0)
	return arg0.charIdList
end

function var0.GetTitle(arg0)
	local var0 = arg0:GetShowId()

	if pg.secretary_special_ship[var0].type == 1 then
		return i18n("secretary_special_title_age")
	else
		return i18n("secretary_special_title_physiognomy")
	end
end

function var0.GetUnlockDesc(arg0)
	local var0 = arg0:GetShowId()

	return pg.secretary_special_ship[var0].unlock_desc
end

function var0.GetSpriteName(arg0)
	local var0 = arg0:GetShowId()
	local var1 = pg.secretary_special_ship[var0].type

	return "label_" .. var1
end

function var0.GetShowId(arg0)
	return (_.detect(arg0.charIdList, function(arg0)
		return pg.secretary_special_ship[arg0].type ~= 0
	end))
end

function var0.GetShowPainting(arg0)
	local var0 = arg0:GetShowId()

	assert(var0)

	return pg.secretary_special_ship[var0].prefab
end

function var0.IsSelected(arg0, arg1)
	return _.any(arg0.charIdList, function(arg0)
		return arg1 == arg0
	end)
end

function var0.IsLock(arg0)
	local var0 = getProxy(EducateProxy):GetSecretaryIDs()
	local var1 = {}

	for iter0, iter1 in ipairs(var0) do
		var1[iter1] = true
	end

	return _.all(arg0.charIdList, function(arg0)
		return not var1[arg0]
	end)
end

function var0.ShouldTip(arg0)
	local var0 = getProxy(SettingsProxy)

	return _.any(arg0.charIdList, function(arg0)
		return var0:_ShouldEducateCharTip(arg0)
	end)
end

return var0
