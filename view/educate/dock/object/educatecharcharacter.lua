local var0_0 = class("EducateCharCharacter")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1

	local var0_1 = pg.secretary_special_ship.get_id_list_by_character_id[arg1_1]

	arg0_1.groupList = {}

	for iter0_1, iter1_1 in pairs(pg.secretary_special_ship.get_id_list_by_group) do
		if table.contains(var0_1, iter0_1) then
			table.insert(arg0_1.groupList, EducateCharGroup.New(iter0_1))
		end
	end
end

function var0_0.GetGroupList(arg0_2)
	return arg0_2.groupList
end

function var0_0.GetGroupById(arg0_3, arg1_3)
	for iter0_3, iter1_3 in ipairs(arg0_3.groupList) do
		if iter1_3.id == arg1_3 then
			return iter1_3
		end
	end
end

function var0_0.IsLock(arg0_4)
	return not NewEducateHelper.IsUnlockDefaultShip(arg0_4.id)
end

function var0_0.IsSelected(arg0_5, arg1_5)
	return _.any(arg0_5.groupList, function(arg0_6)
		return arg0_6:IsSelected(arg1_5)
	end)
end

function var0_0.GetDefaultFrame(arg0_7)
	return pg.secretary_special_ship[arg0_7.id].head
end

function var0_0.ShouldTip(arg0_8)
	return _.any(arg0_8.groupList, function(arg0_9)
		return arg0_9:ShouldTip()
	end)
end

return var0_0
