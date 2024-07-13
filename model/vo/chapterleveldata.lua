local var0_0 = import(".Chapter")

function var0_0.update(arg0_1, arg1_1)
	assert(arg1_1.id == arg0_1.id, "章节ID不一致, 无法更新数据")

	arg0_1.active = true
	arg0_1.dueTime = arg1_1.time
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
		for iter6_1, iter7_1 in ipairs(arg1_1.buff_list) do
			arg0_1.buff_list[iter6_1] = iter7_1
		end
	end

	arg0_1.operationBuffList = {}

	for iter8_1, iter9_1 in ipairs(arg1_1.operation_buff) do
		arg0_1.operationBuffList[#arg0_1.operationBuffList + 1] = iter9_1
	end

	local var7_1 = arg0_1:getNpcShipByType()

	arg0_1.fleets = {}

	for iter10_1, iter11_1 in ipairs(arg1_1.group_list) do
		local var8_1 = ChapterFleet.New(iter11_1, var7_1)

		var8_1:setup(arg0_1)

		arg0_1.fleets[iter10_1] = var8_1
	end

	arg0_1.fleets = _.sort(arg0_1.fleets, function(arg0_8, arg1_8)
		return arg0_8.id < arg1_8.id
	end)

	if arg1_1.escort_list then
		for iter12_1, iter13_1 in ipairs(arg1_1.escort_list) do
			arg0_1.fleets[#arg0_1.fleets + 1] = ChapterTransportFleet.New(iter13_1, #arg0_1.fleets + 1)
		end
	end

	arg0_1.findex = 0
	arg0_1.findex = arg0_1:getNextValidIndex()

	if arg0_1.findex == 0 then
		arg0_1.findex = 1
	end

	arg0_1.champions = {}

	if arg1_1.ai_list then
		for iter14_1, iter15_1 in ipairs(arg1_1.ai_list) do
			if iter15_1.item_flag ~= 1 then
				local var9_1 = ChapterChampionPackage.New(iter15_1)

				arg0_1:mergeChampion(var9_1, true)
			end
		end
	end

	arg0_1.airDominanceStatus = nil
	arg0_1.extraFlagList = {}

	for iter16_1, iter17_1 in ipairs(arg1_1.extra_flag_list) do
		table.insert(arg0_1.extraFlagList, iter17_1)
	end

	arg0_1.defeatEnemies = arg1_1.kill_count or 0
	arg0_1.BaseHP = arg1_1.chapter_hp or 0
	arg0_1.orignalShipCount = arg1_1.init_ship_count or 0
	arg0_1.combo = arg1_1.continuous_kill_count or 0
	arg0_1.scoreHistory = {}

	for iter18_1 = ys.Battle.BattleConst.BattleScore.D, ys.Battle.BattleConst.BattleScore.S do
		arg0_1.scoreHistory[iter18_1] = 0
	end

	if arg1_1.battle_statistics then
		for iter19_1, iter20_1 in ipairs(arg1_1.battle_statistics) do
			arg0_1.scoreHistory[iter20_1.id] = iter20_1.count
		end
	end

	local var10_1 = {}

	if arg1_1.chapter_strategy_list then
		for iter21_1, iter22_1 in ipairs(arg1_1.chapter_strategy_list) do
			var10_1[iter22_1.id] = iter22_1.count
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

function var0_0.retreat(arg0_10, arg1_10)
	if arg1_10 then
		arg0_10.todayDefeatCount = arg0_10.todayDefeatCount + 1

		arg0_10:updateTodayDefeatCount()
	end
end

function var0_0.CleanLevelData(arg0_11)
	arg0_11.active = false
	arg0_11.loopFlag = 0
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

	if arg0_59:getPlayType() == ChapterConst.TypeDOALink then
		local var6_59 = arg0_59:GetBuffOfLinkAct()

		if var6_59 then
			local var7_59 = pg.gameset.doa_fever_buff.description

			table.insert(var0_59, pg.gameset.doa_fever_strategy.description[table.indexof(var7_59, var6_59)])
		end
	end

	return var0_59
end

function var0_0.GetShowingStrategies(arg0_63)
	local var0_63 = arg0_63.fleet
	local var1_63 = arg0_63:getFleetStates(var0_63)

	return (_.filter(var1_63, function(arg0_64)
		local var0_64 = pg.strategy_data_template[arg0_64]

		return var0_64 and var0_64.icon ~= ""
	end))
end

function var0_0.getAirDominanceStg(arg0_65)
	local var0_65, var1_65 = arg0_65:getAirDominanceValue()

	return ChapterConst.AirDominance[var1_65].StgId
end

function var0_0.getAirDominanceValue(arg0_66)
	local var0_66 = 0
	local var1_66 = 0

	for iter0_66, iter1_66 in pairs(arg0_66.fleets) do
		if iter1_66:isValid() and (iter1_66:getFleetType() == FleetType.Normal or iter1_66:getFleetType() == FleetType.Submarine) then
			var0_66 = var0_66 + iter1_66:getFleetAirDominanceValue()
			var1_66 = var1_66 + iter1_66:getAntiAircraftSums()
		end
	end

	return var0_66, calcAirDominanceStatus(var0_66, arg0_66:getConfig("air_dominance"), var1_66), arg0_66.airDominanceStatus
end

function var0_0.setAirDominanceStatus(arg0_67, arg1_67)
	arg0_67.airDominanceStatus = arg1_67
end

function var0_0.updateExtraFlags(arg0_68, arg1_68, arg2_68)
	local var0_68 = false

	for iter0_68, iter1_68 in ipairs(arg2_68) do
		for iter2_68, iter3_68 in ipairs(arg0_68.extraFlagList) do
			if iter3_68 == iter1_68 then
				table.remove(arg0_68.extraFlagList, iter2_68)

				var0_68 = true

				break
			end
		end
	end

	for iter4_68, iter5_68 in ipairs(arg1_68) do
		if not table.contains(arg0_68.extraFlagList, iter5_68) then
			table.insert(arg0_68.extraFlagList, 1, iter5_68)

			var0_68 = true
		end
	end

	return var0_68
end

function var0_0.getExtraFlags(arg0_69)
	local var0_69 = arg0_69.extraFlagList

	if #var0_69 == 0 then
		var0_69 = ChapterConst.StatusDefaultList
	end

	return var0_69
end

function var0_0.UpdateBuffList(arg0_70, arg1_70)
	if not arg1_70 then
		return
	end

	for iter0_70, iter1_70 in ipairs(arg1_70) do
		if not _.include(arg0_70.buff_list, iter1_70) then
			table.insert(arg0_70.buff_list, iter1_70)
		end
	end
end

function var0_0.getFleetBattleBuffs(arg0_71, arg1_71)
	local var0_71 = table.shallowCopy(arg0_71.buff_list)

	_.each(arg0_71:getFleetStates(arg1_71), function(arg0_72)
		local var0_72 = pg.strategy_data_template[arg0_72]
		local var1_72 = var0_72.buff_id

		if var1_72 == 0 then
			return
		end

		if var0_72.buff_type == ChapterConst.StrategyBuffTypeOnlyBoss then
			local var2_72 = arg0_71:GetEnemy(arg1_71.line.row, arg1_71.line.column)

			if var2_72 and not ChapterConst.IsBossCell(var2_72) then
				return
			end
		end

		table.insert(var0_71, var1_72)
	end)
	table.insertto(var0_71, arg0_71:GetCellEventByKey("attach_buff", arg1_71.line.row, arg1_71.line.column) or {})
	_.each(arg0_71:GetWeather(), function(arg0_73)
		local var0_73 = pg.weather_data_template[arg0_73].effect_args

		if type(var0_73) == "table" and var0_73.buff and var0_73.buff > 0 then
			table.insert(var0_71, var0_73.buff)
		end
	end)

	local var1_71 = arg0_71:buildBattleBuffList(arg1_71)

	return var0_71, var1_71
end

function var0_0.GetStageFlags(arg0_74)
	local var0_74 = arg0_74.fleet.line.row
	local var1_74 = arg0_74.fleet.line.column

	return arg0_74:GetCellEventByKey("stage_flags", var0_74, var1_74) or {}
end

function var0_0.GetCellEventByKey(arg0_75, arg1_75, arg2_75, arg3_75)
	arg2_75 = arg2_75 or arg0_75.fleet.line.row
	arg3_75 = arg3_75 or arg0_75.fleet.line.column

	local var0_75 = ChapterCell.Line2Name(arg2_75, arg3_75)
	local var1_75 = arg0_75.cells[var0_75]

	if not var1_75 then
		return
	end

	return var0_0.GetEventTemplateByKey(arg1_75, var1_75.attachmentId)
end

function var0_0.GetEventTemplateByKey(arg0_76, arg1_76)
	local var0_76 = pg.map_event_template[arg1_76]

	if not var0_76 then
		return
	end

	local var1_76

	for iter0_76, iter1_76 in ipairs(var0_76.effect) do
		if iter1_76[1] == arg0_76 then
			for iter2_76 = 2, #iter1_76 do
				var1_76 = var1_76 or {}

				table.insert(var1_76, iter1_76[iter2_76])
			end
		end
	end

	return var1_76
end

function var0_0.buildBattleBuffList(arg0_77, arg1_77)
	local var0_77 = {}
	local var1_77, var2_77 = arg0_77:triggerSkill(arg1_77, FleetSkill.TypeBattleBuff)

	if var1_77 and #var1_77 > 0 then
		local var3_77 = {}

		for iter0_77, iter1_77 in ipairs(var1_77) do
			local var4_77 = var2_77[iter0_77]
			local var5_77 = arg1_77:findCommanderBySkillId(var4_77.id)

			var3_77[var5_77] = var3_77[var5_77] or {}

			table.insert(var3_77[var5_77], iter1_77)
		end

		for iter2_77, iter3_77 in pairs(var3_77) do
			table.insert(var0_77, {
				iter2_77,
				iter3_77
			})
		end
	end

	local var6_77 = arg1_77:getCommanders()

	for iter4_77, iter5_77 in pairs(var6_77) do
		local var7_77 = iter5_77:getTalents()

		for iter6_77, iter7_77 in ipairs(var7_77) do
			local var8_77 = iter7_77:getBuffsAddition()

			if #var8_77 > 0 then
				local var9_77

				for iter8_77, iter9_77 in ipairs(var0_77) do
					if iter9_77[1] == iter5_77 then
						var9_77 = iter9_77[2]

						break
					end
				end

				if not var9_77 then
					var9_77 = {}

					table.insert(var0_77, {
						iter5_77,
						var9_77
					})
				end

				for iter10_77, iter11_77 in ipairs(var8_77) do
					table.insert(var9_77, iter11_77)
				end
			end
		end
	end

	return var0_77
end

function var0_0.updateFleetShipHp(arg0_78, arg1_78, arg2_78)
	for iter0_78, iter1_78 in ipairs(arg0_78.fleets) do
		iter1_78:updateShipHp(arg1_78, arg2_78)

		if iter1_78.id ~= arg0_78.fleet.id then
			iter1_78:clearShipHpChange()
		end
	end
end

function var0_0.getDragExtend(arg0_79)
	local var0_79 = arg0_79.theme
	local var1_79 = 99999999
	local var2_79 = 99999999
	local var3_79 = 0
	local var4_79 = 0

	for iter0_79, iter1_79 in pairs(arg0_79.cells) do
		if var1_79 > iter1_79.row then
			var1_79 = iter1_79.row
		end

		if var3_79 < iter1_79.row then
			var3_79 = iter1_79.row
		end

		if var2_79 > iter1_79.column then
			var2_79 = iter1_79.column
		end

		if var4_79 < iter1_79.column then
			var4_79 = iter1_79.column
		end
	end

	local var5_79 = (var4_79 + var2_79) * 0.5
	local var6_79 = (var3_79 + var1_79) * 0.5
	local var7_79 = var0_79.cellSize + var0_79.cellSpace
	local var8_79 = math.max((var4_79 - var5_79 + 1) * var7_79.x, 0)
	local var9_79 = math.max((var5_79 - var2_79 + 1) * var7_79.x, 0)
	local var10_79 = math.max((var6_79 - var1_79 + 1) * var7_79.y, 0)
	local var11_79 = math.max((var3_79 - var6_79 + 1) * var7_79.y, 0)

	return var9_79, var8_79, var10_79, var11_79
end

function var0_0.getPoisonArea(arg0_80, arg1_80)
	local var0_80 = {}
	local var1_80 = arg0_80.theme.cellSize + arg0_80.theme.cellSpace

	for iter0_80, iter1_80 in pairs(arg0_80.cells) do
		if iter1_80:checkHadFlag(ChapterConst.FlagPoison) then
			local var2_80 = math.floor((iter1_80.column - arg0_80.indexMin.y) * var1_80.x * arg1_80)
			local var3_80 = math.ceil((iter1_80.column - arg0_80.indexMin.y + 1) * var1_80.x * arg1_80)
			local var4_80 = math.floor((iter1_80.row - arg0_80.indexMin.x) * var1_80.y * arg1_80)
			local var5_80 = math.ceil((iter1_80.row - arg0_80.indexMin.x + 1) * var1_80.y * arg1_80)
			local var6_80 = var3_80 - var2_80
			local var7_80 = var5_80 - var4_80

			var0_80[iter0_80] = {
				x = var2_80,
				y = var4_80,
				w = var6_80,
				h = var7_80
			}
		end
	end

	return var0_80
end

function var0_0.selectFleets(arg0_81, arg1_81)
	local var0_81 = Clone(arg1_81) or {}
	local var1_81 = getProxy(FleetProxy):GetRegularFleets()

	for iter0_81 = #var0_81, 1, -1 do
		local var2_81 = var1_81[var0_81[iter0_81]]

		if not var2_81 or not var2_81:isUnlock() or var2_81:isLegalToFight() ~= true then
			table.remove(var0_81, iter0_81)
		end
	end

	local var3_81 = {
		[FleetType.Normal] = _.filter(var0_81, function(arg0_82)
			return var1_81[arg0_82]:getFleetType() == FleetType.Normal
		end),
		[FleetType.Submarine] = _.filter(var0_81, function(arg0_83)
			return var1_81[arg0_83]:getFleetType() == FleetType.Submarine
		end)
	}
	local var4_81 = arg0_81:getConfig("group_num")
	local var5_81 = arg0_81:getConfig("submarine_num")

	for iter1_81 = #var3_81[FleetType.Normal], var4_81 + 1, -1 do
		table.remove(var3_81[FleetType.Normal], iter1_81)
	end

	for iter2_81 = #var3_81[FleetType.Submarine], var5_81 + 1, -1 do
		table.remove(var3_81[FleetType.Submarine], iter2_81)
	end

	for iter3_81, iter4_81 in pairs(var3_81) do
		if #iter4_81 == 0 then
			local var6_81 = 0

			if iter3_81 == FleetType.Normal then
				var6_81 = var4_81
			elseif iter3_81 == FleetType.Submarine then
				var6_81 = var5_81
			end

			for iter5_81, iter6_81 in pairs(var1_81) do
				if var6_81 <= #iter4_81 then
					break
				end

				if iter6_81 and iter6_81:getFleetType() == iter3_81 and iter6_81:isUnlock() and iter6_81:isLegalToFight() == true then
					table.insert(iter4_81, iter5_81)
				end
			end
		end
	end

	local var7_81 = {}

	for iter7_81, iter8_81 in ipairs(var3_81) do
		for iter9_81, iter10_81 in ipairs(iter8_81) do
			table.insert(var7_81, iter10_81)
		end
	end

	return var7_81
end

function var0_0.GetDefaultFleetIndex(arg0_84)
	local var0_84 = getProxy(ChapterProxy):GetLastFleetIndex()

	return arg0_84:selectFleets(var0_84)
end

function var0_0.getMaxColumnByRow(arg0_85, arg1_85)
	local var0_85 = -1

	for iter0_85, iter1_85 in pairs(arg0_85.cells) do
		if iter1_85.row == arg1_85 then
			var0_85 = math.max(var0_85, iter1_85.column)
		end
	end

	return var0_85
end

function var0_0.getFleet(arg0_86, arg1_86, arg2_86, arg3_86)
	return _.detect(arg0_86.fleets, function(arg0_87)
		return arg0_87.line.row == arg2_86 and arg0_87.line.column == arg3_86 and (not arg1_86 or arg0_87:getFleetType() == arg1_86) and arg0_87:isValid()
	end) or _.detect(arg0_86.fleets, function(arg0_88)
		return arg0_88.line.row == arg2_86 and arg0_88.line.column == arg3_86 and (not arg1_86 or arg0_88:getFleetType() == arg1_86)
	end)
end

function var0_0.getFleetIndex(arg0_89, arg1_89, arg2_89, arg3_89)
	local var0_89 = arg0_89:getFleet(arg1_89, arg2_89, arg3_89)

	if var0_89 then
		return table.indexof(arg0_89.fleets, var0_89)
	end
end

function var0_0.getOni(arg0_90)
	return _.detect(arg0_90.champions, function(arg0_91)
		return arg0_91.attachment == ChapterConst.AttachOni
	end)
end

function var0_0.getChampion(arg0_92, arg1_92, arg2_92)
	return (_.detect(arg0_92.champions, function(arg0_93)
		return arg0_93.row == arg1_92 and arg0_93.column == arg2_92
	end))
end

function var0_0.getChampionIndex(arg0_94, arg1_94, arg2_94)
	local var0_94 = arg0_94:getChampion(arg1_94, arg2_94)

	if not var0_94 then
		return
	end

	return table.indexof(arg0_94.champions, var0_94)
end

function var0_0.getChampionVisibility(arg0_95, arg1_95, arg2_95, arg3_95)
	assert(arg1_95, "chapter champion not exist.")

	return arg1_95.flag == ChapterConst.CellFlagActive
end

function var0_0.mergeChampion(arg0_96, arg1_96, arg2_96)
	local var0_96 = arg0_96:getChampionIndex(arg1_96.row, arg1_96.column)

	if var0_96 then
		arg0_96.champions[var0_96] = arg1_96

		return true
	else
		if not arg2_96 then
			arg1_96.trait = ChapterConst.TraitLurk
		end

		table.insert(arg0_96.champions, arg1_96)

		return false
	end
end

function var0_0.RemoveChampion(arg0_97, arg1_97)
	local var0_97 = table.indexof(arg0_97.champions, arg1_97)

	if var0_97 then
		table.remove(arg0_97.champions, var0_97)
	end
end

function var0_0.considerAsObstacle(arg0_98, arg1_98, arg2_98, arg3_98)
	local var0_98 = arg0_98:getChapterCell(arg2_98, arg3_98)

	if not var0_98 or not var0_98:IsWalkable() then
		return true
	end

	if arg0_98:existBarrier(arg2_98, arg3_98) then
		return true
	end

	if arg1_98 == ChapterConst.SubjectPlayer then
		if var0_98.flag == ChapterConst.CellFlagActive then
			if ChapterConst.IsEnemyAttach(var0_98.attachment) then
				return true
			end

			if var0_98.attachment == ChapterConst.AttachBox then
				local var1_98 = pg.box_data_template[var0_98.attachmentId]

				assert(var1_98, "box_data_template not exist: " .. var0_98.attachmentId)

				if var1_98.type == ChapterConst.BoxTorpedo then
					return true
				end
			end

			if var0_98.attachment == ChapterConst.AttachStory then
				return true
			end
		end

		if arg0_98:existVisibleChampion(arg2_98, arg3_98) then
			return true
		end
	elseif arg1_98 == ChapterConst.SubjectChampion and arg0_98:existFleet(FleetType.Normal, arg2_98, arg3_98) then
		return true
	end

	return false
end

function var0_0.considerAsStayPoint(arg0_99, arg1_99, arg2_99, arg3_99)
	local var0_99 = arg0_99:getChapterCell(arg2_99, arg3_99)

	if not var0_99 or not var0_99:IsWalkable() then
		return false
	end

	if arg0_99:existBarrier(arg2_99, arg3_99) then
		return false
	end

	if arg1_99 == ChapterConst.SubjectPlayer then
		if var0_99.flag == ChapterConst.CellFlagActive and var0_99.attachment == ChapterConst.AttachStory then
			return true
		end

		if var0_99.attachment == ChapterConst.AttachLandbase and pg.land_based_template[var0_99.attachmentId] and pg.land_based_template[var0_99.attachmentId].type == ChapterConst.LBHarbor then
			return false
		end

		if arg0_99:existFleet(FleetType.Normal, arg2_99, arg3_99) then
			return false
		end

		if arg0_99:existOni(arg2_99, arg3_99) then
			return false
		end

		if arg0_99:existBombEnemy(arg2_99, arg3_99) then
			return false
		end
	elseif arg1_99 == ChapterConst.SubjectChampion then
		if var0_99.flag ~= ChapterConst.CellFlagDisabled and var0_99.attachment ~= ChapterConst.AttachNone then
			return false
		end

		local var1_99 = arg0_99:getChampion(arg2_99, arg3_99)

		if var1_99 and var1_99.flag ~= ChapterConst.CellFlagDisabled then
			return false
		end
	end

	return true
end

function var0_0.existAny(arg0_100, arg1_100, arg2_100)
	local var0_100 = arg0_100:getChapterCell(arg1_100, arg2_100)

	if var0_100.attachment ~= ChapterConst.AttachNone and var0_100.flag == ChapterConst.CellFlagActive then
		return true
	end

	if arg0_100:existFleet(nil, arg1_100, arg2_100) then
		return true
	end

	local var1_100 = arg0_100:getChampion(arg1_100, arg2_100)

	if var1_100 and var1_100.flag ~= ChapterConst.CellFlagDisabled then
		return true
	end
end

function var0_0.existBarrier(arg0_101, arg1_101, arg2_101)
	local var0_101 = arg0_101:getChapterCell(arg1_101, arg2_101)

	if var0_101.attachment == ChapterConst.AttachBox and var0_101.flag == ChapterConst.CellFlagActive and pg.box_data_template[var0_101.attachmentId].type == ChapterConst.BoxBarrier then
		return true
	end

	if var0_101.attachment == ChapterConst.AttachStory and var0_101.flag == ChapterConst.CellFlagTriggerActive and pg.map_event_template[var0_101.attachmentId].type == ChapterConst.StoryObstacle then
		return true
	end

	local var1_101 = arg0_101:getChampion(arg1_101, arg2_101)

	if var1_101 and var1_101.flag ~= ChapterConst.CellFlagDisabled then
		local var2_101 = pg.expedition_data_template[var1_101.attachmentId]

		if var2_101 and var2_101.type == ChapterConst.ExpeditionTypeUnTouchable then
			return true
		end
	end

	return false
end

function var0_0.GetEnemy(arg0_102, arg1_102, arg2_102)
	local var0_102 = arg0_102:getChapterCell(arg1_102, arg2_102)

	if var0_102 and var0_102.flag == ChapterConst.CellFlagActive and ChapterConst.IsEnemyAttach(var0_102.attachment) then
		return var0_102
	end

	local var1_102 = arg0_102:getChampion(arg1_102, arg2_102)

	if var1_102 and var1_102.flag ~= ChapterConst.CellFlagDisabled then
		return var1_102
	end
end

function var0_0.existEnemy(arg0_103, arg1_103, arg2_103, arg3_103)
	if arg1_103 == ChapterConst.SubjectPlayer then
		local var0_103 = arg0_103:GetEnemy(arg2_103, arg3_103)

		if var0_103 then
			local var1_103

			if isa(var0_103, ChapterCell) then
				var1_103 = var0_103.attachment
			else
				var1_103 = ChapterConst.AttachChampion
			end

			return true, var1_103
		end
	elseif arg1_103 == ChapterConst.SubjectChampion and (arg0_103:existFleet(FleetType.Normal, arg2_103, arg3_103) or arg0_103:existFleet(FleetType.Transport, arg2_103, arg3_103)) then
		return true
	end
end

function var0_0.existFleet(arg0_104, arg1_104, arg2_104, arg3_104)
	if _.any(arg0_104.fleets, function(arg0_105)
		return arg0_105.line.row == arg2_104 and arg0_105.line.column == arg3_104 and (not arg1_104 or arg0_105:getFleetType() == arg1_104) and arg0_105:isValid()
	end) then
		return true
	end
end

function var0_0.existVisibleChampion(arg0_106, arg1_106, arg2_106)
	local var0_106 = arg0_106:getChampion(arg1_106, arg2_106)

	return var0_106 and arg0_106:getChampionVisibility(var0_106)
end

function var0_0.existAlly(arg0_107, arg1_107)
	return _.any(arg0_107.fleets, function(arg0_108)
		return arg0_108.id ~= arg1_107.id and arg0_108.line.row == arg1_107.line.row and arg0_108.line.column == arg1_107.line.column and arg0_108:isValid()
	end)
end

function var0_0.existOni(arg0_109, arg1_109, arg2_109)
	return _.any(arg0_109.champions, function(arg0_110)
		return arg0_110.attachment == ChapterConst.AttachOni and arg0_110.flag == ChapterConst.CellFlagActive and (not arg1_109 or arg1_109 == arg0_110.row) and (not arg2_109 or arg2_109 == arg0_110.column)
	end)
end

function var0_0.existBombEnemy(arg0_111, arg1_111, arg2_111)
	if arg1_111 and arg2_111 then
		local var0_111 = arg0_111:getChapterCell(arg1_111, arg2_111)

		return var0_111.attachment == ChapterConst.AttachBomb_Enemy and var0_111.flag == ChapterConst.CellFlagActive
	end

	for iter0_111, iter1_111 in pairs(arg0_111.cells) do
		if iter1_111.attachment == ChapterConst.AttachBomb_Enemy and iter1_111.flag == ChapterConst.CellFlagActive and (not arg1_111 or arg1_111 == iter1_111.row) and (not arg2_111 or arg2_111 == iter1_111.column) then
			return true
		end
	end

	return false
end

function var0_0.isPlayingWithBombEnemy(arg0_112)
	for iter0_112, iter1_112 in pairs(arg0_112.cells) do
		if iter1_112.attachment == ChapterConst.AttachBomb_Enemy then
			return true
		end
	end

	return false
end

function var0_0.existCoastalGunNoMatterLiveOrDead(arg0_113)
	for iter0_113, iter1_113 in pairs(arg0_113.cells) do
		if iter1_113.attachment == ChapterConst.AttachLandbase then
			local var0_113 = pg.land_based_template[iter1_113.attachmentId]

			assert(var0_113, "land_based_template not exist: " .. iter1_113.attachmentId)

			if var0_113.type == ChapterConst.LBCoastalGun then
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

function var0_0.calcWalkableCells(arg0_114, arg1_114, arg2_114, arg3_114, arg4_114)
	local var0_114 = {}

	for iter0_114 = 0, ChapterConst.MaxRow - 1 do
		if not var0_114[iter0_114] then
			var0_114[iter0_114] = {}
		end

		for iter1_114 = 0, ChapterConst.MaxColumn - 1 do
			local var1_114 = ChapterCell.Line2Name(iter0_114, iter1_114)
			local var2_114 = arg0_114.cells[var1_114]

			var0_114[iter0_114][iter1_114] = var2_114 and var2_114:IsWalkable()
		end
	end

	local var3_114 = {}

	if arg1_114 == ChapterConst.SubjectPlayer then
		local var4_114 = arg0_114:getCoastalGunArea()

		for iter2_114, iter3_114 in ipairs(var4_114) do
			var3_114[iter3_114.row .. "_" .. iter3_114.column] = true
		end
	end

	local var5_114 = {}
	local var6_114 = arg0_114:GetRawChapterCell(arg2_114, arg3_114)

	if not var6_114 then
		return var5_114
	end

	local var7_114 = {
		{
			step = 0,
			row = arg2_114,
			column = arg3_114,
			forbiddens = var6_114.forbiddenDirections
		}
	}
	local var8_114 = {}

	while #var7_114 > 0 do
		local var9_114 = table.remove(var7_114, 1)

		table.insert(var8_114, var9_114)
		_.each(var1_0, function(arg0_115)
			local var0_115 = {
				row = var9_114.row + arg0_115[1],
				column = var9_114.column + arg0_115[2],
				step = var9_114.step + 1
			}
			local var1_115 = arg0_114:GetRawChapterCell(var0_115.row, var0_115.column)

			if not var1_115 then
				return
			end

			var0_115.forbiddens = var1_115.forbiddenDirections

			if var0_115.step <= arg4_114 and not OrientedPathFinding.IsDirectionForbidden(var9_114, arg0_115[1], arg0_115[2]) and not (_.any(var7_114, function(arg0_116)
				return arg0_116.row == var0_115.row and arg0_116.column == var0_115.column
			end) or _.any(var8_114, function(arg0_117)
				return arg0_117.row == var0_115.row and arg0_117.column == var0_115.column
			end)) and var0_114[var0_115.row][var0_115.column] then
				table.insert(var5_114, var0_115)

				if not arg0_114:existEnemy(arg1_114, var0_115.row, var0_115.column) and not arg0_114:existBarrier(var0_115.row, var0_115.column) and not var3_114[var0_115.row .. "_" .. var0_115.column] then
					table.insert(var7_114, var0_115)
				end
			end
		end)
	end

	var5_114 = _.filter(var5_114, function(arg0_118)
		return arg0_118.row == arg2_114 and arg0_118.column == arg3_114 or arg0_114:considerAsStayPoint(arg1_114, arg0_118.row, arg0_118.column)
	end)

	return var5_114
end

function var0_0.calcAreaCells(arg0_119, arg1_119, arg2_119, arg3_119, arg4_119)
	local var0_119 = {}

	for iter0_119 = 0, ChapterConst.MaxRow - 1 do
		if not var0_119[iter0_119] then
			var0_119[iter0_119] = {}
		end

		for iter1_119 = 0, ChapterConst.MaxColumn - 1 do
			local var1_119 = ChapterCell.Line2Name(iter0_119, iter1_119)
			local var2_119 = arg0_119.cells[var1_119]

			var0_119[iter0_119][iter1_119] = var2_119 and var2_119:IsWalkable()
		end
	end

	local var3_119 = {}
	local var4_119 = {
		{
			step = 0,
			row = arg1_119,
			column = arg2_119
		}
	}
	local var5_119 = {}

	while #var4_119 > 0 do
		local var6_119 = table.remove(var4_119, 1)

		table.insert(var5_119, var6_119)
		_.each(var1_0, function(arg0_120)
			local var0_120 = {
				row = var6_119.row + arg0_120[1],
				column = var6_119.column + arg0_120[2],
				step = var6_119.step + 1
			}

			if var0_120.row >= 0 and var0_120.row < ChapterConst.MaxRow and var0_120.column >= 0 and var0_120.column < ChapterConst.MaxColumn and var0_120.step <= arg4_119 and not (_.any(var4_119, function(arg0_121)
				return arg0_121.row == var0_120.row and arg0_121.column == var0_120.column
			end) or _.any(var5_119, function(arg0_122)
				return arg0_122.row == var0_120.row and arg0_122.column == var0_120.column
			end)) then
				table.insert(var4_119, var0_120)

				if var0_119[var0_120.row][var0_120.column] and var0_120.step >= arg3_119 then
					table.insert(var3_119, var0_120)
				end
			end
		end)
	end

	return var3_119
end

function var0_0.calcSquareBarrierCells(arg0_123, arg1_123, arg2_123, arg3_123)
	local var0_123 = {}

	for iter0_123 = -arg3_123, arg3_123 do
		for iter1_123 = -arg3_123, arg3_123 do
			local var1_123 = arg1_123 + iter0_123
			local var2_123 = arg2_123 + iter1_123
			local var3_123 = arg0_123:getChapterCell(var1_123, var2_123)

			if var3_123 and var3_123:IsWalkable() and (arg0_123:existBarrier(var1_123, var2_123) or not arg0_123:existAny(var1_123, var2_123)) then
				table.insert(var0_123, {
					row = var1_123,
					column = var2_123
				})
			end
		end
	end

	return var0_123
end

function var0_0.checkAnyInteractive(arg0_124)
	local var0_124 = arg0_124.fleet.line
	local var1_124 = arg0_124:getChapterCell(var0_124.row, var0_124.column)
	local var2_124 = false

	if arg0_124.fleet:getFleetType() == FleetType.Normal then
		if arg0_124:existEnemy(ChapterConst.SubjectPlayer, var1_124.row, var1_124.column) then
			if arg0_124:getRound() == ChapterConst.RoundPlayer then
				var2_124 = true
			end
		elseif var1_124.attachment == ChapterConst.AttachAmbush or var1_124.attachment == ChapterConst.AttachBox then
			if var1_124.flag ~= ChapterConst.CellFlagDisabled then
				var2_124 = true
			end
		elseif var1_124.attachment == ChapterConst.AttachStory then
			var2_124 = var1_124.flag == ChapterConst.CellFlagActive
		elseif var1_124.attachment == ChapterConst.AttachSupply and var1_124.attachmentId > 0 then
			local var3_124, var4_124 = arg0_124:getFleetAmmo(arg0_124.fleet)

			if var4_124 < var3_124 then
				var2_124 = true
			end
		elseif var1_124.attachment == ChapterConst.AttachBox and var1_124.flag ~= ChapterConst.CellFlagDisabled then
			var2_124 = true
		end
	end

	return var2_124
end

function var0_0.getQuadCellPic(arg0_125, arg1_125)
	local var0_125

	if arg1_125.trait == ChapterConst.TraitLurk then
		-- block empty
	elseif arg1_125.flag == ChapterConst.CellFlagActive and ChapterConst.IsEnemyAttach(arg1_125.attachment) and arg1_125.flag == ChapterConst.CellFlagActive then
		var0_125 = "cell_enemy"
	elseif arg1_125.attachment == ChapterConst.AttachBox and arg1_125.flag == ChapterConst.CellFlagActive then
		local var1_125 = pg.box_data_template[arg1_125.attachmentId]

		assert(var1_125, "box_data_template not exist: " .. arg1_125.attachmentId)

		if var1_125.type == ChapterConst.BoxDrop or var1_125.type == ChapterConst.BoxStrategy or var1_125.type == ChapterConst.BoxSupply or var1_125.type == ChapterConst.BoxEnemy then
			var0_125 = "cell_box"
		elseif var1_125.type == ChapterConst.BoxTorpedo then
			var0_125 = "cell_enemy"
		elseif var1_125.type == ChapterConst.BoxBarrier then
			var0_125 = "cell_green"
		end
	elseif arg1_125.attachment == ChapterConst.AttachStory then
		if arg1_125.flag == ChapterConst.CellFlagTriggerActive then
			local var2_125 = pg.map_event_template[arg1_125.attachmentId].grid_color

			var0_125 = var2_125 and #var2_125 > 0 and var2_125 or nil
		end
	elseif arg1_125.attachment == ChapterConst.AttachSupply and arg1_125.attachmentId > 0 then
		var0_125 = "cell_box"
	elseif arg1_125.attachment == ChapterConst.AttachTransport_Target then
		var0_125 = "cell_box"
	elseif arg1_125.attachment == ChapterConst.AttachLandbase then
		local var3_125 = pg.land_based_template[arg1_125.attachmentId]

		if var3_125 and (var3_125.type == ChapterConst.LBHarbor or var3_125.type == ChapterConst.LBDock) then
			var0_125 = "cell_box"
		end
	end

	return var0_125
end

function var0_0.getMapShip(arg0_126, arg1_126)
	local var0_126

	if arg1_126:isValid() then
		var0_126 = _.detect(arg1_126:getShips(false), function(arg0_127)
			return arg0_127.isNpc and arg0_127.hpRant > 0
		end)

		if not var0_126 then
			local var1_126 = arg1_126:getFleetType()

			if var1_126 == FleetType.Normal then
				var0_126 = arg1_126:getShipsByTeam(TeamType.Main, false)[1]
			elseif var1_126 == FleetType.Submarine then
				var0_126 = arg1_126:getShipsByTeam(TeamType.Submarine, false)[1]
			end
		end
	end

	return var0_126
end

function var0_0.getStrikeAnimShip(arg0_128, arg1_128, arg2_128)
	return underscore.detect(arg1_128:getShips(false), function(arg0_129)
		return arg0_129:GetMapStrikeAnim() == arg2_128
	end)
end

function var0_0.GetSubmarineFleet(arg0_130)
	return table.Find(arg0_130.fleets, function(arg0_131, arg1_131)
		return arg1_131:getFleetType() == FleetType.Submarine and arg1_131:isValid()
	end)
end

function var0_0.getStageCell(arg0_132, arg1_132, arg2_132)
	local var0_132 = arg0_132:getChampion(arg1_132, arg2_132)

	if var0_132 and var0_132.flag ~= ChapterConst.CellFlagDisabled then
		return var0_132
	end

	local var1_132 = arg0_132:getChapterCell(arg1_132, arg2_132)

	if var1_132 and var1_132.flag ~= ChapterConst.CellFlagDisabled then
		return var1_132
	end
end

function var0_0.getStageId(arg0_133, arg1_133, arg2_133)
	local var0_133 = arg0_133:getChampion(arg1_133, arg2_133)

	if var0_133 and var0_133.flag ~= ChapterConst.CellFlagDisabled then
		return var0_133.id
	end

	local var1_133 = arg0_133:getChapterCell(arg1_133, arg2_133)

	if var1_133 and var1_133.flag ~= ChapterConst.CellFlagDisabled then
		return var1_133.attachmentId
	end
end

function var0_0.getStageExtraAwards(arg0_134)
	return
end

function var0_0.GetExtraCostRate(arg0_135)
	local var0_135 = 1
	local var1_135 = {}

	for iter0_135, iter1_135 in ipairs(arg0_135.operationBuffList) do
		local var2_135 = pg.benefit_buff_template[iter1_135]

		var1_135[#var1_135 + 1] = var2_135

		if var2_135.benefit_type == var0_0.OPERATION_BUFF_TYPE_COST then
			var0_135 = var0_135 + var2_135.benefit_effect * 0.01
		end
	end

	return math.max(1, var0_135), var1_135
end

function var0_0.getFleetCost(arg0_136, arg1_136, arg2_136)
	if arg0_136:getPlayType() == ChapterConst.TypeExtra then
		return {
			gold = 0,
			oil = 0
		}, {
			gold = 0,
			oil = 0
		}
	end

	local var0_136, var1_136 = arg1_136:getCost()
	local var2_136 = arg0_136:GetLimitOilCost(arg1_136:getFleetType() == FleetType.Submarine, arg2_136)

	var1_136.oil = math.clamp(var2_136 - var0_136.oil, 0, var1_136.oil)

	local var3_136 = arg0_136:GetExtraCostRate()

	for iter0_136, iter1_136 in ipairs({
		var0_136,
		var1_136
	}) do
		for iter2_136, iter3_136 in pairs(iter1_136) do
			iter1_136[iter2_136] = iter1_136[iter2_136] * var3_136
		end
	end

	return var0_136, var1_136
end

function var0_0.isOverFleetCost(arg0_137, arg1_137, arg2_137)
	local var0_137 = arg0_137:GetLimitOilCost(arg1_137:getFleetType() == FleetType.Submarine, arg2_137)
	local var1_137 = 0

	for iter0_137, iter1_137 in ipairs({
		arg1_137:getCost()
	}) do
		var1_137 = var1_137 + iter1_137.oil
	end

	local var2_137 = arg0_137:GetExtraCostRate()

	return var0_137 < var1_137, var0_137 * var2_137, var1_137 * var2_137
end

function var0_0.writeBack(arg0_138, arg1_138, arg2_138)
	local var0_138 = arg0_138.fleet

	local function var1_138(arg0_139)
		local var0_139 = arg2_138.statistics[arg0_139.id]

		if not var0_139 then
			return
		end

		arg0_139.hpRant = var0_139.bp
	end

	for iter0_138, iter1_138 in pairs(var0_138.ships) do
		var1_138(iter1_138)
	end

	var0_138:ResortShips()

	if not arg2_138.skipAmmo then
		var0_138.restAmmo = math.max(var0_138.restAmmo - 1, 0)
	end

	local var2_138 = _.filter(var0_138:getStrategies(), function(arg0_140)
		local var0_140 = pg.strategy_data_template[arg0_140.id]

		return var0_140 and var0_140.type == ChapterConst.StgTypeBindFleetPassive and arg0_140.count > 0
	end)

	_.each(var2_138, function(arg0_141)
		var0_138:consumeOneStrategy(arg0_141.id)
	end)

	if arg2_138.statistics.submarineAid then
		local var3_138 = arg0_138:GetSubmarineFleet()

		if var3_138 and not var3_138:inHuntingRange(var0_138.line.row, var0_138.line.column) then
			var3_138:consumeOneStrategy(ChapterConst.StrategyCallSubOutofRange)
		end

		if var3_138 then
			for iter2_138, iter3_138 in pairs(var3_138.ships) do
				var1_138(iter3_138)
			end

			var3_138.restAmmo = math.max(var3_138.restAmmo - 1, 0)
		end
	end

	arg0_138:UpdateComboHistory(arg2_138.statistics._battleScore)

	if arg1_138 then
		local var4_138
		local var5_138
		local var6_138 = arg0_138:getChampion(var0_138.line.row, var0_138.line.column)

		if var6_138 then
			var6_138:Iter()

			var4_138 = var6_138.attachment
			var5_138 = var6_138.attachmentId

			if var6_138.flag == ChapterConst.CellFlagDisabled then
				arg0_138:RemoveChampion(var6_138)
			end
		else
			local var7_138 = arg0_138:getChapterCell(var0_138.line.row, var0_138.line.column)

			var4_138 = var7_138.attachment
			var5_138 = var7_138.attachmentId

			if var4_138 == ChapterConst.AttachEnemy or var4_138 == ChapterConst.AttachBoss then
				var7_138.flag = ChapterConst.CellFlagDisabled

				arg0_138:updateChapterCell(var7_138)
			else
				arg0_138:clearChapterCell(var7_138.row, var7_138.column)
			end
		end

		assert(var4_138, "attachment can not be nil.")

		if var4_138 == ChapterConst.AttachEnemy or var4_138 == ChapterConst.AttachElite or var4_138 == ChapterConst.AttachChampion then
			if not var6_138 or var6_138.flag == ChapterConst.CellFlagDisabled then
				local var8_138 = _.detect(arg0_138.achieves, function(arg0_142)
					return arg0_142.type == ChapterConst.AchieveType2
				end)

				if var8_138 then
					var8_138.count = var8_138.count + 1
				end
			end
		elseif var4_138 == ChapterConst.AttachBoss then
			local var9_138 = _.detect(arg0_138.achieves, function(arg0_143)
				return arg0_143.type == ChapterConst.AchieveType1
			end)

			if var9_138 then
				var9_138.count = var9_138.count + 1
			end
		end

		if arg0_138:CheckChapterWin() then
			pg.TrackerMgr.GetInstance():Tracking(TRACKING_KILL_BOSS)
		end

		if var6_138 and var6_138.flag == ChapterConst.CellFlagDisabled or not var6_138 and var4_138 ~= ChapterConst.AttachBox then
			var0_138.defeatEnemies = var0_138.defeatEnemies + 1
			arg0_138.defeatEnemies = arg0_138.defeatEnemies + 1

			local var10_138 = pg.expedition_data_template[var5_138]

			if not arg0_138:isLoop() and var10_138 and var10_138.type == ChapterConst.ExpeditionTypeMulBoss then
				local var11_138 = pg.chapter_model_multistageboss[arg0_138.id].guild_buff
				local var12_138 = var0_138:GetStatusStrategy()

				_.each(var11_138, function(arg0_144)
					if not table.contains(var12_138, arg0_144) then
						table.insert(var12_138, arg0_144)
					end
				end)

				local var13_138 = arg0_138:getNextValidIndex()

				if var13_138 > 0 then
					var12_138 = arg0_138.fleets[var13_138]:GetStatusStrategy()

					_.each(var11_138, function(arg0_145)
						table.removebyvalue(var12_138, arg0_145)
					end)
				end
			end

			getProxy(ChapterProxy):RecordLastDefeatedEnemy(arg0_138.id, {
				score = arg2_138.statistics._battleScore,
				line = {
					row = var0_138.line.row,
					column = var0_138.line.column
				},
				attachment = var4_138,
				attachmentId = var5_138
			})
		end
	end
end

function var0_0.CleanCurrentEnemy(arg0_146)
	local var0_146 = arg0_146.fleet.line
	local var1_146
	local var2_146 = arg0_146:getChampion(var0_146.row, var0_146.column)

	if var2_146 then
		var2_146:Iter()

		if var2_146.flag == ChapterConst.CellFlagDisabled then
			arg0_146:RemoveChampion(var2_146)
		end

		return
	end

	if arg0_146:getChapterCell(var0_146.row, var0_146.column).attachment == ChapterConst.AttachEnemy then
		arg0_146:clearChapterCell(var0_146.row, var0_146.column)

		return
	end
end

function var0_0.UpdateProgressAfterSkipBattle(arg0_147)
	arg0_147:writeBack(true, {
		skipAmmo = true,
		statistics = {
			_battleScore = ys.Battle.BattleConst.BattleScore.S
		}
	})
end

function var0_0.UpdateProgressOnRetreat(arg0_148)
	_.each(arg0_148.achieves, function(arg0_149)
		if arg0_149.type == ChapterConst.AchieveType3 then
			if _.all(_.values(arg0_148.cells), function(arg0_150)
				if arg0_150.attachment == ChapterConst.AttachEnemy or arg0_150.attachment == ChapterConst.AttachElite or arg0_150.attachment == ChapterConst.AttachBox and pg.box_data_template[arg0_150.attachmentId].type == ChapterConst.BoxEnemy then
					return arg0_150.flag == ChapterConst.CellFlagDisabled
				end

				return true
			end) and _.all(arg0_148.champions, function(arg0_151)
				return arg0_151.flag == ChapterConst.CellFlagDisabled
			end) then
				arg0_149.count = arg0_149.count + 1
			end
		elseif arg0_149.type == ChapterConst.AchieveType4 then
			if arg0_148.orignalShipCount <= arg0_149.config then
				arg0_149.count = arg0_149.count + 1
			end
		elseif arg0_149.type == ChapterConst.AchieveType5 then
			if not _.any(arg0_148:getShips(), function(arg0_152)
				return arg0_152:getShipType() == arg0_149.config
			end) then
				arg0_149.count = arg0_149.count + 1
			end
		elseif arg0_149.type == ChapterConst.AchieveType6 then
			local var0_149 = (arg0_148.scoreHistory[0] or 0) + (arg0_148.scoreHistory[1] or 0)

			arg0_149.count = math.max(var0_149 <= 0 and arg0_148.combo or 0, arg0_149.count or 0)
		end
	end)

	if arg0_148.progress == 100 then
		arg0_148.passCount = arg0_148.passCount + 1
	end

	local var0_148 = arg0_148.progress
	local var1_148 = math.min(arg0_148.progress + arg0_148:getConfig("progress_boss"), 100)

	arg0_148.progress = var1_148

	if var0_148 < 100 and var1_148 >= 100 then
		getProxy(ChapterProxy):RecordJustClearChapters(arg0_148.id, true)
	end

	arg0_148.defeatCount = arg0_148.defeatCount + 1

	local var2_148 = getProxy(ChapterProxy):getMapById(arg0_148:getConfig("map")):getMapType()

	if var2_148 == Map.ELITE then
		pg.TrackerMgr.GetInstance():Tracking(TRACKING_HARD_CHAPTER, arg0_148.id)
	elseif var2_148 == Map.SCENARIO then
		if arg0_148.progress == 100 and arg0_148.passCount == 0 then
			pg.TrackerMgr.GetInstance():Tracking(TRACKING_HIGHEST_CHAPTER, arg0_148.id)
		end

		if arg0_148.defeatCount == 1 then
			if arg0_148.id == 304 then
				pg.TrackerMgr.GetInstance():Tracking(TRACKING_FIRST_PASS_3_4)
			elseif arg0_148.id == 404 then
				pg.TrackerMgr.GetInstance():Tracking(TRACKING_FIRST_PASS_4_4)
			elseif arg0_148.id == 504 then
				pg.TrackerMgr.GetInstance():Tracking(TRACKING_FIRST_PASS_5_4)
			elseif arg0_148.id == 604 then
				pg.TrackerMgr.GetInstance():Tracking(TRACKING_FIRST_PASS_6_4)
			elseif arg0_148.id == 1204 then
				pg.TrackerMgr.GetInstance():Tracking(TRACKING_FIRST_PASS_12_4)
			elseif arg0_148.id == 1301 then
				pg.TrackerMgr.GetInstance():Tracking(TRACKING_FIRST_PASS_13_1)
			elseif arg0_148.id == 1302 then
				pg.TrackerMgr.GetInstance():Tracking(TRACKING_FIRST_PASS_13_2)
			elseif arg0_148.id == 1303 then
				pg.TrackerMgr.GetInstance():Tracking(TRACKING_FIRST_PASS_13_3)
			elseif arg0_148.id == 1304 then
				pg.TrackerMgr.GetInstance():Tracking(TRACKING_FIRST_PASS_13_4)
			end
		end
	end
end

function var0_0.UpdateComboHistory(arg0_153, arg1_153)
	getProxy(ChapterProxy):RecordComboHistory(arg0_153.id, {
		scoreHistory = Clone(arg0_153.scoreHistory),
		combo = Clone(arg0_153.combo)
	})

	arg0_153.scoreHistory = arg0_153.scoreHistory or {}
	arg0_153.scoreHistory[arg1_153] = (arg0_153.scoreHistory[arg1_153] or 0) + 1

	if arg1_153 <= ys.Battle.BattleConst.BattleScore.C then
		arg0_153.combo = 0
	else
		arg0_153.combo = (arg0_153.combo or 0) + 1
	end
end

function var0_0.GetWinConditions(arg0_154)
	return arg0_154.winConditions
end

function var0_0.GetLoseConditions(arg0_155)
	return arg0_155.loseConditions
end

function var0_0.CheckChapterWin(arg0_156)
	local var0_156 = arg0_156:GetWinConditions()
	local var1_156 = false
	local var2_156 = ChapterConst.ReasonVictory

	for iter0_156, iter1_156 in pairs(var0_156) do
		if iter1_156.type == 1 then
			local var3_156 = arg0_156:findChapterCells(ChapterConst.AttachBoss)
			local var4_156 = 0

			_.each(var3_156, function(arg0_157)
				if arg0_157 and arg0_157.flag == ChapterConst.CellFlagDisabled then
					var4_156 = var4_156 + 1
				end
			end)

			var1_156 = var1_156 or var4_156 >= iter1_156.param
		elseif iter1_156.type == 2 then
			var1_156 = var1_156 or arg0_156:GetDefeatCount() >= iter1_156.param
		elseif iter1_156.type == 3 then
			local var5_156 = arg0_156:CheckTransportState()

			var1_156 = var1_156 or var5_156 == 1
		elseif iter1_156.type == 4 then
			var1_156 = var1_156 or arg0_156:getRoundNum() > iter1_156.param
		elseif iter1_156.type == 5 then
			local var6_156 = iter1_156.param
			local var7_156 = _.any(arg0_156.champions, function(arg0_158)
				local var0_158 = arg0_158.attachmentId == var6_156

				for iter0_158, iter1_158 in pairs(arg0_158.idList) do
					var0_158 = var0_158 or iter1_158 == var6_156
				end

				return var0_158 and arg0_158.flag ~= ChapterConst.CellFlagDisabled
			end) or _.any(arg0_156.cells, function(arg0_159)
				return arg0_159.attachmentId == var6_156 and arg0_159.flag ~= ChapterConst.CellFlagDisabled
			end)

			var1_156 = var1_156 or not var7_156
		elseif iter1_156.type == 6 then
			local var8_156 = iter1_156.param
			local var9_156 = _.any(arg0_156.fleets, function(arg0_160)
				return arg0_160:getFleetType() == FleetType.Normal and arg0_160:isValid() and arg0_160.line.row == var8_156[1] and arg0_160.line.column == var8_156[2]
			end)

			var1_156 = var1_156 or var9_156
		end

		if var1_156 then
			break
		end
	end

	return var1_156, var2_156
end

function var0_0.CheckChapterLose(arg0_161)
	local var0_161 = arg0_161:GetLoseConditions()
	local var1_161 = false
	local var2_161 = ChapterConst.ReasonDefeat

	for iter0_161, iter1_161 in pairs(var0_161) do
		if iter1_161.type == 1 then
			local var3_161 = _.any(arg0_161.fleets, function(arg0_162)
				return arg0_162:getFleetType() == FleetType.Normal and arg0_162:isValid()
			end)

			var1_161 = var1_161 or not var3_161
		elseif iter1_161.type == 2 then
			var1_161 = var1_161 or arg0_161.BaseHP <= 0
			var2_161 = var1_161 and ChapterConst.ReasonDefeatDefense or var2_161
		end

		if var1_161 then
			break
		end
	end

	if arg0_161:getPlayType() == ChapterConst.TypeTransport then
		local var4_161 = arg0_161:CheckTransportState()

		var1_161 = var1_161 or var4_161 == -1
	end

	return var1_161, var2_161
end

function var0_0.CheckChapterWillWin(arg0_163)
	if arg0_163:existOni() or arg0_163:isPlayingWithBombEnemy() then
		return true
	end

	if arg0_163:CheckChapterWin() then
		return true
	end
end

function var0_0.triggerSkill(arg0_164, arg1_164, arg2_164)
	local var0_164 = _.filter(arg1_164:findSkills(arg2_164), function(arg0_165)
		local var0_165 = arg0_165:GetTriggers()

		return _.any(var0_165, function(arg0_166)
			return arg0_166[1] == FleetSkill.TriggerInSubTeam and arg0_166[2] == 1
		end) == (arg1_164:getFleetType() == FleetType.Submarine) and _.all(arg0_165:GetTriggers(), function(arg0_167)
			return arg0_164:triggerCheck(arg1_164, arg0_165, arg0_167)
		end)
	end)

	return _.reduce(var0_164, nil, function(arg0_168, arg1_168)
		local var0_168 = arg1_168:GetType()
		local var1_168 = arg1_168:GetArgs()

		if var0_168 == FleetSkill.TypeMoveSpeed or var0_168 == FleetSkill.TypeHuntingLv or var0_168 == FleetSkill.TypeTorpedoPowerUp then
			return (arg0_168 or 0) + var1_168[1]
		elseif var0_168 == FleetSkill.TypeAmbushDodge or var0_168 == FleetSkill.TypeAirStrikeDodge then
			return math.max(arg0_168 or 0, var1_168[1])
		elseif var0_168 == FleetSkill.TypeAttack or var0_168 == FleetSkill.TypeStrategy then
			arg0_168 = arg0_168 or {}

			table.insert(arg0_168, var1_168)

			return arg0_168
		elseif var0_168 == FleetSkill.TypeBattleBuff then
			arg0_168 = arg0_168 or {}

			table.insert(arg0_168, var1_168[1])

			return arg0_168
		end
	end), var0_164
end

function var0_0.triggerCheck(arg0_169, arg1_169, arg2_169, arg3_169)
	local var0_169 = arg3_169[1]

	if var0_169 == FleetSkill.TriggerDDHead then
		local var1_169 = arg1_169:getShipsByTeam(TeamType.Vanguard, false)

		return #var1_169 > 0 and ShipType.IsTypeQuZhu(var1_169[1]:getShipType())
	elseif var0_169 == FleetSkill.TriggerVanCount then
		local var2_169 = arg1_169:getShipsByTeam(TeamType.Vanguard, false)

		return #var2_169 >= arg3_169[2] and #var2_169 <= arg3_169[3]
	elseif var0_169 == FleetSkill.TriggerShipCount then
		local var3_169 = _.filter(arg1_169:getShips(false), function(arg0_170)
			return table.contains(arg3_169[2], arg0_170:getShipType())
		end)

		return #var3_169 >= arg3_169[3] and #var3_169 <= arg3_169[4]
	elseif var0_169 == FleetSkill.TriggerAroundEnemy then
		local var4_169 = {
			row = arg1_169.line.row,
			column = arg1_169.line.column
		}

		return _.any(_.values(arg0_169.cells), function(arg0_171)
			local var0_171 = arg0_169:GetEnemy(arg0_171.row, arg0_171.column)

			if not var0_171 then
				return
			end

			local var1_171 = pg.expedition_data_template[var0_171.attachmentId]

			if not var1_171 then
				return
			end

			local var2_171 = var1_171.type

			return ManhattonDist(var4_169, {
				row = arg0_171.row,
				column = arg0_171.column
			}) <= arg3_169[2] and (type(arg3_169[3]) == "number" and arg3_169[3] == var2_171 or type(arg3_169[3]) == "table" and table.contains(arg3_169[3], var2_171))
		end)
	elseif var0_169 == FleetSkill.TriggerNekoPos then
		local var5_169 = arg1_169:findCommanderBySkillId(arg2_169.id)

		for iter0_169, iter1_169 in pairs(arg1_169:getCommanders()) do
			if var5_169.id == iter1_169.id and iter0_169 == arg3_169[2] then
				return true
			end
		end
	elseif var0_169 == FleetSkill.TriggerAroundLand then
		local var6_169 = {
			row = arg1_169.line.row,
			column = arg1_169.line.column
		}

		return _.any(_.values(arg0_169.cells), function(arg0_172)
			return not arg0_172:IsWalkable() and ManhattonDist(var6_169, {
				row = arg0_172.row,
				column = arg0_172.column
			}) <= arg3_169[2]
		end)
	elseif var0_169 == FleetSkill.TriggerAroundCombatAlly then
		local var7_169 = {
			row = arg1_169.line.row,
			column = arg1_169.line.column
		}

		return _.any(arg0_169.fleets, function(arg0_173)
			return arg1_169.id ~= arg0_173.id and arg0_173:getFleetType() == FleetType.Normal and arg0_169:existEnemy(ChapterConst.SubjectPlayer, arg0_173.line.row, arg0_173.line.column) and ManhattonDist(var7_169, {
				row = arg0_173.line.row,
				column = arg0_173.line.column
			}) <= arg3_169[2]
		end)
	elseif var0_169 == FleetSkill.TriggerInSubTeam then
		return true
	else
		assert(false, "invalid trigger type: " .. var0_169)
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

function var0_0.checkOniState(arg0_174)
	local var0_174 = arg0_174:getOni()

	assert(var0_174, "oni not exist.")

	if _.all(var2_0, function(arg0_175)
		local var0_175 = {
			var0_174.row + arg0_175[1],
			var0_174.column + arg0_175[2]
		}

		if arg0_174:existFleet(FleetType.Normal, var0_175[1], var0_175[2]) then
			return true
		end

		local var1_175 = arg0_174:getChapterCell(var0_175[1], var0_175[2])

		if not var1_175 or not var1_175:IsWalkable() then
			return true
		end

		if arg0_174:existBarrier(var1_175.row, var1_175.column) then
			return true
		end
	end) then
		return 1
	end

	local var1_174 = arg0_174:getOniChapterInfo().escape_grids

	if _.any(var1_174, function(arg0_176)
		return arg0_176[1] == var0_174.row and arg0_176[2] == var0_174.column
	end) then
		return 2
	end
end

function var0_0.onOniEnter(arg0_177)
	for iter0_177, iter1_177 in pairs(arg0_177.cells) do
		iter1_177.attachment = ChapterConst.AttachNone
		iter1_177.attachmentId = nil
		iter1_177.flag = nil
		iter1_177.data = nil
	end

	arg0_177.champions = {}
	arg0_177.modelCount = arg0_177:getOniChapterInfo().special_item
	arg0_177.roundIndex = 0
end

function var0_0.onBombEnemyEnter(arg0_178)
	for iter0_178, iter1_178 in pairs(arg0_178.cells) do
		iter1_178.attachment = ChapterConst.AttachNone
		iter1_178.attachmentId = nil
		iter1_178.flag = nil
		iter1_178.data = nil
	end

	arg0_178.champions = {}
	arg0_178.modelCount = 0
	arg0_178.roundIndex = 0
end

function var0_0.clearSubmarineFleet(arg0_179)
	for iter0_179 = #arg0_179.fleets, 1, -1 do
		if arg0_179.fleets[iter0_179]:getFleetType() == FleetType.Submarine then
			table.remove(arg0_179.fleets, iter0_179)
		end
	end
end

function var0_0.getSpAppearStory(arg0_180)
	if arg0_180:existOni() then
		for iter0_180, iter1_180 in ipairs(arg0_180.champions) do
			if iter1_180.trait == ChapterConst.TraitLurk and iter1_180.attachment == ChapterConst.AttachOni then
				local var0_180 = iter1_180:getConfig("appear_story")

				if var0_180 and #var0_180 > 0 then
					return var0_180
				end
			end
		end
	elseif arg0_180:isPlayingWithBombEnemy() then
		for iter2_180, iter3_180 in pairs(arg0_180.cells) do
			if iter3_180.attachment == ChapterConst.AttachBomb_Enemy and iter3_180.trait == ChapterConst.TraitLurk then
				local var1_180 = pg.specialunit_template[iter3_180.attachmentId]

				if var1_180.appear_story and #var1_180.appear_story > 0 then
					return var1_180.appear_story
				end
			end
		end
	end
end

function var0_0.getSpAppearGuide(arg0_181)
	if arg0_181:existOni() then
		for iter0_181, iter1_181 in ipairs(arg0_181.champions) do
			if iter1_181.trait == ChapterConst.TraitLurk and iter1_181.attachment == ChapterConst.AttachOni then
				local var0_181 = iter1_181:getConfig("appear_guide")

				if var0_181 and #var0_181 > 0 then
					return var0_181
				end
			end
		end
	elseif arg0_181:isPlayingWithBombEnemy() then
		for iter2_181, iter3_181 in pairs(arg0_181.cells) do
			if iter3_181.attachment == ChapterConst.AttachBomb_Enemy and iter3_181.trait == ChapterConst.TraitLurk then
				local var1_181 = pg.specialunit_template[iter3_181.attachmentId]

				if var1_181.appear_guide and #var1_181.appear_guide > 0 then
					return var1_181.appear_guide
				end
			end
		end
	end
end

function var0_0.CheckTransportState(arg0_182)
	local var0_182 = _.detect(arg0_182.fleets, function(arg0_183)
		return arg0_183:getFleetType() == FleetType.Transport
	end)

	if not var0_182 then
		return -1
	end

	local var1_182 = arg0_182:findChapterCell(ChapterConst.AttachTransport_Target)

	assert(var0_182, "transport fleet not exist.")
	assert(var1_182, "transport target not exist.")

	if not var0_182:isValid() then
		return -1
	elseif var0_182.line.row == var1_182.row and var0_182.line.column == var1_182.column and not arg0_182:existEnemy(ChapterConst.SubjectPlayer, var1_182.row, var1_182.column) then
		return 1
	else
		return 0
	end
end

function var0_0.getCoastalGunArea(arg0_184)
	local var0_184 = {}

	for iter0_184, iter1_184 in pairs(arg0_184.cells) do
		if iter1_184.attachment == ChapterConst.AttachLandbase and iter1_184.flag ~= ChapterConst.CellFlagDisabled then
			local var1_184 = pg.land_based_template[iter1_184.attachmentId]

			if var1_184.type == ChapterConst.LBCoastalGun then
				local var2_184 = var1_184.function_args
				local var3_184 = {
					math.abs(var2_184[1]),
					math.abs(var2_184[2])
				}
				local var4_184 = {
					Mathf.Sign(var2_184[1]),
					Mathf.Sign(var2_184[2])
				}
				local var5_184 = math.max(var3_184[1], var3_184[2])

				for iter2_184 = 1, var5_184 do
					table.insert(var0_184, {
						row = iter1_184.row + math.min(var3_184[1], iter2_184) * var4_184[1],
						column = iter1_184.column + math.min(var3_184[2], iter2_184) * var4_184[2]
					})
				end
			end
		end
	end

	return var0_184
end

function var0_0.GetAntiAirGunArea(arg0_185)
	local var0_185 = {}
	local var1_185 = {}

	for iter0_185, iter1_185 in pairs(arg0_185.cells) do
		if iter1_185.attachment == ChapterConst.AttachLandbase and iter1_185.flag ~= ChapterConst.CellFlagDisabled then
			local var2_185 = pg.land_based_template[iter1_185.attachmentId]

			if var2_185.type == ChapterConst.LBAntiAir then
				local var3_185 = var2_185.function_args
				local var4_185 = math.abs(var3_185[1])

				local function var5_185(arg0_186, arg1_186)
					return ChapterConst.MaxColumn * arg0_186 + arg1_186
				end

				local var6_185 = {}
				local var7_185 = {}

				if var4_185 > 0 then
					var6_185[var5_185(iter1_185.row, iter1_185.column)] = iter1_185
				end

				while next(var6_185) do
					local var8_185 = next(var6_185)
					local var9_185 = var6_185[var8_185]

					var6_185[var8_185] = nil

					if var4_185 >= math.abs(var9_185.row - iter1_185.row) and var4_185 >= math.abs(var9_185.column - iter1_185.column) then
						var7_185[var8_185] = var9_185

						for iter2_185 = 1, #var2_0 do
							local var10_185 = var9_185.row + var2_0[iter2_185][1]
							local var11_185 = var9_185.column + var2_0[iter2_185][2]
							local var12_185 = var5_185(var10_185, var11_185)

							if not var7_185[var12_185] then
								var6_185[var12_185] = {
									row = var10_185,
									column = var11_185
								}
							end
						end
					end
				end

				for iter3_185, iter4_185 in pairs(var7_185) do
					var1_185[iter3_185] = iter4_185
				end
			end
		end
	end

	for iter5_185, iter6_185 in pairs(var1_185) do
		table.insert(var0_185, iter6_185)
	end

	return var0_185
end

function var0_0.GetDefeatCount(arg0_187)
	return arg0_187.defeatEnemies
end

function var0_0.ExistDivingChampion(arg0_188)
	return _.any(arg0_188.champions, function(arg0_189)
		return arg0_189.flag == ChapterConst.CellFlagDiving
	end)
end

function var0_0.IsSkipPrecombat(arg0_190)
	return arg0_190:isLoop() and getProxy(ChapterProxy):GetSkipPrecombat()
end

function var0_0.CanActivateAutoFight(arg0_191)
	local var0_191 = pg.chapter_template_loop[arg0_191.id]

	return var0_191 and var0_191.fightauto == 1 and arg0_191:isLoop() and AutoBotCommand.autoBotSatisfied() and not arg0_191:existOni() and not arg0_191:existBombEnemy()
end

function var0_0.IsAutoFight(arg0_192)
	return arg0_192:CanActivateAutoFight() and getProxy(ChapterProxy):GetChapterAutoFlag(arg0_192.id) == 1
end

function var0_0.getOperationBuffDescStg(arg0_193)
	for iter0_193, iter1_193 in ipairs(arg0_193.operationBuffList) do
		if pg.benefit_buff_template[iter1_193].benefit_type == Chapter.OPERATION_BUFF_TYPE_DESC then
			return iter1_193
		end
	end
end

function var0_0.GetOperationDesc(arg0_194)
	local var0_194 = ""

	for iter0_194, iter1_194 in ipairs(arg0_194.operationBuffList) do
		local var1_194 = pg.benefit_buff_template[iter1_194]

		if var1_194.benefit_type == var0_0.OPERATION_BUFF_TYPE_DESC then
			var0_194 = var1_194.desc

			break
		end
	end

	return var0_194
end

function var0_0.GetOperationBuffList(arg0_195)
	return arg0_195.operationBuffList
end

function var0_0.GetAllEnemies(arg0_196, arg1_196)
	local var0_196 = {}

	for iter0_196, iter1_196 in pairs(arg0_196.cells) do
		if ChapterConst.IsEnemyAttach(iter1_196.attachment) and (arg1_196 or iter1_196.flag ~= ChapterConst.CellFlagDisabled) then
			table.insert(var0_196, iter1_196)
		end
	end

	for iter2_196, iter3_196 in pairs(arg0_196.champions) do
		if arg1_196 or iter3_196.flag ~= ChapterConst.CellFlagDisabled then
			table.insert(var0_196, iter3_196)
		end
	end

	return var0_196
end

function var0_0.GetFleetofDuty(arg0_197, arg1_197)
	local var0_197

	for iter0_197, iter1_197 in ipairs(arg0_197.fleets) do
		if iter1_197:isValid() and iter1_197:getFleetType() == FleetType.Normal then
			local var1_197 = arg0_197.duties[iter1_197.id] or 0

			if var1_197 == ChapterFleet.DUTY_KILLALL or arg1_197 and var1_197 == ChapterFleet.DUTY_KILLBOSS or not arg1_197 and var1_197 == ChapterFleet.DUTY_CLEANPATH then
				return iter1_197
			end

			var0_197 = iter1_197
		end
	end

	return var0_197
end

function var0_0.GetBuffOfLinkAct(arg0_198)
	if arg0_198:getPlayType() == ChapterConst.TypeDOALink then
		local var0_198 = pg.gameset.doa_fever_buff.description

		return _.detect(arg0_198.buff_list, function(arg0_199)
			return table.contains(var0_198, arg0_199)
		end)
	end
end

function var0_0.GetAttachmentStories(arg0_200)
	local var0_200 = arg0_200.cellAttachments
	local var1_200 = 0
	local var2_200

	for iter0_200, iter1_200 in pairs(var0_200) do
		local var3_200 = var0_0.GetEventTemplateByKey("mult_story", iter1_200.attachmentId)

		if var3_200 then
			assert(not var2_200 or table.equal(var2_200, var3_200[1]), "Not the same Config of Mult_story ID: " .. iter1_200.attachmentId)

			var2_200 = var2_200 or var3_200[1]

			local var4_200 = arg0_200.cells[iter0_200]

			if var4_200 and var4_200.flag == ChapterConst.CellFlagDisabled then
				var1_200 = var1_200 + 1
			end
		end
	end

	return var2_200, var1_200
end

function var0_0.GetWeather(arg0_201, arg1_201, arg2_201)
	arg1_201 = arg1_201 or arg0_201.fleet.line.row
	arg2_201 = arg2_201 or arg0_201.fleet.line.column

	local var0_201 = ChapterCell.Line2Name(arg1_201, arg2_201)
	local var1_201 = arg0_201.cells[var0_201]

	return var1_201 and var1_201:GetWeatherFlagList() or {}
end

function var0_0.getDisplayEnemyCount(arg0_202)
	local var0_202 = 0

	local function var1_202(arg0_203)
		if arg0_203.flag ~= ChapterConst.CellFlagDisabled then
			var0_202 = var0_202 + 1
		end
	end

	local var2_202 = {
		[ChapterConst.AttachEnemy] = var1_202,
		[ChapterConst.AttachElite] = var1_202,
		[ChapterConst.AttachBox] = function(arg0_204)
			if pg.box_data_template[arg0_204.attachmentId].type == ChapterConst.BoxEnemy then
				var1_202(arg0_204)
			end
		end
	}

	for iter0_202, iter1_202 in pairs(arg0_202.cells) do
		switch(iter1_202.attachment, var2_202, nil, iter1_202)
	end

	for iter2_202, iter3_202 in ipairs(arg0_202.champions) do
		var1_202(iter3_202)
	end

	return var0_202
end

function var0_0.getNearestEnemyCell(arg0_205)
	local function var0_205(arg0_206, arg1_206)
		return (arg0_206.row - arg1_206.row) * (arg0_206.row - arg1_206.row) + (arg0_206.column - arg1_206.column) * (arg0_206.column - arg1_206.column)
	end

	local var1_205

	local function var2_205(arg0_207)
		if arg0_207.flag ~= ChapterConst.CellFlagDisabled and (not var1_205 or var0_205(arg0_205.fleet.line, arg0_207) < var0_205(arg0_205.fleet.line, var1_205)) then
			var1_205 = arg0_207
		end
	end

	local var3_205 = {
		[ChapterConst.AttachEnemy] = var2_205,
		[ChapterConst.AttachElite] = var2_205,
		[ChapterConst.AttachBox] = function(arg0_208)
			if pg.box_data_template[arg0_208.attachmentId].type == ChapterConst.BoxEnemy then
				var2_205(arg0_208)
			end
		end
	}

	for iter0_205, iter1_205 in pairs(arg0_205.cells) do
		switch(iter1_205.attachment, var3_205, nil, iter1_205)
	end

	for iter2_205, iter3_205 in ipairs(arg0_205.champions) do
		var2_205(iter3_205)
	end

	return var1_205
end

function var0_0.GetRegularFleetIds(arg0_209)
	return (_.map(_.filter(arg0_209.fleets, function(arg0_210)
		local var0_210 = arg0_210:getFleetType()

		return var0_210 == FleetType.Normal or var0_210 == FleetType.Submarine
	end), function(arg0_211)
		return arg0_211.fleetId
	end))
end

return var0_0
