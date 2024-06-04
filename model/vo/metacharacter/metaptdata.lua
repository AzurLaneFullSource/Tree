local var0 = class("MetaPTData")

function var0.Ctor(arg0, arg1)
	local var0 = arg1.group_id

	arg0.groupID = var0

	local var1 = pg.ship_strengthen_meta[var0]

	assert(var1 ~= nil, "Null MetaShip Strengthen Data, ID:" .. var0)

	arg0.targets = var1.target
	arg0.dropList = var1.award_display
	arg0.resId = var1.itemid
	arg0.count = 0
	arg0.level = 0
	arg0.curLevel = arg0.level + 1
end

function var0.initFromServerData(arg0, arg1)
	arg0.count = arg1.pt or 0

	local var0 = arg1.fetch_list

	if #var0 > 0 then
		local var1 = {}

		for iter0, iter1 in ipairs(var0) do
			table.insert(var1, iter1)
		end

		table.sort(var1)

		for iter2, iter3 in ipairs(var1) do
			if iter3 == arg0.targets[iter2] then
				arg0.level = iter2
			else
				break
			end
		end
	end

	arg0.curLevel = math.min(arg0.level + 1, #arg0.targets)
end

function var0.update(arg0, arg1)
	arg0.count = arg1.pt or arg0.count
	arg0.level = arg1.level or arg0.level
	arg0.curLevel = arg0.level + 1
end

function var0.updateLevel(arg0, arg1)
	arg0.level = arg1
	arg0.curLevel = math.min(arg0.level + 1, #arg0.targets)
end

function var0.addPT(arg0, arg1)
	arg0.count = arg0.count + arg1
end

function var0.GetResProgress(arg0)
	local var0 = arg0.count
	local var1 = arg0.targets[arg0.curLevel]
	local var2 = var0 / var1

	return var0, var1, var2
end

function var0.GetLevelProgress(arg0)
	local var0 = arg0.curLevel
	local var1 = #arg0.targets
	local var2 = var0 / var1

	return var0, var1, var2
end

function var0.CanGetAward(arg0)
	local var0, var1, var2 = arg0:GetResProgress()

	return arg0:CanGetNextAward() and var2 >= 1
end

function var0.CanGetNextAward(arg0)
	return arg0.level < #arg0.targets
end

function var0.GetTotalResRequire(arg0)
	return arg0.targets[#arg0.targets]
end

function var0.IsMaxPt(arg0)
	return arg0.count >= arg0:GetTotalResRequire()
end

return var0
