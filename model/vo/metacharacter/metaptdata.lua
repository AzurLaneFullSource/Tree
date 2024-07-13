local var0_0 = class("MetaPTData")

function var0_0.Ctor(arg0_1, arg1_1)
	local var0_1 = arg1_1.group_id

	arg0_1.groupID = var0_1

	local var1_1 = pg.ship_strengthen_meta[var0_1]

	assert(var1_1 ~= nil, "Null MetaShip Strengthen Data, ID:" .. var0_1)

	arg0_1.targets = var1_1.target
	arg0_1.dropList = var1_1.award_display
	arg0_1.resId = var1_1.itemid
	arg0_1.count = 0
	arg0_1.level = 0
	arg0_1.curLevel = arg0_1.level + 1
end

function var0_0.initFromServerData(arg0_2, arg1_2)
	arg0_2.count = arg1_2.pt or 0

	local var0_2 = arg1_2.fetch_list

	if #var0_2 > 0 then
		local var1_2 = {}

		for iter0_2, iter1_2 in ipairs(var0_2) do
			table.insert(var1_2, iter1_2)
		end

		table.sort(var1_2)

		for iter2_2, iter3_2 in ipairs(var1_2) do
			if iter3_2 == arg0_2.targets[iter2_2] then
				arg0_2.level = iter2_2
			else
				break
			end
		end
	end

	arg0_2.curLevel = math.min(arg0_2.level + 1, #arg0_2.targets)
end

function var0_0.update(arg0_3, arg1_3)
	arg0_3.count = arg1_3.pt or arg0_3.count
	arg0_3.level = arg1_3.level or arg0_3.level
	arg0_3.curLevel = arg0_3.level + 1
end

function var0_0.updateLevel(arg0_4, arg1_4)
	arg0_4.level = arg1_4
	arg0_4.curLevel = math.min(arg0_4.level + 1, #arg0_4.targets)
end

function var0_0.addPT(arg0_5, arg1_5)
	arg0_5.count = arg0_5.count + arg1_5
end

function var0_0.GetResProgress(arg0_6)
	local var0_6 = arg0_6.count
	local var1_6 = arg0_6.targets[arg0_6.curLevel]
	local var2_6 = var0_6 / var1_6

	return var0_6, var1_6, var2_6
end

function var0_0.GetLevelProgress(arg0_7)
	local var0_7 = arg0_7.curLevel
	local var1_7 = #arg0_7.targets
	local var2_7 = var0_7 / var1_7

	return var0_7, var1_7, var2_7
end

function var0_0.CanGetAward(arg0_8)
	local var0_8, var1_8, var2_8 = arg0_8:GetResProgress()

	return arg0_8:CanGetNextAward() and var2_8 >= 1
end

function var0_0.CanGetNextAward(arg0_9)
	return arg0_9.level < #arg0_9.targets
end

function var0_0.GetTotalResRequire(arg0_10)
	return arg0_10.targets[#arg0_10.targets]
end

function var0_0.IsMaxPt(arg0_11)
	return arg0_11.count >= arg0_11:GetTotalResRequire()
end

return var0_0
