local var0_0 = import(".Chapter")

function var0_0.update(arg0_1, arg1_1)
	assert(arg1_1.id == arg0_1.id, "章节ID不一致, 无法更新数据")

	arg0_1.active = true
	arg0_1.dueTime = arg1_1.time
	arg0_1.activeTime = arg1_1.start_time
	arg0_1.loopFlag = arg1_1.loop_flag
	arg0_1.modelCount = arg1_1.model_act_count
	arg0_1.roundIndex = arg1_1.round
	arg0_1.subAutoAttack = arg1_1.is_submarine_auto_attack
	arg0_1.barriers = 0
	arg0_1.pathFinder = OrientedPathFinding.New({}, ChapterConst.MaxRow, ChapterConst.MaxColumn)
	arg0_1.wallAssets = {}

	if arg0_1:getConfig("wall_prefab") and #arg0_1:getConfig("wall_prefab") > 0 then
		for iter0_1, iter1_1 in ipairs(arg0_1:getConfig("wall_prefab")) do
			arg0_1.wallAssets[iter1_1[1] .. "_" .. iter1_1[2]] = iter1_1
		end
	end

	arg0_1.winConditions = {}

	local var0_1 = arg0_1:getConfig("win_condition")

	assert(var0_1, "Assure Chapter's WIN Conditions is not empty")

	for iter2_1, iter3_1 in pairs(var0_1) do
		table.insert(arg0_1.winConditions, {
			type = iter3_1[1],
			param = iter3_1[2]
		})
	end

	arg0_1.loseConditions = {}

	local var1_1 = arg0_1:getConfig("lose_condition")

	assert(var1_1, "Assure Chapter's LOSE Conditions is not empty")

	for iter4_1, iter5_1 in pairs(var1_1) do
		table.insert(arg0_1.loseConditions, {
			type = iter5_1[1],
			param = iter5_1[2]
		})
	end

	arg0_1.theme = ChapterTheme.New(arg0_1:getConfig("theme"))

	local var2_1 = arg1_1.cell_list
	local var3_1 = arg1_1.cell_flag_list
	local var4_1 = arg0_1:getConfig("float_items")
	local var5_1 = arg0_1:getConfig("grids")

	arg0_1.cells = {}
	arg0_1.cellAttachments = {}

	local function var6_1(arg0_2)
		local var0_2 = ChapterCell.Line2Name(arg0_2.pos.row, arg0_2.pos.column)

		if arg0_2.item_type == ChapterConst.AttachStory and arg0_2.item_data == ChapterConst.StoryTrigger then
			if arg0_1.cellAttachments[var0_2] then
				warning("Multi Cell Attachemnts in one cell " .. arg0_2.pos.row .. " " .. arg0_2.pos.column)
			end

			arg0_1.cellAttachments[var0_2] = ChapterCell.New(arg0_2)
			arg0_2 = {
				item_id = 0,
				item_data = 0,
				item_flag = 0,
				pos = {
					row = arg0_2.pos.row,
					column = arg0_2.pos.column
				},
				item_type = ChapterConst.AttachNone
			}
		end

		if not arg0_1.cells[var0_2] or arg0_1.cells[var0_2].attachment == ChapterConst.AttachNone then
			local var1_2 = ChapterCell.New(arg0_2)

			if var1_2.attachment == ChapterConst.AttachOni_Target or var1_2.attachment == ChapterConst.AttachOni then
				var1_2.attachment = ChapterConst.AttachNone
			end

			local var2_2 = _.detect(var4_1, function(arg0_3)
				return arg0_3[1] == var1_2.row and arg0_3[2] == var1_2.column
			end)

			if var2_2 then
				var1_2.item = var2_2[3]
				var1_2.itemOffset = Vector2(var2_2[4], var2_2[5])
			end

			arg0_1.cells[var0_2] = var1_2

			return var1_2
		end
	end

	_.each(var2_1, function(arg0_4)
		var6_1(arg0_4)
	end)
	_.each(var5_1, function(arg0_5)
		local var0_5 = ChapterCell.Line2Name(arg0_5[1], arg0_5[2])

		;(arg0_1.cells[var0_5] or var6_1({
			pos = {
				row = arg0_5[1],
				column = arg0_5[2]
			},
			item_type = ChapterConst.AttachNone
		})):SetWalkable(arg0_5[3])
	end)

	arg0_1.cellsCount = #underscore.values(arg0_1.cells)

	if arg0_1:IsFogStage() then
		arg0_1.fleetVisibleStore = {}
		arg0_1.cellsVisibleCount = 0

		for iter6_1, iter7_1 in pairs(arg0_1.cells) do
			iter7_1:InitVisible()
		end
	end

	arg0_1.indexMin, arg0_1.indexMax = Vector2(ChapterConst.MaxRow, ChapterConst.MaxColumn), Vector2(-ChapterConst.MaxRow, -ChapterConst.MaxColumn)

	_.each(var5_1, function(arg0_6)
		arg0_1.indexMin.x = math.min(arg0_1.indexMin.x, arg0_6[1])
		arg0_1.indexMin.y = math.min(arg0_1.indexMin.y, arg0_6[2])
		arg0_1.indexMax.x = math.max(arg0_1.indexMax.x, arg0_6[1])
		arg0_1.indexMax.y = math.max(arg0_1.indexMax.y, arg0_6[2])
	end)
	_.each(var3_1 or {}, function(arg0_7)
		local var0_7 = ChapterCell.Line2Name(arg0_7.pos.row, arg0_7.pos.column)
		local var1_7 = arg0_1.cells[var0_7]

		assert(var1_7, "Attach cellFlaglist On NIL Cell " .. var0_7)

		if var1_7 then
			var1_7:updateFlagList(arg0_7)
		end
	end)

	arg0_1.buff_list = {}

	if arg1_1.buff_list then
		for iter8_1, iter9_1 in ipairs(arg1_1.buff_list) do
			arg0_1.buff_list[iter8_1] = iter9_1
		end
	end

	arg0_1.operationBuffList = {}

	for iter10_1, iter11_1 in ipairs(arg1_1.operation_buff) do
		arg0_1.operationBuffList[#arg0_1.operationBuffList + 1] = iter11_1
	end

	local var7_1 = arg0_1:getNpcShipByType()

	arg0_1.fleets = {}

	for iter12_1, iter13_1 in pairs({
		[FleetType.Normal] = arg1_1.main_group_list,
		[FleetType.Submarine] = arg1_1.submarine_group_list,
		[FleetType.Support] = arg1_1.support_group_list
	}) do
		for iter14_1, iter15_1 in ipairs(iter13_1) do
			local var8_1 = ChapterFleet.New(setmetatable({
				fleetType = iter12_1
			}, {
				__index = iter15_1
			}), var7_1)

			var8_1:setup(arg0_1)
			table.insert(arg0_1.fleets, var8_1)
		end
	end

	table.sort(arg0_1.fleets, CompareFuncs({
		function(arg0_8)
			return arg0_8.id
		end
	}))

	if arg1_1.escort_list then
		for iter16_1, iter17_1 in ipairs(arg1_1.escort_list) do
			arg0_1.fleets[#arg0_1.fleets + 1] = ChapterTransportFleet.New(iter17_1, #arg0_1.fleets + 1)
		end
	end

	arg0_1.findex = 0
	arg0_1.findex = arg0_1:getNextValidIndex()

	if arg0_1.findex == 0 then
		arg0_1.findex = 1
	end

	arg0_1.champions = {}

	if arg1_1.ai_list then
		for iter18_1, iter19_1 in ipairs(arg1_1.ai_list) do
			if iter19_1.item_flag ~= 1 then
				local var9_1 = ChapterChampionPackage.New(iter19_1)

				arg0_1:mergeChampion(var9_1, true)
			end
		end
	end

	arg0_1.airDominanceStatus = nil
	arg0_1.extraFlagList = {}

	for iter20_1, iter21_1 in ipairs(arg1_1.extra_flag_list) do
		table.insert(arg0_1.extraFlagList, iter21_1)
	end

	arg0_1.defeatEnemies = arg1_1.kill_count or 0
	arg0_1.BaseHP = arg1_1.chapter_hp or 0
	arg0_1.orignalShipCount = arg1_1.init_ship_count or 0
	arg0_1.combo = arg1_1.continuous_kill_count or 0
	arg0_1.scoreHistory = {}

	for iter22_1 = ys.Battle.BattleConst.BattleScore.D, ys.Battle.BattleConst.BattleScore.S do
		arg0_1.scoreHistory[iter22_1] = 0
	end

	if arg1_1.battle_statistics then
		for iter23_1, iter24_1 in ipairs(arg1_1.battle_statistics) do
			arg0_1.scoreHistory[iter24_1.id] = iter24_1.count
		end
	end

	local var10_1 = {}

	if arg1_1.chapter_strategy_list then
		for iter25_1, iter26_1 in ipairs(arg1_1.chapter_strategy_list) do
			var10_1[iter26_1.id] = iter26_1.count
		end
	end

	arg0_1.strategies = var10_1
	arg0_1.duties = {}

	if #arg1_1.fleet_duties > 0 then
		_.each(arg1_1.fleet_duties, function(arg0_9)
			arg0_1.duties[arg0_9.key] = arg0_9.value
		end)
	end

	arg0_1.moveStep = arg1_1.move_step_count or 0
	arg0_1.activateAmbush = not arg0_1:isLoop() and arg0_1:GetWillActiveAmbush()
end

function var0_0.retreat(arg0_10, arg1_10, arg2_10, arg3_10)
	if arg1_10 then
		arg0_10.todayDefeatCount = arg0_10.todayDefeatCount + 1

		arg0_10:updateTodayDefeatCount()

		if arg2_10 == 1 and arg3_10 and arg3_10 > 0 then
			getProxy(ChapterAutoProxy):UpdateRecord(ChapterAutoProxy.TYPE.SLG, arg0_10.id, arg3_10)
		end
	end
end

function var0_0.CleanLevelData(arg0_11)
	arg0_11.active = false
	arg0_11.loopFlag = 0
	arg0_11.activeTime = nil
	arg0_11.dueTime = nil
	arg0_11.cells = nil
	arg0_11.fleets = nil
	arg0_11.findex = nil
	arg0_11.champions = nil
	arg0_11.cellAttachments = nil
	arg0_11.round = nil
	arg0_11.airDominanceStatus = nil
	arg0_11.winConditions, arg0_11.loseConditions = nil
	arg0_11.theme = nil
	arg0_11.buff_list = nil
	arg0_11.operationBuffList = nil
	arg0_11.modelCount = nil
	arg0_11.roundIndex = nil
	arg0_11.subAutoAttack = nil
	arg0_11.barriers = nil
	arg0_11.pathFinder = nil
	arg0_11.wallAssets = nil
	arg0_11.strategies = nil
	arg0_11.duties = nil
	arg0_11.indexMin, arg0_11.indexMax = nil
	arg0_11.extraFlagList = nil
	arg0_11.defeatEnemies = nil
	arg0_11.BaseHP = nil
	arg0_11.orignalShipCount = nil
	arg0_11.combo = nil
	arg0_11.scoreHistory = nil
end

function var0_0.__index(arg0_12, arg1_12)
	if arg1_12 == "fleet" then
		local var0_12 = rawget(arg0_12, "fleets")

		if not var0_12 then
			return nil
		end

		return var0_12[rawget(arg0_12, "findex")]
	end

	return rawget(arg0_12, arg1_12) or var0_0[arg1_12]
end

function var0_0.GetActiveFleet(arg0_13)
	if not arg0_13.fleets then
		return nil
	end

	return arg0_13.fleets[arg0_13.findex]
end

function var0_0.getFleetById(arg0_14, arg1_14)
	return _.detect(arg0_14.fleets, function(arg0_15)
		return arg0_15.id == arg1_14
	end)
end

function var0_0.getChapterSupportFleet(arg0_16)
	return table.Find(arg0_16.fleets, function(arg0_17, arg1_17)
		return arg1_17:getFleetType() == FleetType.Support
	end)
end

function var0_0.getFleetByShipVO(arg0_18, arg1_18)
	local var0_18 = arg1_18.id
	local var1_18

	for iter0_18, iter1_18 in ipairs(arg0_18.fleets) do
		if iter1_18:getShip(var0_18) then
			var1_18 = iter1_18

			break
		end
	end

	return var1_18
end

function var0_0.getRound(arg0_19)
	return arg0_19.roundIndex % 2
end

function var0_0.getRoundNum(arg0_20)
	return math.floor(arg0_20.roundIndex / 2)
end

function var0_0.IncreaseRound(arg0_21)
	arg0_21.roundIndex = arg0_21.roundIndex + 1
end

function var0_0.existMoveLimit(arg0_22)
	return arg0_22:getConfig("is_limit_move") == 1 or arg0_22:existOni() or arg0_22:isPlayingWithBombEnemy()
end

function var0_0.getChapterCell(arg0_23, arg1_23, arg2_23)
	local var0_23 = ChapterCell.Line2Name(arg1_23, arg2_23)

	return Clone(arg0_23.cells[var0_23])
end

function var0_0.GetRawChapterCell(arg0_24, arg1_24, arg2_24)
	local var0_24 = ChapterCell.Line2Name(arg1_24, arg2_24)

	return arg0_24.cells[var0_24]
end

function var0_0.FilterCell(arg0_25, arg1_25)
	return table.Checkout(arg0_25.cells, arg1_25)
end

function var0_0.findChapterCell(arg0_26, arg1_26, arg2_26)
	for iter0_26, iter1_26 in pairs(arg0_26.cells) do
		if iter1_26.attachment == arg1_26 and (not arg2_26 or iter1_26.attachmentId == arg2_26) then
			return iter1_26
		end
	end

	return nil
end

function var0_0.findChapterCells(arg0_27, arg1_27, arg2_27)
	local var0_27 = {}

	for iter0_27, iter1_27 in pairs(arg0_27.cells) do
		if iter1_27.attachment == arg1_27 and (not arg2_27 or iter1_27.attachmentId == arg2_27) then
			table.insert(var0_27, iter1_27)
		end
	end

	return var0_27
end

function var0_0.GetBossCell(arg0_28)
	return table.Find(arg0_28.cells, function(arg0_29, arg1_29)
		return ChapterConst.IsBossCell(arg1_29)
	end)
end

function var0_0.mergeChapterCell(arg0_30, arg1_30, arg2_30)
	local var0_30 = ChapterCell.Line2Name(arg1_30.row, arg1_30.column)
	local var1_30 = arg0_30.cells[var0_30]
	local var2_30 = var1_30 == nil or var1_30.attachment ~= arg1_30.attachment or var1_30.attachmentId ~= arg1_30.attachmentId

	if var1_30 then
		var1_30.attachment = arg1_30.attachment
		var1_30.attachmentId = arg1_30.attachmentId
		var1_30.flag = arg1_30.flag
		var1_30.data = arg1_30.data
		arg1_30 = var1_30
	end

	if not arg2_30 and var2_30 and ChapterConst.NeedMarkAsLurk(arg1_30) then
		arg1_30.trait = ChapterConst.TraitLurk
	end

	if ChapterConst.IsBossCell(arg1_30) then
		local var3_30 = arg0_30:getChampionIndex(arg1_30.row, arg1_30.column)

		if var3_30 then
			table.remove(arg0_30.champions, var3_30)
		end
	end

	arg0_30:updateChapterCell(arg1_30)
end

function var0_0.updateChapterCell(arg0_31, arg1_31)
	local var0_31 = ChapterCell.Line2Name(arg1_31.row, arg1_31.column)

	arg0_31.cells[var0_31] = Clone(arg1_31)
end

function var0_0.clearChapterCell(arg0_32, arg1_32, arg2_32)
	local var0_32 = ChapterCell.Line2Name(arg1_32, arg2_32)
	local var1_32 = arg0_32.cells[var0_32]

	var1_32.attachment = ChapterConst.AttachNone
	var1_32.attachmentId = 0
	var1_32.flag = ChapterConst.CellFlagActive
	var1_32.data = 0
	var1_32.trait = ChapterConst.TraitNone
end

function var0_0.GetChapterCellAttachemnts(arg0_33)
	return arg0_33.cellAttachments
end

function var0_0.GetRawChapterAttachemnt(arg0_34, arg1_34, arg2_34)
	local var0_34 = ChapterCell.Line2Name(arg1_34, arg2_34)

	return arg0_34.cellAttachments[var0_34]
end

function var0_0.getShips(arg0_35)
	local var0_35 = {}

	_.each(arg0_35.fleets, function(arg0_36)
		local var0_36 = arg0_36:getShips(true)

		_.each(var0_36, function(arg0_37)
			table.insert(var0_35, Clone(arg0_37))
		end)
	end)

	return var0_35
end

function var0_0.getNextValidIndex(arg0_38)
	for iter0_38 = arg0_38.findex + 1, #arg0_38.fleets do
		if arg0_38.fleets[iter0_38]:getFleetType() == FleetType.Normal and arg0_38.fleets[iter0_38]:isValid() then
			return iter0_38
		end
	end

	for iter1_38 = 1, arg0_38.findex - 1 do
		if arg0_38.fleets[iter1_38]:getFleetType() == FleetType.Normal and arg0_38.fleets[iter1_38]:isValid() then
			return iter1_38
		end
	end

	return 0
end

function var0_0.getAmbushRate(arg0_39, arg1_39, arg2_39)
	local var0_39 = arg1_39:getInvestSums()
	local var1_39 = arg0_39:getConfig("investigation_ratio")
	local var2_39 = var1_39 / (var1_39 + var0_39) / 4
	local var3_39 = _.detect(arg0_39:getConfig("ambush_ratio_extra"), function(arg0_40)
		return arg0_40[1] == arg2_39.row and arg0_40[2] == arg2_39.column
	end)
	local var4_39 = _.detect(arg0_39:getConfig("ambush_ratio_extra"), function(arg0_41)
		return #arg0_41 == 1
	end)
	local var5_39

	var5_39 = var3_39 and var3_39[3] / 10000 or 0

	local var6_39 = var5_39 + (var4_39 and var4_39[1] / 10000 or 0)
	local var7_39 = 0.05 + var2_39 * math.max(arg1_39.step - 1, 0) + var6_39

	if var6_39 == 0 then
		var7_39 = var7_39 - arg1_39:getEquipAmbushRateReduce()
	end

	return (math.clamp(var7_39, 0, 1))
end

function var0_0.getAmbushDodge(arg0_42, arg1_42)
	local var0_42 = arg1_42.line
	local var1_42 = arg1_42:getDodgeSums()
	local var2_42 = var1_42 / (var1_42 + arg0_42:getConfig("avoid_ratio"))
	local var3_42 = _.detect(arg0_42:getConfig("ambush_ratio_extra"), function(arg0_43)
		return arg0_43[1] == var0_42.row and arg0_43[2] == var0_42.column
	end)
	local var4_42

	var4_42 = var3_42 and var3_42[3] / 10000 or 0

	if var4_42 == 0 then
		var2_42 = var2_42 + arg1_42:getEquipDodgeRateUp()
	end

	return (math.clamp(var2_42, 0, 1))
end

function var0_0.inWartime(arg0_44)
	return arg0_44.dueTime and pg.TimeMgr.GetInstance():GetServerTime() < arg0_44.dueTime
end

function var0_0.inActTime(arg0_45)
	local var0_45 = arg0_45:GetBindActID()

	if var0_45 == 0 then
		return true
	end

	local var1_45 = var0_45 and getProxy(ActivityProxy):getActivityById(var0_45)

	return var1_45 and not var1_45:isEnd()
end

function var0_0.getRemainTime(arg0_46)
	return arg0_46.dueTime and math.max(arg0_46.dueTime - pg.TimeMgr.GetInstance():GetServerTime() - 1, 0) or 0
end

function var0_0.getStartTime(arg0_47)
	return math.max(arg0_47.dueTime - arg0_47:getConfig("time"), 0)
end

function var0_0.GetWillActiveAmbush(arg0_48)
	if not arg0_48:existAmbush() then
		return false
	end

	local var0_48 = arg0_48:getConfig("avoid_require")

	return not _.any(arg0_48.fleets, function(arg0_49)
		return arg0_49:getFleetType() == FleetType.Normal and arg0_49:getInvestSums(true) >= var0_48
	end)
end

function var0_0.findPath(arg0_50, arg1_50, arg2_50, arg3_50)
	local var0_50 = {}

	for iter0_50 = 0, ChapterConst.MaxRow - 1 do
		var0_50[iter0_50] = var0_50[iter0_50] or {}

		for iter1_50 = 0, ChapterConst.MaxColumn - 1 do
			var0_50[iter0_50][iter1_50] = var0_50[iter0_50][iter1_50] or {}

			local var1_50 = PathFinding.PrioForbidden
			local var2_50 = ChapterConst.ForbiddenAll
			local var3_50 = ChapterCell.Line2Name(iter0_50, iter1_50)
			local var4_50 = arg0_50.cells[var3_50]

			if var4_50 and var4_50:IsWalkable() then
				var1_50 = PathFinding.PrioNormal

				if arg0_50:considerAsObstacle(arg1_50, var4_50.row, var4_50.column) then
					var1_50 = PathFinding.PrioObstacle
				end

				if arg1_50 == ChapterConst.SubjectPlayer then
					var2_50 = var4_50.forbiddenDirections
				else
					var2_50 = ChapterConst.ForbiddenNone
				end
			end

			var0_50[iter0_50][iter1_50].forbiddens = var2_50
			var0_50[iter0_50][iter1_50].priority = var1_50
		end
	end

	if arg1_50 == ChapterConst.SubjectPlayer then
		local var5_50 = arg0_50:getCoastalGunArea()

		for iter2_50, iter3_50 in ipairs(var5_50) do
			var0_50[iter3_50.row][iter3_50.column].priority = math.max(var0_50[iter3_50.row][iter3_50.column].priority, PathFinding.PrioObstacle)
		end
	end

	local var6_50 = var0_50[arg3_50.row] and var0_50[arg3_50.row][arg3_50.column]

	if var6_50 then
		var6_50.priority = arg0_50:considerAsStayPoint(arg1_50, arg3_50.row, arg3_50.column) and PathFinding.PrioNormal or PathFinding.PrioObstacle
	end

	arg0_50.pathFinder.cells = var0_50

	return arg0_50.pathFinder:Find(arg2_50, arg3_50)
end

function var0_0.FindBossPath(arg0_51, arg1_51, arg2_51)
	local var0_51 = ChapterConst.SubjectPlayer
	local var1_51 = {}

	for iter0_51 = 0, ChapterConst.MaxRow - 1 do
		var1_51[iter0_51] = var1_51[iter0_51] or {}

		for iter1_51 = 0, ChapterConst.MaxColumn - 1 do
			var1_51[iter0_51][iter1_51] = var1_51[iter0_51][iter1_51] or {}

			local var2_51 = PathFinding.PrioForbidden
			local var3_51 = ChapterConst.ForbiddenAll
			local var4_51
			local var5_51 = ChapterCell.Line2Name(iter0_51, iter1_51)
			local var6_51 = arg0_51.cells[var5_51]

			if var6_51 and var6_51:IsWalkable() then
				var2_51 = PathFinding.PrioNormal

				if arg0_51:considerAsObstacle(var0_51, var6_51.row, var6_51.column) then
					var2_51 = PathFinding.PrioObstacle
				end

				local var7_51 = arg0_51:GetEnemy(var6_51.row, var6_51.column)

				if var7_51 then
					var2_51 = PathFinding.PrioNormal
					var4_51 = not ChapterConst.IsBossCell(var7_51)
				end

				var3_51 = var6_51.forbiddenDirections
			end

			var1_51[iter0_51][iter1_51].forbiddens = var3_51
			var1_51[iter0_51][iter1_51].priority = var2_51
			var1_51[iter0_51][iter1_51].isEnemy = var4_51
		end
	end

	local var8_51 = arg0_51:getCoastalGunArea()

	for iter2_51, iter3_51 in ipairs(var8_51) do
		var1_51[iter3_51.row][iter3_51.column].priority = math.max(var1_51[iter3_51.row][iter3_51.column].priority, PathFinding.PrioObstacle)
	end

	local var9_51 = var1_51[arg2_51.row] and var1_51[arg2_51.row][arg2_51.column]

	if var9_51 then
		var9_51.priority = arg0_51:considerAsStayPoint(var0_51, arg2_51.row, arg2_51.column) and PathFinding.PrioNormal or PathFinding.PrioObstacle
	end

	return OrientedWeightPathFinding.StaticFind(var1_51, ChapterConst.MaxRow, ChapterConst.MaxColumn, arg1_51, arg2_51)
end

function var0_0.getWaveCount(arg0_52)
	local var0_52 = 0

	for iter0_52, iter1_52 in pairs(arg0_52.cells) do
		if iter1_52.attachment == ChapterConst.AttachEnemy and underscore.detect(arg0_52:getConfig("grids"), function(arg0_53)
			if arg0_53[1] == iter1_52.row and arg0_53[2] == iter1_52.column and (arg0_53[4] == ChapterConst.AttachElite or arg0_53[4] == ChapterConst.AttachEnemy) then
				return true
			end

			return false
		end) then
			var0_52 = var0_52 + 1
		end
	end

	local var1_52 = 0
	local var2_52 = pg.chapter_group_refresh[arg0_52.id]

	if var2_52 then
		local var3_52 = 1

		repeat
			local var4_52 = false

			for iter2_52, iter3_52 in ipairs(var2_52.enemy_refresh) do
				var1_52 = var1_52 + (iter3_52[var3_52] or 0)
				var4_52 = var4_52 or tobool(iter3_52[var3_52])
			end

			if var0_52 <= var1_52 then
				return var3_52
			end

			var3_52 = var3_52 + 1
		until not var4_52
	else
		local var5_52 = arg0_52:getConfig("enemy_refresh")
		local var6_52 = arg0_52:getConfig("elite_refresh")

		for iter4_52, iter5_52 in pairs(var5_52) do
			var1_52 = var1_52 + iter5_52

			if iter4_52 <= #var6_52 then
				var1_52 = var1_52 + var6_52[iter4_52]
			end

			if var0_52 <= var1_52 then
				return iter4_52
			end
		end
	end

	return 1
end

function var0_0.IsFinalBossRefreshed(arg0_54)
	return tobool(arg0_54:findChapterCell(ChapterConst.AttachBoss))
end

function var0_0.getFleetAmmo(arg0_55, arg1_55)
	local var0_55 = arg1_55:getShipAmmo()
	local var1_55 = arg1_55:getFleetType()

	if var1_55 == FleetType.Normal then
		var0_55 = var0_55 + arg0_55:getConfig("ammo_total")
	elseif var1_55 == FleetType.Submarine then
		var0_55 = var0_55 + arg0_55:getConfig("ammo_submarine")
	else
		assert(false, "invalide operation.")
	end

	local var2_55 = arg1_55.restAmmo

	return var0_55, var2_55
end

function var0_0.GetInteractableStrategies(arg0_56)
	local var0_56 = arg0_56.fleet:getStrategies()
	local var1_56 = _.filter(var0_56, function(arg0_57)
		local var0_57 = pg.strategy_data_template[arg0_57.id]

		return var0_57 and var0_57.type ~= ChapterConst.StgTypeBindFleetPassive
	end)
	local var2_56 = arg0_56.fleet:getFormationStg()

	table.insert(var1_56, 1, {
		id = var2_56
	})

	if arg0_56:GetSubmarineFleet() then
		table.insert(var1_56, 3, {
			id = ChapterConst.StrategyHuntingRange
		})
		table.insert(var1_56, 4, {
			id = ChapterConst.StrategySubAutoAttack
		})
		table.insert(var1_56, 5, {
			id = ChapterConst.StrategySubTeleport
		})
	end

	local var3_56 = arg0_56:getChapterSupportFleet()

	if var3_56 then
		table.insertto(var1_56, _.filter(var3_56:getStrategies(), function(arg0_58)
			local var0_58 = pg.strategy_data_template[arg0_58.id]

			return var0_58 and var0_58.type == ChapterConst.StgTypeBindSupportConsume
		end))
	end

	if #arg0_56.strategies > 0 then
		for iter0_56, iter1_56 in pairs(arg0_56.strategies) do
			table.insert(var1_56, {
				id = iter0_56,
				count = iter1_56
			})
		end
	end

	return var1_56
end

function var0_0.getFleetStates(arg0_59, arg1_59)
	local var0_59 = {}
	local var1_59, var2_59 = arg0_59:getFleetAmmo(arg1_59)

	if var2_59 >= ChapterConst.AmmoRich then
		table.insert(var0_59, ChapterConst.StrategyAmmoRich)
	elseif var2_59 <= ChapterConst.AmmoPoor then
		table.insert(var0_59, ChapterConst.StrategyAmmoPoor)
	end

	local var3_59 = underscore.filter(arg1_59:getStrategies(), function(arg0_60)
		local var0_60 = pg.strategy_data_template[arg0_60.id]

		return var0_60 and var0_60.type == ChapterConst.StgTypeBindFleetPassive and arg0_60.count > 0
	end)

	table.insertto(var0_59, underscore.map(var3_59, function(arg0_61)
		return arg0_61.id
	end))
	table.insertto(var0_59, arg1_59.stgIds)

	local var4_59 = arg0_59:getConfig("chapter_strategy")

	for iter0_59, iter1_59 in ipairs(var4_59) do
		table.insert(var0_59, iter1_59)
	end

	if arg0_59:IsFogStage() then
		table.insert(var0_59, arg0_59:GetFogStageStrategy())
	end

	if OPEN_AIR_DOMINANCE and arg0_59:getConfig("air_dominance") > 0 then
		table.insert(var0_59, arg0_59:getAirDominanceStg())
	end

	for iter2_59, iter3_59 in ipairs(arg0_59:getExtraFlags()) do
		table.insert(var0_59, ChapterConst.Status2Stg[iter3_59])
	end

	local var5_59 = arg0_59:getOperationBuffDescStg()

	if var5_59 then
		table.insert(var0_59, var5_59)
	end

	underscore.each(arg0_59.buff_list, function(arg0_62)
		if ChapterConst.Buff2Stg[arg0_62] then
			table.insert(var0_59, ChapterConst.Buff2Stg[arg0_62])
		end
	end)

	local var6_59 = getProxy(ActivityProxy):getActivityById(ActivityConst.YUMIA_EXPEDITION_BUFF_ACT_ID)

	if var6_59 and not var6_59:isEnd() then
		local var7_59, var8_59 = unpack(getGameset("yumia_buff_mapping")[2])
		local var9_59 = {}

		for iter4_59 = 1, #var7_59 do
			var9_59[var7_59[iter4_59]] = var8_59[iter4_59]
		end

		local var10_59 = underscore.filter(var6_59:GetBuffList(), function(arg0_63)
			return arg0_63:isActivate() and arg0_63:checkChaper(arg0_59.id)
		end)

		table.sort(var10_59, CompareFuncs({
			function(arg0_64)
				return arg0_64.id
			end
		}))
		underscore.each(var10_59, function(arg0_65)
			if var9_59[arg0_65.id] then
				table.insert(var0_59, var9_59[arg0_65.id])
			end
		end)
	end

	return var0_59
end

function var0_0.GetShowingStrategies(arg0_66)
	local var0_66 = arg0_66.fleet
	local var1_66 = arg0_66:getFleetStates(var0_66)

	return (_.filter(var1_66, function(arg0_67)
		local var0_67 = pg.strategy_data_template[arg0_67]

		return var0_67 and var0_67.icon ~= ""
	end))
end

function var0_0.getAirDominanceStg(arg0_68)
	local var0_68, var1_68 = arg0_68:getAirDominanceValue()

	return ChapterConst.AirDominance[var1_68].StgId
end

function var0_0.getAirDominanceValue(arg0_69)
	local var0_69 = 0
	local var1_69 = 0

	for iter0_69, iter1_69 in pairs(arg0_69.fleets) do
		if iter1_69:isValid() and (iter1_69:getFleetType() == FleetType.Normal or iter1_69:getFleetType() == FleetType.Submarine) then
			var0_69 = var0_69 + iter1_69:getFleetAirDominanceValue()
			var1_69 = var1_69 + iter1_69:getAntiAircraftSums()
		end
	end

	return var0_69, calcAirDominanceStatus(var0_69, arg0_69:getConfig("air_dominance"), var1_69), arg0_69.airDominanceStatus
end

function var0_0.setAirDominanceStatus(arg0_70, arg1_70)
	arg0_70.airDominanceStatus = arg1_70
end

function var0_0.updateExtraFlags(arg0_71, arg1_71, arg2_71)
	local var0_71 = false

	for iter0_71, iter1_71 in ipairs(arg2_71) do
		for iter2_71, iter3_71 in ipairs(arg0_71.extraFlagList) do
			if iter3_71 == iter1_71 then
				table.remove(arg0_71.extraFlagList, iter2_71)

				var0_71 = true

				break
			end
		end
	end

	for iter4_71, iter5_71 in ipairs(arg1_71) do
		if not table.contains(arg0_71.extraFlagList, iter5_71) then
			table.insert(arg0_71.extraFlagList, 1, iter5_71)

			var0_71 = true
		end
	end

	return var0_71
end

function var0_0.getExtraFlags(arg0_72)
	return arg0_72.extraFlagList
end

function var0_0.UpdateBuffList(arg0_73, arg1_73)
	if not arg1_73 then
		return
	end

	for iter0_73, iter1_73 in ipairs(arg1_73) do
		if not _.include(arg0_73.buff_list, iter1_73) then
			table.insert(arg0_73.buff_list, iter1_73)
		end
	end
end

function var0_0.getFleetBattleBuffs(arg0_74, arg1_74)
	local var0_74 = table.shallowCopy(arg0_74.buff_list)

	_.each(arg0_74:getFleetStates(arg1_74), function(arg0_75)
		local var0_75 = pg.strategy_data_template[arg0_75]
		local var1_75 = var0_75.buff_id

		if var1_75 == 0 then
			return
		end

		if var0_75.buff_type == ChapterConst.StrategyBuffTypeOnlyBoss then
			local var2_75 = arg0_74:GetEnemy(arg1_74.line.row, arg1_74.line.column)

			if var2_75 and not ChapterConst.IsBossCell(var2_75) then
				return
			end
		end

		table.insert(var0_74, var1_75)
	end)
	table.insertto(var0_74, arg0_74:GetCellEventByKey("attach_buff", arg1_74.line.row, arg1_74.line.column) or {})
	_.each(arg0_74:GetWeather(), function(arg0_76)
		local var0_76 = pg.weather_data_template[arg0_76].effect_args

		if type(var0_76) == "table" and var0_76.buff and var0_76.buff > 0 then
			table.insert(var0_74, var0_76.buff)
		end
	end)

	local var1_74 = arg0_74:buildBattleBuffList(arg1_74)

	return var0_74, var1_74
end

function var0_0.GetStageFlags(arg0_77)
	local var0_77 = arg0_77.fleet.line.row
	local var1_77 = arg0_77.fleet.line.column

	return arg0_77:GetCellEventByKey("stage_flags", var0_77, var1_77) or {}
end

function var0_0.GetCellEventByKey(arg0_78, arg1_78, arg2_78, arg3_78)
	arg2_78 = arg2_78 or arg0_78.fleet.line.row
	arg3_78 = arg3_78 or arg0_78.fleet.line.column

	local var0_78 = ChapterCell.Line2Name(arg2_78, arg3_78)
	local var1_78 = arg0_78.cells[var0_78]

	if not var1_78 then
		return
	end

	return var0_0.GetEventTemplateByKey(arg1_78, var1_78.attachmentId)
end

function var0_0.GetEventTemplateByKey(arg0_79, arg1_79)
	local var0_79 = pg.map_event_template[arg1_79]

	if not var0_79 then
		return
	end

	local var1_79

	for iter0_79, iter1_79 in ipairs(var0_79.effect) do
		if iter1_79[1] == arg0_79 then
			for iter2_79 = 2, #iter1_79 do
				var1_79 = var1_79 or {}

				table.insert(var1_79, iter1_79[iter2_79])
			end
		end
	end

	return var1_79
end

function var0_0.buildBattleBuffList(arg0_80, arg1_80)
	local var0_80 = {}
	local var1_80, var2_80 = arg0_80:triggerSkill(arg1_80, FleetSkill.TypeBattleBuff)

	if var1_80 and #var1_80 > 0 then
		local var3_80 = {}

		for iter0_80, iter1_80 in ipairs(var1_80) do
			local var4_80 = var2_80[iter0_80]
			local var5_80 = arg1_80:findCommanderBySkillId(var4_80.id)

			var3_80[var5_80] = var3_80[var5_80] or {}

			table.insert(var3_80[var5_80], iter1_80)
		end

		for iter2_80, iter3_80 in pairs(var3_80) do
			table.insert(var0_80, {
				iter2_80,
				iter3_80
			})
		end
	end

	local var6_80 = arg1_80:getCommanders()

	for iter4_80, iter5_80 in pairs(var6_80) do
		local var7_80 = iter5_80:getTalents()

		for iter6_80, iter7_80 in ipairs(var7_80) do
			local var8_80 = iter7_80:getBuffsAddition()

			if #var8_80 > 0 then
				local var9_80

				for iter8_80, iter9_80 in ipairs(var0_80) do
					if iter9_80[1] == iter5_80 then
						var9_80 = iter9_80[2]

						break
					end
				end

				if not var9_80 then
					var9_80 = {}

					table.insert(var0_80, {
						iter5_80,
						var9_80
					})
				end

				for iter10_80, iter11_80 in ipairs(var8_80) do
					table.insert(var9_80, iter11_80)
				end
			end
		end
	end

	return var0_80
end

function var0_0.updateFleetShipHp(arg0_81, arg1_81, arg2_81)
	for iter0_81, iter1_81 in ipairs(arg0_81.fleets) do
		iter1_81:updateShipHp(arg1_81, arg2_81)

		if iter1_81.id ~= arg0_81.fleet.id then
			iter1_81:clearShipHpChange()
		end
	end
end

function var0_0.getDragExtend(arg0_82)
	local var0_82 = arg0_82.theme
	local var1_82 = 99999999
	local var2_82 = 99999999
	local var3_82 = 0
	local var4_82 = 0

	for iter0_82, iter1_82 in pairs(arg0_82.cells) do
		if var1_82 > iter1_82.row then
			var1_82 = iter1_82.row
		end

		if var3_82 < iter1_82.row then
			var3_82 = iter1_82.row
		end

		if var2_82 > iter1_82.column then
			var2_82 = iter1_82.column
		end

		if var4_82 < iter1_82.column then
			var4_82 = iter1_82.column
		end
	end

	local var5_82 = (var4_82 + var2_82) * 0.5
	local var6_82 = (var3_82 + var1_82) * 0.5
	local var7_82 = var0_82.cellSize + var0_82.cellSpace
	local var8_82 = math.max((var4_82 - var5_82 + 1) * var7_82.x, 0)
	local var9_82 = math.max((var5_82 - var2_82 + 1) * var7_82.x, 0)
	local var10_82 = math.max((var6_82 - var1_82 + 1) * var7_82.y, 0)
	local var11_82 = math.max((var3_82 - var6_82 + 1) * var7_82.y, 0)

	return var9_82, var8_82, var10_82, var11_82
end

function var0_0.getPoisonArea(arg0_83, arg1_83)
	local var0_83 = {}
	local var1_83 = arg0_83.theme.cellSize + arg0_83.theme.cellSpace

	for iter0_83, iter1_83 in pairs(arg0_83.cells) do
		if iter1_83:checkHadFlag(ChapterConst.FlagPoison) then
			local var2_83 = math.floor((iter1_83.column - arg0_83.indexMin.y) * var1_83.x * arg1_83)
			local var3_83 = math.ceil((iter1_83.column - arg0_83.indexMin.y + 1) * var1_83.x * arg1_83)
			local var4_83 = math.floor((iter1_83.row - arg0_83.indexMin.x) * var1_83.y * arg1_83)
			local var5_83 = math.ceil((iter1_83.row - arg0_83.indexMin.x + 1) * var1_83.y * arg1_83)
			local var6_83 = var3_83 - var2_83
			local var7_83 = var5_83 - var4_83

			var0_83[iter0_83] = {
				x = var2_83,
				y = var4_83,
				w = var6_83,
				h = var7_83
			}
		end
	end

	return var0_83
end

function var0_0.selectFleets(arg0_84, arg1_84)
	local var0_84 = Clone(arg1_84) or {}
	local var1_84 = getProxy(FleetProxy):GetRegularFleets()

	for iter0_84 = #var0_84, 1, -1 do
		local var2_84 = var1_84[var0_84[iter0_84]]

		if not var2_84 or not var2_84:isUnlock() or var2_84:isLegalToFight() ~= true then
			table.remove(var0_84, iter0_84)
		end
	end

	local var3_84 = {
		[FleetType.Normal] = _.filter(var0_84, function(arg0_85)
			return var1_84[arg0_85]:getFleetType() == FleetType.Normal
		end),
		[FleetType.Submarine] = _.filter(var0_84, function(arg0_86)
			return var1_84[arg0_86]:getFleetType() == FleetType.Submarine
		end)
	}
	local var4_84 = arg0_84:getConfig("group_num")
	local var5_84 = arg0_84:getConfig("submarine_num")

	for iter1_84 = #var3_84[FleetType.Normal], var4_84 + 1, -1 do
		table.remove(var3_84[FleetType.Normal], iter1_84)
	end

	for iter2_84 = #var3_84[FleetType.Submarine], var5_84 + 1, -1 do
		table.remove(var3_84[FleetType.Submarine], iter2_84)
	end

	for iter3_84, iter4_84 in pairs(var3_84) do
		if #iter4_84 == 0 then
			local var6_84 = 0

			if iter3_84 == FleetType.Normal then
				var6_84 = var4_84
			elseif iter3_84 == FleetType.Submarine then
				var6_84 = var5_84
			end

			for iter5_84, iter6_84 in pairs(var1_84) do
				if var6_84 <= #iter4_84 then
					break
				end

				if iter6_84 and iter6_84:getFleetType() == iter3_84 and iter6_84:isUnlock() and iter6_84:isLegalToFight() == true then
					table.insert(iter4_84, iter5_84)
				end
			end
		end
	end

	local var7_84 = {}

	for iter7_84, iter8_84 in ipairs(var3_84) do
		for iter9_84, iter10_84 in ipairs(iter8_84) do
			table.insert(var7_84, iter10_84)
		end
	end

	return var7_84
end

function var0_0.GetDefaultFleetIndex(arg0_87)
	local var0_87 = getProxy(ChapterProxy):GetLastFleetIndex()

	return arg0_87:selectFleets(var0_87)
end

function var0_0.getMaxColumnByRow(arg0_88, arg1_88)
	local var0_88 = -1

	for iter0_88, iter1_88 in pairs(arg0_88.cells) do
		if iter1_88.row == arg1_88 then
			var0_88 = math.max(var0_88, iter1_88.column)
		end
	end

	return var0_88
end

function var0_0.getFleet(arg0_89, arg1_89, arg2_89, arg3_89)
	return _.detect(arg0_89.fleets, function(arg0_90)
		return arg0_90.line.row == arg2_89 and arg0_90.line.column == arg3_89 and (not arg1_89 or arg0_90:getFleetType() == arg1_89) and arg0_90:isValid()
	end) or _.detect(arg0_89.fleets, function(arg0_91)
		return arg0_91.line.row == arg2_89 and arg0_91.line.column == arg3_89 and (not arg1_89 or arg0_91:getFleetType() == arg1_89)
	end)
end

function var0_0.getFleetIndex(arg0_92, arg1_92, arg2_92, arg3_92)
	local var0_92 = arg0_92:getFleet(arg1_92, arg2_92, arg3_92)

	if var0_92 then
		return table.indexof(arg0_92.fleets, var0_92)
	end
end

function var0_0.getOni(arg0_93)
	return _.detect(arg0_93.champions, function(arg0_94)
		return arg0_94.attachment == ChapterConst.AttachOni
	end)
end

function var0_0.getChampion(arg0_95, arg1_95, arg2_95)
	return (_.detect(arg0_95.champions, function(arg0_96)
		return arg0_96.row == arg1_95 and arg0_96.column == arg2_95
	end))
end

function var0_0.getChampionIndex(arg0_97, arg1_97, arg2_97)
	local var0_97 = arg0_97:getChampion(arg1_97, arg2_97)

	if not var0_97 then
		return
	end

	return table.indexof(arg0_97.champions, var0_97)
end

function var0_0.getChampionVisibility(arg0_98, arg1_98, arg2_98, arg3_98)
	assert(arg1_98, "chapter champion not exist.")

	return arg1_98.flag == ChapterConst.CellFlagActive
end

function var0_0.mergeChampion(arg0_99, arg1_99, arg2_99)
	local var0_99 = arg0_99:getChampionIndex(arg1_99.row, arg1_99.column)

	if var0_99 then
		arg0_99.champions[var0_99] = arg1_99

		return true
	else
		if not arg2_99 then
			arg1_99.trait = ChapterConst.TraitLurk
		end

		table.insert(arg0_99.champions, arg1_99)

		return false
	end
end

function var0_0.RemoveChampion(arg0_100, arg1_100)
	local var0_100 = table.indexof(arg0_100.champions, arg1_100)

	if var0_100 then
		table.remove(arg0_100.champions, var0_100)
	end
end

function var0_0.considerAsObstacle(arg0_101, arg1_101, arg2_101, arg3_101)
	local var0_101 = arg0_101:getChapterCell(arg2_101, arg3_101)

	if not var0_101 or not var0_101:IsWalkable() then
		return true
	end

	if arg0_101:existBarrier(arg2_101, arg3_101) then
		return true
	end

	if arg1_101 == ChapterConst.SubjectPlayer then
		if var0_101.flag == ChapterConst.CellFlagActive then
			if ChapterConst.IsEnemyAttach(var0_101.attachment) then
				return true
			end

			if var0_101.attachment == ChapterConst.AttachBox then
				local var1_101 = pg.box_data_template[var0_101.attachmentId]

				assert(var1_101, "box_data_template not exist: " .. var0_101.attachmentId)

				if var1_101.type == ChapterConst.BoxTorpedo then
					return true
				end
			end

			if var0_101.attachment == ChapterConst.AttachStory then
				return true
			end
		end

		if arg0_101:existVisibleChampion(arg2_101, arg3_101) then
			return true
		end
	elseif arg1_101 == ChapterConst.SubjectChampion and arg0_101:existFleet(FleetType.Normal, arg2_101, arg3_101) then
		return true
	end

	return false
end

function var0_0.considerAsStayPoint(arg0_102, arg1_102, arg2_102, arg3_102)
	local var0_102 = arg0_102:getChapterCell(arg2_102, arg3_102)

	if not var0_102 or not var0_102:IsWalkable() then
		return false
	end

	if arg0_102:existBarrier(arg2_102, arg3_102) then
		return false
	end

	if arg1_102 == ChapterConst.SubjectPlayer then
		if var0_102.flag == ChapterConst.CellFlagActive and var0_102.attachment == ChapterConst.AttachStory then
			return true
		end

		if var0_102.attachment == ChapterConst.AttachLandbase and pg.land_based_template[var0_102.attachmentId] and pg.land_based_template[var0_102.attachmentId].type == ChapterConst.LBHarbor then
			return false
		end

		if arg0_102:existFleet(FleetType.Normal, arg2_102, arg3_102) then
			return false
		end

		if arg0_102:existOni(arg2_102, arg3_102) then
			return false
		end

		if arg0_102:existBombEnemy(arg2_102, arg3_102) then
			return false
		end
	elseif arg1_102 == ChapterConst.SubjectChampion then
		if var0_102.flag ~= ChapterConst.CellFlagDisabled and var0_102.attachment ~= ChapterConst.AttachNone then
			return false
		end

		local var1_102 = arg0_102:getChampion(arg2_102, arg3_102)

		if var1_102 and var1_102.flag ~= ChapterConst.CellFlagDisabled then
			return false
		end
	end

	return true
end

function var0_0.existAny(arg0_103, arg1_103, arg2_103)
	local var0_103 = arg0_103:getChapterCell(arg1_103, arg2_103)

	if var0_103.attachment ~= ChapterConst.AttachNone and var0_103.flag == ChapterConst.CellFlagActive then
		return true
	end

	if arg0_103:existFleet(nil, arg1_103, arg2_103) then
		return true
	end

	local var1_103 = arg0_103:getChampion(arg1_103, arg2_103)

	if var1_103 and var1_103.flag ~= ChapterConst.CellFlagDisabled then
		return true
	end
end

function var0_0.existBarrier(arg0_104, arg1_104, arg2_104)
	local var0_104 = arg0_104:getChapterCell(arg1_104, arg2_104)

	if var0_104.attachment == ChapterConst.AttachBox and var0_104.flag == ChapterConst.CellFlagActive and pg.box_data_template[var0_104.attachmentId].type == ChapterConst.BoxBarrier then
		return true
	end

	if var0_104.attachment == ChapterConst.AttachStory and var0_104.flag == ChapterConst.CellFlagTriggerActive and pg.map_event_template[var0_104.attachmentId].type == ChapterConst.StoryObstacle then
		return true
	end

	local var1_104 = arg0_104:getChampion(arg1_104, arg2_104)

	if var1_104 and var1_104.flag ~= ChapterConst.CellFlagDisabled then
		local var2_104 = pg.expedition_data_template[var1_104.attachmentId]

		if var2_104 and var2_104.type == ChapterConst.ExpeditionTypeUnTouchable then
			return true
		end
	end

	return false
end

function var0_0.GetEnemy(arg0_105, arg1_105, arg2_105)
	local var0_105 = arg0_105:getChapterCell(arg1_105, arg2_105)

	if var0_105 and var0_105.flag == ChapterConst.CellFlagActive and ChapterConst.IsEnemyAttach(var0_105.attachment) then
		return var0_105
	end

	local var1_105 = arg0_105:getChampion(arg1_105, arg2_105)

	if var1_105 and var1_105.flag ~= ChapterConst.CellFlagDisabled then
		return var1_105
	end
end

function var0_0.existEnemy(arg0_106, arg1_106, arg2_106, arg3_106)
	if arg1_106 == ChapterConst.SubjectPlayer then
		local var0_106 = arg0_106:GetEnemy(arg2_106, arg3_106)

		if var0_106 then
			local var1_106

			if isa(var0_106, ChapterCell) then
				var1_106 = var0_106.attachment
			else
				var1_106 = ChapterConst.AttachChampion
			end

			return true, var1_106
		end
	elseif arg1_106 == ChapterConst.SubjectChampion and (arg0_106:existFleet(FleetType.Normal, arg2_106, arg3_106) or arg0_106:existFleet(FleetType.Transport, arg2_106, arg3_106)) then
		return true
	end
end

function var0_0.existFleet(arg0_107, arg1_107, arg2_107, arg3_107)
	if _.any(arg0_107.fleets, function(arg0_108)
		return arg0_108.line.row == arg2_107 and arg0_108.line.column == arg3_107 and (not arg1_107 or arg0_108:getFleetType() == arg1_107) and arg0_108:isValid()
	end) then
		return true
	end
end

function var0_0.existVisibleChampion(arg0_109, arg1_109, arg2_109)
	local var0_109 = arg0_109:getChampion(arg1_109, arg2_109)

	return var0_109 and arg0_109:getChampionVisibility(var0_109)
end

function var0_0.existAlly(arg0_110, arg1_110)
	return _.any(arg0_110.fleets, function(arg0_111)
		return arg0_111.id ~= arg1_110.id and arg0_111.line.row == arg1_110.line.row and arg0_111.line.column == arg1_110.line.column and arg0_111:isValid()
	end)
end

function var0_0.existOni(arg0_112, arg1_112, arg2_112)
	return _.any(arg0_112.champions, function(arg0_113)
		return arg0_113.attachment == ChapterConst.AttachOni and arg0_113.flag == ChapterConst.CellFlagActive and (not arg1_112 or arg1_112 == arg0_113.row) and (not arg2_112 or arg2_112 == arg0_113.column)
	end)
end

function var0_0.existBombEnemy(arg0_114, arg1_114, arg2_114)
	if arg1_114 and arg2_114 then
		local var0_114 = arg0_114:getChapterCell(arg1_114, arg2_114)

		return var0_114.attachment == ChapterConst.AttachBomb_Enemy and var0_114.flag == ChapterConst.CellFlagActive
	end

	for iter0_114, iter1_114 in pairs(arg0_114.cells) do
		if iter1_114.attachment == ChapterConst.AttachBomb_Enemy and iter1_114.flag == ChapterConst.CellFlagActive and (not arg1_114 or arg1_114 == iter1_114.row) and (not arg2_114 or arg2_114 == iter1_114.column) then
			return true
		end
	end

	return false
end

function var0_0.isPlayingWithBombEnemy(arg0_115)
	for iter0_115, iter1_115 in pairs(arg0_115.cells) do
		if iter1_115.attachment == ChapterConst.AttachBomb_Enemy then
			return true
		end
	end

	return false
end

function var0_0.existCoastalGunNoMatterLiveOrDead(arg0_116)
	for iter0_116, iter1_116 in pairs(arg0_116.cells) do
		if iter1_116.attachment == ChapterConst.AttachLandbase then
			local var0_116 = pg.land_based_template[iter1_116.attachmentId]

			assert(var0_116, "land_based_template not exist: " .. iter1_116.attachmentId)

			if var0_116.type == ChapterConst.LBCoastalGun then
				return true
			end
		end
	end

	return false
end

local var1_0 = {
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

function var0_0.calcWalkableCells(arg0_117, arg1_117, arg2_117, arg3_117, arg4_117)
	local var0_117 = {}

	for iter0_117 = 0, ChapterConst.MaxRow - 1 do
		if not var0_117[iter0_117] then
			var0_117[iter0_117] = {}
		end

		for iter1_117 = 0, ChapterConst.MaxColumn - 1 do
			local var1_117 = ChapterCell.Line2Name(iter0_117, iter1_117)
			local var2_117 = arg0_117.cells[var1_117]

			var0_117[iter0_117][iter1_117] = var2_117 and var2_117:IsWalkable()
		end
	end

	local var3_117 = {}

	if arg1_117 == ChapterConst.SubjectPlayer then
		local var4_117 = arg0_117:getCoastalGunArea()

		for iter2_117, iter3_117 in ipairs(var4_117) do
			var3_117[iter3_117.row .. "_" .. iter3_117.column] = true
		end
	end

	local var5_117 = {}
	local var6_117 = arg0_117:GetRawChapterCell(arg2_117, arg3_117)

	if not var6_117 then
		return var5_117
	end

	local var7_117 = {
		{
			step = 0,
			row = arg2_117,
			column = arg3_117,
			forbiddens = var6_117.forbiddenDirections
		}
	}
	local var8_117 = {}

	while #var7_117 > 0 do
		local var9_117 = table.remove(var7_117, 1)

		table.insert(var8_117, var9_117)
		_.each(var1_0, function(arg0_118)
			local var0_118 = {
				row = var9_117.row + arg0_118[1],
				column = var9_117.column + arg0_118[2],
				step = var9_117.step + 1
			}
			local var1_118 = arg0_117:GetRawChapterCell(var0_118.row, var0_118.column)

			if not var1_118 then
				return
			end

			var0_118.forbiddens = var1_118.forbiddenDirections

			if var0_118.step <= arg4_117 and not OrientedPathFinding.IsDirectionForbidden(var9_117, arg0_118[1], arg0_118[2]) and not (_.any(var7_117, function(arg0_119)
				return arg0_119.row == var0_118.row and arg0_119.column == var0_118.column
			end) or _.any(var8_117, function(arg0_120)
				return arg0_120.row == var0_118.row and arg0_120.column == var0_118.column
			end)) and var0_117[var0_118.row][var0_118.column] then
				table.insert(var5_117, var0_118)

				if not arg0_117:existEnemy(arg1_117, var0_118.row, var0_118.column) and not arg0_117:existBarrier(var0_118.row, var0_118.column) and not var3_117[var0_118.row .. "_" .. var0_118.column] then
					table.insert(var7_117, var0_118)
				end
			end
		end)
	end

	var5_117 = _.filter(var5_117, function(arg0_121)
		return arg0_121.row == arg2_117 and arg0_121.column == arg3_117 or arg0_117:considerAsStayPoint(arg1_117, arg0_121.row, arg0_121.column)
	end)

	return var5_117
end

function var0_0.calcAreaCells(arg0_122, arg1_122, arg2_122, arg3_122, arg4_122)
	local var0_122 = {}

	for iter0_122 = 0, ChapterConst.MaxRow - 1 do
		if not var0_122[iter0_122] then
			var0_122[iter0_122] = {}
		end

		for iter1_122 = 0, ChapterConst.MaxColumn - 1 do
			local var1_122 = ChapterCell.Line2Name(iter0_122, iter1_122)
			local var2_122 = arg0_122.cells[var1_122]

			var0_122[iter0_122][iter1_122] = var2_122 and var2_122:IsWalkable()
		end
	end

	local var3_122 = {}
	local var4_122 = {
		{
			step = 0,
			row = arg1_122,
			column = arg2_122
		}
	}
	local var5_122 = {}

	while #var4_122 > 0 do
		local var6_122 = table.remove(var4_122, 1)

		table.insert(var5_122, var6_122)
		_.each(var1_0, function(arg0_123)
			local var0_123 = {
				row = var6_122.row + arg0_123[1],
				column = var6_122.column + arg0_123[2],
				step = var6_122.step + 1
			}

			if var0_123.row >= 0 and var0_123.row < ChapterConst.MaxRow and var0_123.column >= 0 and var0_123.column < ChapterConst.MaxColumn and var0_123.step <= arg4_122 and not (_.any(var4_122, function(arg0_124)
				return arg0_124.row == var0_123.row and arg0_124.column == var0_123.column
			end) or _.any(var5_122, function(arg0_125)
				return arg0_125.row == var0_123.row and arg0_125.column == var0_123.column
			end)) then
				table.insert(var4_122, var0_123)

				if var0_122[var0_123.row][var0_123.column] and var0_123.step >= arg3_122 then
					table.insert(var3_122, var0_123)
				end
			end
		end)
	end

	return var3_122
end

function var0_0.calcSquareBarrierCells(arg0_126, arg1_126, arg2_126, arg3_126)
	local var0_126 = {}

	for iter0_126 = -arg3_126, arg3_126 do
		for iter1_126 = -arg3_126, arg3_126 do
			local var1_126 = arg1_126 + iter0_126
			local var2_126 = arg2_126 + iter1_126
			local var3_126 = arg0_126:getChapterCell(var1_126, var2_126)

			if var3_126 and var3_126:IsWalkable() and (arg0_126:existBarrier(var1_126, var2_126) or not arg0_126:existAny(var1_126, var2_126)) then
				table.insert(var0_126, {
					row = var1_126,
					column = var2_126
				})
			end
		end
	end

	return var0_126
end

function var0_0.checkAnyInteractive(arg0_127)
	local var0_127 = arg0_127.fleet.line
	local var1_127 = arg0_127:getChapterCell(var0_127.row, var0_127.column)
	local var2_127 = false

	if arg0_127.fleet:getFleetType() == FleetType.Normal then
		if arg0_127:existEnemy(ChapterConst.SubjectPlayer, var1_127.row, var1_127.column) then
			if arg0_127:getRound() == ChapterConst.RoundPlayer then
				var2_127 = true
			end
		elseif var1_127.attachment == ChapterConst.AttachAmbush or var1_127.attachment == ChapterConst.AttachBox then
			if var1_127.flag ~= ChapterConst.CellFlagDisabled then
				var2_127 = true
			end
		elseif var1_127.attachment == ChapterConst.AttachStory then
			var2_127 = var1_127.flag == ChapterConst.CellFlagActive
		elseif var1_127.attachment == ChapterConst.AttachSupply and var1_127.attachmentId > 0 then
			local var3_127, var4_127 = arg0_127:getFleetAmmo(arg0_127.fleet)

			if var4_127 < var3_127 then
				var2_127 = true
			end
		elseif var1_127.attachment == ChapterConst.AttachBox and var1_127.flag ~= ChapterConst.CellFlagDisabled then
			var2_127 = true
		end
	end

	return var2_127
end

function var0_0.getQuadCellPic(arg0_128, arg1_128)
	local var0_128

	if arg1_128.trait == ChapterConst.TraitLurk then
		-- block empty
	elseif arg1_128.flag == ChapterConst.CellFlagActive and ChapterConst.IsEnemyAttach(arg1_128.attachment) and arg1_128.flag == ChapterConst.CellFlagActive then
		var0_128 = "cell_enemy"
	elseif arg1_128.attachment == ChapterConst.AttachBox and arg1_128.flag == ChapterConst.CellFlagActive then
		local var1_128 = pg.box_data_template[arg1_128.attachmentId]

		assert(var1_128, "box_data_template not exist: " .. arg1_128.attachmentId)

		if var1_128.type == ChapterConst.BoxDrop or var1_128.type == ChapterConst.BoxStrategy or var1_128.type == ChapterConst.BoxSupply or var1_128.type == ChapterConst.BoxEnemy then
			var0_128 = "cell_box"
		elseif var1_128.type == ChapterConst.BoxTorpedo then
			var0_128 = "cell_enemy"
		elseif var1_128.type == ChapterConst.BoxBarrier then
			var0_128 = "cell_green"
		end
	elseif arg1_128.attachment == ChapterConst.AttachStory then
		if arg1_128.flag == ChapterConst.CellFlagTriggerActive then
			local var2_128 = pg.map_event_template[arg1_128.attachmentId].grid_color

			var0_128 = var2_128 and #var2_128 > 0 and var2_128 or nil
		end
	elseif arg1_128.attachment == ChapterConst.AttachSupply and arg1_128.attachmentId > 0 then
		var0_128 = "cell_box"
	elseif arg1_128.attachment == ChapterConst.AttachTransport_Target then
		var0_128 = "cell_box"
	elseif arg1_128.attachment == ChapterConst.AttachLandbase then
		local var3_128 = pg.land_based_template[arg1_128.attachmentId]

		if var3_128 and (var3_128.type == ChapterConst.LBHarbor or var3_128.type == ChapterConst.LBDock) then
			var0_128 = "cell_box"
		end
	end

	return var0_128
end

function var0_0.getMapShip(arg0_129, arg1_129)
	local var0_129

	if arg1_129:isValid() then
		var0_129 = _.detect(arg1_129:getShips(false), function(arg0_130)
			return arg0_130.isNpc and arg0_130.hpRant > 0
		end)

		if not var0_129 then
			local var1_129 = arg1_129:getFleetType()

			if var1_129 == FleetType.Normal then
				var0_129 = arg1_129:getShipsByTeam(TeamType.Main, false)[1]
			elseif var1_129 == FleetType.Submarine then
				var0_129 = arg1_129:getShipsByTeam(TeamType.Submarine, false)[1]
			end
		end
	end

	return var0_129
end

function var0_0.getStrikeAnimShip(arg0_131, arg1_131, arg2_131)
	return underscore.detect(arg1_131:getShips(false), function(arg0_132)
		return arg0_132:GetMapStrikeAnim() == arg2_131
	end)
end

function var0_0.GetSubmarineFleet(arg0_133)
	return table.Find(arg0_133.fleets, function(arg0_134, arg1_134)
		return arg1_134:getFleetType() == FleetType.Submarine and arg1_134:isValid()
	end)
end

function var0_0.getStageCell(arg0_135, arg1_135, arg2_135)
	local var0_135 = arg0_135:getChampion(arg1_135, arg2_135)

	if var0_135 and var0_135.flag ~= ChapterConst.CellFlagDisabled then
		return var0_135
	end

	local var1_135 = arg0_135:getChapterCell(arg1_135, arg2_135)

	if var1_135 and var1_135.flag ~= ChapterConst.CellFlagDisabled then
		return var1_135
	end
end

function var0_0.getStageId(arg0_136, arg1_136, arg2_136)
	local var0_136 = arg0_136:getChampion(arg1_136, arg2_136)

	if var0_136 and var0_136.flag ~= ChapterConst.CellFlagDisabled then
		return var0_136.id
	end

	local var1_136 = arg0_136:getChapterCell(arg1_136, arg2_136)

	if var1_136 and var1_136.flag ~= ChapterConst.CellFlagDisabled then
		return var1_136.attachmentId
	end
end

function var0_0.getStageExtraAwards(arg0_137)
	return
end

function var0_0.GetExtraCostRate(arg0_138)
	local var0_138 = 1
	local var1_138 = {}

	for iter0_138, iter1_138 in ipairs(arg0_138.operationBuffList) do
		local var2_138 = pg.benefit_buff_template[iter1_138]

		var1_138[#var1_138 + 1] = var2_138

		if var2_138.benefit_type == var0_0.OPERATION_BUFF_TYPE_COST then
			var0_138 = var0_138 + var2_138.benefit_effect * 0.01
		end
	end

	return math.max(1, var0_138), var1_138
end

function var0_0.getFleetCost(arg0_139, arg1_139, arg2_139)
	if arg0_139:getPlayType() == ChapterConst.TypeExtra then
		return {
			gold = 0,
			oil = 0
		}, {
			gold = 0,
			oil = 0
		}
	end

	local var0_139, var1_139 = arg1_139:getCost()
	local var2_139 = arg0_139:GetLimitOilCost(arg1_139:getFleetType() == FleetType.Submarine, arg2_139)

	var1_139.oil = math.clamp(var2_139 - var0_139.oil, 0, var1_139.oil)

	local var3_139 = arg0_139:GetExtraCostRate()

	for iter0_139, iter1_139 in ipairs({
		var0_139,
		var1_139
	}) do
		for iter2_139, iter3_139 in pairs(iter1_139) do
			iter1_139[iter2_139] = iter1_139[iter2_139] * var3_139
		end
	end

	return var0_139, var1_139
end

function var0_0.isOverFleetCost(arg0_140, arg1_140, arg2_140)
	local var0_140 = arg0_140:GetLimitOilCost(arg1_140:getFleetType() == FleetType.Submarine, arg2_140)
	local var1_140 = 0

	for iter0_140, iter1_140 in ipairs({
		arg1_140:getCost()
	}) do
		var1_140 = var1_140 + iter1_140.oil
	end

	local var2_140 = arg0_140:GetExtraCostRate()

	return var0_140 < var1_140, var0_140 * var2_140, var1_140 * var2_140
end

function var0_0.writeBack(arg0_141, arg1_141, arg2_141)
	local var0_141 = arg0_141.fleet

	local function var1_141(arg0_142)
		local var0_142 = arg2_141.statistics[arg0_142.id]

		if not var0_142 then
			return
		end

		arg0_142.hpRant = var0_142.bp
	end

	for iter0_141, iter1_141 in pairs(var0_141.ships) do
		var1_141(iter1_141)
	end

	var0_141:ResortShips()

	if not arg2_141.skipAmmo then
		var0_141.restAmmo = math.max(var0_141.restAmmo - 1, 0)
	end

	local var2_141 = _.filter(var0_141:getStrategies(), function(arg0_143)
		local var0_143 = pg.strategy_data_template[arg0_143.id]

		return var0_143 and var0_143.type == ChapterConst.StgTypeBindFleetPassive and arg0_143.count > 0
	end)

	_.each(var2_141, function(arg0_144)
		var0_141:consumeOneStrategy(arg0_144.id)
	end)

	if arg2_141.statistics.submarineAid then
		local var3_141 = arg0_141:GetSubmarineFleet()

		if var3_141 and not var3_141:inHuntingRange(var0_141.line.row, var0_141.line.column) then
			var3_141:consumeOneStrategy(ChapterConst.StrategyCallSubOutofRange)
		end

		if var3_141 then
			for iter2_141, iter3_141 in pairs(var3_141.ships) do
				var1_141(iter3_141)
			end

			var3_141.restAmmo = math.max(var3_141.restAmmo - 1, 0)
		end
	end

	arg0_141:UpdateComboHistory(arg2_141.statistics._battleScore)

	if arg1_141 then
		local var4_141
		local var5_141
		local var6_141 = arg0_141:getChampion(var0_141.line.row, var0_141.line.column)

		if var6_141 then
			var6_141:Iter()

			var4_141 = var6_141.attachment
			var5_141 = var6_141.attachmentId

			if var6_141.flag == ChapterConst.CellFlagDisabled then
				arg0_141:RemoveChampion(var6_141)
			end
		else
			local var7_141 = arg0_141:getChapterCell(var0_141.line.row, var0_141.line.column)

			var4_141 = var7_141.attachment
			var5_141 = var7_141.attachmentId

			if var4_141 == ChapterConst.AttachEnemy or var4_141 == ChapterConst.AttachBoss then
				var7_141.flag = ChapterConst.CellFlagDisabled

				arg0_141:updateChapterCell(var7_141)
			else
				arg0_141:clearChapterCell(var7_141.row, var7_141.column)
			end
		end

		assert(var4_141, "attachment can not be nil.")

		if var4_141 == ChapterConst.AttachEnemy or var4_141 == ChapterConst.AttachElite or var4_141 == ChapterConst.AttachChampion then
			if not var6_141 or var6_141.flag == ChapterConst.CellFlagDisabled then
				local var8_141 = _.detect(arg0_141.achieves, function(arg0_145)
					return arg0_145.type == ChapterConst.AchieveType2
				end)

				if var8_141 then
					var8_141.count = var8_141.count + 1
				end
			end
		elseif var4_141 == ChapterConst.AttachBoss then
			local var9_141 = _.detect(arg0_141.achieves, function(arg0_146)
				return arg0_146.type == ChapterConst.AchieveType1
			end)

			if var9_141 then
				var9_141.count = var9_141.count + 1
			end
		end

		if arg0_141:CheckChapterWin() then
			pg.TrackerMgr.GetInstance():Tracking(TRACKING_KILL_BOSS)
		end

		local var10_141 = false

		if var6_141 then
			var10_141 = var6_141.flag == ChapterConst.CellFlagDisabled
		else
			var10_141 = (arg2_141.system ~= SYSTEM_SCENARIO_SUB_STRIKE or false) and var4_141 ~= ChapterConst.AttachBox
		end

		if var10_141 then
			var0_141.defeatEnemies = var0_141.defeatEnemies + 1

			if var4_141 ~= ChapterConst.AttachAmbush and arg0_141:IsFogStage() then
				var0_141.visibleLevel = var0_141.visibleLevel + 1

				var0_141:UpdateVisible()
			end

			arg0_141.defeatEnemies = arg0_141.defeatEnemies + 1

			local var11_141 = pg.expedition_data_template[var5_141]

			if not arg0_141:isLoop() and var11_141 and var11_141.type == ChapterConst.ExpeditionTypeMulBoss then
				local var12_141 = pg.chapter_model_multistageboss[arg0_141.id].guild_buff
				local var13_141 = var0_141:GetStatusStrategy()

				_.each(var12_141, function(arg0_147)
					if not table.contains(var13_141, arg0_147) then
						table.insert(var13_141, arg0_147)
					end
				end)

				local var14_141 = arg0_141:getNextValidIndex()

				if var14_141 > 0 then
					var13_141 = arg0_141.fleets[var14_141]:GetStatusStrategy()

					_.each(var12_141, function(arg0_148)
						table.removebyvalue(var13_141, arg0_148)
					end)
				end
			end

			getProxy(ChapterProxy):RecordLastDefeatedEnemy(arg0_141.id, {
				score = arg2_141.statistics._battleScore,
				line = {
					row = var0_141.line.row,
					column = var0_141.line.column
				},
				attachment = var4_141,
				attachmentId = var5_141
			})
		end
	end
end

function var0_0.CleanCurrentEnemy(arg0_149)
	local var0_149 = arg0_149.fleet.line
	local var1_149
	local var2_149 = arg0_149:getChampion(var0_149.row, var0_149.column)

	if var2_149 then
		var2_149:Iter()

		if var2_149.flag == ChapterConst.CellFlagDisabled then
			arg0_149:RemoveChampion(var2_149)
		end

		return
	end

	if arg0_149:getChapterCell(var0_149.row, var0_149.column).attachment == ChapterConst.AttachEnemy then
		arg0_149:clearChapterCell(var0_149.row, var0_149.column)

		return
	end
end

function var0_0.UpdateProgressAfterSkipBattle(arg0_150)
	arg0_150:writeBack(true, {
		skipAmmo = true,
		statistics = {
			_battleScore = ys.Battle.BattleConst.BattleScore.S
		}
	})
end

function var0_0.UpdateProgressOnRetreat(arg0_151)
	_.each(arg0_151.achieves, function(arg0_152)
		if arg0_152.type == ChapterConst.AchieveType3 then
			if _.all(_.values(arg0_151.cells), function(arg0_153)
				if arg0_153.attachment == ChapterConst.AttachEnemy or arg0_153.attachment == ChapterConst.AttachElite or arg0_153.attachment == ChapterConst.AttachBox and pg.box_data_template[arg0_153.attachmentId].type == ChapterConst.BoxEnemy then
					return arg0_153.flag == ChapterConst.CellFlagDisabled
				end

				return true
			end) and _.all(arg0_151.champions, function(arg0_154)
				return arg0_154.flag == ChapterConst.CellFlagDisabled
			end) then
				arg0_152.count = arg0_152.count + 1
			end
		elseif arg0_152.type == ChapterConst.AchieveType4 then
			if arg0_151.orignalShipCount <= arg0_152.config then
				arg0_152.count = arg0_152.count + 1
			end
		elseif arg0_152.type == ChapterConst.AchieveType5 then
			if not _.any(arg0_151:getShips(), function(arg0_155)
				return arg0_155:getShipType() == arg0_152.config
			end) then
				arg0_152.count = arg0_152.count + 1
			end
		elseif arg0_152.type == ChapterConst.AchieveType6 then
			local var0_152 = (arg0_151.scoreHistory[0] or 0) + (arg0_151.scoreHistory[1] or 0)

			arg0_152.count = math.max(var0_152 <= 0 and arg0_151.combo or 0, arg0_152.count or 0)
		end
	end)

	if arg0_151.progress == 100 then
		arg0_151.passCount = arg0_151.passCount + 1
	end

	local var0_151 = arg0_151.progress
	local var1_151 = math.min(arg0_151.progress + arg0_151:getConfig("progress_boss"), 100)

	arg0_151.progress = var1_151

	if var0_151 < 100 and var1_151 >= 100 then
		getProxy(ChapterProxy):RecordJustClearChapters(arg0_151.id, true)
	end

	arg0_151.defeatCount = arg0_151.defeatCount + 1

	local var2_151 = getProxy(ChapterProxy):getMapById(arg0_151:getConfig("map")):getMapType()

	if var2_151 == Map.ELITE then
		pg.TrackerMgr.GetInstance():Tracking(TRACKING_HARD_CHAPTER, arg0_151.id)
	elseif var2_151 == Map.SCENARIO then
		if arg0_151.progress == 100 and arg0_151.passCount == 0 then
			pg.TrackerMgr.GetInstance():Tracking(TRACKING_HIGHEST_CHAPTER, arg0_151.id)
		end

		if arg0_151.defeatCount == 1 then
			if arg0_151.id == 304 then
				pg.TrackerMgr.GetInstance():Tracking(TRACKING_FIRST_PASS_3_4)
			elseif arg0_151.id == 404 then
				pg.TrackerMgr.GetInstance():Tracking(TRACKING_FIRST_PASS_4_4)
			elseif arg0_151.id == 504 then
				pg.TrackerMgr.GetInstance():Tracking(TRACKING_FIRST_PASS_5_4)
			elseif arg0_151.id == 604 then
				pg.TrackerMgr.GetInstance():Tracking(TRACKING_FIRST_PASS_6_4)
			elseif arg0_151.id == 1204 then
				pg.TrackerMgr.GetInstance():Tracking(TRACKING_FIRST_PASS_12_4)
			elseif arg0_151.id == 1301 then
				pg.TrackerMgr.GetInstance():Tracking(TRACKING_FIRST_PASS_13_1)
			elseif arg0_151.id == 1302 then
				pg.TrackerMgr.GetInstance():Tracking(TRACKING_FIRST_PASS_13_2)
			elseif arg0_151.id == 1303 then
				pg.TrackerMgr.GetInstance():Tracking(TRACKING_FIRST_PASS_13_3)
			elseif arg0_151.id == 1304 then
				pg.TrackerMgr.GetInstance():Tracking(TRACKING_FIRST_PASS_13_4)
			end
		end
	end
end

function var0_0.UpdateComboHistory(arg0_156, arg1_156)
	getProxy(ChapterProxy):RecordComboHistory(arg0_156.id, {
		scoreHistory = Clone(arg0_156.scoreHistory),
		combo = Clone(arg0_156.combo)
	})

	arg0_156.scoreHistory = arg0_156.scoreHistory or {}
	arg0_156.scoreHistory[arg1_156] = (arg0_156.scoreHistory[arg1_156] or 0) + 1

	if arg1_156 <= ys.Battle.BattleConst.BattleScore.C then
		arg0_156.combo = 0
	else
		arg0_156.combo = (arg0_156.combo or 0) + 1
	end
end

function var0_0.GetWinConditions(arg0_157)
	return arg0_157.winConditions
end

function var0_0.GetLoseConditions(arg0_158)
	return arg0_158.loseConditions
end

function var0_0.CheckChapterWin(arg0_159)
	local var0_159 = arg0_159:GetWinConditions()
	local var1_159 = false
	local var2_159 = ChapterConst.ReasonVictory

	for iter0_159, iter1_159 in pairs(var0_159) do
		if iter1_159.type == 1 then
			local var3_159 = arg0_159:findChapterCells(ChapterConst.AttachBoss)
			local var4_159 = 0

			_.each(var3_159, function(arg0_160)
				if arg0_160 and arg0_160.flag == ChapterConst.CellFlagDisabled then
					var4_159 = var4_159 + 1
				end
			end)

			var1_159 = var1_159 or var4_159 >= iter1_159.param
		elseif iter1_159.type == 2 then
			var1_159 = var1_159 or arg0_159:GetDefeatCount() >= iter1_159.param
		elseif iter1_159.type == 3 then
			local var5_159 = arg0_159:CheckTransportState()

			var1_159 = var1_159 or var5_159 == 1
		elseif iter1_159.type == 4 then
			var1_159 = var1_159 or arg0_159:getRoundNum() > iter1_159.param
		elseif iter1_159.type == 5 then
			local var6_159 = iter1_159.param
			local var7_159 = _.any(arg0_159.champions, function(arg0_161)
				local var0_161 = arg0_161.attachmentId == var6_159

				for iter0_161, iter1_161 in pairs(arg0_161.idList) do
					var0_161 = var0_161 or iter1_161 == var6_159
				end

				return var0_161 and arg0_161.flag ~= ChapterConst.CellFlagDisabled
			end) or _.any(arg0_159.cells, function(arg0_162)
				return arg0_162.attachmentId == var6_159 and arg0_162.flag ~= ChapterConst.CellFlagDisabled
			end)

			var1_159 = var1_159 or not var7_159
		elseif iter1_159.type == 6 then
			local var8_159 = iter1_159.param
			local var9_159 = _.any(arg0_159.fleets, function(arg0_163)
				return arg0_163:getFleetType() == FleetType.Normal and arg0_163:isValid() and arg0_163.line.row == var8_159[1] and arg0_163.line.column == var8_159[2]
			end)

			var1_159 = var1_159 or var9_159
		end

		if var1_159 then
			break
		end
	end

	return var1_159, var2_159
end

function var0_0.CheckChapterLose(arg0_164)
	local var0_164 = arg0_164:GetLoseConditions()
	local var1_164 = false
	local var2_164 = ChapterConst.ReasonDefeat

	for iter0_164, iter1_164 in pairs(var0_164) do
		if iter1_164.type == 1 then
			local var3_164 = _.any(arg0_164.fleets, function(arg0_165)
				return arg0_165:getFleetType() == FleetType.Normal and arg0_165:isValid()
			end)

			var1_164 = var1_164 or not var3_164
		elseif iter1_164.type == 2 then
			var1_164 = var1_164 or arg0_164.BaseHP <= 0
			var2_164 = var1_164 and ChapterConst.ReasonDefeatDefense or var2_164
		end

		if var1_164 then
			break
		end
	end

	if arg0_164:getPlayType() == ChapterConst.TypeTransport then
		local var4_164 = arg0_164:CheckTransportState()

		var1_164 = var1_164 or var4_164 == -1
	end

	return var1_164, var2_164
end

function var0_0.CheckChapterWillWin(arg0_166)
	if arg0_166:existOni() or arg0_166:isPlayingWithBombEnemy() then
		return true
	end

	if arg0_166:CheckChapterWin() then
		return true
	end
end

function var0_0.triggerSkill(arg0_167, arg1_167, arg2_167)
	local var0_167 = _.filter(arg1_167:findSkills(arg2_167), function(arg0_168)
		local var0_168 = arg0_168:GetTriggers()

		return _.any(var0_168, function(arg0_169)
			return arg0_169[1] == FleetSkill.TriggerInSubTeam and arg0_169[2] == 1
		end) == (arg1_167:getFleetType() == FleetType.Submarine) and _.all(arg0_168:GetTriggers(), function(arg0_170)
			return arg0_167:triggerCheck(arg1_167, arg0_168, arg0_170)
		end)
	end)

	return _.reduce(var0_167, nil, function(arg0_171, arg1_171)
		local var0_171 = arg1_171:GetType()
		local var1_171 = arg1_171:GetArgs()

		if var0_171 == FleetSkill.TypeMoveSpeed or var0_171 == FleetSkill.TypeHuntingLv or var0_171 == FleetSkill.TypeTorpedoPowerUp then
			return (arg0_171 or 0) + var1_171[1]
		elseif var0_171 == FleetSkill.TypeAmbushDodge or var0_171 == FleetSkill.TypeAirStrikeDodge then
			return math.max(arg0_171 or 0, var1_171[1])
		elseif var0_171 == FleetSkill.TypeAttack or var0_171 == FleetSkill.TypeStrategy then
			arg0_171 = arg0_171 or {}

			table.insert(arg0_171, var1_171)

			return arg0_171
		elseif var0_171 == FleetSkill.TypeBattleBuff then
			arg0_171 = arg0_171 or {}

			table.insert(arg0_171, var1_171[1])

			return arg0_171
		end
	end), var0_167
end

function var0_0.triggerCheck(arg0_172, arg1_172, arg2_172, arg3_172)
	local var0_172 = arg3_172[1]

	if var0_172 == FleetSkill.TriggerDDHead then
		local var1_172 = arg1_172:getShipsByTeam(TeamType.Vanguard, false)

		return #var1_172 > 0 and ShipType.IsTypeQuZhu(var1_172[1]:getShipType())
	elseif var0_172 == FleetSkill.TriggerVanCount then
		local var2_172 = arg1_172:getShipsByTeam(TeamType.Vanguard, false)

		return #var2_172 >= arg3_172[2] and #var2_172 <= arg3_172[3]
	elseif var0_172 == FleetSkill.TriggerShipCount then
		local var3_172 = _.filter(arg1_172:getShips(false), function(arg0_173)
			return table.contains(arg3_172[2], arg0_173:getShipType())
		end)

		return #var3_172 >= arg3_172[3] and #var3_172 <= arg3_172[4]
	elseif var0_172 == FleetSkill.TriggerAroundEnemy then
		local var4_172 = {
			row = arg1_172.line.row,
			column = arg1_172.line.column
		}

		return _.any(_.values(arg0_172.cells), function(arg0_174)
			local var0_174 = arg0_172:GetEnemy(arg0_174.row, arg0_174.column)

			if not var0_174 then
				return
			end

			local var1_174 = pg.expedition_data_template[var0_174.attachmentId]

			if not var1_174 then
				return
			end

			local var2_174 = var1_174.type

			return ManhattonDist(var4_172, {
				row = arg0_174.row,
				column = arg0_174.column
			}) <= arg3_172[2] and (type(arg3_172[3]) == "number" and arg3_172[3] == var2_174 or type(arg3_172[3]) == "table" and table.contains(arg3_172[3], var2_174))
		end)
	elseif var0_172 == FleetSkill.TriggerNekoPos then
		local var5_172 = arg1_172:findCommanderBySkillId(arg2_172.id)

		for iter0_172, iter1_172 in pairs(arg1_172:getCommanders()) do
			if var5_172.id == iter1_172.id and iter0_172 == arg3_172[2] then
				return true
			end
		end
	elseif var0_172 == FleetSkill.TriggerAroundLand then
		local var6_172 = {
			row = arg1_172.line.row,
			column = arg1_172.line.column
		}

		return _.any(_.values(arg0_172.cells), function(arg0_175)
			return not arg0_175:IsWalkable() and ManhattonDist(var6_172, {
				row = arg0_175.row,
				column = arg0_175.column
			}) <= arg3_172[2]
		end)
	elseif var0_172 == FleetSkill.TriggerAroundCombatAlly then
		local var7_172 = {
			row = arg1_172.line.row,
			column = arg1_172.line.column
		}

		return _.any(arg0_172.fleets, function(arg0_176)
			return arg1_172.id ~= arg0_176.id and arg0_176:getFleetType() == FleetType.Normal and arg0_172:existEnemy(ChapterConst.SubjectPlayer, arg0_176.line.row, arg0_176.line.column) and ManhattonDist(var7_172, {
				row = arg0_176.line.row,
				column = arg0_176.line.column
			}) <= arg3_172[2]
		end)
	elseif var0_172 == FleetSkill.TriggerInSubTeam then
		return true
	else
		assert(false, "invalid trigger type: " .. var0_172)
	end
end

local var2_0 = {
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

function var0_0.checkOniState(arg0_177)
	local var0_177 = arg0_177:getOni()

	assert(var0_177, "oni not exist.")

	if _.all(var2_0, function(arg0_178)
		local var0_178 = {
			var0_177.row + arg0_178[1],
			var0_177.column + arg0_178[2]
		}

		if arg0_177:existFleet(FleetType.Normal, var0_178[1], var0_178[2]) then
			return true
		end

		local var1_178 = arg0_177:getChapterCell(var0_178[1], var0_178[2])

		if not var1_178 or not var1_178:IsWalkable() then
			return true
		end

		if arg0_177:existBarrier(var1_178.row, var1_178.column) then
			return true
		end
	end) then
		return 1
	end

	local var1_177 = arg0_177:getOniChapterInfo().escape_grids

	if _.any(var1_177, function(arg0_179)
		return arg0_179[1] == var0_177.row and arg0_179[2] == var0_177.column
	end) then
		return 2
	end
end

function var0_0.onOniEnter(arg0_180)
	for iter0_180, iter1_180 in pairs(arg0_180.cells) do
		iter1_180.attachment = ChapterConst.AttachNone
		iter1_180.attachmentId = nil
		iter1_180.flag = nil
		iter1_180.data = nil
	end

	arg0_180.champions = {}
	arg0_180.modelCount = arg0_180:getOniChapterInfo().special_item
	arg0_180.roundIndex = 0
end

function var0_0.onBombEnemyEnter(arg0_181)
	for iter0_181, iter1_181 in pairs(arg0_181.cells) do
		iter1_181.attachment = ChapterConst.AttachNone
		iter1_181.attachmentId = nil
		iter1_181.flag = nil
		iter1_181.data = nil
	end

	arg0_181.champions = {}
	arg0_181.modelCount = 0
	arg0_181.roundIndex = 0
end

function var0_0.clearSubmarineFleet(arg0_182)
	for iter0_182 = #arg0_182.fleets, 1, -1 do
		if arg0_182.fleets[iter0_182]:getFleetType() == FleetType.Submarine then
			table.remove(arg0_182.fleets, iter0_182)
		end
	end
end

function var0_0.getSpAppearStory(arg0_183)
	if arg0_183:existOni() then
		for iter0_183, iter1_183 in ipairs(arg0_183.champions) do
			if iter1_183.trait == ChapterConst.TraitLurk and iter1_183.attachment == ChapterConst.AttachOni then
				local var0_183 = iter1_183:getConfig("appear_story")

				if var0_183 and #var0_183 > 0 then
					return var0_183
				end
			end
		end
	elseif arg0_183:isPlayingWithBombEnemy() then
		for iter2_183, iter3_183 in pairs(arg0_183.cells) do
			if iter3_183.attachment == ChapterConst.AttachBomb_Enemy and iter3_183.trait == ChapterConst.TraitLurk then
				local var1_183 = pg.specialunit_template[iter3_183.attachmentId]

				if var1_183.appear_story and #var1_183.appear_story > 0 then
					return var1_183.appear_story
				end
			end
		end
	end
end

function var0_0.getSpAppearGuide(arg0_184)
	if arg0_184:existOni() then
		for iter0_184, iter1_184 in ipairs(arg0_184.champions) do
			if iter1_184.trait == ChapterConst.TraitLurk and iter1_184.attachment == ChapterConst.AttachOni then
				local var0_184 = iter1_184:getConfig("appear_guide")

				if var0_184 and #var0_184 > 0 then
					return var0_184
				end
			end
		end
	elseif arg0_184:isPlayingWithBombEnemy() then
		for iter2_184, iter3_184 in pairs(arg0_184.cells) do
			if iter3_184.attachment == ChapterConst.AttachBomb_Enemy and iter3_184.trait == ChapterConst.TraitLurk then
				local var1_184 = pg.specialunit_template[iter3_184.attachmentId]

				if var1_184.appear_guide and #var1_184.appear_guide > 0 then
					return var1_184.appear_guide
				end
			end
		end
	end
end

function var0_0.CheckTransportState(arg0_185)
	local var0_185 = _.detect(arg0_185.fleets, function(arg0_186)
		return arg0_186:getFleetType() == FleetType.Transport
	end)

	if not var0_185 then
		return -1
	end

	local var1_185 = arg0_185:findChapterCell(ChapterConst.AttachTransport_Target)

	assert(var0_185, "transport fleet not exist.")
	assert(var1_185, "transport target not exist.")

	if not var0_185:isValid() then
		return -1
	elseif var0_185.line.row == var1_185.row and var0_185.line.column == var1_185.column and not arg0_185:existEnemy(ChapterConst.SubjectPlayer, var1_185.row, var1_185.column) then
		return 1
	else
		return 0
	end
end

function var0_0.getCoastalGunArea(arg0_187)
	local var0_187 = {}

	for iter0_187, iter1_187 in pairs(arg0_187.cells) do
		if iter1_187.attachment == ChapterConst.AttachLandbase and iter1_187.flag ~= ChapterConst.CellFlagDisabled then
			local var1_187 = pg.land_based_template[iter1_187.attachmentId]

			if var1_187.type == ChapterConst.LBCoastalGun then
				local var2_187 = var1_187.function_args
				local var3_187 = {
					math.abs(var2_187[1]),
					math.abs(var2_187[2])
				}
				local var4_187 = {
					Mathf.Sign(var2_187[1]),
					Mathf.Sign(var2_187[2])
				}
				local var5_187 = math.max(var3_187[1], var3_187[2])

				for iter2_187 = 1, var5_187 do
					table.insert(var0_187, {
						row = iter1_187.row + math.min(var3_187[1], iter2_187) * var4_187[1],
						column = iter1_187.column + math.min(var3_187[2], iter2_187) * var4_187[2]
					})
				end
			end
		end
	end

	return var0_187
end

function var0_0.GetAntiAirGunArea(arg0_188)
	local var0_188 = {}
	local var1_188 = {}

	for iter0_188, iter1_188 in pairs(arg0_188.cells) do
		if iter1_188.attachment == ChapterConst.AttachLandbase and iter1_188.flag ~= ChapterConst.CellFlagDisabled then
			local var2_188 = pg.land_based_template[iter1_188.attachmentId]

			if var2_188.type == ChapterConst.LBAntiAir then
				local var3_188 = var2_188.function_args
				local var4_188 = math.abs(var3_188[1])

				local function var5_188(arg0_189, arg1_189)
					return ChapterConst.MaxColumn * arg0_189 + arg1_189
				end

				local var6_188 = {}
				local var7_188 = {}

				if var4_188 > 0 then
					var6_188[var5_188(iter1_188.row, iter1_188.column)] = iter1_188
				end

				while next(var6_188) do
					local var8_188 = next(var6_188)
					local var9_188 = var6_188[var8_188]

					var6_188[var8_188] = nil

					if var4_188 >= math.abs(var9_188.row - iter1_188.row) and var4_188 >= math.abs(var9_188.column - iter1_188.column) then
						var7_188[var8_188] = var9_188

						for iter2_188 = 1, #var2_0 do
							local var10_188 = var9_188.row + var2_0[iter2_188][1]
							local var11_188 = var9_188.column + var2_0[iter2_188][2]
							local var12_188 = var5_188(var10_188, var11_188)

							if not var7_188[var12_188] then
								var6_188[var12_188] = {
									row = var10_188,
									column = var11_188
								}
							end
						end
					end
				end

				for iter3_188, iter4_188 in pairs(var7_188) do
					var1_188[iter3_188] = iter4_188
				end
			end
		end
	end

	for iter5_188, iter6_188 in pairs(var1_188) do
		table.insert(var0_188, iter6_188)
	end

	return var0_188
end

function var0_0.GetDefeatCount(arg0_190)
	return arg0_190.defeatEnemies
end

function var0_0.ExistDivingChampion(arg0_191)
	return _.any(arg0_191.champions, function(arg0_192)
		return arg0_192.flag == ChapterConst.CellFlagDiving
	end)
end

function var0_0.IsSkipPrecombat(arg0_193)
	return arg0_193:isLoop() and getProxy(ChapterProxy):GetSkipPrecombat()
end

function var0_0.CanActivateAutoFight(arg0_194)
	local var0_194 = pg.chapter_template_loop[arg0_194.id]

	return var0_194 and var0_194.fightauto == 1 and arg0_194:isLoop() and AutoBotCommand.autoBotSatisfied() and not arg0_194:existOni() and not arg0_194:existBombEnemy()
end

function var0_0.IsAutoFight(arg0_195)
	return arg0_195:CanActivateAutoFight() and getProxy(ChapterProxy):GetChapterAutoFlag(arg0_195.id) == 1
end

function var0_0.getOperationBuffDescStg(arg0_196)
	for iter0_196, iter1_196 in ipairs(arg0_196.operationBuffList) do
		if pg.benefit_buff_template[iter1_196].benefit_type == Chapter.OPERATION_BUFF_TYPE_DESC then
			return iter1_196
		end
	end
end

function var0_0.GetOperationDesc(arg0_197)
	local var0_197 = ""

	for iter0_197, iter1_197 in ipairs(arg0_197.operationBuffList) do
		local var1_197 = pg.benefit_buff_template[iter1_197]

		if var1_197.benefit_type == var0_0.OPERATION_BUFF_TYPE_DESC then
			var0_197 = var1_197.desc

			break
		end
	end

	return var0_197
end

function var0_0.GetOperationBuffList(arg0_198)
	return arg0_198.operationBuffList
end

function var0_0.GetAllEnemies(arg0_199, arg1_199)
	local var0_199 = {}

	for iter0_199, iter1_199 in pairs(arg0_199.cells) do
		if ChapterConst.IsEnemyAttach(iter1_199.attachment) and (arg1_199 or iter1_199.flag ~= ChapterConst.CellFlagDisabled) then
			table.insert(var0_199, iter1_199)
		end
	end

	for iter2_199, iter3_199 in pairs(arg0_199.champions) do
		if arg1_199 or iter3_199.flag ~= ChapterConst.CellFlagDisabled then
			table.insert(var0_199, iter3_199)
		end
	end

	return var0_199
end

function var0_0.GetFleetOfDuty(arg0_200, arg1_200)
	local var0_200

	for iter0_200, iter1_200 in ipairs(arg0_200.fleets) do
		if iter1_200:isValid() and iter1_200:getFleetType() == FleetType.Normal then
			local var1_200 = arg0_200.duties[iter1_200.id] or 0

			if var1_200 == ChapterFleet.DUTY_KILLALL or var1_200 == ChapterFleet.DUTY_KILLBOSS and tobool(arg1_200) or var1_200 == ChapterFleet.DUTY_CLEANPATH and not tobool(arg1_200) then
				return iter1_200
			end

			var0_200 = iter1_200
		end
	end

	return var0_200
end

function var0_0.GetBuffOfLinkAct(arg0_201)
	if arg0_201:getPlayType() == ChapterConst.TypeDOALink then
		local var0_201 = pg.gameset.doa_fever_buff.description

		return _.detect(arg0_201.buff_list, function(arg0_202)
			return table.contains(var0_201, arg0_202)
		end)
	end
end

function var0_0.GetAttachmentStories(arg0_203)
	local var0_203 = arg0_203.cellAttachments
	local var1_203 = 0
	local var2_203

	for iter0_203, iter1_203 in pairs(var0_203) do
		local var3_203 = var0_0.GetEventTemplateByKey("mult_story", iter1_203.attachmentId)

		if var3_203 then
			assert(not var2_203 or table.equal(var2_203, var3_203[1]), "Not the same Config of Mult_story ID: " .. iter1_203.attachmentId)

			var2_203 = var2_203 or var3_203[1]

			local var4_203 = arg0_203.cells[iter0_203]

			if var4_203 and var4_203.flag == ChapterConst.CellFlagDisabled then
				var1_203 = var1_203 + 1
			end
		end
	end

	return var2_203, var1_203
end

function var0_0.GetWeather(arg0_204, arg1_204, arg2_204)
	arg1_204 = arg1_204 or arg0_204.fleet.line.row
	arg2_204 = arg2_204 or arg0_204.fleet.line.column

	local var0_204 = ChapterCell.Line2Name(arg1_204, arg2_204)
	local var1_204 = arg0_204.cells[var0_204]

	return var1_204 and var1_204:GetWeatherFlagList() or {}
end

function var0_0.getDisplayEnemyCount(arg0_205)
	local var0_205 = 0

	local function var1_205(arg0_206)
		if arg0_206.flag ~= ChapterConst.CellFlagDisabled then
			var0_205 = var0_205 + 1
		end
	end

	local var2_205 = {
		[ChapterConst.AttachEnemy] = var1_205,
		[ChapterConst.AttachElite] = var1_205,
		[ChapterConst.AttachBox] = function(arg0_207)
			if pg.box_data_template[arg0_207.attachmentId].type == ChapterConst.BoxEnemy then
				var1_205(arg0_207)
			end
		end
	}

	for iter0_205, iter1_205 in pairs(arg0_205.cells) do
		switch(iter1_205.attachment, var2_205, nil, iter1_205)
	end

	for iter2_205, iter3_205 in ipairs(arg0_205.champions) do
		var1_205(iter3_205)
	end

	return var0_205
end

function var0_0.getNearestEnemyCell(arg0_208)
	local function var0_208(arg0_209, arg1_209)
		return (arg0_209.row - arg1_209.row) * (arg0_209.row - arg1_209.row) + (arg0_209.column - arg1_209.column) * (arg0_209.column - arg1_209.column)
	end

	local var1_208

	local function var2_208(arg0_210)
		if arg0_210.flag ~= ChapterConst.CellFlagDisabled and (not var1_208 or var0_208(arg0_208.fleet.line, arg0_210) < var0_208(arg0_208.fleet.line, var1_208)) then
			var1_208 = arg0_210
		end
	end

	local var3_208 = {
		[ChapterConst.AttachEnemy] = var2_208,
		[ChapterConst.AttachElite] = var2_208,
		[ChapterConst.AttachBox] = function(arg0_211)
			if pg.box_data_template[arg0_211.attachmentId].type == ChapterConst.BoxEnemy then
				var2_208(arg0_211)
			end
		end
	}

	for iter0_208, iter1_208 in pairs(arg0_208.cells) do
		switch(iter1_208.attachment, var3_208, nil, iter1_208)
	end

	for iter2_208, iter3_208 in ipairs(arg0_208.champions) do
		var2_208(iter3_208)
	end

	return var1_208
end

function var0_0.GetRegularFleetIds(arg0_212)
	return (_.map(_.filter(arg0_212.fleets, function(arg0_213)
		local var0_213 = arg0_213:getFleetType()

		return var0_213 == FleetType.Normal or var0_213 == FleetType.Submarine
	end), function(arg0_214)
		return arg0_214.fleetId
	end))
end

function var0_0.NeedSupportSubmarineStage(arg0_215)
	return arg0_215:IsSupportSubmarineStage() and not table.contains(arg0_215:getExtraFlags(), ChapterConst.StatusSupportSubmarineFinish)
end

function var0_0.UpdateCellsVisible(arg0_216, arg1_216, arg2_216)
	if not arg0_216:IsFogStage() then
		return
	end

	local var0_216 = {}

	if arg0_216.fleetVisibleStore[arg1_216.id] then
		for iter0_216, iter1_216 in ipairs(arg0_216.fleetVisibleStore[arg1_216.id]) do
			var0_216[iter1_216] = defaultValue(var0_216[iter1_216], 0) - 1
		end
	end

	if arg1_216.isRetreat then
		arg0_216.fleetVisibleStore[arg1_216.id] = {}
	else
		arg0_216.fleetVisibleStore[arg1_216.id] = underscore(arg1_216:GetVisibleRange(arg2_216)):chain():map(function(arg0_217)
			return ChapterCell.Line2Name(arg0_217.row, arg0_217.column)
		end):filter(function(arg0_218)
			return tobool(arg0_216.cells[arg0_218])
		end):value()
	end

	for iter2_216, iter3_216 in ipairs(arg0_216.fleetVisibleStore[arg1_216.id]) do
		var0_216[iter3_216] = defaultValue(var0_216[iter3_216], 0) + 1
	end

	local var1_216 = {}

	for iter4_216, iter5_216 in pairs(var0_216) do
		local var2_216 = arg0_216.cells[iter4_216]:IsVisible()

		if iter5_216 < 0 then
			arg0_216.cells[iter4_216]:UpdateVisible(arg1_216.id, false)
		elseif iter5_216 > 0 then
			arg0_216.cells[iter4_216]:UpdateVisible(arg1_216.id, true)
		end

		if var2_216 ~= arg0_216.cells[iter4_216]:IsVisible() then
			arg0_216.cellsVisibleCount = arg0_216.cellsVisibleCount + (var2_216 and -1 or 1)

			table.insert(var1_216, iter4_216)
		end
	end

	return var1_216
end

function var0_0.GetFogStageStrategy(arg0_219)
	local var0_219 = arg0_219.cellsVisibleCount * 100 / arg0_219.cellsCount
	local var1_219

	for iter0_219, iter1_219 in ipairs(arg0_219:getConfigMiscArg("fog_visible_buff")) do
		local var2_219, var3_219 = unpack(iter1_219)

		var1_219 = var3_219

		if var0_219 <= var2_219 then
			break
		end
	end

	return var1_219
end

function var0_0.retreatFleet(arg0_220, arg1_220)
	local var0_220

	for iter0_220, iter1_220 in ipairs(arg0_220.fleets) do
		if iter1_220.id == arg1_220 then
			var0_220 = table.remove(arg0_220.fleets, iter0_220)

			break
		end
	end

	if var0_220 and var0_220:getFleetType() == FleetType.Normal then
		arg0_220.findex = 1
	end

	var0_220.isRetreat = true

	var0_220:UpdateVisible()
end

return var0_0
