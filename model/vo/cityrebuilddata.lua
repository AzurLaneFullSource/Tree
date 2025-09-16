local var0_0 = class("CityRebuildData", import("..vo.BaseVO"))
local var1_0 = pg.activity_ninja_city
local var2_0 = pg.activity_ninja_building
local var3_0 = pg.activity_ninja_buff
local var4_0 = pg.activity_ninja_enemy

var0_0.Thousand = 1000
var0_0.Million = 1000000
var0_0.Billion = 1000000000
var0_0.MaxGold = 99999999999

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.isInited = arg1_1.is_inited
	arg0_1.pt = arg1_1.pt.k + arg1_1.pt.m * var0_0.Million + arg1_1.pt.b * var0_0.Billion
	arg0_1.buildings = arg1_1.builds
	arg0_1.roles = arg1_1.roles
	arg0_1.recruiting = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.recruits) do
		arg0_1.recruiting[iter1_1.id] = iter1_1.start_time
	end

	arg0_1.buffs = arg1_1.buffs
	arg0_1.buffLevels = {}

	for iter2_1, iter3_1 in ipairs(arg0_1.buffs) do
		local var0_1 = var3_0[iter3_1]

		arg0_1.buffLevels[var0_1.group] = var0_1.level
	end

	arg0_1.maxLevel = arg1_1.max_level
	arg0_1.curLevel = arg1_1.cur_level
	arg0_1.maxChooseLevel = arg1_1.max_display
	arg0_1.startTime = arg1_1.adjust.time
	arg0_1.leftHp = arg1_1.adjust.left_hp.k + arg1_1.adjust.left_hp.m * var0_0.Million + arg1_1.adjust.left_hp.b * var0_0.Billion
	arg0_1.summaryPt = arg1_1.summary_pt.k + arg1_1.summary_pt.m * var0_0.Million + arg1_1.summary_pt.b * var0_0.Billion
	arg0_1.cityLevel = 1
	arg0_1.allBuildingIds = {}
	arg0_1.allCharaIds = {}

	for iter4_1, iter5_1 in ipairs(var2_0.all) do
		local var1_1 = var2_0[iter5_1].type

		if var1_1 == 1 then
			table.insert(arg0_1.allBuildingIds, iter5_1)
		elseif var1_1 == 2 then
			table.insert(arg0_1.allCharaIds, iter5_1)
		end
	end

	arg0_1.unlockBuildingOrCharaIds = Clone(var1_0[1].include)

	arg0_1:TryUpgradeCityLevel(true)

	arg0_1.Levelbuildings = {}
	arg0_1.Levelcharas = {}

	arg0_1:SetLevelDatas()
end

function var0_0.TryUpgradeCityLevel(arg0_2, arg1_2)
	local var0_2 = true

	while var0_2 do
		local var1_2
		local var2_2

		for iter0_2, iter1_2 in ipairs(var1_0.all) do
			local var3_2 = var1_0[iter1_2]

			if var1_2 then
				var2_2 = var3_2

				break
			end

			if var3_2.level == arg0_2.cityLevel then
				var1_2 = var3_2
			end
		end

		if not var1_2 or not var2_2 then
			return
		end

		for iter2_2, iter3_2 in ipairs(var1_2.include) do
			if not table.contains(arg0_2.buildings, iter3_2) and not table.contains(arg0_2.roles, iter3_2) then
				var0_2 = false

				break
			end
		end

		if var0_2 then
			arg0_2.cityLevel = arg0_2.cityLevel + 1

			table.insertto(arg0_2.unlockBuildingOrCharaIds, var2_2.include)

			for iter4_2, iter5_2 in ipairs(var2_2.include) do
				if var2_0[iter5_2].default_state == 2 then
					if type == 1 and not table.contains(arg0_2.buildings, iter5_2) then
						table.insert(arg0_2.buildings, iter5_2)
					elseif type == 2 and not table.contains(arg0_2.roles, iter5_2) then
						table.insert(arg0_2.roles, iter5_2)
					end
				end
			end

			if arg1_2 and var2_2.story ~= "" then
				pg.NewStoryMgr.GetInstance():Play(var2_2.story)
			end
		end
	end
end

function var0_0.RebuildDone(arg0_3, arg1_3)
	table.insert(arg0_3.buildings, arg1_3)
	arg0_3:TryUpgradeCityLevel(true)
end

function var0_0.StartRecruit(arg0_4, arg1_4)
	arg0_4.recruiting[arg1_4] = pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.RecruitDone(arg0_5, arg1_5)
	for iter0_5, iter1_5 in ipairs(arg1_5) do
		arg0_5.recruiting[iter1_5] = nil

		table.insert(arg0_5.roles, iter1_5)
	end

	arg0_5:TryUpgradeCityLevel(true)
end

function var0_0.UpgradeBuff(arg0_6, arg1_6, arg2_6)
	local var0_6 = var3_0.get_id_list_by_group[arg1_6]

	table.sort(var0_6, function(arg0_7, arg1_7)
		return var3_0[arg0_7].level < var3_0[arg1_7].level
	end)

	local var1_6 = 0

	for iter0_6, iter1_6 in ipairs(arg0_6.buffs) do
		if var3_0[iter1_6].group == arg1_6 then
			var1_6 = iter1_6

			table.remove(arg0_6.buffs, iter0_6)

			break
		end
	end

	local var2_6 = table.indexof(var0_6, var1_6) + arg2_6
	local var3_6 = var0_6[var2_6]

	table.insert(arg0_6.buffs, var3_6)

	arg0_6.buffLevels[arg1_6] = var2_6
end

function var0_0.Result(arg0_8, arg1_8)
	arg0_8.pt = arg0_8.pt + arg1_8.summary_pt.k + arg1_8.summary_pt.m * var0_0.Million + arg1_8.summary_pt.b * var0_0.Billion

	arg0_8:Adjust(arg1_8.adjust)

	arg0_8.summaryPt = 0
end

function var0_0.ConsumePt(arg0_9, arg1_9)
	arg0_9.pt = arg0_9.pt - arg1_9
end

function var0_0.AddPt(arg0_10, arg1_10)
	arg0_10.pt = arg0_10.pt + arg1_10
end

function var0_0.Adjust(arg0_11, arg1_11)
	arg0_11.startTime = arg1_11.time
	arg0_11.leftHp = arg1_11.left_hp.k + arg1_11.left_hp.m * var0_0.Million + arg1_11.left_hp.b * var0_0.Billion
	arg0_11.maxLevel = arg1_11.max_level
end

function var0_0.IsRepairedOrRecruited(arg0_12, arg1_12)
	return table.contains(arg0_12.buildings, arg1_12) or table.contains(arg0_12.roles, arg1_12)
end

function var0_0.IsUnlock(arg0_13, arg1_13)
	return table.contains(arg0_13.unlockBuildingOrCharaIds, arg1_13)
end

function var0_0.UpdateChooseLevel(arg0_14, arg1_14)
	arg0_14.curLevel = arg1_14

	if arg1_14 > arg0_14.maxChooseLevel then
		arg0_14.maxChooseLevel = arg1_14
	end
end

function var0_0.SetLevelDatas(arg0_15)
	arg0_15.Levelbuildings = {}
	arg0_15.Levelcharas = {}

	for iter0_15, iter1_15 in ipairs(var1_0.all) do
		arg0_15.Levelbuildings[iter0_15] = {}
		arg0_15.Levelcharas[iter0_15] = {}

		for iter2_15, iter3_15 in ipairs(var1_0[iter1_15].include) do
			local var0_15 = var2_0[iter3_15].type

			if var0_15 == 1 then
				table.insert(arg0_15.Levelbuildings[iter0_15], iter3_15)
			elseif var0_15 == 2 then
				table.insert(arg0_15.Levelcharas[iter0_15], iter3_15)
			end
		end
	end
end

function var0_0.KeepDecimal(arg0_16, arg1_16)
	return math.floor(10^arg1_16 * arg0_16) / 10^arg1_16
end

var0_0.SHOW_NUM_CNT = 4

function var0_0.PtToShow(arg0_17)
	if arg0_17 >= var0_0.MaxGold then
		return 99.99 .. "B"
	end

	if arg0_17 >= var0_0.Billion then
		if arg0_17 % var0_0.Billion == 0 then
			return arg0_17 / var0_0.Billion .. "B"
		end

		local var0_17 = arg0_17 / var0_0.Billion
		local var1_17 = var0_0.SHOW_NUM_CNT - #tostring(math.floor(var0_17))

		return var0_0.KeepDecimal(var0_17, var1_17) .. "B"
	elseif arg0_17 >= var0_0.Million then
		if arg0_17 % var0_0.Million == 0 then
			return arg0_17 / var0_0.Million .. "M"
		end

		local var2_17 = arg0_17 / var0_0.Million
		local var3_17 = var0_0.SHOW_NUM_CNT - #tostring(math.floor(var2_17))

		return var0_0.KeepDecimal(var2_17, var3_17) .. "M"
	elseif arg0_17 >= var0_0.Thousand then
		if arg0_17 % var0_0.Thousand == 0 then
			return arg0_17 / var0_0.Thousand .. "K"
		end

		local var4_17 = arg0_17 / var0_0.Thousand
		local var5_17 = var0_0.SHOW_NUM_CNT - #tostring(math.floor(var4_17))

		return var0_0.KeepDecimal(var4_17, var5_17) .. "K"
	end

	return arg0_17
end

return var0_0
