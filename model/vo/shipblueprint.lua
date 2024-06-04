local var0 = class("ShipBluePrint", import(".BaseVO"))

var0.STATE_LOCK = 1
var0.STATE_DEV = 2
var0.STATE_DEV_FINISHED = 3
var0.STATE_UNLOCK = 4
var0.TASK_STATE_LOCK = 1
var0.TASK_STATE_OPENING = 2
var0.TASK_STATE_WAIT = 3
var0.TASK_STATE_START = 4
var0.TASK_STATE_ACHIEVED = 5
var0.TASK_STATE_FINISHED = 6
var0.TASK_STATE_PAUSE = 7
var0.STRENGTHEN_TYPE_ATTR = "attr"
var0.STRENGTHEN_TYPE_DIALOGUE = "dialog"
var0.STRENGTHEN_TYPE_SKILL = "skill"
var0.STRENGTHEN_TYPE_CHANGE_SKILL = "change_skill"
var0.STRENGTHEN_TYPE_BASE_LIST = "base"
var0.STRENGTHEN_TYPE_SKIN = "skin"
var0.STRENGTHEN_TYPE_BREAKOUT = "breakout"
var0.STRENGTHEN_TYPE_PRLOAD_COUNT = "preload"
var0.STRENGTHEN_TYPE_EQUIPMENTPROFICIENCY = "equipmentproficiency"

local var1 = pg.ship_data_blueprint
local var2 = pg.ship_strengthen_blueprint
local var3 = false

function var0.print(...)
	if var3 then
		print(...)
	end
end

function var0.Ctor(arg0, arg1)
	arg0.configId = arg1.id
	arg0.id = arg0.configId
	arg0.state = var0.STATE_LOCK
	arg0.startTime = 0
	arg0.shipId = 0
	arg0.duration = 0
	arg0.level = 0
	arg0.fateLevel = -1
	arg0.exp = 0
	arg0.strengthenConfig = {}

	for iter0, iter1 in ipairs(arg0:getConfig("strengthen_effect")) do
		local var0 = Clone(var2[iter1])

		if var0.special == 1 then
			arg0:warpspecialEffect(var0)
		end

		arg0.strengthenConfig[iter0] = var0
	end

	arg0.fateStrengthenConfig = {}

	for iter2, iter3 in ipairs(arg0:getConfig("fate_strengthen")) do
		local var1 = Clone(var2[iter3])

		if var1.special == 1 then
			arg0:warpspecialEffect(var1)
		end

		arg0.fateStrengthenConfig[iter2] = var1
	end
end

function var0.warpspecialEffect(arg0, arg1)
	local var0 = {}
	local var1 = string.split(arg1.effect_desc, "|")
	local var2 = 0

	if type(arg1.effect_attr) == "table" then
		for iter0, iter1 in ipairs(arg1.effect_attr) do
			var2 = var2 + 1

			table.insert(var0, {
				var0.STRENGTHEN_TYPE_ATTR,
				iter1,
				var1[var2] or ""
			})
		end

		arg1.effect_attr = nil
	end

	if arg1.effect_breakout ~= 0 then
		var2 = var2 + 1

		table.insert(var0, {
			var0.STRENGTHEN_TYPE_BREAKOUT,
			arg1.effect_breakout,
			var1[var2] or ""
		})

		arg1.effect_breakout = nil
	end

	if type(arg1.effect_skill) == "table" then
		var2 = var2 + 1

		table.insert(var0, {
			var0.STRENGTHEN_TYPE_SKILL,
			arg1.effect_skill,
			var1[var2] or ""
		})

		arg1.effect_skill = nil
	end

	if type(arg1.change_skill) == "table" then
		var2 = var2 + 1

		table.insert(var0, {
			var0.STRENGTHEN_TYPE_CHANGE_SKILL,
			arg1.change_skill,
			var1[var2] or ""
		})

		arg1.change_skill = nil
	end

	if type(arg1.effect_base) == "table" then
		var2 = var2 + 1

		table.insert(var0, {
			var0.STRENGTHEN_TYPE_BASE_LIST,
			arg1.effect_base,
			var1[var2] or ""
		})

		arg1.effect_base = nil
	end

	if type(arg1.effect_preload) == "table" then
		var2 = var2 + 1

		table.insert(var0, {
			var0.STRENGTHEN_TYPE_PRLOAD_COUNT,
			arg1.effect_preload,
			var1[var2] or ""
		})

		arg1.effect_preload = nil
	end

	if type(arg1.effect_dialog) == "table" then
		var2 = var2 + 1

		table.insert(var0, {
			var0.STRENGTHEN_TYPE_DIALOGUE,
			arg1.effect_dialog,
			var1[var2] or ""
		})

		arg1.effect_dialog = nil
	end

	if arg1.effect_skin ~= 0 then
		var2 = var2 + 1

		table.insert(var0, {
			var0.STRENGTHEN_TYPE_SKIN,
			arg1.effect_skin,
			var1[var2] or ""
		})

		arg1.effect_skin = nil
	end

	if type(arg1.effect_equipment_proficiency) == "table" then
		local var3 = var2 + 1

		table.insert(var0, {
			var0.STRENGTHEN_TYPE_EQUIPMENTPROFICIENCY,
			arg1.effect_equipment_proficiency,
			var1[var3] or ""
		})
	end

	arg1.special_effect = var0
end

function var0.updateInfo(arg0, arg1)
	arg0.startTime = arg1.start_time or 0
	arg0.shipId = arg1.ship_id or 0
	arg0.level = arg1.blue_print_level and math.min(arg1.blue_print_level, arg0:getMaxLevel()) or 0
	arg0.fateLevel = arg0.level == arg0:getMaxLevel() and arg1.blue_print_level - arg0:getMaxLevel() or -1
	arg0.exp = arg1.exp or 0
	arg0.duration = arg1.start_duration or 0

	arg0:updateState()
end

function var0.updateStartUpTime(arg0, arg1)
	arg0.duration = arg1
end

function var0.updateState(arg0)
	if arg0:isFetched() then
		arg0.state = var0.STATE_UNLOCK
	elseif arg0.startTime == 0 then
		arg0.state = var0.STATE_LOCK
	elseif arg0:isFinishedAllTasks() then
		arg0.state = var0.STATE_DEV_FINISHED
	else
		arg0.state = var0.STATE_DEV
	end
end

function var0.addExp(arg0, arg1)
	assert(arg1, "exp can not be nil")

	arg0.exp = arg0.exp + arg1

	local var0 = arg0:getMaxLevel()

	if var0 > arg0.level then
		while arg0:canLevelUp() do
			local var1 = arg0:getNextLevelExp()

			arg0.exp = arg0.exp - var1
			arg0.level = math.min(arg0.level + 1, var0)
		end

		if arg0.level == var0 then
			arg0.fateLevel = 0
		end
	end

	if arg0:canFateSimulation() then
		local var2 = arg0:getMaxFateLevel()

		while arg0:canFateLevelUp() do
			local var3 = arg0:getNextFateLevelExp()

			arg0.exp = arg0.exp - var3
			arg0.fateLevel = math.min(arg0.fateLevel + 1, var2)
		end
	end
end

function var0.getNextLevelExp(arg0)
	if arg0.level == arg0:getMaxLevel() then
		return -1
	else
		local var0 = arg0.level + 1

		return arg0.strengthenConfig[var0].need_exp
	end
end

function var0.getNextFateLevelExp(arg0)
	if arg0.fateLevel == arg0:getMaxFateLevel() then
		return -1
	else
		local var0 = arg0.fateLevel + 1

		return arg0.fateStrengthenConfig[var0].need_exp
	end
end

function var0.canLevelUp(arg0)
	if arg0.level == arg0:getMaxLevel() then
		return false
	end

	if arg0:getNextLevelExp() <= arg0.exp then
		return true
	end

	return false
end

function var0.canFateSimulation(arg0)
	return #arg0.fateStrengthenConfig > 0 and arg0.fateLevel >= 0
end

function var0.canFateLevelUp(arg0)
	if arg0.fateLevel == arg0:getMaxFateLevel() then
		return false
	end

	if arg0:getNextFateLevelExp() <= arg0.exp then
		return true
	end

	return false
end

function var0.getMaxLevel(arg0)
	return arg0.strengthenConfig[#arg0.strengthenConfig].lv
end

function var0.getMaxFateLevel(arg0)
	return arg0.fateStrengthenConfig[#arg0.fateStrengthenConfig].lv - 30
end

function var0.isMaxLevel(arg0)
	return arg0.level == arg0:getMaxLevel()
end

function var0.isMaxFateLevel(arg0)
	return arg0.fateLevel == arg0:getMaxFateLevel()
end

function var0.isMaxIntensifyLevel(arg0)
	if #arg0:getConfig("fate_strengthen") > 0 then
		return arg0:isMaxFateLevel()
	else
		return arg0:isMaxLevel()
	end
end

function var0.getBluePrintAddition(arg0, arg1)
	local var0 = table.indexof(ShipModAttr.BLUEPRINT_ATTRS, arg1)
	local var1 = arg0:getConfig("attr_exp")[var0]

	if var1 then
		local var2 = 0

		for iter0 = 1, arg0.level do
			var2 = var2 + arg0.strengthenConfig[iter0].effect[var0]
		end

		local var3 = 0

		if not arg0:isMaxLevel() then
			local var4 = arg0:getNextLevelExp()

			var3 = arg0.exp / var4 * arg0.strengthenConfig[arg0.level + 1].effect[var0]
		end

		local var5 = (var2 + var3) / var1
		local var6 = (var2 + var3) % var1

		return var5, var6
	else
		return 0, 0
	end
end

function var0.getShipVO(arg0)
	return Ship.New({
		configId = tonumber(arg0.id .. "1")
	})
end

function var0.isFetched(arg0)
	return arg0.shipId ~= 0
end

function var0.getState(arg0)
	return arg0.state
end

function var0.start(arg0, arg1)
	arg0.state = var0.STATE_DEV
	arg0.startTime = arg1
	arg0.duration = 0
end

function var0.reset(arg0)
	arg0.state = var0.STATE_LOCK
	arg0.startTime = 0
end

function var0.isLock(arg0)
	return arg0.state == var0.STATE_LOCK
end

function var0.isDeving(arg0)
	return arg0.state == var0.STATE_DEV
end

function var0.isFinished(arg0)
	return arg0.state == var0.STATE_DEV_FINISHED
end

function var0.finish(arg0)
	arg0.state = var0.STATE_DEV_FINISHED
end

function var0.unlock(arg0, arg1)
	arg0.shipId = arg1
	arg0.state = var0.STATE_UNLOCK
	arg0.duration = 0
end

function var0.isUnlock(arg0)
	return arg0.state == var0.STATE_UNLOCK
end

function var0.getItemId(arg0)
	return arg0:getConfig("strengthen_item")
end

function var0.bindConfigTable(arg0)
	return pg.ship_data_blueprint
end

function var0.getTaskIds(arg0)
	return _.map(arg0:getConfig("unlock_task"), function(arg0)
		return arg0[1]
	end)
end

function var0.getTaskOpenTimeStamp(arg0, arg1)
	local var0 = table.indexof(arg0:getTaskIds(), arg1)

	return arg0:getConfig("unlock_task")[var0][2] + arg0.startTime + 1
end

function var0.isFinishedAllTasks(arg0)
	local var0 = getProxy(TaskProxy)

	return _.all(arg0:getTaskIds(), function(arg0)
		return arg0:getTaskStateById(arg0) == var0.TASK_STATE_FINISHED
	end)
end

function var0.getTaskStateById(arg0, arg1)
	if arg0:isLock() then
		if arg0.duration > 0 then
			return var0.TASK_STATE_PAUSE
		else
			return var0.TASK_STATE_LOCK
		end
	elseif arg0:getTaskOpenTimeStamp(arg1) > pg.TimeMgr.GetInstance():GetServerTime() then
		return var0.TASK_STATE_WAIT
	else
		local var0 = getProxy(TaskProxy):getTaskVO(arg1)

		if var0 and var0:isReceive() then
			return var0.TASK_STATE_FINISHED
		elseif var0 and var0:isFinish() then
			return var0.TASK_STATE_ACHIEVED
		elseif var0 then
			return var0.TASK_STATE_START
		else
			return var0.TASK_STATE_OPENING
		end
	end
end

function var0.getExpRetio(arg0, arg1)
	local var0 = arg0:getConfig("attr_exp")

	assert(arg1 > 0 and arg1 <= #var0, "invalid index" .. arg1)

	return var0[arg1]
end

function var0.specialStrengthens(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.strengthenConfig) do
		if iter1.special == 1 then
			table.insert(var0, {
				des = iter1.special_effect,
				extraDes = iter1.extra_desc,
				level = iter1.lv
			})
		end
	end

	return var0
end

function var0.getSpecials(arg0)
	return arg0.strengthenConfig[arg0.level].special_effect
end

function var0.getTopLimitAttrValue(arg0, arg1)
	if arg0.level == 0 then
		return 0
	else
		local var0 = arg0.strengthenConfig[arg0.level].effect
		local var1 = var0[arg1]

		assert(var0[arg1], "strengthen config effect" .. arg1)

		local var2 = arg0:getConfig("attr_exp")[arg1]

		return math.floor(var1 / var2)
	end
end

function var0.getItemExp(arg0)
	local var0 = arg0:getConfig("strengthen_item")

	return Item.getConfigData(var0).usage_arg[1]
end

function var0.getShipProperties(arg0, arg1, arg2)
	assert(arg1, "shipVO can not be nil" .. arg0.shipId)

	local var0 = arg1:getBaseProperties()

	arg2 = defaultValue(arg2, true)

	local var1 = arg0:getTotalAdditions()

	for iter0, iter1 in pairs(var0) do
		var0[iter0] = var0[iter0] + (var1[iter0] or 0)
	end

	if arg1:getIntimacyLevel() > 0 and arg2 then
		local var2 = pg.intimacy_template[arg1:getIntimacyLevel()].attr_bonus * 0.0001

		for iter2, iter3 in pairs(var0) do
			if iter2 == AttributeType.Durability or iter2 == AttributeType.Cannon or iter2 == AttributeType.Torpedo or iter2 == AttributeType.AntiAircraft or iter2 == AttributeType.Air or iter2 == AttributeType.Reload or iter2 == AttributeType.Hit or iter2 == AttributeType.AntiSub or iter2 == AttributeType.Dodge then
				var0[iter2] = var0[iter2] * (var2 + 1)
			end
		end
	end

	return var0
end

function var0.getTotalAdditions(arg0)
	local var0 = {}
	local var1 = arg0:attrSpecialAddition()

	for iter0, iter1 in ipairs(Ship.PROPERTIES) do
		local var2, var3 = arg0:getBluePrintAddition(iter1)

		var0[iter1] = var2 + (var1[iter1] or 0)
	end

	return var0
end

function var0.attrSpecialAddition(arg0)
	local var0 = {}

	for iter0 = 1, arg0.level do
		local var1 = arg0.strengthenConfig[iter0]

		if var1.special == 1 and type(var1.special_effect) == "table" then
			for iter1, iter2 in ipairs(var1.special_effect) do
				if iter2[1] == var0.STRENGTHEN_TYPE_ATTR then
					local var2 = iter2[2]

					var0[var2[1]] = (var0[var2[1]] or 0) + var2[2]
				end
			end
		end
	end

	for iter3 = 1, arg0.fateLevel do
		local var3 = arg0.fateStrengthenConfig[iter3]

		if var3.special == 1 and type(var3.special_effect) == "table" then
			for iter4, iter5 in ipairs(var3.special_effect) do
				if iter5[1] == var0.STRENGTHEN_TYPE_ATTR then
					local var4 = iter5[2]

					var0[var4[1]] = (var0[var4[1]] or 0) + var4[2]
				end
			end
		end
	end

	return var0
end

function var0.getUseageMaxItem(arg0)
	local var0 = 0

	for iter0 = arg0.level + 1, arg0:getMaxLevel() do
		assert(arg0.strengthenConfig[iter0], "strengthen config >> " .. iter0)

		var0 = var0 + arg0.strengthenConfig[iter0].need_exp
	end

	return math.max(math.ceil((var0 - arg0.exp) / arg0:getItemExp()), 0)
end

function var0.getFateUseageMaxItem(arg0)
	local var0 = 0

	for iter0 = arg0.fateLevel + 1, arg0:getMaxFateLevel() do
		assert(arg0.fateStrengthenConfig[iter0], "strengthen config >> " .. iter0)

		var0 = var0 + arg0.fateStrengthenConfig[iter0].need_exp
	end

	return math.max(math.ceil((var0 - arg0.exp) / arg0:getItemExp()), 0)
end

function var0.getOpenTaskList(arg0)
	return arg0:getConfig("unlock_task_open_condition")
end

function var0.getStrengthenConfig(arg0, arg1)
	return arg0.strengthenConfig[arg1]
end

function var0.getFateStrengthenConfig(arg0, arg1)
	return arg0.fateStrengthenConfig[arg1]
end

function var0.getUnlockVoices(arg0)
	local var0 = {}

	for iter0 = 1, arg0.level do
		local var1 = arg0:getStrengthenConfig(iter0)

		if var1.special == 1 then
			local var2 = var1.special_effect

			if type(var2) == "table" then
				for iter1, iter2 in ipairs(var2) do
					if iter2[1] == var0.STRENGTHEN_TYPE_DIALOGUE then
						for iter3, iter4 in ipairs(iter2[2]) do
							table.insert(var0, iter4)
						end
					end
				end
			end
		end
	end

	return var0
end

function var0.getUnlockLevel(arg0, arg1)
	local var0 = arg0:getMaxLevel()

	for iter0 = 1, var0 do
		local var1 = arg0:getStrengthenConfig(iter0).special_effect

		if type(var1) == "table" then
			for iter1, iter2 in ipairs(var1) do
				if iter2[1] == var0.STRENGTHEN_TYPE_DIALOGUE then
					for iter3, iter4 in ipairs(iter2[2]) do
						if arg1 == iter4 then
							return iter0
						end
					end
				end
			end
		end
	end

	return 0
end

function var0.getBaseList(arg0, arg1)
	assert(arg1, "shipVO can not be nil" .. arg0.shipId)

	for iter0 = arg0.level, 1, -1 do
		local var0 = arg0:getStrengthenConfig(iter0)

		if var0.special == 1 then
			local var1 = var0.special_effect

			for iter1, iter2 in ipairs(var1) do
				if iter2[1] == var0.STRENGTHEN_TYPE_BASE_LIST then
					return iter2[2]
				end
			end
		end
	end

	return arg1:getConfig("base_list")
end

function var0.getPreLoadCount(arg0, arg1)
	assert(arg1, "shipVO can not be nil" .. arg0.shipId)

	for iter0 = arg0.level, 1, -1 do
		local var0 = arg0:getStrengthenConfig(iter0)

		if var0.special == 1 then
			local var1 = var0.special_effect

			for iter1, iter2 in ipairs(var1) do
				if iter2[1] == var0.STRENGTHEN_TYPE_PRLOAD_COUNT then
					return iter2[2]
				end
			end
		end
	end

	return arg1:getConfig("preload_count")
end

function var0.getEquipProficiencyList(arg0, arg1)
	assert(arg1, "shipVO can not be nil" .. arg0.shipId)

	local var0 = {}

	for iter0 = 1, arg0.level do
		local var1 = arg0:getStrengthenConfig(iter0)

		if var1.special == 1 then
			local var2 = var1.special_effect

			for iter1, iter2 in ipairs(var2) do
				if iter2[1] == var0.STRENGTHEN_TYPE_EQUIPMENTPROFICIENCY then
					local var3 = iter2[2][1]
					local var4 = iter2[2][2]

					var0[var3] = (var0[var3] or 0) + var4
				end
			end
		end
	end

	local var5 = Clone(arg1:getConfig("equipment_proficiency"))

	for iter3, iter4 in pairs(var0) do
		var5[iter3] = var5[iter3] + iter4
	end

	return var5
end

function var0.isFinishPrevTask(arg0)
	local var0 = true
	local var1 = true

	for iter0, iter1 in ipairs(arg0:getOpenTaskList()) do
		local var2 = getProxy(TaskProxy):getTaskVO(iter1)

		if not var2 or not var2:isFinish() then
			return false, false
		else
			var1 = (var2:isReceive() or false) and var1
		end
	end

	return var0, var1
end

function var0.isShipModMaxLevel(arg0, arg1)
	assert(arg1, "shipVO can not be nil" .. arg0.shipId)

	local var0 = arg0:getStrengthenConfig(math.min(arg0.level + 1, arg0:getMaxLevel()))

	if not arg0:isMaxLevel() and arg1.level < var0.need_lv then
		return true, var0.need_lv
	else
		return false
	end
end

function var0.isShipModMaxFateLevel(arg0, arg1)
	assert(arg1, "shipVO can not be nil" .. arg0.shipId)

	local var0 = arg0:getFateStrengthenConfig(math.min(arg0.fateLevel + 1, arg0:getMaxFateLevel()))

	if not arg0:isMaxFateLevel() and arg1.level < var0.need_lv then
		return true, var0.need_lv
	else
		return false
	end
end

function var0.isShipModMaxIntensifyLevel(arg0, arg1)
	if arg0:canFateSimulation() then
		return arg0:isShipModMaxFateLevel(arg1)
	else
		return arg0:isShipModMaxLevel(arg1)
	end
end

function var0.getChangeSkillList(arg0)
	return arg0:getConfig("change_skill")
end

function var0.isRarityUR(arg0)
	return arg0:getShipVO():getRarity() >= ShipRarity.SSR
end

function var0.getFateMaxLeftOver(arg0)
	local var0 = arg0:isRarityUR() and pg.gameset.fate_sim_ur.key_value or pg.gameset.fate_sim_ssr.key_value
	local var1 = var0 - arg0:getFateUseNum()

	return var1 < 0 and var0 or var1
end

function var0.getFateUseNum(arg0)
	local var0 = 0

	if arg0:isMaxLevel() then
		local var1 = 0

		for iter0, iter1 in ipairs(arg0.fateStrengthenConfig) do
			if iter1.lv <= 30 + arg0.fateLevel then
				var1 = var1 + iter1.need_exp
			end
		end

		local var2 = var1 + arg0.exp
		local var3 = arg0:getItemExp()

		var0 = math.floor(var2 / var3)
	end

	return var0
end

function var0.isPursuing(arg0)
	return arg0:getConfig("is_pursuing") == 1
end

function var0.getPursuingPrice(arg0, arg1)
	arg1 = arg1 or 100

	return arg0:getConfig("price") * arg1 / 100
end

function var0.getUnlockItem(arg0)
	local var0 = getProxy(BagProxy)

	for iter0, iter1 in ipairs(arg0:getConfig("gain_item_id")) do
		if var0:getItemCountById(iter1) > 0 then
			return iter1
		end
	end
end

function var0.isPursuingCostTip(arg0)
	return arg0:isPursuing() and arg0:isUnlock() and not arg0:isMaxIntensifyLevel() and not arg0:isShipModMaxIntensifyLevel(getProxy(BayProxy):getShipById(arg0.shipId)) and getProxy(TechnologyProxy):calcPursuingCost(arg0, 1) == 0
end

return var0
