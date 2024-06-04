local var0 = class("ChapterOpRoutine", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	return
end

function var0.initData(arg0, arg1, arg2, arg3)
	arg0.op = arg1
	arg0.data = arg2
	arg0.chapter = arg3
	arg0.items = {}
	arg0.fullpath = nil
	arg0.flag = 0
	arg0.extraFlag = 0
end

function var0.doDropUpdate(arg0)
	arg0.items = PlayerConst.addTranDrop(arg0.data.drop_list)
end

function var0.doMapUpdate(arg0)
	local var0 = arg0.data
	local var1 = arg0.flag
	local var2 = arg0.extraFlag
	local var3 = arg0.chapter

	if #var0.map_update > 0 then
		_.each(var0.map_update, function(arg0)
			if arg0.item_type == ChapterConst.AttachStory and arg0.item_data == ChapterConst.StoryTrigger then
				local var0 = ChapterCell.Line2Name(arg0.pos.row, arg0.pos.column)
				local var1 = var3:GetChapterCellAttachemnts()
				local var2 = var1[var0]

				if var2 then
					if var2.flag == ChapterConst.CellFlagTriggerActive and arg0.item_flag == ChapterConst.CellFlagTriggerDisabled then
						local var3 = pg.map_event_template[var2.attachmentId].gametip

						if var3 ~= "" then
							pg.TipsMgr.GetInstance():ShowTips(i18n(var3))
						end
					end

					var2.attachment = arg0.item_type
					var2.attachmentId = arg0.item_id
					var2.flag = arg0.item_flag
					var2.data = arg0.item_data
				else
					var1[var0] = ChapterCell.New(arg0)
				end
			elseif arg0.item_type ~= ChapterConst.AttachNone and arg0.item_type ~= ChapterConst.AttachBorn and arg0.item_type ~= ChapterConst.AttachBorn_Sub then
				local var4 = ChapterCell.New(arg0)

				var3:mergeChapterCell(var4)
			end
		end)

		var1 = bit.bor(var1, ChapterConst.DirtyAttachment)
		var2 = bit.bor(var2, ChapterConst.DirtyAutoAction)
	end

	arg0.flag = var1
	arg0.extraFlag = var2
end

function var0.doCellFlagUpdate(arg0)
	local var0 = arg0.data
	local var1 = arg0.flag
	local var2 = arg0.chapter

	if #var0.cell_flag_list > 0 then
		_.each(var0.cell_flag_list, function(arg0)
			local var0 = var2:getChapterCell(arg0.pos.row, arg0.pos.column)

			if var0 then
				var0:updateFlagList(arg0)
			else
				var0 = ChapterCell.New(arg0)
			end

			arg0.chapter:updateChapterCell(var0)
		end)

		var1 = bit.bor(var1, ChapterConst.DirtyCellFlag)
	end

	arg0.flag = var1
end

function var0.doAIUpdate(arg0)
	local var0 = arg0.data
	local var1 = arg0.flag
	local var2 = arg0.extraFlag
	local var3 = arg0.chapter

	if #var0.ai_list > 0 then
		_.each(var0.ai_list, function(arg0)
			local var0 = ChapterChampionPackage.New(arg0)

			var3:mergeChampion(var0)
		end)

		var1 = bit.bor(var1, ChapterConst.DirtyChampion)
		var2 = bit.bor(var2, ChapterConst.DirtyAutoAction)
	end

	arg0.flag = var1
	arg0.extraFlag = var2
end

function var0.doShipUpdate(arg0)
	local var0 = arg0.data
	local var1 = arg0.flag
	local var2 = arg0.chapter

	if #var0.ship_update > 0 then
		_.each(var0.ship_update, function(arg0)
			var2:updateFleetShipHp(arg0.id, arg0.hp_rant)

			var1 = bit.bor(var1, ChapterConst.DirtyStrategy)
		end)

		var1 = bit.bor(var1, ChapterConst.DirtyFleet)
	end

	arg0.flag = var1
end

function var0.doBuffUpdate(arg0)
	local var0 = arg0.data

	arg0.chapter:UpdateBuffList(var0.buff_list)
end

function var0.doExtraFlagUpdate(arg0)
	local var0 = arg0.data
	local var1 = arg0.chapter
	local var2 = getProxy(ChapterProxy)

	if #var0.add_flag_list > 0 or #var0.del_flag_list > 0 then
		var2:updateExtraFlag(var1, var0.add_flag_list, var0.del_flag_list)

		arg0.flag = bit.bor(arg0.flag, ChapterConst.DirtyFleet, ChapterConst.DirtyStrategy, ChapterConst.DirtyCellFlag, ChapterConst.DirtyFloatItems, ChapterConst.DirtyAttachment)
	end
end

function var0.doRetreat(arg0)
	local var0 = arg0.op
	local var1 = arg0.flag
	local var2 = arg0.chapter

	if var0.id then
		if #var2.fleets > 0 then
			local var3 = var2.fleets[var0.id]

			var2.fleets = _.filter(var2.fleets, function(arg0)
				return arg0.id ~= var0.id
			end)

			if var3 and var3:getFleetType() == FleetType.Normal then
				var2.findex = 1
			end

			var1 = bit.bor(var1, ChapterConst.DirtyFleet, ChapterConst.DirtyAttachment, ChapterConst.DirtyChampion, ChapterConst.DirtyStrategy)
		end
	else
		var2:retreat(var0.win)
	end

	arg0.flag = var1
end

function var0.doMove(arg0)
	local var0 = arg0.extraFlag
	local var1 = arg0.data
	local var2 = arg0.chapter
	local var3

	if #var1.move_path > 0 then
		var3 = _.map(_.rest(var1.move_path, 1), function(arg0)
			return {
				row = arg0.row,
				column = arg0.column
			}
		end)
		var2.moveStep = var2.moveStep + #var1.move_path
		var0 = bit.bor(var0, ChapterConst.DirtyAutoAction)
	end

	arg0.fullpath = var3

	var2:IncreaseRound()

	arg0.extraFlag = var0
end

function var0.doOpenBox(arg0)
	local var0 = arg0.items
	local var1 = arg0.flag
	local var2 = arg0.chapter
	local var3 = var2.fleet
	local var4 = var3.line
	local var5 = var2:getChapterCell(var4.row, var4.column)

	var5.flag = ChapterConst.CellFlagDisabled

	local var6 = bit.bor(var1, ChapterConst.DirtyAttachment)
	local var7 = pg.box_data_template[var5.attachmentId]

	assert(var7, "box_data_template not exist: " .. var5.attachmentId)

	if var7.type == ChapterConst.BoxStrategy then
		local var8 = var7.effect_id
		local var9 = var7.effect_arg

		var3:achievedStrategy(var8, var9)
		table.insert(var0, Drop.New({
			type = DROP_TYPE_STRATEGY,
			id = var8,
			count = var9
		}))

		var6 = bit.bor(var6, ChapterConst.DirtyStrategy)
	elseif var7.type == ChapterConst.BoxSupply then
		local var10, var11 = var2:getFleetAmmo(var3)

		var3.restAmmo = var3.restAmmo + math.min(var10 - var11, var7.effect_id)
		var6 = bit.bor(var6, ChapterConst.DirtyFleet)

		pg.TipsMgr.GetInstance():ShowTips(i18n("level_ammo_supply_p1", var7.effect_id))
	end

	var2:clearChapterCell(var4.row, var4.column)

	arg0.flag = var6
	arg0.extraFlag = bit.bor(arg0.extraFlag, ChapterConst.DirtyAutoAction)
end

function var0.doPlayStory(arg0)
	local var0 = arg0.flag
	local var1 = arg0.chapter
	local var2 = var1.fleet.line
	local var3 = var1:getChapterCell(var2.row, var2.column)

	var3.flag = ChapterConst.CellFlagDisabled

	var1:updateChapterCell(var3)

	arg0.flag = bit.bor(var0, ChapterConst.DirtyAttachment)
end

function var0.doAmbush(arg0)
	local var0 = arg0.op
	local var1 = arg0.chapter
	local var2 = var1.fleet

	if var0.arg1 == 1 then
		local var3 = var2.line
		local var4 = var1:getChapterCell(var3.row, var3.column)

		if var4.flag == ChapterConst.CellFlagAmbush then
			var1:clearChapterCell(var3.row, var3.column)
		end

		pg.TipsMgr.GetInstance():ShowTips(var4.flag == ChapterConst.CellFlagActive and i18n("chapter_tip_aovid_failed") or i18n("chapter_tip_aovid_succeed"))
	end
end

function var0.doStrategy(arg0)
	local var0 = arg0.flag
	local var1 = arg0.op
	local var2 = arg0.chapter
	local var3 = pg.strategy_data_template[var1.arg1]

	if var3.type == ChapterConst.StgTypeForm then
		local var4 = var2.fleet

		for iter0, iter1 in ipairs(var4.stgIds) do
			if pg.strategy_data_template[iter1].type == ChapterConst.StgTypeForm then
				var4.stgIds[iter0] = var3.id
			end
		end

		PlayerPrefs.SetInt("team_formation_" .. var4.id, var3.id)
		pg.TipsMgr.GetInstance():ShowTips(i18n("chapter_tip_change", var3.name))
	elseif var3.type == ChapterConst.StgTypeConsume then
		var2.fleet:consumeOneStrategy(var3.id)

		if var3.id == ChapterConst.StrategyRepair or var3.id == ChapterConst.StrategyExchange then
			pg.TipsMgr.GetInstance():ShowTips(i18n("chapter_tip_use", var3.name))
		end

		if var3.id == ChapterConst.StrategyExchange then
			local var5 = var2:getFleetById(var1.id)
			local var6 = var2:getFleetById(var1.arg2)

			var5.line, var6.line = var6.line, var5.line
			var0 = bit.bor(var0, ChapterConst.DirtyFleet)
		end
	elseif var3.type == ChapterConst.StgTypeBindSupportConsume then
		var2:getChapterSupportFleet():consumeOneStrategy(var3.id)
	end

	arg0.flag = bit.bor(var0, ChapterConst.DirtyStrategy)
end

function var0.doRepair(arg0)
	local var0 = getProxy(ChapterProxy)

	var0.repairTimes = var0.repairTimes + 1

	local var1, var2, var3 = ChapterConst.GetRepairParams()

	if var1 < var0.repairTimes then
		local var4 = getProxy(PlayerProxy)
		local var5 = var4:getData()

		var5:consume({
			gem = var3
		})
		var4:updatePlayer(var5)
	end
end

function var0.doSupply(arg0)
	local var0 = arg0.flag
	local var1 = arg0.chapter
	local var2 = var1.fleet
	local var3, var4 = var1:getFleetAmmo(var2)
	local var5 = var2.line
	local var6 = var1:getChapterCell(var5.row, var5.column)
	local var7 = math.min(var6.attachmentId, var3 - var4)

	var6.attachmentId = var6.attachmentId - var7
	var2.restAmmo = var2.restAmmo + var7

	var1:updateChapterCell(var6)

	if var6.attachmentId > 20 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("level_ammo_supply_p1", var7))
	elseif var6.attachmentId > 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("level_ammo_supply", var7, var6.attachmentId))
	else
		pg.TipsMgr.GetInstance():ShowTips(i18n("level_ammo_empty", var7))
	end

	arg0.flag = bit.bor(var0, ChapterConst.DirtyAttachment, ChapterConst.DirtyFleet)
end

function var0.doSubState(arg0)
	local var0 = arg0.flag
	local var1 = arg0.op

	arg0.chapter.subAutoAttack = var1.arg1
	arg0.flag = bit.bor(var0, ChapterConst.DirtyStrategy)
end

function var0.doCollectAI(arg0)
	local var0 = arg0.data

	arg0.aiActs = arg0.aiActs or {}

	if var0.submarine_act_list then
		_.each(var0.submarine_act_list, function(arg0)
			table.insert(arg0.aiActs, SubAIAction.New(arg0))
		end)
	end

	if var0.escort_act_list then
		_.each(var0.escort_act_list, function(arg0)
			table.insert(arg0.aiActs, TransportAIAction.New(arg0))
		end)
	end

	_.each(var0.ai_act_list, function(arg0)
		local var0

		if arg0.act_type == ChapterConst.ActType_TargetDown then
			if arg0.op.type == ChapterConst.OpStrategy then
				if arg0.op.arg1 == ChapterConst.StrategyMissileStrike then
					var0 = ChapterMissileExplodeAction.New(arg0)
				elseif arg0.op.arg1 == ChapterConst.StrategyAirSupport then
					var0 = ChapterAirSupportAIAction.New(arg0)
				end

				var0:SetTargetLine({
					row = arg0.op.arg2,
					column = arg0.op.arg3
				})
			else
				var0 = ChapterMissileExplodeAction.New(arg0)
			end
		elseif arg0.act_type == ChapterConst.ActType_Expel then
			var0 = ChapterExpelAIAction.New(arg0)

			var0:SetTargetLine({
				row = arg0.op.arg2,
				column = arg0.op.arg3
			}, {
				row = arg0.op.arg4,
				column = arg0.op.arg5
			})
		else
			var0 = ChapterAIAction.New(arg0)
		end

		table.insert(arg0.aiActs, var0)
	end)
	_.each(var0.fleet_act_list, function(arg0)
		table.insert(arg0.aiActs, FleetAIAction.New(arg0))
	end)
end

function var0.doBarrier(arg0)
	local var0 = arg0.flag
	local var1 = arg0.op
	local var2 = arg0.chapter
	local var3 = var2:getChapterCell(var1.arg1, var1.arg2)

	assert(var3, "cell not exist: " .. var1.arg1 .. ", " .. var1.arg2)

	local var4 = ChapterConst.AttachBox
	local var5 = _.detect(pg.box_data_template.all, function(arg0)
		return pg.box_data_template[arg0].type == ChapterConst.BoxBarrier
	end)

	if var3.attachment ~= var4 or var3.attachmentId ~= var5 then
		var3.attachment = var4
		var3.attachmentId = var5
		var3.flag = ChapterConst.CellFlagDisabled
	end

	var2.modelCount = var2.modelCount + (var3.flag == ChapterConst.CellFlagDisabled and -1 or 1)
	var3.flag = 1 - var3.flag

	var2:updateChapterCell(var3)

	arg0.flag = bit.bor(var0, ChapterConst.DirtyAttachment, ChapterConst.DirtyStrategy)
end

function var0.doRequest(arg0)
	local var0 = arg0.data
	local var1 = -1
	local var2 = arg0.chapter.fleet

	if #var0.move_path > 0 then
		local var3 = var0.move_path[#var0.move_path]

		var2.line = {
			row = var3.row,
			column = var3.column
		}
	end

	arg0.flag = var1
end

function var0.doSkipBattle(arg0)
	local var0 = arg0.flag

	arg0.flag = bit.bor(var0, ChapterConst.DirtyStrategy, ChapterConst.DirtyAttachment, ChapterConst.DirtyAchieve, ChapterConst.DirtyFleet, ChapterConst.DirtyChampion)
end

function var0.doTeleportSub(arg0)
	local var0 = arg0.op
	local var1 = arg0.chapter
	local var2 = _.detect(var1.fleets, function(arg0)
		return arg0.id == var0.id
	end).startPos

	arg0.fullpath = {
		var2,
		{
			row = var0.arg1,
			column = var0.arg2
		}
	}
end

function var0.doEnemyRound(arg0)
	local var0 = arg0.chapter
	local var1 = arg0.extraFlag

	var0:IncreaseRound()

	if var0:getPlayType() == ChapterConst.TypeDefence then
		arg0.flag = bit.bor(arg0.flag, ChapterConst.DirtyAttachment)
	end

	arg0.extraFlag = bit.bor(var1, ChapterConst.DirtyAutoAction)
end

function var0.doTeleportByPortal(arg0)
	local var0 = arg0.fullpath and arg0.fullpath[#arg0.fullpath]

	if not var0 then
		return
	end

	local var1 = arg0.chapter
	local var2

	if arg0.op.type == ChapterConst.OpMove then
		var2 = var1:GetCellEventByKey("jump", var0.row, var0.column)
	elseif arg0.op.type == ChapterConst.OpSubTeleport then
		var2 = var1:GetCellEventByKey("jumpsub", var0.row, var0.column)
	end

	if not var2 then
		return
	end

	local var3 = {
		row = var2[1],
		column = var2[2]
	}

	if arg0.op.type == ChapterConst.OpMove and var1:getFleet(FleetType.Normal, var3.row, var3.column) then
		return
	end

	arg0.teleportPaths = arg0.teleportPaths or {}

	table.insert(arg0.teleportPaths, {
		row = var0.row,
		column = var0.column
	})
	table.insert(arg0.teleportPaths, var3)
end

function var0.doCollectCommonAction(arg0)
	arg0.aiActs = arg0.aiActs or {}

	table.insert(arg0.aiActs, ChapterCommonAction.New(arg0))
end

function var0.AddBoxAction(arg0)
	local var0 = arg0.chapter
	local var1 = var0.fleet.line
	local var2 = var0:getChapterCell(var1.row, var1.column)
	local var3 = pg.box_data_template[var2.attachmentId]

	assert(var3, "box_data_template not exist: " .. var2.attachmentId)

	if var3.type == ChapterConst.BoxStrategy then
		local var4 = var3.effect_id
		local var5 = var3.effect_arg

		table.insert(arg0.items, Drop.New({
			type = DROP_TYPE_STRATEGY,
			id = var4,
			count = var5
		}))
	end

	arg0.aiActs = arg0.aiActs or {}

	table.insert(arg0.aiActs, ChapterBoxAction.New(arg0))
end

return var0
