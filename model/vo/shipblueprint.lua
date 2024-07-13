local var0_0 = class("ShipBluePrint", import(".BaseVO"))

var0_0.STATE_LOCK = 1
var0_0.STATE_DEV = 2
var0_0.STATE_DEV_FINISHED = 3
var0_0.STATE_UNLOCK = 4
var0_0.TASK_STATE_LOCK = 1
var0_0.TASK_STATE_OPENING = 2
var0_0.TASK_STATE_WAIT = 3
var0_0.TASK_STATE_START = 4
var0_0.TASK_STATE_ACHIEVED = 5
var0_0.TASK_STATE_FINISHED = 6
var0_0.TASK_STATE_PAUSE = 7
var0_0.STRENGTHEN_TYPE_ATTR = "attr"
var0_0.STRENGTHEN_TYPE_DIALOGUE = "dialog"
var0_0.STRENGTHEN_TYPE_SKILL = "skill"
var0_0.STRENGTHEN_TYPE_CHANGE_SKILL = "change_skill"
var0_0.STRENGTHEN_TYPE_BASE_LIST = "base"
var0_0.STRENGTHEN_TYPE_SKIN = "skin"
var0_0.STRENGTHEN_TYPE_BREAKOUT = "breakout"
var0_0.STRENGTHEN_TYPE_PRLOAD_COUNT = "preload"
var0_0.STRENGTHEN_TYPE_EQUIPMENTPROFICIENCY = "equipmentproficiency"

local var1_0 = pg.ship_data_blueprint
local var2_0 = pg.ship_strengthen_blueprint
local var3_0 = false

function var0_0.print(...)
	if var3_0 then
		print(...)
	end
end

function var0_0.Ctor(arg0_2, arg1_2)
	arg0_2.configId = arg1_2.id
	arg0_2.id = arg0_2.configId
	arg0_2.state = var0_0.STATE_LOCK
	arg0_2.startTime = 0
	arg0_2.shipId = 0
	arg0_2.duration = 0
	arg0_2.level = 0
	arg0_2.fateLevel = -1
	arg0_2.exp = 0
	arg0_2.strengthenConfig = {}

	for iter0_2, iter1_2 in ipairs(arg0_2:getConfig("strengthen_effect")) do
		local var0_2 = Clone(var2_0[iter1_2])

		if var0_2.special == 1 then
			arg0_2:warpspecialEffect(var0_2)
		end

		arg0_2.strengthenConfig[iter0_2] = var0_2
	end

	arg0_2.fateStrengthenConfig = {}

	for iter2_2, iter3_2 in ipairs(arg0_2:getConfig("fate_strengthen")) do
		local var1_2 = Clone(var2_0[iter3_2])

		if var1_2.special == 1 then
			arg0_2:warpspecialEffect(var1_2)
		end

		arg0_2.fateStrengthenConfig[iter2_2] = var1_2
	end
end

function var0_0.warpspecialEffect(arg0_3, arg1_3)
	local var0_3 = {}
	local var1_3 = string.split(arg1_3.effect_desc, "|")
	local var2_3 = 0

	if type(arg1_3.effect_attr) == "table" then
		for iter0_3, iter1_3 in ipairs(arg1_3.effect_attr) do
			var2_3 = var2_3 + 1

			table.insert(var0_3, {
				var0_0.STRENGTHEN_TYPE_ATTR,
				iter1_3,
				var1_3[var2_3] or ""
			})
		end

		arg1_3.effect_attr = nil
	end

	if arg1_3.effect_breakout ~= 0 then
		var2_3 = var2_3 + 1

		table.insert(var0_3, {
			var0_0.STRENGTHEN_TYPE_BREAKOUT,
			arg1_3.effect_breakout,
			var1_3[var2_3] or ""
		})

		arg1_3.effect_breakout = nil
	end

	if type(arg1_3.effect_skill) == "table" then
		var2_3 = var2_3 + 1

		table.insert(var0_3, {
			var0_0.STRENGTHEN_TYPE_SKILL,
			arg1_3.effect_skill,
			var1_3[var2_3] or ""
		})

		arg1_3.effect_skill = nil
	end

	if type(arg1_3.change_skill) == "table" then
		var2_3 = var2_3 + 1

		table.insert(var0_3, {
			var0_0.STRENGTHEN_TYPE_CHANGE_SKILL,
			arg1_3.change_skill,
			var1_3[var2_3] or ""
		})

		arg1_3.change_skill = nil
	end

	if type(arg1_3.effect_base) == "table" then
		var2_3 = var2_3 + 1

		table.insert(var0_3, {
			var0_0.STRENGTHEN_TYPE_BASE_LIST,
			arg1_3.effect_base,
			var1_3[var2_3] or ""
		})

		arg1_3.effect_base = nil
	end

	if type(arg1_3.effect_preload) == "table" then
		var2_3 = var2_3 + 1

		table.insert(var0_3, {
			var0_0.STRENGTHEN_TYPE_PRLOAD_COUNT,
			arg1_3.effect_preload,
			var1_3[var2_3] or ""
		})

		arg1_3.effect_preload = nil
	end

	if type(arg1_3.effect_dialog) == "table" then
		var2_3 = var2_3 + 1

		table.insert(var0_3, {
			var0_0.STRENGTHEN_TYPE_DIALOGUE,
			arg1_3.effect_dialog,
			var1_3[var2_3] or ""
		})

		arg1_3.effect_dialog = nil
	end

	if arg1_3.effect_skin ~= 0 then
		var2_3 = var2_3 + 1

		table.insert(var0_3, {
			var0_0.STRENGTHEN_TYPE_SKIN,
			arg1_3.effect_skin,
			var1_3[var2_3] or ""
		})

		arg1_3.effect_skin = nil
	end

	if type(arg1_3.effect_equipment_proficiency) == "table" then
		local var3_3 = var2_3 + 1

		table.insert(var0_3, {
			var0_0.STRENGTHEN_TYPE_EQUIPMENTPROFICIENCY,
			arg1_3.effect_equipment_proficiency,
			var1_3[var3_3] or ""
		})
	end

	arg1_3.special_effect = var0_3
end

function var0_0.updateInfo(arg0_4, arg1_4)
	arg0_4.startTime = arg1_4.start_time or 0
	arg0_4.shipId = arg1_4.ship_id or 0
	arg0_4.level = arg1_4.blue_print_level and math.min(arg1_4.blue_print_level, arg0_4:getMaxLevel()) or 0
	arg0_4.fateLevel = arg0_4.level == arg0_4:getMaxLevel() and arg1_4.blue_print_level - arg0_4:getMaxLevel() or -1
	arg0_4.exp = arg1_4.exp or 0
	arg0_4.duration = arg1_4.start_duration or 0

	arg0_4:updateState()
end

function var0_0.updateStartUpTime(arg0_5, arg1_5)
	arg0_5.duration = arg1_5
end

function var0_0.updateState(arg0_6)
	if arg0_6:isFetched() then
		arg0_6.state = var0_0.STATE_UNLOCK
	elseif arg0_6.startTime == 0 then
		arg0_6.state = var0_0.STATE_LOCK
	elseif arg0_6:isFinishedAllTasks() then
		arg0_6.state = var0_0.STATE_DEV_FINISHED
	else
		arg0_6.state = var0_0.STATE_DEV
	end
end

function var0_0.addExp(arg0_7, arg1_7)
	assert(arg1_7, "exp can not be nil")

	arg0_7.exp = arg0_7.exp + arg1_7

	local var0_7 = arg0_7:getMaxLevel()

	if var0_7 > arg0_7.level then
		while arg0_7:canLevelUp() do
			local var1_7 = arg0_7:getNextLevelExp()

			arg0_7.exp = arg0_7.exp - var1_7
			arg0_7.level = math.min(arg0_7.level + 1, var0_7)
		end

		if arg0_7.level == var0_7 then
			arg0_7.fateLevel = 0
		end
	end

	if arg0_7:canFateSimulation() then
		local var2_7 = arg0_7:getMaxFateLevel()

		while arg0_7:canFateLevelUp() do
			local var3_7 = arg0_7:getNextFateLevelExp()

			arg0_7.exp = arg0_7.exp - var3_7
			arg0_7.fateLevel = math.min(arg0_7.fateLevel + 1, var2_7)
		end
	end
end

function var0_0.getNextLevelExp(arg0_8)
	if arg0_8.level == arg0_8:getMaxLevel() then
		return -1
	else
		local var0_8 = arg0_8.level + 1

		return arg0_8.strengthenConfig[var0_8].need_exp
	end
end

function var0_0.getNextFateLevelExp(arg0_9)
	if arg0_9.fateLevel == arg0_9:getMaxFateLevel() then
		return -1
	else
		local var0_9 = arg0_9.fateLevel + 1

		return arg0_9.fateStrengthenConfig[var0_9].need_exp
	end
end

function var0_0.canLevelUp(arg0_10)
	if arg0_10.level == arg0_10:getMaxLevel() then
		return false
	end

	if arg0_10:getNextLevelExp() <= arg0_10.exp then
		return true
	end

	return false
end

function var0_0.canFateSimulation(arg0_11)
	return #arg0_11.fateStrengthenConfig > 0 and arg0_11.fateLevel >= 0
end

function var0_0.canFateLevelUp(arg0_12)
	if arg0_12.fateLevel == arg0_12:getMaxFateLevel() then
		return false
	end

	if arg0_12:getNextFateLevelExp() <= arg0_12.exp then
		return true
	end

	return false
end

function var0_0.getMaxLevel(arg0_13)
	return arg0_13.strengthenConfig[#arg0_13.strengthenConfig].lv
end

function var0_0.getMaxFateLevel(arg0_14)
	return arg0_14.fateStrengthenConfig[#arg0_14.fateStrengthenConfig].lv - 30
end

function var0_0.isMaxLevel(arg0_15)
	return arg0_15.level == arg0_15:getMaxLevel()
end

function var0_0.isMaxFateLevel(arg0_16)
	return arg0_16.fateLevel == arg0_16:getMaxFateLevel()
end

function var0_0.isMaxIntensifyLevel(arg0_17)
	if #arg0_17:getConfig("fate_strengthen") > 0 then
		return arg0_17:isMaxFateLevel()
	else
		return arg0_17:isMaxLevel()
	end
end

function var0_0.getBluePrintAddition(arg0_18, arg1_18)
	local var0_18 = table.indexof(ShipModAttr.BLUEPRINT_ATTRS, arg1_18)
	local var1_18 = arg0_18:getConfig("attr_exp")[var0_18]

	if var1_18 then
		local var2_18 = 0

		for iter0_18 = 1, arg0_18.level do
			var2_18 = var2_18 + arg0_18.strengthenConfig[iter0_18].effect[var0_18]
		end

		local var3_18 = 0

		if not arg0_18:isMaxLevel() then
			local var4_18 = arg0_18:getNextLevelExp()

			var3_18 = arg0_18.exp / var4_18 * arg0_18.strengthenConfig[arg0_18.level + 1].effect[var0_18]
		end

		local var5_18 = (var2_18 + var3_18) / var1_18
		local var6_18 = (var2_18 + var3_18) % var1_18

		return var5_18, var6_18
	else
		return 0, 0
	end
end

function var0_0.getShipVO(arg0_19)
	return Ship.New({
		configId = tonumber(arg0_19.id .. "1")
	})
end

function var0_0.isFetched(arg0_20)
	return arg0_20.shipId ~= 0
end

function var0_0.getState(arg0_21)
	return arg0_21.state
end

function var0_0.start(arg0_22, arg1_22)
	arg0_22.state = var0_0.STATE_DEV
	arg0_22.startTime = arg1_22
	arg0_22.duration = 0
end

function var0_0.reset(arg0_23)
	arg0_23.state = var0_0.STATE_LOCK
	arg0_23.startTime = 0
end

function var0_0.isLock(arg0_24)
	return arg0_24.state == var0_0.STATE_LOCK
end

function var0_0.isDeving(arg0_25)
	return arg0_25.state == var0_0.STATE_DEV
end

function var0_0.isFinished(arg0_26)
	return arg0_26.state == var0_0.STATE_DEV_FINISHED
end

function var0_0.finish(arg0_27)
	arg0_27.state = var0_0.STATE_DEV_FINISHED
end

function var0_0.unlock(arg0_28, arg1_28)
	arg0_28.shipId = arg1_28
	arg0_28.state = var0_0.STATE_UNLOCK
	arg0_28.duration = 0
end

function var0_0.isUnlock(arg0_29)
	return arg0_29.state == var0_0.STATE_UNLOCK
end

function var0_0.getItemId(arg0_30)
	return arg0_30:getConfig("strengthen_item")
end

function var0_0.bindConfigTable(arg0_31)
	return pg.ship_data_blueprint
end

function var0_0.getTaskIds(arg0_32)
	return _.map(arg0_32:getConfig("unlock_task"), function(arg0_33)
		return arg0_33[1]
	end)
end

function var0_0.getTaskOpenTimeStamp(arg0_34, arg1_34)
	local var0_34 = table.indexof(arg0_34:getTaskIds(), arg1_34)

	return arg0_34:getConfig("unlock_task")[var0_34][2] + arg0_34.startTime + 1
end

function var0_0.isFinishedAllTasks(arg0_35)
	local var0_35 = getProxy(TaskProxy)

	return _.all(arg0_35:getTaskIds(), function(arg0_36)
		return arg0_35:getTaskStateById(arg0_36) == var0_0.TASK_STATE_FINISHED
	end)
end

function var0_0.getTaskStateById(arg0_37, arg1_37)
	if arg0_37:isLock() then
		if arg0_37.duration > 0 then
			return var0_0.TASK_STATE_PAUSE
		else
			return var0_0.TASK_STATE_LOCK
		end
	elseif arg0_37:getTaskOpenTimeStamp(arg1_37) > pg.TimeMgr.GetInstance():GetServerTime() then
		return var0_0.TASK_STATE_WAIT
	else
		local var0_37 = getProxy(TaskProxy):getTaskVO(arg1_37)

		if var0_37 and var0_37:isReceive() then
			return var0_0.TASK_STATE_FINISHED
		elseif var0_37 and var0_37:isFinish() then
			return var0_0.TASK_STATE_ACHIEVED
		elseif var0_37 then
			return var0_0.TASK_STATE_START
		else
			return var0_0.TASK_STATE_OPENING
		end
	end
end

function var0_0.getExpRetio(arg0_38, arg1_38)
	local var0_38 = arg0_38:getConfig("attr_exp")

	assert(arg1_38 > 0 and arg1_38 <= #var0_38, "invalid index" .. arg1_38)

	return var0_38[arg1_38]
end

function var0_0.specialStrengthens(arg0_39)
	local var0_39 = {}

	for iter0_39, iter1_39 in ipairs(arg0_39.strengthenConfig) do
		if iter1_39.special == 1 then
			table.insert(var0_39, {
				des = iter1_39.special_effect,
				extraDes = iter1_39.extra_desc,
				level = iter1_39.lv
			})
		end
	end

	return var0_39
end

function var0_0.getSpecials(arg0_40)
	return arg0_40.strengthenConfig[arg0_40.level].special_effect
end

function var0_0.getTopLimitAttrValue(arg0_41, arg1_41)
	if arg0_41.level == 0 then
		return 0
	else
		local var0_41 = arg0_41.strengthenConfig[arg0_41.level].effect
		local var1_41 = var0_41[arg1_41]

		assert(var0_41[arg1_41], "strengthen config effect" .. arg1_41)

		local var2_41 = arg0_41:getConfig("attr_exp")[arg1_41]

		return math.floor(var1_41 / var2_41)
	end
end

function var0_0.getItemExp(arg0_42)
	local var0_42 = arg0_42:getConfig("strengthen_item")

	return Item.getConfigData(var0_42).usage_arg[1]
end

function var0_0.getShipProperties(arg0_43, arg1_43, arg2_43)
	assert(arg1_43, "shipVO can not be nil" .. arg0_43.shipId)

	local var0_43 = arg1_43:getBaseProperties()

	arg2_43 = defaultValue(arg2_43, true)

	local var1_43 = arg0_43:getTotalAdditions()

	for iter0_43, iter1_43 in pairs(var0_43) do
		var0_43[iter0_43] = var0_43[iter0_43] + (var1_43[iter0_43] or 0)
	end

	if arg1_43:getIntimacyLevel() > 0 and arg2_43 then
		local var2_43 = pg.intimacy_template[arg1_43:getIntimacyLevel()].attr_bonus * 0.0001

		for iter2_43, iter3_43 in pairs(var0_43) do
			if iter2_43 == AttributeType.Durability or iter2_43 == AttributeType.Cannon or iter2_43 == AttributeType.Torpedo or iter2_43 == AttributeType.AntiAircraft or iter2_43 == AttributeType.Air or iter2_43 == AttributeType.Reload or iter2_43 == AttributeType.Hit or iter2_43 == AttributeType.AntiSub or iter2_43 == AttributeType.Dodge then
				var0_43[iter2_43] = var0_43[iter2_43] * (var2_43 + 1)
			end
		end
	end

	return var0_43
end

function var0_0.getTotalAdditions(arg0_44)
	local var0_44 = {}
	local var1_44 = arg0_44:attrSpecialAddition()

	for iter0_44, iter1_44 in ipairs(Ship.PROPERTIES) do
		local var2_44, var3_44 = arg0_44:getBluePrintAddition(iter1_44)

		var0_44[iter1_44] = var2_44 + (var1_44[iter1_44] or 0)
	end

	return var0_44
end

function var0_0.attrSpecialAddition(arg0_45)
	local var0_45 = {}

	for iter0_45 = 1, arg0_45.level do
		local var1_45 = arg0_45.strengthenConfig[iter0_45]

		if var1_45.special == 1 and type(var1_45.special_effect) == "table" then
			for iter1_45, iter2_45 in ipairs(var1_45.special_effect) do
				if iter2_45[1] == var0_0.STRENGTHEN_TYPE_ATTR then
					local var2_45 = iter2_45[2]

					var0_45[var2_45[1]] = (var0_45[var2_45[1]] or 0) + var2_45[2]
				end
			end
		end
	end

	for iter3_45 = 1, arg0_45.fateLevel do
		local var3_45 = arg0_45.fateStrengthenConfig[iter3_45]

		if var3_45.special == 1 and type(var3_45.special_effect) == "table" then
			for iter4_45, iter5_45 in ipairs(var3_45.special_effect) do
				if iter5_45[1] == var0_0.STRENGTHEN_TYPE_ATTR then
					local var4_45 = iter5_45[2]

					var0_45[var4_45[1]] = (var0_45[var4_45[1]] or 0) + var4_45[2]
				end
			end
		end
	end

	return var0_45
end

function var0_0.getUseageMaxItem(arg0_46)
	local var0_46 = 0

	for iter0_46 = arg0_46.level + 1, arg0_46:getMaxLevel() do
		assert(arg0_46.strengthenConfig[iter0_46], "strengthen config >> " .. iter0_46)

		var0_46 = var0_46 + arg0_46.strengthenConfig[iter0_46].need_exp
	end

	return math.max(math.ceil((var0_46 - arg0_46.exp) / arg0_46:getItemExp()), 0)
end

function var0_0.getFateUseageMaxItem(arg0_47)
	local var0_47 = 0

	for iter0_47 = arg0_47.fateLevel + 1, arg0_47:getMaxFateLevel() do
		assert(arg0_47.fateStrengthenConfig[iter0_47], "strengthen config >> " .. iter0_47)

		var0_47 = var0_47 + arg0_47.fateStrengthenConfig[iter0_47].need_exp
	end

	return math.max(math.ceil((var0_47 - arg0_47.exp) / arg0_47:getItemExp()), 0)
end

function var0_0.getOpenTaskList(arg0_48)
	return arg0_48:getConfig("unlock_task_open_condition")
end

function var0_0.getStrengthenConfig(arg0_49, arg1_49)
	return arg0_49.strengthenConfig[arg1_49]
end

function var0_0.getFateStrengthenConfig(arg0_50, arg1_50)
	return arg0_50.fateStrengthenConfig[arg1_50]
end

function var0_0.getUnlockVoices(arg0_51)
	local var0_51 = {}

	for iter0_51 = 1, arg0_51.level do
		local var1_51 = arg0_51:getStrengthenConfig(iter0_51)

		if var1_51.special == 1 then
			local var2_51 = var1_51.special_effect

			if type(var2_51) == "table" then
				for iter1_51, iter2_51 in ipairs(var2_51) do
					if iter2_51[1] == var0_0.STRENGTHEN_TYPE_DIALOGUE then
						for iter3_51, iter4_51 in ipairs(iter2_51[2]) do
							table.insert(var0_51, iter4_51)
						end
					end
				end
			end
		end
	end

	return var0_51
end

function var0_0.getUnlockLevel(arg0_52, arg1_52)
	local var0_52 = arg0_52:getMaxLevel()

	for iter0_52 = 1, var0_52 do
		local var1_52 = arg0_52:getStrengthenConfig(iter0_52).special_effect

		if type(var1_52) == "table" then
			for iter1_52, iter2_52 in ipairs(var1_52) do
				if iter2_52[1] == var0_0.STRENGTHEN_TYPE_DIALOGUE then
					for iter3_52, iter4_52 in ipairs(iter2_52[2]) do
						if arg1_52 == iter4_52 then
							return iter0_52
						end
					end
				end
			end
		end
	end

	return 0
end

function var0_0.getBaseList(arg0_53, arg1_53)
	assert(arg1_53, "shipVO can not be nil" .. arg0_53.shipId)

	for iter0_53 = arg0_53.level, 1, -1 do
		local var0_53 = arg0_53:getStrengthenConfig(iter0_53)

		if var0_53.special == 1 then
			local var1_53 = var0_53.special_effect

			for iter1_53, iter2_53 in ipairs(var1_53) do
				if iter2_53[1] == var0_0.STRENGTHEN_TYPE_BASE_LIST then
					return iter2_53[2]
				end
			end
		end
	end

	return arg1_53:getConfig("base_list")
end

function var0_0.getPreLoadCount(arg0_54, arg1_54)
	assert(arg1_54, "shipVO can not be nil" .. arg0_54.shipId)

	for iter0_54 = arg0_54.level, 1, -1 do
		local var0_54 = arg0_54:getStrengthenConfig(iter0_54)

		if var0_54.special == 1 then
			local var1_54 = var0_54.special_effect

			for iter1_54, iter2_54 in ipairs(var1_54) do
				if iter2_54[1] == var0_0.STRENGTHEN_TYPE_PRLOAD_COUNT then
					return iter2_54[2]
				end
			end
		end
	end

	return arg1_54:getConfig("preload_count")
end

function var0_0.getEquipProficiencyList(arg0_55, arg1_55)
	assert(arg1_55, "shipVO can not be nil" .. arg0_55.shipId)

	local var0_55 = {}

	for iter0_55 = 1, arg0_55.level do
		local var1_55 = arg0_55:getStrengthenConfig(iter0_55)

		if var1_55.special == 1 then
			local var2_55 = var1_55.special_effect

			for iter1_55, iter2_55 in ipairs(var2_55) do
				if iter2_55[1] == var0_0.STRENGTHEN_TYPE_EQUIPMENTPROFICIENCY then
					local var3_55 = iter2_55[2][1]
					local var4_55 = iter2_55[2][2]

					var0_55[var3_55] = (var0_55[var3_55] or 0) + var4_55
				end
			end
		end
	end

	local var5_55 = Clone(arg1_55:getConfig("equipment_proficiency"))

	for iter3_55, iter4_55 in pairs(var0_55) do
		var5_55[iter3_55] = var5_55[iter3_55] + iter4_55
	end

	return var5_55
end

function var0_0.isFinishPrevTask(arg0_56)
	local var0_56 = true
	local var1_56 = true

	for iter0_56, iter1_56 in ipairs(arg0_56:getOpenTaskList()) do
		local var2_56 = getProxy(TaskProxy):getTaskVO(iter1_56)

		if not var2_56 or not var2_56:isFinish() then
			return false, false
		else
			var1_56 = (var2_56:isReceive() or false) and var1_56
		end
	end

	return var0_56, var1_56
end

function var0_0.isShipModMaxLevel(arg0_57, arg1_57)
	assert(arg1_57, "shipVO can not be nil" .. arg0_57.shipId)

	local var0_57 = arg0_57:getStrengthenConfig(math.min(arg0_57.level + 1, arg0_57:getMaxLevel()))

	if not arg0_57:isMaxLevel() and arg1_57.level < var0_57.need_lv then
		return true, var0_57.need_lv
	else
		return false
	end
end

function var0_0.isShipModMaxFateLevel(arg0_58, arg1_58)
	assert(arg1_58, "shipVO can not be nil" .. arg0_58.shipId)

	local var0_58 = arg0_58:getFateStrengthenConfig(math.min(arg0_58.fateLevel + 1, arg0_58:getMaxFateLevel()))

	if not arg0_58:isMaxFateLevel() and arg1_58.level < var0_58.need_lv then
		return true, var0_58.need_lv
	else
		return false
	end
end

function var0_0.isShipModMaxIntensifyLevel(arg0_59, arg1_59)
	if arg0_59:canFateSimulation() then
		return arg0_59:isShipModMaxFateLevel(arg1_59)
	else
		return arg0_59:isShipModMaxLevel(arg1_59)
	end
end

function var0_0.getChangeSkillList(arg0_60)
	return arg0_60:getConfig("change_skill")
end

function var0_0.isRarityUR(arg0_61)
	return arg0_61:getShipVO():getRarity() >= ShipRarity.SSR
end

function var0_0.getFateMaxLeftOver(arg0_62)
	local var0_62 = arg0_62:isRarityUR() and pg.gameset.fate_sim_ur.key_value or pg.gameset.fate_sim_ssr.key_value
	local var1_62 = var0_62 - arg0_62:getFateUseNum()

	return var1_62 < 0 and var0_62 or var1_62
end

function var0_0.getFateUseNum(arg0_63)
	local var0_63 = 0

	if arg0_63:isMaxLevel() then
		local var1_63 = 0

		for iter0_63, iter1_63 in ipairs(arg0_63.fateStrengthenConfig) do
			if iter1_63.lv <= 30 + arg0_63.fateLevel then
				var1_63 = var1_63 + iter1_63.need_exp
			end
		end

		local var2_63 = var1_63 + arg0_63.exp
		local var3_63 = arg0_63:getItemExp()

		var0_63 = math.floor(var2_63 / var3_63)
	end

	return var0_63
end

function var0_0.isPursuing(arg0_64)
	return arg0_64:getConfig("is_pursuing") == 1
end

function var0_0.getPursuingPrice(arg0_65, arg1_65)
	arg1_65 = arg1_65 or 100

	return arg0_65:getConfig("price") * arg1_65 / 100
end

function var0_0.getUnlockItem(arg0_66)
	local var0_66 = getProxy(BagProxy)

	for iter0_66, iter1_66 in ipairs(arg0_66:getConfig("gain_item_id")) do
		if var0_66:getItemCountById(iter1_66) > 0 then
			return iter1_66
		end
	end
end

function var0_0.isPursuingCostTip(arg0_67)
	return arg0_67:isPursuing() and arg0_67:isUnlock() and not arg0_67:isMaxIntensifyLevel() and not arg0_67:isShipModMaxIntensifyLevel(getProxy(BayProxy):getShipById(arg0_67.shipId)) and getProxy(TechnologyProxy):calcPursuingCost(arg0_67, 1) == 0
end

return var0_0
