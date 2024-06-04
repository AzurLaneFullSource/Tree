local var0 = import(".Chapter")

function var0.update(arg0, arg1)
	assert(arg1.id == arg0.id, "章节ID不一致, 无法更新数据")

	arg0.active = true
	arg0.dueTime = arg1.time
	arg0.loopFlag = arg1.loop_flag
	arg0.modelCount = arg1.model_act_count
	arg0.roundIndex = arg1.round
	arg0.subAutoAttack = arg1.is_submarine_auto_attack
	arg0.barriers = 0
	arg0.pathFinder = OrientedPathFinding.New({}, ChapterConst.MaxRow, ChapterConst.MaxColumn)
	arg0.wallAssets = {}

	if arg0:getConfig("wall_prefab") and #arg0:getConfig("wall_prefab") > 0 then
		for iter0, iter1 in ipairs(arg0:getConfig("wall_prefab")) do
			arg0.wallAssets[iter1[1] .. "_" .. iter1[2]] = iter1
		end
	end

	arg0.winConditions = {}

	local var0 = arg0:getConfig("win_condition")

	assert(var0, "Assure Chapter's WIN Conditions is not empty")

	for iter2, iter3 in pairs(var0) do
		table.insert(arg0.winConditions, {
			type = iter3[1],
			param = iter3[2]
		})
	end

	arg0.loseConditions = {}

	local var1 = arg0:getConfig("lose_condition")

	assert(var1, "Assure Chapter's LOSE Conditions is not empty")

	for iter4, iter5 in pairs(var1) do
		table.insert(arg0.loseConditions, {
			type = iter5[1],
			param = iter5[2]
		})
	end

	arg0.theme = ChapterTheme.New(arg0:getConfig("theme"))

	local var2 = arg1.cell_list
	local var3 = arg1.cell_flag_list
	local var4 = arg0:getConfig("float_items")
	local var5 = arg0:getConfig("grids")

	arg0.cells = {}
	arg0.cellAttachments = {}

	local function var6(arg0)
		local var0 = ChapterCell.Line2Name(arg0.pos.row, arg0.pos.column)

		if arg0.item_type == ChapterConst.AttachStory and arg0.item_data == ChapterConst.StoryTrigger then
			if arg0.cellAttachments[var0] then
				warning("Multi Cell Attachemnts in one cell " .. arg0.pos.row .. " " .. arg0.pos.column)
			end

			arg0.cellAttachments[var0] = ChapterCell.New(arg0)
			arg0 = {
				item_id = 0,
				item_data = 0,
				item_flag = 0,
				pos = {
					row = arg0.pos.row,
					column = arg0.pos.column
				},
				item_type = ChapterConst.AttachNone
			}
		end

		if not arg0.cells[var0] or arg0.cells[var0].attachment == ChapterConst.AttachNone then
			local var1 = ChapterCell.New(arg0)

			if var1.attachment == ChapterConst.AttachOni_Target or var1.attachment == ChapterConst.AttachOni then
				var1.attachment = ChapterConst.AttachNone
			end

			local var2 = _.detect(var4, function(arg0)
				return arg0[1] == var1.row and arg0[2] == var1.column
			end)

			if var2 then
				var1.item = var2[3]
				var1.itemOffset = Vector2(var2[4], var2[5])
			end

			arg0.cells[var0] = var1

			return var1
		end
	end

	_.each(var2, function(arg0)
		var6(arg0)
	end)
	_.each(var5, function(arg0)
		local var0 = ChapterCell.Line2Name(arg0[1], arg0[2])

		;(arg0.cells[var0] or var6({
			pos = {
				row = arg0[1],
				column = arg0[2]
			},
			item_type = ChapterConst.AttachNone
		})):SetWalkable(arg0[3])
	end)

	arg0.indexMin, arg0.indexMax = Vector2(ChapterConst.MaxRow, ChapterConst.MaxColumn), Vector2(-ChapterConst.MaxRow, -ChapterConst.MaxColumn)

	_.each(var5, function(arg0)
		arg0.indexMin.x = math.min(arg0.indexMin.x, arg0[1])
		arg0.indexMin.y = math.min(arg0.indexMin.y, arg0[2])
		arg0.indexMax.x = math.max(arg0.indexMax.x, arg0[1])
		arg0.indexMax.y = math.max(arg0.indexMax.y, arg0[2])
	end)
	_.each(var3 or {}, function(arg0)
		local var0 = ChapterCell.Line2Name(arg0.pos.row, arg0.pos.column)
		local var1 = arg0.cells[var0]

		assert(var1, "Attach cellFlaglist On NIL Cell " .. var0)

		if var1 then
			var1:updateFlagList(arg0)
		end
	end)

	arg0.buff_list = {}

	if arg1.buff_list then
		for iter6, iter7 in ipairs(arg1.buff_list) do
			arg0.buff_list[iter6] = iter7
		end
	end

	arg0.operationBuffList = {}

	for iter8, iter9 in ipairs(arg1.operation_buff) do
		arg0.operationBuffList[#arg0.operationBuffList + 1] = iter9
	end

	local var7 = arg0:getNpcShipByType()

	arg0.fleets = {}

	for iter10, iter11 in ipairs(arg1.group_list) do
		local var8 = ChapterFleet.New(iter11, var7)

		var8:setup(arg0)

		arg0.fleets[iter10] = var8
	end

	arg0.fleets = _.sort(arg0.fleets, function(arg0, arg1)
		return arg0.id < arg1.id
	end)

	if arg1.escort_list then
		for iter12, iter13 in ipairs(arg1.escort_list) do
			arg0.fleets[#arg0.fleets + 1] = ChapterTransportFleet.New(iter13, #arg0.fleets + 1)
		end
	end

	arg0.findex = 0
	arg0.findex = arg0:getNextValidIndex()

	if arg0.findex == 0 then
		arg0.findex = 1
	end

	arg0.champions = {}

	if arg1.ai_list then
		for iter14, iter15 in ipairs(arg1.ai_list) do
			if iter15.item_flag ~= 1 then
				local var9 = ChapterChampionPackage.New(iter15)

				arg0:mergeChampion(var9, true)
			end
		end
	end

	arg0.airDominanceStatus = nil
	arg0.extraFlagList = {}

	for iter16, iter17 in ipairs(arg1.extra_flag_list) do
		table.insert(arg0.extraFlagList, iter17)
	end

	arg0.defeatEnemies = arg1.kill_count or 0
	arg0.BaseHP = arg1.chapter_hp or 0
	arg0.orignalShipCount = arg1.init_ship_count or 0
	arg0.combo = arg1.continuous_kill_count or 0
	arg0.scoreHistory = {}

	for iter18 = ys.Battle.BattleConst.BattleScore.D, ys.Battle.BattleConst.BattleScore.S do
		arg0.scoreHistory[iter18] = 0
	end

	if arg1.battle_statistics then
		for iter19, iter20 in ipairs(arg1.battle_statistics) do
			arg0.scoreHistory[iter20.id] = iter20.count
		end
	end

	local var10 = {}

	if arg1.chapter_strategy_list then
		for iter21, iter22 in ipairs(arg1.chapter_strategy_list) do
			var10[iter22.id] = iter22.count
		end
	end

	arg0.strategies = var10
	arg0.duties = {}

	if #arg1.fleet_duties > 0 then
		_.each(arg1.fleet_duties, function(arg0)
			arg0.duties[arg0.key] = arg0.value
		end)
	end

	arg0.moveStep = arg1.move_step_count or 0
	arg0.activateAmbush = not arg0:isLoop() and arg0:GetWillActiveAmbush()
end

function var0.retreat(arg0, arg1)
	if arg1 then
		arg0.todayDefeatCount = arg0.todayDefeatCount + 1

		arg0:updateTodayDefeatCount()
	end
end

function var0.CleanLevelData(arg0)
	arg0.active = false
	arg0.loopFlag = 0
	arg0.dueTime = nil
	arg0.cells = nil
	arg0.fleets = nil
	arg0.findex = nil
	arg0.champions = nil
	arg0.cellAttachments = nil
	arg0.round = nil
	arg0.airDominanceStatus = nil
	arg0.winConditions, arg0.loseConditions = nil
	arg0.theme = nil
	arg0.buff_list = nil
	arg0.operationBuffList = nil
	arg0.modelCount = nil
	arg0.roundIndex = nil
	arg0.subAutoAttack = nil
	arg0.barriers = nil
	arg0.pathFinder = nil
	arg0.wallAssets = nil
	arg0.strategies = nil
	arg0.duties = nil
	arg0.indexMin, arg0.indexMax = nil
	arg0.extraFlagList = nil
	arg0.defeatEnemies = nil
	arg0.BaseHP = nil
	arg0.orignalShipCount = nil
	arg0.combo = nil
	arg0.scoreHistory = nil
end

function var0.__index(arg0, arg1)
	if arg1 == "fleet" then
		local var0 = rawget(arg0, "fleets")

		if not var0 then
			return nil
		end

		return var0[rawget(arg0, "findex")]
	end

	return rawget(arg0, arg1) or var0[arg1]
end

function var0.GetActiveFleet(arg0)
	if not arg0.fleets then
		return nil
	end

	return arg0.fleets[arg0.findex]
end

function var0.getFleetById(arg0, arg1)
	return _.detect(arg0.fleets, function(arg0)
		return arg0.id == arg1
	end)
end

function var0.getChapterSupportFleet(arg0)
	return table.Find(arg0.fleets, function(arg0, arg1)
		return arg1:getFleetType() == FleetType.Support
	end)
end

function var0.getFleetByShipVO(arg0, arg1)
	local var0 = arg1.id
	local var1

	for iter0, iter1 in ipairs(arg0.fleets) do
		if iter1:getShip(var0) then
			var1 = iter1

			break
		end
	end

	return var1
end

function var0.getRound(arg0)
	return arg0.roundIndex % 2
end

function var0.getRoundNum(arg0)
	return math.floor(arg0.roundIndex / 2)
end

function var0.IncreaseRound(arg0)
	arg0.roundIndex = arg0.roundIndex + 1
end

function var0.existMoveLimit(arg0)
	return arg0:getConfig("is_limit_move") == 1 or arg0:existOni() or arg0:isPlayingWithBombEnemy()
end

function var0.getChapterCell(arg0, arg1, arg2)
	local var0 = ChapterCell.Line2Name(arg1, arg2)

	return Clone(arg0.cells[var0])
end

function var0.GetRawChapterCell(arg0, arg1, arg2)
	local var0 = ChapterCell.Line2Name(arg1, arg2)

	return arg0.cells[var0]
end

function var0.FilterCell(arg0, arg1)
	return table.Checkout(arg0.cells, arg1)
end

function var0.findChapterCell(arg0, arg1, arg2)
	for iter0, iter1 in pairs(arg0.cells) do
		if iter1.attachment == arg1 and (not arg2 or iter1.attachmentId == arg2) then
			return iter1
		end
	end

	return nil
end

function var0.findChapterCells(arg0, arg1, arg2)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.cells) do
		if iter1.attachment == arg1 and (not arg2 or iter1.attachmentId == arg2) then
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var0.GetBossCell(arg0)
	return table.Find(arg0.cells, function(arg0, arg1)
		return ChapterConst.IsBossCell(arg1)
	end)
end

function var0.mergeChapterCell(arg0, arg1, arg2)
	local var0 = ChapterCell.Line2Name(arg1.row, arg1.column)
	local var1 = arg0.cells[var0]
	local var2 = var1 == nil or var1.attachment ~= arg1.attachment or var1.attachmentId ~= arg1.attachmentId

	if var1 then
		var1.attachment = arg1.attachment
		var1.attachmentId = arg1.attachmentId
		var1.flag = arg1.flag
		var1.data = arg1.data
		arg1 = var1
	end

	if not arg2 and var2 and ChapterConst.NeedMarkAsLurk(arg1) then
		arg1.trait = ChapterConst.TraitLurk
	end

	if ChapterConst.IsBossCell(arg1) then
		local var3 = arg0:getChampionIndex(arg1.row, arg1.column)

		if var3 then
			table.remove(arg0.champions, var3)
		end
	end

	arg0:updateChapterCell(arg1)
end

function var0.updateChapterCell(arg0, arg1)
	local var0 = ChapterCell.Line2Name(arg1.row, arg1.column)

	arg0.cells[var0] = Clone(arg1)
end

function var0.clearChapterCell(arg0, arg1, arg2)
	local var0 = ChapterCell.Line2Name(arg1, arg2)
	local var1 = arg0.cells[var0]

	var1.attachment = ChapterConst.AttachNone
	var1.attachmentId = 0
	var1.flag = ChapterConst.CellFlagActive
	var1.data = 0
	var1.trait = ChapterConst.TraitNone
end

function var0.GetChapterCellAttachemnts(arg0)
	return arg0.cellAttachments
end

function var0.GetRawChapterAttachemnt(arg0, arg1, arg2)
	local var0 = ChapterCell.Line2Name(arg1, arg2)

	return arg0.cellAttachments[var0]
end

function var0.getShips(arg0)
	local var0 = {}

	_.each(arg0.fleets, function(arg0)
		local var0 = arg0:getShips(true)

		_.each(var0, function(arg0)
			table.insert(var0, Clone(arg0))
		end)
	end)

	return var0
end

function var0.getNextValidIndex(arg0)
	for iter0 = arg0.findex + 1, #arg0.fleets do
		if arg0.fleets[iter0]:getFleetType() == FleetType.Normal and arg0.fleets[iter0]:isValid() then
			return iter0
		end
	end

	for iter1 = 1, arg0.findex - 1 do
		if arg0.fleets[iter1]:getFleetType() == FleetType.Normal and arg0.fleets[iter1]:isValid() then
			return iter1
		end
	end

	return 0
end

function var0.getAmbushRate(arg0, arg1, arg2)
	local var0 = arg1:getInvestSums()
	local var1 = arg0:getConfig("investigation_ratio")
	local var2 = var1 / (var1 + var0) / 4
	local var3 = _.detect(arg0:getConfig("ambush_ratio_extra"), function(arg0)
		return arg0[1] == arg2.row and arg0[2] == arg2.column
	end)
	local var4 = _.detect(arg0:getConfig("ambush_ratio_extra"), function(arg0)
		return #arg0 == 1
	end)
	local var5

	var5 = var3 and var3[3] / 10000 or 0

	local var6 = var5 + (var4 and var4[1] / 10000 or 0)
	local var7 = 0.05 + var2 * math.max(arg1.step - 1, 0) + var6

	if var6 == 0 then
		var7 = var7 - arg1:getEquipAmbushRateReduce()
	end

	return (math.clamp(var7, 0, 1))
end

function var0.getAmbushDodge(arg0, arg1)
	local var0 = arg1.line
	local var1 = arg1:getDodgeSums()
	local var2 = var1 / (var1 + arg0:getConfig("avoid_ratio"))
	local var3 = _.detect(arg0:getConfig("ambush_ratio_extra"), function(arg0)
		return arg0[1] == var0.row and arg0[2] == var0.column
	end)
	local var4

	var4 = var3 and var3[3] / 10000 or 0

	if var4 == 0 then
		var2 = var2 + arg1:getEquipDodgeRateUp()
	end

	return (math.clamp(var2, 0, 1))
end

function var0.inWartime(arg0)
	return arg0.dueTime and pg.TimeMgr.GetInstance():GetServerTime() < arg0.dueTime
end

function var0.inActTime(arg0)
	local var0 = arg0:GetBindActID()

	if var0 == 0 then
		return true
	end

	local var1 = var0 and getProxy(ActivityProxy):getActivityById(var0)

	return var1 and not var1:isEnd()
end

function var0.getRemainTime(arg0)
	return arg0.dueTime and math.max(arg0.dueTime - pg.TimeMgr.GetInstance():GetServerTime() - 1, 0) or 0
end

function var0.getStartTime(arg0)
	return math.max(arg0.dueTime - arg0:getConfig("time"), 0)
end

function var0.GetWillActiveAmbush(arg0)
	if not arg0:existAmbush() then
		return false
	end

	local var0 = arg0:getConfig("avoid_require")

	return not _.any(arg0.fleets, function(arg0)
		return arg0:getFleetType() == FleetType.Normal and arg0:getInvestSums(true) >= var0
	end)
end

function var0.findPath(arg0, arg1, arg2, arg3)
	local var0 = {}

	for iter0 = 0, ChapterConst.MaxRow - 1 do
		var0[iter0] = var0[iter0] or {}

		for iter1 = 0, ChapterConst.MaxColumn - 1 do
			var0[iter0][iter1] = var0[iter0][iter1] or {}

			local var1 = PathFinding.PrioForbidden
			local var2 = ChapterConst.ForbiddenAll
			local var3 = ChapterCell.Line2Name(iter0, iter1)
			local var4 = arg0.cells[var3]

			if var4 and var4:IsWalkable() then
				var1 = PathFinding.PrioNormal

				if arg0:considerAsObstacle(arg1, var4.row, var4.column) then
					var1 = PathFinding.PrioObstacle
				end

				if arg1 == ChapterConst.SubjectPlayer then
					var2 = var4.forbiddenDirections
				else
					var2 = ChapterConst.ForbiddenNone
				end
			end

			var0[iter0][iter1].forbiddens = var2
			var0[iter0][iter1].priority = var1
		end
	end

	if arg1 == ChapterConst.SubjectPlayer then
		local var5 = arg0:getCoastalGunArea()

		for iter2, iter3 in ipairs(var5) do
			var0[iter3.row][iter3.column].priority = math.max(var0[iter3.row][iter3.column].priority, PathFinding.PrioObstacle)
		end
	end

	local var6 = var0[arg3.row] and var0[arg3.row][arg3.column]

	if var6 then
		var6.priority = arg0:considerAsStayPoint(arg1, arg3.row, arg3.column) and PathFinding.PrioNormal or PathFinding.PrioObstacle
	end

	arg0.pathFinder.cells = var0

	return arg0.pathFinder:Find(arg2, arg3)
end

function var0.FindBossPath(arg0, arg1, arg2)
	local var0 = ChapterConst.SubjectPlayer
	local var1 = {}

	for iter0 = 0, ChapterConst.MaxRow - 1 do
		var1[iter0] = var1[iter0] or {}

		for iter1 = 0, ChapterConst.MaxColumn - 1 do
			var1[iter0][iter1] = var1[iter0][iter1] or {}

			local var2 = PathFinding.PrioForbidden
			local var3 = ChapterConst.ForbiddenAll
			local var4
			local var5 = ChapterCell.Line2Name(iter0, iter1)
			local var6 = arg0.cells[var5]

			if var6 and var6:IsWalkable() then
				var2 = PathFinding.PrioNormal

				if arg0:considerAsObstacle(var0, var6.row, var6.column) then
					var2 = PathFinding.PrioObstacle
				end

				local var7 = arg0:GetEnemy(var6.row, var6.column)

				if var7 then
					var2 = PathFinding.PrioNormal
					var4 = not ChapterConst.IsBossCell(var7)
				end

				var3 = var6.forbiddenDirections
			end

			var1[iter0][iter1].forbiddens = var3
			var1[iter0][iter1].priority = var2
			var1[iter0][iter1].isEnemy = var4
		end
	end

	local var8 = arg0:getCoastalGunArea()

	for iter2, iter3 in ipairs(var8) do
		var1[iter3.row][iter3.column].priority = math.max(var1[iter3.row][iter3.column].priority, PathFinding.PrioObstacle)
	end

	local var9 = var1[arg2.row] and var1[arg2.row][arg2.column]

	if var9 then
		var9.priority = arg0:considerAsStayPoint(var0, arg2.row, arg2.column) and PathFinding.PrioNormal or PathFinding.PrioObstacle
	end

	return OrientedWeightPathFinding.StaticFind(var1, ChapterConst.MaxRow, ChapterConst.MaxColumn, arg1, arg2)
end

function var0.getWaveCount(arg0)
	local var0 = 0

	for iter0, iter1 in pairs(arg0.cells) do
		if iter1.attachment == ChapterConst.AttachEnemy and underscore.detect(arg0:getConfig("grids"), function(arg0)
			if arg0[1] == iter1.row and arg0[2] == iter1.column and (arg0[4] == ChapterConst.AttachElite or arg0[4] == ChapterConst.AttachEnemy) then
				return true
			end

			return false
		end) then
			var0 = var0 + 1
		end
	end

	local var1 = 0
	local var2 = pg.chapter_group_refresh[arg0.id]

	if var2 then
		local var3 = 1

		repeat
			local var4 = false

			for iter2, iter3 in ipairs(var2.enemy_refresh) do
				var1 = var1 + (iter3[var3] or 0)
				var4 = var4 or tobool(iter3[var3])
			end

			if var0 <= var1 then
				return var3
			end

			var3 = var3 + 1
		until not var4
	else
		local var5 = arg0:getConfig("enemy_refresh")
		local var6 = arg0:getConfig("elite_refresh")

		for iter4, iter5 in pairs(var5) do
			var1 = var1 + iter5

			if iter4 <= #var6 then
				var1 = var1 + var6[iter4]
			end

			if var0 <= var1 then
				return iter4
			end
		end
	end

	return 1
end

function var0.IsFinalBossRefreshed(arg0)
	return tobool(arg0:findChapterCell(ChapterConst.AttachBoss))
end

function var0.getFleetAmmo(arg0, arg1)
	local var0 = arg1:getShipAmmo()
	local var1 = arg1:getFleetType()

	if var1 == FleetType.Normal then
		var0 = var0 + arg0:getConfig("ammo_total")
	elseif var1 == FleetType.Submarine then
		var0 = var0 + arg0:getConfig("ammo_submarine")
	else
		assert(false, "invalide operation.")
	end

	local var2 = arg1.restAmmo

	return var0, var2
end

function var0.GetInteractableStrategies(arg0)
	local var0 = arg0.fleet:getStrategies()
	local var1 = _.filter(var0, function(arg0)
		local var0 = pg.strategy_data_template[arg0.id]

		return var0 and var0.type ~= ChapterConst.StgTypeBindFleetPassive
	end)
	local var2 = arg0.fleet:getFormationStg()

	table.insert(var1, 1, {
		id = var2
	})

	if arg0:GetSubmarineFleet() then
		table.insert(var1, 3, {
			id = ChapterConst.StrategyHuntingRange
		})
		table.insert(var1, 4, {
			id = ChapterConst.StrategySubAutoAttack
		})
		table.insert(var1, 5, {
			id = ChapterConst.StrategySubTeleport
		})
	end

	local var3 = arg0:getChapterSupportFleet()

	if var3 then
		table.insertto(var1, _.filter(var3:getStrategies(), function(arg0)
			local var0 = pg.strategy_data_template[arg0.id]

			return var0 and var0.type == ChapterConst.StgTypeBindSupportConsume
		end))
	end

	if #arg0.strategies > 0 then
		for iter0, iter1 in pairs(arg0.strategies) do
			table.insert(var1, {
				id = iter0,
				count = iter1
			})
		end
	end

	return var1
end

function var0.getFleetStates(arg0, arg1)
	local var0 = {}
	local var1, var2 = arg0:getFleetAmmo(arg1)

	if var2 >= ChapterConst.AmmoRich then
		table.insert(var0, ChapterConst.StrategyAmmoRich)
	elseif var2 <= ChapterConst.AmmoPoor then
		table.insert(var0, ChapterConst.StrategyAmmoPoor)
	end

	local var3 = underscore.filter(arg1:getStrategies(), function(arg0)
		local var0 = pg.strategy_data_template[arg0.id]

		return var0 and var0.type == ChapterConst.StgTypeBindFleetPassive and arg0.count > 0
	end)

	table.insertto(var0, underscore.map(var3, function(arg0)
		return arg0.id
	end))
	table.insertto(var0, arg1.stgIds)

	local var4 = arg0:getConfig("chapter_strategy")

	for iter0, iter1 in ipairs(var4) do
		table.insert(var0, iter1)
	end

	if OPEN_AIR_DOMINANCE and arg0:getConfig("air_dominance") > 0 then
		table.insert(var0, arg0:getAirDominanceStg())
	end

	for iter2, iter3 in ipairs(arg0:getExtraFlags()) do
		table.insert(var0, ChapterConst.Status2Stg[iter3])
	end

	local var5 = arg0:getOperationBuffDescStg()

	if var5 then
		table.insert(var0, var5)
	end

	underscore.each(arg0.buff_list, function(arg0)
		if ChapterConst.Buff2Stg[arg0] then
			table.insert(var0, ChapterConst.Buff2Stg[arg0])
		end
	end)

	if arg0:getPlayType() == ChapterConst.TypeDOALink then
		local var6 = arg0:GetBuffOfLinkAct()

		if var6 then
			local var7 = pg.gameset.doa_fever_buff.description

			table.insert(var0, pg.gameset.doa_fever_strategy.description[table.indexof(var7, var6)])
		end
	end

	return var0
end

function var0.GetShowingStrategies(arg0)
	local var0 = arg0.fleet
	local var1 = arg0:getFleetStates(var0)

	return (_.filter(var1, function(arg0)
		local var0 = pg.strategy_data_template[arg0]

		return var0 and var0.icon ~= ""
	end))
end

function var0.getAirDominanceStg(arg0)
	local var0, var1 = arg0:getAirDominanceValue()

	return ChapterConst.AirDominance[var1].StgId
end

function var0.getAirDominanceValue(arg0)
	local var0 = 0
	local var1 = 0

	for iter0, iter1 in pairs(arg0.fleets) do
		if iter1:isValid() and (iter1:getFleetType() == FleetType.Normal or iter1:getFleetType() == FleetType.Submarine) then
			var0 = var0 + iter1:getFleetAirDominanceValue()
			var1 = var1 + iter1:getAntiAircraftSums()
		end
	end

	return var0, calcAirDominanceStatus(var0, arg0:getConfig("air_dominance"), var1), arg0.airDominanceStatus
end

function var0.setAirDominanceStatus(arg0, arg1)
	arg0.airDominanceStatus = arg1
end

function var0.updateExtraFlags(arg0, arg1, arg2)
	local var0 = false

	for iter0, iter1 in ipairs(arg2) do
		for iter2, iter3 in ipairs(arg0.extraFlagList) do
			if iter3 == iter1 then
				table.remove(arg0.extraFlagList, iter2)

				var0 = true

				break
			end
		end
	end

	for iter4, iter5 in ipairs(arg1) do
		if not table.contains(arg0.extraFlagList, iter5) then
			table.insert(arg0.extraFlagList, 1, iter5)

			var0 = true
		end
	end

	return var0
end

function var0.getExtraFlags(arg0)
	local var0 = arg0.extraFlagList

	if #var0 == 0 then
		var0 = ChapterConst.StatusDefaultList
	end

	return var0
end

function var0.UpdateBuffList(arg0, arg1)
	if not arg1 then
		return
	end

	for iter0, iter1 in ipairs(arg1) do
		if not _.include(arg0.buff_list, iter1) then
			table.insert(arg0.buff_list, iter1)
		end
	end
end

function var0.getFleetBattleBuffs(arg0, arg1)
	local var0 = table.shallowCopy(arg0.buff_list)

	_.each(arg0:getFleetStates(arg1), function(arg0)
		local var0 = pg.strategy_data_template[arg0]
		local var1 = var0.buff_id

		if var1 == 0 then
			return
		end

		if var0.buff_type == ChapterConst.StrategyBuffTypeOnlyBoss then
			local var2 = arg0:GetEnemy(arg1.line.row, arg1.line.column)

			if var2 and not ChapterConst.IsBossCell(var2) then
				return
			end
		end

		table.insert(var0, var1)
	end)
	table.insertto(var0, arg0:GetCellEventByKey("attach_buff", arg1.line.row, arg1.line.column) or {})
	_.each(arg0:GetWeather(), function(arg0)
		local var0 = pg.weather_data_template[arg0].effect_args

		if type(var0) == "table" and var0.buff and var0.buff > 0 then
			table.insert(var0, var0.buff)
		end
	end)

	local var1 = arg0:buildBattleBuffList(arg1)

	return var0, var1
end

function var0.GetStageFlags(arg0)
	local var0 = arg0.fleet.line.row
	local var1 = arg0.fleet.line.column

	return arg0:GetCellEventByKey("stage_flags", var0, var1) or {}
end

function var0.GetCellEventByKey(arg0, arg1, arg2, arg3)
	arg2 = arg2 or arg0.fleet.line.row
	arg3 = arg3 or arg0.fleet.line.column

	local var0 = ChapterCell.Line2Name(arg2, arg3)
	local var1 = arg0.cells[var0]

	if not var1 then
		return
	end

	return var0.GetEventTemplateByKey(arg1, var1.attachmentId)
end

function var0.GetEventTemplateByKey(arg0, arg1)
	local var0 = pg.map_event_template[arg1]

	if not var0 then
		return
	end

	local var1

	for iter0, iter1 in ipairs(var0.effect) do
		if iter1[1] == arg0 then
			for iter2 = 2, #iter1 do
				var1 = var1 or {}

				table.insert(var1, iter1[iter2])
			end
		end
	end

	return var1
end

function var0.buildBattleBuffList(arg0, arg1)
	local var0 = {}
	local var1, var2 = arg0:triggerSkill(arg1, FleetSkill.TypeBattleBuff)

	if var1 and #var1 > 0 then
		local var3 = {}

		for iter0, iter1 in ipairs(var1) do
			local var4 = var2[iter0]
			local var5 = arg1:findCommanderBySkillId(var4.id)

			var3[var5] = var3[var5] or {}

			table.insert(var3[var5], iter1)
		end

		for iter2, iter3 in pairs(var3) do
			table.insert(var0, {
				iter2,
				iter3
			})
		end
	end

	local var6 = arg1:getCommanders()

	for iter4, iter5 in pairs(var6) do
		local var7 = iter5:getTalents()

		for iter6, iter7 in ipairs(var7) do
			local var8 = iter7:getBuffsAddition()

			if #var8 > 0 then
				local var9

				for iter8, iter9 in ipairs(var0) do
					if iter9[1] == iter5 then
						var9 = iter9[2]

						break
					end
				end

				if not var9 then
					var9 = {}

					table.insert(var0, {
						iter5,
						var9
					})
				end

				for iter10, iter11 in ipairs(var8) do
					table.insert(var9, iter11)
				end
			end
		end
	end

	return var0
end

function var0.updateFleetShipHp(arg0, arg1, arg2)
	for iter0, iter1 in ipairs(arg0.fleets) do
		iter1:updateShipHp(arg1, arg2)

		if iter1.id ~= arg0.fleet.id then
			iter1:clearShipHpChange()
		end
	end
end

function var0.getDragExtend(arg0)
	local var0 = arg0.theme
	local var1 = 99999999
	local var2 = 99999999
	local var3 = 0
	local var4 = 0

	for iter0, iter1 in pairs(arg0.cells) do
		if var1 > iter1.row then
			var1 = iter1.row
		end

		if var3 < iter1.row then
			var3 = iter1.row
		end

		if var2 > iter1.column then
			var2 = iter1.column
		end

		if var4 < iter1.column then
			var4 = iter1.column
		end
	end

	local var5 = (var4 + var2) * 0.5
	local var6 = (var3 + var1) * 0.5
	local var7 = var0.cellSize + var0.cellSpace
	local var8 = math.max((var4 - var5 + 1) * var7.x, 0)
	local var9 = math.max((var5 - var2 + 1) * var7.x, 0)
	local var10 = math.max((var6 - var1 + 1) * var7.y, 0)
	local var11 = math.max((var3 - var6 + 1) * var7.y, 0)

	return var9, var8, var10, var11
end

function var0.getPoisonArea(arg0, arg1)
	local var0 = {}
	local var1 = arg0.theme.cellSize + arg0.theme.cellSpace

	for iter0, iter1 in pairs(arg0.cells) do
		if iter1:checkHadFlag(ChapterConst.FlagPoison) then
			local var2 = math.floor((iter1.column - arg0.indexMin.y) * var1.x * arg1)
			local var3 = math.ceil((iter1.column - arg0.indexMin.y + 1) * var1.x * arg1)
			local var4 = math.floor((iter1.row - arg0.indexMin.x) * var1.y * arg1)
			local var5 = math.ceil((iter1.row - arg0.indexMin.x + 1) * var1.y * arg1)
			local var6 = var3 - var2
			local var7 = var5 - var4

			var0[iter0] = {
				x = var2,
				y = var4,
				w = var6,
				h = var7
			}
		end
	end

	return var0
end

function var0.selectFleets(arg0, arg1)
	local var0 = Clone(arg1) or {}
	local var1 = getProxy(FleetProxy):GetRegularFleets()

	for iter0 = #var0, 1, -1 do
		local var2 = var1[var0[iter0]]

		if not var2 or not var2:isUnlock() or var2:isLegalToFight() ~= true then
			table.remove(var0, iter0)
		end
	end

	local var3 = {
		[FleetType.Normal] = _.filter(var0, function(arg0)
			return var1[arg0]:getFleetType() == FleetType.Normal
		end),
		[FleetType.Submarine] = _.filter(var0, function(arg0)
			return var1[arg0]:getFleetType() == FleetType.Submarine
		end)
	}
	local var4 = arg0:getConfig("group_num")
	local var5 = arg0:getConfig("submarine_num")

	for iter1 = #var3[FleetType.Normal], var4 + 1, -1 do
		table.remove(var3[FleetType.Normal], iter1)
	end

	for iter2 = #var3[FleetType.Submarine], var5 + 1, -1 do
		table.remove(var3[FleetType.Submarine], iter2)
	end

	for iter3, iter4 in pairs(var3) do
		if #iter4 == 0 then
			local var6 = 0

			if iter3 == FleetType.Normal then
				var6 = var4
			elseif iter3 == FleetType.Submarine then
				var6 = var5
			end

			for iter5, iter6 in pairs(var1) do
				if var6 <= #iter4 then
					break
				end

				if iter6 and iter6:getFleetType() == iter3 and iter6:isUnlock() and iter6:isLegalToFight() == true then
					table.insert(iter4, iter5)
				end
			end
		end
	end

	local var7 = {}

	for iter7, iter8 in ipairs(var3) do
		for iter9, iter10 in ipairs(iter8) do
			table.insert(var7, iter10)
		end
	end

	return var7
end

function var0.GetDefaultFleetIndex(arg0)
	local var0 = getProxy(ChapterProxy):GetLastFleetIndex()

	return arg0:selectFleets(var0)
end

function var0.getMaxColumnByRow(arg0, arg1)
	local var0 = -1

	for iter0, iter1 in pairs(arg0.cells) do
		if iter1.row == arg1 then
			var0 = math.max(var0, iter1.column)
		end
	end

	return var0
end

function var0.getFleet(arg0, arg1, arg2, arg3)
	return _.detect(arg0.fleets, function(arg0)
		return arg0.line.row == arg2 and arg0.line.column == arg3 and (not arg1 or arg0:getFleetType() == arg1) and arg0:isValid()
	end) or _.detect(arg0.fleets, function(arg0)
		return arg0.line.row == arg2 and arg0.line.column == arg3 and (not arg1 or arg0:getFleetType() == arg1)
	end)
end

function var0.getFleetIndex(arg0, arg1, arg2, arg3)
	local var0 = arg0:getFleet(arg1, arg2, arg3)

	if var0 then
		return table.indexof(arg0.fleets, var0)
	end
end

function var0.getOni(arg0)
	return _.detect(arg0.champions, function(arg0)
		return arg0.attachment == ChapterConst.AttachOni
	end)
end

function var0.getChampion(arg0, arg1, arg2)
	return (_.detect(arg0.champions, function(arg0)
		return arg0.row == arg1 and arg0.column == arg2
	end))
end

function var0.getChampionIndex(arg0, arg1, arg2)
	local var0 = arg0:getChampion(arg1, arg2)

	if not var0 then
		return
	end

	return table.indexof(arg0.champions, var0)
end

function var0.getChampionVisibility(arg0, arg1, arg2, arg3)
	assert(arg1, "chapter champion not exist.")

	return arg1.flag == ChapterConst.CellFlagActive
end

function var0.mergeChampion(arg0, arg1, arg2)
	local var0 = arg0:getChampionIndex(arg1.row, arg1.column)

	if var0 then
		arg0.champions[var0] = arg1

		return true
	else
		if not arg2 then
			arg1.trait = ChapterConst.TraitLurk
		end

		table.insert(arg0.champions, arg1)

		return false
	end
end

function var0.RemoveChampion(arg0, arg1)
	local var0 = table.indexof(arg0.champions, arg1)

	if var0 then
		table.remove(arg0.champions, var0)
	end
end

function var0.considerAsObstacle(arg0, arg1, arg2, arg3)
	local var0 = arg0:getChapterCell(arg2, arg3)

	if not var0 or not var0:IsWalkable() then
		return true
	end

	if arg0:existBarrier(arg2, arg3) then
		return true
	end

	if arg1 == ChapterConst.SubjectPlayer then
		if var0.flag == ChapterConst.CellFlagActive then
			if ChapterConst.IsEnemyAttach(var0.attachment) then
				return true
			end

			if var0.attachment == ChapterConst.AttachBox then
				local var1 = pg.box_data_template[var0.attachmentId]

				assert(var1, "box_data_template not exist: " .. var0.attachmentId)

				if var1.type == ChapterConst.BoxTorpedo then
					return true
				end
			end

			if var0.attachment == ChapterConst.AttachStory then
				return true
			end
		end

		if arg0:existVisibleChampion(arg2, arg3) then
			return true
		end
	elseif arg1 == ChapterConst.SubjectChampion and arg0:existFleet(FleetType.Normal, arg2, arg3) then
		return true
	end

	return false
end

function var0.considerAsStayPoint(arg0, arg1, arg2, arg3)
	local var0 = arg0:getChapterCell(arg2, arg3)

	if not var0 or not var0:IsWalkable() then
		return false
	end

	if arg0:existBarrier(arg2, arg3) then
		return false
	end

	if arg1 == ChapterConst.SubjectPlayer then
		if var0.flag == ChapterConst.CellFlagActive and var0.attachment == ChapterConst.AttachStory then
			return true
		end

		if var0.attachment == ChapterConst.AttachLandbase and pg.land_based_template[var0.attachmentId] and pg.land_based_template[var0.attachmentId].type == ChapterConst.LBHarbor then
			return false
		end

		if arg0:existFleet(FleetType.Normal, arg2, arg3) then
			return false
		end

		if arg0:existOni(arg2, arg3) then
			return false
		end

		if arg0:existBombEnemy(arg2, arg3) then
			return false
		end
	elseif arg1 == ChapterConst.SubjectChampion then
		if var0.flag ~= ChapterConst.CellFlagDisabled and var0.attachment ~= ChapterConst.AttachNone then
			return false
		end

		local var1 = arg0:getChampion(arg2, arg3)

		if var1 and var1.flag ~= ChapterConst.CellFlagDisabled then
			return false
		end
	end

	return true
end

function var0.existAny(arg0, arg1, arg2)
	local var0 = arg0:getChapterCell(arg1, arg2)

	if var0.attachment ~= ChapterConst.AttachNone and var0.flag == ChapterConst.CellFlagActive then
		return true
	end

	if arg0:existFleet(nil, arg1, arg2) then
		return true
	end

	local var1 = arg0:getChampion(arg1, arg2)

	if var1 and var1.flag ~= ChapterConst.CellFlagDisabled then
		return true
	end
end

function var0.existBarrier(arg0, arg1, arg2)
	local var0 = arg0:getChapterCell(arg1, arg2)

	if var0.attachment == ChapterConst.AttachBox and var0.flag == ChapterConst.CellFlagActive and pg.box_data_template[var0.attachmentId].type == ChapterConst.BoxBarrier then
		return true
	end

	if var0.attachment == ChapterConst.AttachStory and var0.flag == ChapterConst.CellFlagTriggerActive and pg.map_event_template[var0.attachmentId].type == ChapterConst.StoryObstacle then
		return true
	end

	local var1 = arg0:getChampion(arg1, arg2)

	if var1 and var1.flag ~= ChapterConst.CellFlagDisabled then
		local var2 = pg.expedition_data_template[var1.attachmentId]

		if var2 and var2.type == ChapterConst.ExpeditionTypeUnTouchable then
			return true
		end
	end

	return false
end

function var0.GetEnemy(arg0, arg1, arg2)
	local var0 = arg0:getChapterCell(arg1, arg2)

	if var0 and var0.flag == ChapterConst.CellFlagActive and ChapterConst.IsEnemyAttach(var0.attachment) then
		return var0
	end

	local var1 = arg0:getChampion(arg1, arg2)

	if var1 and var1.flag ~= ChapterConst.CellFlagDisabled then
		return var1
	end
end

function var0.existEnemy(arg0, arg1, arg2, arg3)
	if arg1 == ChapterConst.SubjectPlayer then
		local var0 = arg0:GetEnemy(arg2, arg3)

		if var0 then
			local var1

			if isa(var0, ChapterCell) then
				var1 = var0.attachment
			else
				var1 = ChapterConst.AttachChampion
			end

			return true, var1
		end
	elseif arg1 == ChapterConst.SubjectChampion and (arg0:existFleet(FleetType.Normal, arg2, arg3) or arg0:existFleet(FleetType.Transport, arg2, arg3)) then
		return true
	end
end

function var0.existFleet(arg0, arg1, arg2, arg3)
	if _.any(arg0.fleets, function(arg0)
		return arg0.line.row == arg2 and arg0.line.column == arg3 and (not arg1 or arg0:getFleetType() == arg1) and arg0:isValid()
	end) then
		return true
	end
end

function var0.existVisibleChampion(arg0, arg1, arg2)
	local var0 = arg0:getChampion(arg1, arg2)

	return var0 and arg0:getChampionVisibility(var0)
end

function var0.existAlly(arg0, arg1)
	return _.any(arg0.fleets, function(arg0)
		return arg0.id ~= arg1.id and arg0.line.row == arg1.line.row and arg0.line.column == arg1.line.column and arg0:isValid()
	end)
end

function var0.existOni(arg0, arg1, arg2)
	return _.any(arg0.champions, function(arg0)
		return arg0.attachment == ChapterConst.AttachOni and arg0.flag == ChapterConst.CellFlagActive and (not arg1 or arg1 == arg0.row) and (not arg2 or arg2 == arg0.column)
	end)
end

function var0.existBombEnemy(arg0, arg1, arg2)
	if arg1 and arg2 then
		local var0 = arg0:getChapterCell(arg1, arg2)

		return var0.attachment == ChapterConst.AttachBomb_Enemy and var0.flag == ChapterConst.CellFlagActive
	end

	for iter0, iter1 in pairs(arg0.cells) do
		if iter1.attachment == ChapterConst.AttachBomb_Enemy and iter1.flag == ChapterConst.CellFlagActive and (not arg1 or arg1 == iter1.row) and (not arg2 or arg2 == iter1.column) then
			return true
		end
	end

	return false
end

function var0.isPlayingWithBombEnemy(arg0)
	for iter0, iter1 in pairs(arg0.cells) do
		if iter1.attachment == ChapterConst.AttachBomb_Enemy then
			return true
		end
	end

	return false
end

function var0.existCoastalGunNoMatterLiveOrDead(arg0)
	for iter0, iter1 in pairs(arg0.cells) do
		if iter1.attachment == ChapterConst.AttachLandbase then
			local var0 = pg.land_based_template[iter1.attachmentId]

			assert(var0, "land_based_template not exist: " .. iter1.attachmentId)

			if var0.type == ChapterConst.LBCoastalGun then
				return true
			end
		end
	end

	return false
end

local var1 = {
	{
		1,
		0
	},
	{
		-1,
		0
	},
	{
		0,
		1
	},
	{
		0,
		-1
	}
}

function var0.calcWalkableCells(arg0, arg1, arg2, arg3, arg4)
	local var0 = {}

	for iter0 = 0, ChapterConst.MaxRow - 1 do
		if not var0[iter0] then
			var0[iter0] = {}
		end

		for iter1 = 0, ChapterConst.MaxColumn - 1 do
			local var1 = ChapterCell.Line2Name(iter0, iter1)
			local var2 = arg0.cells[var1]

			var0[iter0][iter1] = var2 and var2:IsWalkable()
		end
	end

	local var3 = {}

	if arg1 == ChapterConst.SubjectPlayer then
		local var4 = arg0:getCoastalGunArea()

		for iter2, iter3 in ipairs(var4) do
			var3[iter3.row .. "_" .. iter3.column] = true
		end
	end

	local var5 = {}
	local var6 = arg0:GetRawChapterCell(arg2, arg3)

	if not var6 then
		return var5
	end

	local var7 = {
		{
			step = 0,
			row = arg2,
			column = arg3,
			forbiddens = var6.forbiddenDirections
		}
	}
	local var8 = {}

	while #var7 > 0 do
		local var9 = table.remove(var7, 1)

		table.insert(var8, var9)
		_.each(var1, function(arg0)
			local var0 = {
				row = var9.row + arg0[1],
				column = var9.column + arg0[2],
				step = var9.step + 1
			}
			local var1 = arg0:GetRawChapterCell(var0.row, var0.column)

			if not var1 then
				return
			end

			var0.forbiddens = var1.forbiddenDirections

			if var0.step <= arg4 and not OrientedPathFinding.IsDirectionForbidden(var9, arg0[1], arg0[2]) and not (_.any(var7, function(arg0)
				return arg0.row == var0.row and arg0.column == var0.column
			end) or _.any(var8, function(arg0)
				return arg0.row == var0.row and arg0.column == var0.column
			end)) and var0[var0.row][var0.column] then
				table.insert(var5, var0)

				if not arg0:existEnemy(arg1, var0.row, var0.column) and not arg0:existBarrier(var0.row, var0.column) and not var3[var0.row .. "_" .. var0.column] then
					table.insert(var7, var0)
				end
			end
		end)
	end

	var5 = _.filter(var5, function(arg0)
		return arg0.row == arg2 and arg0.column == arg3 or arg0:considerAsStayPoint(arg1, arg0.row, arg0.column)
	end)

	return var5
end

function var0.calcAreaCells(arg0, arg1, arg2, arg3, arg4)
	local var0 = {}

	for iter0 = 0, ChapterConst.MaxRow - 1 do
		if not var0[iter0] then
			var0[iter0] = {}
		end

		for iter1 = 0, ChapterConst.MaxColumn - 1 do
			local var1 = ChapterCell.Line2Name(iter0, iter1)
			local var2 = arg0.cells[var1]

			var0[iter0][iter1] = var2 and var2:IsWalkable()
		end
	end

	local var3 = {}
	local var4 = {
		{
			step = 0,
			row = arg1,
			column = arg2
		}
	}
	local var5 = {}

	while #var4 > 0 do
		local var6 = table.remove(var4, 1)

		table.insert(var5, var6)
		_.each(var1, function(arg0)
			local var0 = {
				row = var6.row + arg0[1],
				column = var6.column + arg0[2],
				step = var6.step + 1
			}

			if var0.row >= 0 and var0.row < ChapterConst.MaxRow and var0.column >= 0 and var0.column < ChapterConst.MaxColumn and var0.step <= arg4 and not (_.any(var4, function(arg0)
				return arg0.row == var0.row and arg0.column == var0.column
			end) or _.any(var5, function(arg0)
				return arg0.row == var0.row and arg0.column == var0.column
			end)) then
				table.insert(var4, var0)

				if var0[var0.row][var0.column] and var0.step >= arg3 then
					table.insert(var3, var0)
				end
			end
		end)
	end

	return var3
end

function var0.calcSquareBarrierCells(arg0, arg1, arg2, arg3)
	local var0 = {}

	for iter0 = -arg3, arg3 do
		for iter1 = -arg3, arg3 do
			local var1 = arg1 + iter0
			local var2 = arg2 + iter1
			local var3 = arg0:getChapterCell(var1, var2)

			if var3 and var3:IsWalkable() and (arg0:existBarrier(var1, var2) or not arg0:existAny(var1, var2)) then
				table.insert(var0, {
					row = var1,
					column = var2
				})
			end
		end
	end

	return var0
end

function var0.checkAnyInteractive(arg0)
	local var0 = arg0.fleet.line
	local var1 = arg0:getChapterCell(var0.row, var0.column)
	local var2 = false

	if arg0.fleet:getFleetType() == FleetType.Normal then
		if arg0:existEnemy(ChapterConst.SubjectPlayer, var1.row, var1.column) then
			if arg0:getRound() == ChapterConst.RoundPlayer then
				var2 = true
			end
		elseif var1.attachment == ChapterConst.AttachAmbush or var1.attachment == ChapterConst.AttachBox then
			if var1.flag ~= ChapterConst.CellFlagDisabled then
				var2 = true
			end
		elseif var1.attachment == ChapterConst.AttachStory then
			var2 = var1.flag == ChapterConst.CellFlagActive
		elseif var1.attachment == ChapterConst.AttachSupply and var1.attachmentId > 0 then
			local var3, var4 = arg0:getFleetAmmo(arg0.fleet)

			if var4 < var3 then
				var2 = true
			end
		elseif var1.attachment == ChapterConst.AttachBox and var1.flag ~= ChapterConst.CellFlagDisabled then
			var2 = true
		end
	end

	return var2
end

function var0.getQuadCellPic(arg0, arg1)
	local var0

	if arg1.trait == ChapterConst.TraitLurk then
		-- block empty
	elseif arg1.flag == ChapterConst.CellFlagActive and ChapterConst.IsEnemyAttach(arg1.attachment) and arg1.flag == ChapterConst.CellFlagActive then
		var0 = "cell_enemy"
	elseif arg1.attachment == ChapterConst.AttachBox and arg1.flag == ChapterConst.CellFlagActive then
		local var1 = pg.box_data_template[arg1.attachmentId]

		assert(var1, "box_data_template not exist: " .. arg1.attachmentId)

		if var1.type == ChapterConst.BoxDrop or var1.type == ChapterConst.BoxStrategy or var1.type == ChapterConst.BoxSupply or var1.type == ChapterConst.BoxEnemy then
			var0 = "cell_box"
		elseif var1.type == ChapterConst.BoxTorpedo then
			var0 = "cell_enemy"
		elseif var1.type == ChapterConst.BoxBarrier then
			var0 = "cell_green"
		end
	elseif arg1.attachment == ChapterConst.AttachStory then
		if arg1.flag == ChapterConst.CellFlagTriggerActive then
			local var2 = pg.map_event_template[arg1.attachmentId].grid_color

			var0 = var2 and #var2 > 0 and var2 or nil
		end
	elseif arg1.attachment == ChapterConst.AttachSupply and arg1.attachmentId > 0 then
		var0 = "cell_box"
	elseif arg1.attachment == ChapterConst.AttachTransport_Target then
		var0 = "cell_box"
	elseif arg1.attachment == ChapterConst.AttachLandbase then
		local var3 = pg.land_based_template[arg1.attachmentId]

		if var3 and (var3.type == ChapterConst.LBHarbor or var3.type == ChapterConst.LBDock) then
			var0 = "cell_box"
		end
	end

	return var0
end

function var0.getMapShip(arg0, arg1)
	local var0

	if arg1:isValid() then
		var0 = _.detect(arg1:getShips(false), function(arg0)
			return arg0.isNpc and arg0.hpRant > 0
		end)

		if not var0 then
			local var1 = arg1:getFleetType()

			if var1 == FleetType.Normal then
				var0 = arg1:getShipsByTeam(TeamType.Main, false)[1]
			elseif var1 == FleetType.Submarine then
				var0 = arg1:getShipsByTeam(TeamType.Submarine, false)[1]
			end
		end
	end

	return var0
end

function var0.getStrikeAnimShip(arg0, arg1, arg2)
	return underscore.detect(arg1:getShips(false), function(arg0)
		return arg0:GetMapStrikeAnim() == arg2
	end)
end

function var0.GetSubmarineFleet(arg0)
	return table.Find(arg0.fleets, function(arg0, arg1)
		return arg1:getFleetType() == FleetType.Submarine and arg1:isValid()
	end)
end

function var0.getStageCell(arg0, arg1, arg2)
	local var0 = arg0:getChampion(arg1, arg2)

	if var0 and var0.flag ~= ChapterConst.CellFlagDisabled then
		return var0
	end

	local var1 = arg0:getChapterCell(arg1, arg2)

	if var1 and var1.flag ~= ChapterConst.CellFlagDisabled then
		return var1
	end
end

function var0.getStageId(arg0, arg1, arg2)
	local var0 = arg0:getChampion(arg1, arg2)

	if var0 and var0.flag ~= ChapterConst.CellFlagDisabled then
		return var0.id
	end

	local var1 = arg0:getChapterCell(arg1, arg2)

	if var1 and var1.flag ~= ChapterConst.CellFlagDisabled then
		return var1.attachmentId
	end
end

function var0.getStageExtraAwards(arg0)
	return
end

function var0.GetExtraCostRate(arg0)
	local var0 = 1
	local var1 = {}

	for iter0, iter1 in ipairs(arg0.operationBuffList) do
		local var2 = pg.benefit_buff_template[iter1]

		var1[#var1 + 1] = var2

		if var2.benefit_type == var0.OPERATION_BUFF_TYPE_COST then
			var0 = var0 + var2.benefit_effect * 0.01
		end
	end

	return math.max(1, var0), var1
end

function var0.getFleetCost(arg0, arg1, arg2)
	if arg0:getPlayType() == ChapterConst.TypeExtra then
		return {
			gold = 0,
			oil = 0
		}, {
			gold = 0,
			oil = 0
		}
	end

	local var0, var1 = arg1:getCost()
	local var2 = arg0:GetLimitOilCost(arg1:getFleetType() == FleetType.Submarine, arg2)

	var1.oil = math.clamp(var2 - var0.oil, 0, var1.oil)

	local var3 = arg0:GetExtraCostRate()

	for iter0, iter1 in ipairs({
		var0,
		var1
	}) do
		for iter2, iter3 in pairs(iter1) do
			iter1[iter2] = iter1[iter2] * var3
		end
	end

	return var0, var1
end

function var0.isOverFleetCost(arg0, arg1, arg2)
	local var0 = arg0:GetLimitOilCost(arg1:getFleetType() == FleetType.Submarine, arg2)
	local var1 = 0

	for iter0, iter1 in ipairs({
		arg1:getCost()
	}) do
		var1 = var1 + iter1.oil
	end

	local var2 = arg0:GetExtraCostRate()

	return var0 < var1, var0 * var2, var1 * var2
end

function var0.writeBack(arg0, arg1, arg2)
	local var0 = arg0.fleet

	local function var1(arg0)
		local var0 = arg2.statistics[arg0.id]

		if not var0 then
			return
		end

		arg0.hpRant = var0.bp
	end

	for iter0, iter1 in pairs(var0.ships) do
		var1(iter1)
	end

	var0:ResortShips()

	if not arg2.skipAmmo then
		var0.restAmmo = math.max(var0.restAmmo - 1, 0)
	end

	local var2 = _.filter(var0:getStrategies(), function(arg0)
		local var0 = pg.strategy_data_template[arg0.id]

		return var0 and var0.type == ChapterConst.StgTypeBindFleetPassive and arg0.count > 0
	end)

	_.each(var2, function(arg0)
		var0:consumeOneStrategy(arg0.id)
	end)

	if arg2.statistics.submarineAid then
		local var3 = arg0:GetSubmarineFleet()

		if var3 and not var3:inHuntingRange(var0.line.row, var0.line.column) then
			var3:consumeOneStrategy(ChapterConst.StrategyCallSubOutofRange)
		end

		if var3 then
			for iter2, iter3 in pairs(var3.ships) do
				var1(iter3)
			end

			var3.restAmmo = math.max(var3.restAmmo - 1, 0)
		end
	end

	arg0:UpdateComboHistory(arg2.statistics._battleScore)

	if arg1 then
		local var4
		local var5
		local var6 = arg0:getChampion(var0.line.row, var0.line.column)

		if var6 then
			var6:Iter()

			var4 = var6.attachment
			var5 = var6.attachmentId

			if var6.flag == ChapterConst.CellFlagDisabled then
				arg0:RemoveChampion(var6)
			end
		else
			local var7 = arg0:getChapterCell(var0.line.row, var0.line.column)

			var4 = var7.attachment
			var5 = var7.attachmentId

			if var4 == ChapterConst.AttachEnemy or var4 == ChapterConst.AttachBoss then
				var7.flag = ChapterConst.CellFlagDisabled

				arg0:updateChapterCell(var7)
			else
				arg0:clearChapterCell(var7.row, var7.column)
			end
		end

		assert(var4, "attachment can not be nil.")

		if var4 == ChapterConst.AttachEnemy or var4 == ChapterConst.AttachElite or var4 == ChapterConst.AttachChampion then
			if not var6 or var6.flag == ChapterConst.CellFlagDisabled then
				local var8 = _.detect(arg0.achieves, function(arg0)
					return arg0.type == ChapterConst.AchieveType2
				end)

				if var8 then
					var8.count = var8.count + 1
				end
			end
		elseif var4 == ChapterConst.AttachBoss then
			local var9 = _.detect(arg0.achieves, function(arg0)
				return arg0.type == ChapterConst.AchieveType1
			end)

			if var9 then
				var9.count = var9.count + 1
			end
		end

		if arg0:CheckChapterWin() then
			pg.TrackerMgr.GetInstance():Tracking(TRACKING_KILL_BOSS)
		end

		if var6 and var6.flag == ChapterConst.CellFlagDisabled or not var6 and var4 ~= ChapterConst.AttachBox then
			var0.defeatEnemies = var0.defeatEnemies + 1
			arg0.defeatEnemies = arg0.defeatEnemies + 1

			local var10 = pg.expedition_data_template[var5]

			if not arg0:isLoop() and var10 and var10.type == ChapterConst.ExpeditionTypeMulBoss then
				local var11 = pg.chapter_model_multistageboss[arg0.id].guild_buff
				local var12 = var0:GetStatusStrategy()

				_.each(var11, function(arg0)
					if not table.contains(var12, arg0) then
						table.insert(var12, arg0)
					end
				end)

				local var13 = arg0:getNextValidIndex()

				if var13 > 0 then
					var12 = arg0.fleets[var13]:GetStatusStrategy()

					_.each(var11, function(arg0)
						table.removebyvalue(var12, arg0)
					end)
				end
			end

			getProxy(ChapterProxy):RecordLastDefeatedEnemy(arg0.id, {
				score = arg2.statistics._battleScore,
				line = {
					row = var0.line.row,
					column = var0.line.column
				},
				attachment = var4,
				attachmentId = var5
			})
		end
	end
end

function var0.CleanCurrentEnemy(arg0)
	local var0 = arg0.fleet.line
	local var1
	local var2 = arg0:getChampion(var0.row, var0.column)

	if var2 then
		var2:Iter()

		if var2.flag == ChapterConst.CellFlagDisabled then
			arg0:RemoveChampion(var2)
		end

		return
	end

	if arg0:getChapterCell(var0.row, var0.column).attachment == ChapterConst.AttachEnemy then
		arg0:clearChapterCell(var0.row, var0.column)

		return
	end
end

function var0.UpdateProgressAfterSkipBattle(arg0)
	arg0:writeBack(true, {
		skipAmmo = true,
		statistics = {
			_battleScore = ys.Battle.BattleConst.BattleScore.S
		}
	})
end

function var0.UpdateProgressOnRetreat(arg0)
	_.each(arg0.achieves, function(arg0)
		if arg0.type == ChapterConst.AchieveType3 then
			if _.all(_.values(arg0.cells), function(arg0)
				if arg0.attachment == ChapterConst.AttachEnemy or arg0.attachment == ChapterConst.AttachElite or arg0.attachment == ChapterConst.AttachBox and pg.box_data_template[arg0.attachmentId].type == ChapterConst.BoxEnemy then
					return arg0.flag == ChapterConst.CellFlagDisabled
				end

				return true
			end) and _.all(arg0.champions, function(arg0)
				return arg0.flag == ChapterConst.CellFlagDisabled
			end) then
				arg0.count = arg0.count + 1
			end
		elseif arg0.type == ChapterConst.AchieveType4 then
			if arg0.orignalShipCount <= arg0.config then
				arg0.count = arg0.count + 1
			end
		elseif arg0.type == ChapterConst.AchieveType5 then
			if not _.any(arg0:getShips(), function(arg0)
				return arg0:getShipType() == arg0.config
			end) then
				arg0.count = arg0.count + 1
			end
		elseif arg0.type == ChapterConst.AchieveType6 then
			local var0 = (arg0.scoreHistory[0] or 0) + (arg0.scoreHistory[1] or 0)

			arg0.count = math.max(var0 <= 0 and arg0.combo or 0, arg0.count or 0)
		end
	end)

	if arg0.progress == 100 then
		arg0.passCount = arg0.passCount + 1
	end

	local var0 = arg0.progress
	local var1 = math.min(arg0.progress + arg0:getConfig("progress_boss"), 100)

	arg0.progress = var1

	if var0 < 100 and var1 >= 100 then
		getProxy(ChapterProxy):RecordJustClearChapters(arg0.id, true)
	end

	arg0.defeatCount = arg0.defeatCount + 1

	local var2 = getProxy(ChapterProxy):getMapById(arg0:getConfig("map")):getMapType()

	if var2 == Map.ELITE then
		pg.TrackerMgr.GetInstance():Tracking(TRACKING_HARD_CHAPTER, arg0.id)
	elseif var2 == Map.SCENARIO then
		if arg0.progress == 100 and arg0.passCount == 0 then
			pg.TrackerMgr.GetInstance():Tracking(TRACKING_HIGHEST_CHAPTER, arg0.id)
		end

		if arg0.defeatCount == 1 then
			if arg0.id == 304 then
				pg.TrackerMgr.GetInstance():Tracking(TRACKING_FIRST_PASS_3_4)
			elseif arg0.id == 404 then
				pg.TrackerMgr.GetInstance():Tracking(TRACKING_FIRST_PASS_4_4)
			elseif arg0.id == 504 then
				pg.TrackerMgr.GetInstance():Tracking(TRACKING_FIRST_PASS_5_4)
			elseif arg0.id == 604 then
				pg.TrackerMgr.GetInstance():Tracking(TRACKING_FIRST_PASS_6_4)
			elseif arg0.id == 1204 then
				pg.TrackerMgr.GetInstance():Tracking(TRACKING_FIRST_PASS_12_4)
			elseif arg0.id == 1301 then
				pg.TrackerMgr.GetInstance():Tracking(TRACKING_FIRST_PASS_13_1)
			elseif arg0.id == 1302 then
				pg.TrackerMgr.GetInstance():Tracking(TRACKING_FIRST_PASS_13_2)
			elseif arg0.id == 1303 then
				pg.TrackerMgr.GetInstance():Tracking(TRACKING_FIRST_PASS_13_3)
			elseif arg0.id == 1304 then
				pg.TrackerMgr.GetInstance():Tracking(TRACKING_FIRST_PASS_13_4)
			end
		end
	end
end

function var0.UpdateComboHistory(arg0, arg1)
	getProxy(ChapterProxy):RecordComboHistory(arg0.id, {
		scoreHistory = Clone(arg0.scoreHistory),
		combo = Clone(arg0.combo)
	})

	arg0.scoreHistory = arg0.scoreHistory or {}
	arg0.scoreHistory[arg1] = (arg0.scoreHistory[arg1] or 0) + 1

	if arg1 <= ys.Battle.BattleConst.BattleScore.C then
		arg0.combo = 0
	else
		arg0.combo = (arg0.combo or 0) + 1
	end
end

function var0.GetWinConditions(arg0)
	return arg0.winConditions
end

function var0.GetLoseConditions(arg0)
	return arg0.loseConditions
end

function var0.CheckChapterWin(arg0)
	local var0 = arg0:GetWinConditions()
	local var1 = false
	local var2 = ChapterConst.ReasonVictory

	for iter0, iter1 in pairs(var0) do
		if iter1.type == 1 then
			local var3 = arg0:findChapterCells(ChapterConst.AttachBoss)
			local var4 = 0

			_.each(var3, function(arg0)
				if arg0 and arg0.flag == ChapterConst.CellFlagDisabled then
					var4 = var4 + 1
				end
			end)

			var1 = var1 or var4 >= iter1.param
		elseif iter1.type == 2 then
			var1 = var1 or arg0:GetDefeatCount() >= iter1.param
		elseif iter1.type == 3 then
			local var5 = arg0:CheckTransportState()

			var1 = var1 or var5 == 1
		elseif iter1.type == 4 then
			var1 = var1 or arg0:getRoundNum() > iter1.param
		elseif iter1.type == 5 then
			local var6 = iter1.param
			local var7 = _.any(arg0.champions, function(arg0)
				local var0 = arg0.attachmentId == var6

				for iter0, iter1 in pairs(arg0.idList) do
					var0 = var0 or iter1 == var6
				end

				return var0 and arg0.flag ~= ChapterConst.CellFlagDisabled
			end) or _.any(arg0.cells, function(arg0)
				return arg0.attachmentId == var6 and arg0.flag ~= ChapterConst.CellFlagDisabled
			end)

			var1 = var1 or not var7
		elseif iter1.type == 6 then
			local var8 = iter1.param
			local var9 = _.any(arg0.fleets, function(arg0)
				return arg0:getFleetType() == FleetType.Normal and arg0:isValid() and arg0.line.row == var8[1] and arg0.line.column == var8[2]
			end)

			var1 = var1 or var9
		end

		if var1 then
			break
		end
	end

	return var1, var2
end

function var0.CheckChapterLose(arg0)
	local var0 = arg0:GetLoseConditions()
	local var1 = false
	local var2 = ChapterConst.ReasonDefeat

	for iter0, iter1 in pairs(var0) do
		if iter1.type == 1 then
			local var3 = _.any(arg0.fleets, function(arg0)
				return arg0:getFleetType() == FleetType.Normal and arg0:isValid()
			end)

			var1 = var1 or not var3
		elseif iter1.type == 2 then
			var1 = var1 or arg0.BaseHP <= 0
			var2 = var1 and ChapterConst.ReasonDefeatDefense or var2
		end

		if var1 then
			break
		end
	end

	if arg0:getPlayType() == ChapterConst.TypeTransport then
		local var4 = arg0:CheckTransportState()

		var1 = var1 or var4 == -1
	end

	return var1, var2
end

function var0.CheckChapterWillWin(arg0)
	if arg0:existOni() or arg0:isPlayingWithBombEnemy() then
		return true
	end

	if arg0:CheckChapterWin() then
		return true
	end
end

function var0.triggerSkill(arg0, arg1, arg2)
	local var0 = _.filter(arg1:findSkills(arg2), function(arg0)
		local var0 = arg0:GetTriggers()

		return _.any(var0, function(arg0)
			return arg0[1] == FleetSkill.TriggerInSubTeam and arg0[2] == 1
		end) == (arg1:getFleetType() == FleetType.Submarine) and _.all(arg0:GetTriggers(), function(arg0)
			return arg0:triggerCheck(arg1, arg0, arg0)
		end)
	end)

	return _.reduce(var0, nil, function(arg0, arg1)
		local var0 = arg1:GetType()
		local var1 = arg1:GetArgs()

		if var0 == FleetSkill.TypeMoveSpeed or var0 == FleetSkill.TypeHuntingLv or var0 == FleetSkill.TypeTorpedoPowerUp then
			return (arg0 or 0) + var1[1]
		elseif var0 == FleetSkill.TypeAmbushDodge or var0 == FleetSkill.TypeAirStrikeDodge then
			return math.max(arg0 or 0, var1[1])
		elseif var0 == FleetSkill.TypeAttack or var0 == FleetSkill.TypeStrategy then
			arg0 = arg0 or {}

			table.insert(arg0, var1)

			return arg0
		elseif var0 == FleetSkill.TypeBattleBuff then
			arg0 = arg0 or {}

			table.insert(arg0, var1[1])

			return arg0
		end
	end), var0
end

function var0.triggerCheck(arg0, arg1, arg2, arg3)
	local var0 = arg3[1]

	if var0 == FleetSkill.TriggerDDHead then
		local var1 = arg1:getShipsByTeam(TeamType.Vanguard, false)

		return #var1 > 0 and ShipType.IsTypeQuZhu(var1[1]:getShipType())
	elseif var0 == FleetSkill.TriggerVanCount then
		local var2 = arg1:getShipsByTeam(TeamType.Vanguard, false)

		return #var2 >= arg3[2] and #var2 <= arg3[3]
	elseif var0 == FleetSkill.TriggerShipCount then
		local var3 = _.filter(arg1:getShips(false), function(arg0)
			return table.contains(arg3[2], arg0:getShipType())
		end)

		return #var3 >= arg3[3] and #var3 <= arg3[4]
	elseif var0 == FleetSkill.TriggerAroundEnemy then
		local var4 = {
			row = arg1.line.row,
			column = arg1.line.column
		}

		return _.any(_.values(arg0.cells), function(arg0)
			local var0 = arg0:GetEnemy(arg0.row, arg0.column)

			if not var0 then
				return
			end

			local var1 = pg.expedition_data_template[var0.attachmentId]

			if not var1 then
				return
			end

			local var2 = var1.type

			return ManhattonDist(var4, {
				row = arg0.row,
				column = arg0.column
			}) <= arg3[2] and (type(arg3[3]) == "number" and arg3[3] == var2 or type(arg3[3]) == "table" and table.contains(arg3[3], var2))
		end)
	elseif var0 == FleetSkill.TriggerNekoPos then
		local var5 = arg1:findCommanderBySkillId(arg2.id)

		for iter0, iter1 in pairs(arg1:getCommanders()) do
			if var5.id == iter1.id and iter0 == arg3[2] then
				return true
			end
		end
	elseif var0 == FleetSkill.TriggerAroundLand then
		local var6 = {
			row = arg1.line.row,
			column = arg1.line.column
		}

		return _.any(_.values(arg0.cells), function(arg0)
			return not arg0:IsWalkable() and ManhattonDist(var6, {
				row = arg0.row,
				column = arg0.column
			}) <= arg3[2]
		end)
	elseif var0 == FleetSkill.TriggerAroundCombatAlly then
		local var7 = {
			row = arg1.line.row,
			column = arg1.line.column
		}

		return _.any(arg0.fleets, function(arg0)
			return arg1.id ~= arg0.id and arg0:getFleetType() == FleetType.Normal and arg0:existEnemy(ChapterConst.SubjectPlayer, arg0.line.row, arg0.line.column) and ManhattonDist(var7, {
				row = arg0.line.row,
				column = arg0.line.column
			}) <= arg3[2]
		end)
	elseif var0 == FleetSkill.TriggerInSubTeam then
		return true
	else
		assert(false, "invalid trigger type: " .. var0)
	end
end

local var2 = {
	{
		1,
		0
	},
	{
		-1,
		0
	},
	{
		0,
		1
	},
	{
		0,
		-1
	}
}

function var0.checkOniState(arg0)
	local var0 = arg0:getOni()

	assert(var0, "oni not exist.")

	if _.all(var2, function(arg0)
		local var0 = {
			var0.row + arg0[1],
			var0.column + arg0[2]
		}

		if arg0:existFleet(FleetType.Normal, var0[1], var0[2]) then
			return true
		end

		local var1 = arg0:getChapterCell(var0[1], var0[2])

		if not var1 or not var1:IsWalkable() then
			return true
		end

		if arg0:existBarrier(var1.row, var1.column) then
			return true
		end
	end) then
		return 1
	end

	local var1 = arg0:getOniChapterInfo().escape_grids

	if _.any(var1, function(arg0)
		return arg0[1] == var0.row and arg0[2] == var0.column
	end) then
		return 2
	end
end

function var0.onOniEnter(arg0)
	for iter0, iter1 in pairs(arg0.cells) do
		iter1.attachment = ChapterConst.AttachNone
		iter1.attachmentId = nil
		iter1.flag = nil
		iter1.data = nil
	end

	arg0.champions = {}
	arg0.modelCount = arg0:getOniChapterInfo().special_item
	arg0.roundIndex = 0
end

function var0.onBombEnemyEnter(arg0)
	for iter0, iter1 in pairs(arg0.cells) do
		iter1.attachment = ChapterConst.AttachNone
		iter1.attachmentId = nil
		iter1.flag = nil
		iter1.data = nil
	end

	arg0.champions = {}
	arg0.modelCount = 0
	arg0.roundIndex = 0
end

function var0.clearSubmarineFleet(arg0)
	for iter0 = #arg0.fleets, 1, -1 do
		if arg0.fleets[iter0]:getFleetType() == FleetType.Submarine then
			table.remove(arg0.fleets, iter0)
		end
	end
end

function var0.getSpAppearStory(arg0)
	if arg0:existOni() then
		for iter0, iter1 in ipairs(arg0.champions) do
			if iter1.trait == ChapterConst.TraitLurk and iter1.attachment == ChapterConst.AttachOni then
				local var0 = iter1:getConfig("appear_story")

				if var0 and #var0 > 0 then
					return var0
				end
			end
		end
	elseif arg0:isPlayingWithBombEnemy() then
		for iter2, iter3 in pairs(arg0.cells) do
			if iter3.attachment == ChapterConst.AttachBomb_Enemy and iter3.trait == ChapterConst.TraitLurk then
				local var1 = pg.specialunit_template[iter3.attachmentId]

				if var1.appear_story and #var1.appear_story > 0 then
					return var1.appear_story
				end
			end
		end
	end
end

function var0.getSpAppearGuide(arg0)
	if arg0:existOni() then
		for iter0, iter1 in ipairs(arg0.champions) do
			if iter1.trait == ChapterConst.TraitLurk and iter1.attachment == ChapterConst.AttachOni then
				local var0 = iter1:getConfig("appear_guide")

				if var0 and #var0 > 0 then
					return var0
				end
			end
		end
	elseif arg0:isPlayingWithBombEnemy() then
		for iter2, iter3 in pairs(arg0.cells) do
			if iter3.attachment == ChapterConst.AttachBomb_Enemy and iter3.trait == ChapterConst.TraitLurk then
				local var1 = pg.specialunit_template[iter3.attachmentId]

				if var1.appear_guide and #var1.appear_guide > 0 then
					return var1.appear_guide
				end
			end
		end
	end
end

function var0.CheckTransportState(arg0)
	local var0 = _.detect(arg0.fleets, function(arg0)
		return arg0:getFleetType() == FleetType.Transport
	end)

	if not var0 then
		return -1
	end

	local var1 = arg0:findChapterCell(ChapterConst.AttachTransport_Target)

	assert(var0, "transport fleet not exist.")
	assert(var1, "transport target not exist.")

	if not var0:isValid() then
		return -1
	elseif var0.line.row == var1.row and var0.line.column == var1.column and not arg0:existEnemy(ChapterConst.SubjectPlayer, var1.row, var1.column) then
		return 1
	else
		return 0
	end
end

function var0.getCoastalGunArea(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.cells) do
		if iter1.attachment == ChapterConst.AttachLandbase and iter1.flag ~= ChapterConst.CellFlagDisabled then
			local var1 = pg.land_based_template[iter1.attachmentId]

			if var1.type == ChapterConst.LBCoastalGun then
				local var2 = var1.function_args
				local var3 = {
					math.abs(var2[1]),
					math.abs(var2[2])
				}
				local var4 = {
					Mathf.Sign(var2[1]),
					Mathf.Sign(var2[2])
				}
				local var5 = math.max(var3[1], var3[2])

				for iter2 = 1, var5 do
					table.insert(var0, {
						row = iter1.row + math.min(var3[1], iter2) * var4[1],
						column = iter1.column + math.min(var3[2], iter2) * var4[2]
					})
				end
			end
		end
	end

	return var0
end

function var0.GetAntiAirGunArea(arg0)
	local var0 = {}
	local var1 = {}

	for iter0, iter1 in pairs(arg0.cells) do
		if iter1.attachment == ChapterConst.AttachLandbase and iter1.flag ~= ChapterConst.CellFlagDisabled then
			local var2 = pg.land_based_template[iter1.attachmentId]

			if var2.type == ChapterConst.LBAntiAir then
				local var3 = var2.function_args
				local var4 = math.abs(var3[1])

				local function var5(arg0, arg1)
					return ChapterConst.MaxColumn * arg0 + arg1
				end

				local var6 = {}
				local var7 = {}

				if var4 > 0 then
					var6[var5(iter1.row, iter1.column)] = iter1
				end

				while next(var6) do
					local var8 = next(var6)
					local var9 = var6[var8]

					var6[var8] = nil

					if var4 >= math.abs(var9.row - iter1.row) and var4 >= math.abs(var9.column - iter1.column) then
						var7[var8] = var9

						for iter2 = 1, #var2 do
							local var10 = var9.row + var2[iter2][1]
							local var11 = var9.column + var2[iter2][2]
							local var12 = var5(var10, var11)

							if not var7[var12] then
								var6[var12] = {
									row = var10,
									column = var11
								}
							end
						end
					end
				end

				for iter3, iter4 in pairs(var7) do
					var1[iter3] = iter4
				end
			end
		end
	end

	for iter5, iter6 in pairs(var1) do
		table.insert(var0, iter6)
	end

	return var0
end

function var0.GetDefeatCount(arg0)
	return arg0.defeatEnemies
end

function var0.ExistDivingChampion(arg0)
	return _.any(arg0.champions, function(arg0)
		return arg0.flag == ChapterConst.CellFlagDiving
	end)
end

function var0.IsSkipPrecombat(arg0)
	return arg0:isLoop() and getProxy(ChapterProxy):GetSkipPrecombat()
end

function var0.CanActivateAutoFight(arg0)
	local var0 = pg.chapter_template_loop[arg0.id]

	return var0 and var0.fightauto == 1 and arg0:isLoop() and AutoBotCommand.autoBotSatisfied() and not arg0:existOni() and not arg0:existBombEnemy()
end

function var0.IsAutoFight(arg0)
	return arg0:CanActivateAutoFight() and getProxy(ChapterProxy):GetChapterAutoFlag(arg0.id) == 1
end

function var0.getOperationBuffDescStg(arg0)
	for iter0, iter1 in ipairs(arg0.operationBuffList) do
		if pg.benefit_buff_template[iter1].benefit_type == Chapter.OPERATION_BUFF_TYPE_DESC then
			return iter1
		end
	end
end

function var0.GetOperationDesc(arg0)
	local var0 = ""

	for iter0, iter1 in ipairs(arg0.operationBuffList) do
		local var1 = pg.benefit_buff_template[iter1]

		if var1.benefit_type == var0.OPERATION_BUFF_TYPE_DESC then
			var0 = var1.desc

			break
		end
	end

	return var0
end

function var0.GetOperationBuffList(arg0)
	return arg0.operationBuffList
end

function var0.GetAllEnemies(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.cells) do
		if ChapterConst.IsEnemyAttach(iter1.attachment) and (arg1 or iter1.flag ~= ChapterConst.CellFlagDisabled) then
			table.insert(var0, iter1)
		end
	end

	for iter2, iter3 in pairs(arg0.champions) do
		if arg1 or iter3.flag ~= ChapterConst.CellFlagDisabled then
			table.insert(var0, iter3)
		end
	end

	return var0
end

function var0.GetFleetofDuty(arg0, arg1)
	local var0

	for iter0, iter1 in ipairs(arg0.fleets) do
		if iter1:isValid() and iter1:getFleetType() == FleetType.Normal then
			local var1 = arg0.duties[iter1.id] or 0

			if var1 == ChapterFleet.DUTY_KILLALL or arg1 and var1 == ChapterFleet.DUTY_KILLBOSS or not arg1 and var1 == ChapterFleet.DUTY_CLEANPATH then
				return iter1
			end

			var0 = iter1
		end
	end

	return var0
end

function var0.GetBuffOfLinkAct(arg0)
	if arg0:getPlayType() == ChapterConst.TypeDOALink then
		local var0 = pg.gameset.doa_fever_buff.description

		return _.detect(arg0.buff_list, function(arg0)
			return table.contains(var0, arg0)
		end)
	end
end

function var0.GetAttachmentStories(arg0)
	local var0 = arg0.cellAttachments
	local var1 = 0
	local var2

	for iter0, iter1 in pairs(var0) do
		local var3 = var0.GetEventTemplateByKey("mult_story", iter1.attachmentId)

		if var3 then
			assert(not var2 or table.equal(var2, var3[1]), "Not the same Config of Mult_story ID: " .. iter1.attachmentId)

			var2 = var2 or var3[1]

			local var4 = arg0.cells[iter0]

			if var4 and var4.flag == ChapterConst.CellFlagDisabled then
				var1 = var1 + 1
			end
		end
	end

	return var2, var1
end

function var0.GetWeather(arg0, arg1, arg2)
	arg1 = arg1 or arg0.fleet.line.row
	arg2 = arg2 or arg0.fleet.line.column

	local var0 = ChapterCell.Line2Name(arg1, arg2)
	local var1 = arg0.cells[var0]

	return var1 and var1:GetWeatherFlagList() or {}
end

function var0.getDisplayEnemyCount(arg0)
	local var0 = 0

	local function var1(arg0)
		if arg0.flag ~= ChapterConst.CellFlagDisabled then
			var0 = var0 + 1
		end
	end

	local var2 = {
		[ChapterConst.AttachEnemy] = var1,
		[ChapterConst.AttachElite] = var1,
		[ChapterConst.AttachBox] = function(arg0)
			if pg.box_data_template[arg0.attachmentId].type == ChapterConst.BoxEnemy then
				var1(arg0)
			end
		end
	}

	for iter0, iter1 in pairs(arg0.cells) do
		switch(iter1.attachment, var2, nil, iter1)
	end

	for iter2, iter3 in ipairs(arg0.champions) do
		var1(iter3)
	end

	return var0
end

function var0.getNearestEnemyCell(arg0)
	local function var0(arg0, arg1)
		return (arg0.row - arg1.row) * (arg0.row - arg1.row) + (arg0.column - arg1.column) * (arg0.column - arg1.column)
	end

	local var1

	local function var2(arg0)
		if arg0.flag ~= ChapterConst.CellFlagDisabled and (not var1 or var0(arg0.fleet.line, arg0) < var0(arg0.fleet.line, var1)) then
			var1 = arg0
		end
	end

	local var3 = {
		[ChapterConst.AttachEnemy] = var2,
		[ChapterConst.AttachElite] = var2,
		[ChapterConst.AttachBox] = function(arg0)
			if pg.box_data_template[arg0.attachmentId].type == ChapterConst.BoxEnemy then
				var2(arg0)
			end
		end
	}

	for iter0, iter1 in pairs(arg0.cells) do
		switch(iter1.attachment, var3, nil, iter1)
	end

	for iter2, iter3 in ipairs(arg0.champions) do
		var2(iter3)
	end

	return var1
end

function var0.GetRegularFleetIds(arg0)
	return (_.map(_.filter(arg0.fleets, function(arg0)
		local var0 = arg0:getFleetType()

		return var0 == FleetType.Normal or var0 == FleetType.Submarine
	end), function(arg0)
		return arg0.fleetId
	end))
end

return var0
