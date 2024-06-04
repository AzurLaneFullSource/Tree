local var0 = class("ChapterChampionPackage")
local var1 = {
	[ChapterConst.AttachOni] = import(".ChapterChampionOni"),
	[ChapterConst.AttachChampion] = import(".ChapterChampionNormal")
}

function var0.Ctor(arg0, arg1)
	local var0 = arg0:RebuildData(arg1)

	arg0.idList = {}

	if arg1.extra_id then
		for iter0, iter1 in ipairs(arg1.extra_id) do
			arg0.idList[iter0] = iter1
		end
	end

	arg0.currentChampion = var1[var0.attachment].New(var0)
	arg0.trait = ChapterConst.TraitNone
	arg0.rotation = Quaternion.identity

	rawset(arg0, "_init", true)
end

function var0.RebuildData(arg0, arg1)
	local var0 = {
		id = arg1.item_id,
		pos = {}
	}

	var0.pos.row = arg1.pos.row
	var0.pos.column = arg1.pos.column
	var0.attachment = arg1.item_type
	var0.flag = arg1.item_flag
	var0.data = arg1.item_data

	return var0
end

function var0.__index(arg0, arg1)
	local var0 = var0[arg1]

	if not var0 then
		local var1 = rawget(arg0, "currentChampion")

		if var1 then
			var0 = var1[arg1]
		end
	end

	return var0
end

function var0.__newindex(arg0, arg1, arg2)
	if not rawget(arg0, "_init") then
		rawset(arg0, arg1, arg2)

		return
	end

	local var0 = rawget(arg0, "currentChampion")

	if var0 then
		var0[arg1] = arg2
	end
end

function var0.Iter(arg0)
	if #arg0.idList <= 0 then
		arg0.flag = ChapterConst.CellFlagDisabled

		return
	end

	local var0 = table.remove(arg0.idList, 1)
	local var1 = setmetatable({
		data = 0,
		id = var0,
		pos = arg0.currentChampion
	}, arg0.currentChampion)

	arg0.currentChampion = var1[var1.attachment].New(var1)
end

function var0.GetLastID(arg0)
	if #arg0.idList > 0 then
		return arg0.idList[#arg0.idList]
	else
		return arg0.currentChampion.id
	end
end

return var0
