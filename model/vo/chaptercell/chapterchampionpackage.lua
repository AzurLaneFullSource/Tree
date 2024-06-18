local var0_0 = class("ChapterChampionPackage")
local var1_0 = {
	[ChapterConst.AttachOni] = import(".ChapterChampionOni"),
	[ChapterConst.AttachChampion] = import(".ChapterChampionNormal")
}

function var0_0.Ctor(arg0_1, arg1_1)
	local var0_1 = arg0_1:RebuildData(arg1_1)

	arg0_1.idList = {}

	if arg1_1.extra_id then
		for iter0_1, iter1_1 in ipairs(arg1_1.extra_id) do
			arg0_1.idList[iter0_1] = iter1_1
		end
	end

	arg0_1.currentChampion = var1_0[var0_1.attachment].New(var0_1)
	arg0_1.trait = ChapterConst.TraitNone
	arg0_1.rotation = Quaternion.identity

	rawset(arg0_1, "_init", true)
end

function var0_0.RebuildData(arg0_2, arg1_2)
	local var0_2 = {
		id = arg1_2.item_id,
		pos = {}
	}

	var0_2.pos.row = arg1_2.pos.row
	var0_2.pos.column = arg1_2.pos.column
	var0_2.attachment = arg1_2.item_type
	var0_2.flag = arg1_2.item_flag
	var0_2.data = arg1_2.item_data

	return var0_2
end

function var0_0.__index(arg0_3, arg1_3)
	local var0_3 = var0_0[arg1_3]

	if not var0_3 then
		local var1_3 = rawget(arg0_3, "currentChampion")

		if var1_3 then
			var0_3 = var1_3[arg1_3]
		end
	end

	return var0_3
end

function var0_0.__newindex(arg0_4, arg1_4, arg2_4)
	if not rawget(arg0_4, "_init") then
		rawset(arg0_4, arg1_4, arg2_4)

		return
	end

	local var0_4 = rawget(arg0_4, "currentChampion")

	if var0_4 then
		var0_4[arg1_4] = arg2_4
	end
end

function var0_0.Iter(arg0_5)
	if #arg0_5.idList <= 0 then
		arg0_5.flag = ChapterConst.CellFlagDisabled

		return
	end

	local var0_5 = table.remove(arg0_5.idList, 1)
	local var1_5 = setmetatable({
		data = 0,
		id = var0_5,
		pos = arg0_5.currentChampion
	}, arg0_5.currentChampion)

	arg0_5.currentChampion = var1_0[var1_5.attachment].New(var1_5)
end

function var0_0.GetLastID(arg0_6)
	if #arg0_6.idList > 0 then
		return arg0_6.idList[#arg0_6.idList]
	else
		return arg0_6.currentChampion.id
	end
end

return var0_0
