local var0_0 = class("ChapterOpRoutine", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	return
end

function var0_0.initData(arg0_2, arg1_2, arg2_2, arg3_2)
	arg0_2.op = arg1_2
	arg0_2.data = arg2_2
	arg0_2.chapter = arg3_2
	arg0_2.items = {}
	arg0_2.fullpath = nil
	arg0_2.flag = 0
	arg0_2.extraFlag = 0
end

function var0_0.doDropUpdate(arg0_3)
	arg0_3.items = PlayerConst.addTranDrop(arg0_3.data.drop_list)

	table.insertto(arg0_3.items, underscore.map(PlayerConst.addTranDrop(arg0_3.data.extra_drop_list), function(arg0_4)
		arg0_4.riraty = true

		return arg0_4
	end))
end

function var0_0.doMapUpdate(arg0_5)
	local var0_5 = arg0_5.data
	local var1_5 = arg0_5.flag
	local var2_5 = arg0_5.extraFlag
	local var3_5 = arg0_5.chapter

	if #var0_5.map_update > 0 then
		_.each(var0_5.map_update, function(arg0_6)
			if arg0_6.item_type == ChapterConst.AttachStory and arg0_6.item_data == ChapterConst.StoryTrigger then
				local var0_6 = ChapterCell.Line2Name(arg0_6.pos.row, arg0_6.pos.column)
				local var1_6 = var3_5:GetChapterCellAttachemnts()
				local var2_6 = var1_6[var0_6]

				if var2_6 then
					if var2_6.flag == ChapterConst.CellFlagTriggerActive and arg0_6.item_flag == ChapterConst.CellFlagTriggerDisabled then
						local var3_6 = pg.map_event_template[var2_6.attachmentId].gametip

						if var3_6 ~= "" then
							pg.TipsMgr.GetInstance():ShowTips(i18n(var3_6))
						end
					end

					var2_6.attachment = arg0_6.item_type
					var2_6.attachmentId = arg0_6.item_id
					var2_6.flag = arg0_6.item_flag
					var2_6.data = arg0_6.item_data
				else
					var1_6[var0_6] = ChapterCell.New(arg0_6)
				end
			elseif arg0_6.item_type ~= ChapterConst.AttachNone and arg0_6.item_type ~= ChapterConst.AttachBorn and arg0_6.item_type ~= ChapterConst.AttachBorn_Sub then
				local var4_6 = ChapterCell.New(arg0_6)

				var3_5:mergeChapterCell(var4_6)
			end
		end)

		var1_5 = bit.bor(var1_5, ChapterConst.DirtyAttachment)
		var2_5 = bit.bor(var2_5, ChapterConst.DirtyAutoAction)
	end

	arg0_5.flag = var1_5
	arg0_5.extraFlag = var2_5
end

function var0_0.doCellFlagUpdate(arg0_7)
	local var0_7 = arg0_7.data
	local var1_7 = arg0_7.flag
	local var2_7 = arg0_7.chapter

	if #var0_7.cell_flag_list > 0 then
		_.each(var0_7.cell_flag_list, function(arg0_8)
			local var0_8 = var2_7:getChapterCell(arg0_8.pos.row, arg0_8.pos.column)

			if var0_8 then
				var0_8:updateFlagList(arg0_8)
			else
				var0_8 = ChapterCell.New(arg0_8)
			end

			arg0_7.chapter:updateChapterCell(var0_8)
		end)

		var1_7 = bit.bor(var1_7, ChapterConst.DirtyCellFlag)
	end

	arg0_7.flag = var1_7
end

function var0_0.doAIUpdate(arg0_9)
	local var0_9 = arg0_9.data
	local var1_9 = arg0_9.flag
	local var2_9 = arg0_9.extraFlag
	local var3_9 = arg0_9.chapter

	if #var0_9.ai_list > 0 then
		_.each(var0_9.ai_list, function(arg0_10)
			local var0_10 = ChapterChampionPackage.New(arg0_10)

			var3_9:mergeChampion(var0_10)
		end)

		var1_9 = bit.bor(var1_9, ChapterConst.DirtyChampion)
		var2_9 = bit.bor(var2_9, ChapterConst.DirtyAutoAction)
	end

	arg0_9.flag = var1_9
	arg0_9.extraFlag = var2_9
end

function var0_0.doShipUpdate(arg0_11)
	local var0_11 = arg0_11.data
	local var1_11 = arg0_11.flag
	local var2_11 = arg0_11.chapter

	if #var0_11.ship_update > 0 then
		_.each(var0_11.ship_update, function(arg0_12)
			var2_11:updateFleetShipHp(arg0_12.id, arg0_12.hp_rant)

			var1_11 = bit.bor(var1_11, ChapterConst.DirtyStrategy)
		end)

		var1_11 = bit.bor(var1_11, ChapterConst.DirtyFleet)
	end

	arg0_11.flag = var1_11
end

function var0_0.doBuffUpdate(arg0_13)
	local var0_13 = arg0_13.data

	arg0_13.chapter:UpdateBuffList(var0_13.buff_list)
end

function var0_0.doExtraFlagUpdate(arg0_14)
	local var0_14 = arg0_14.data
	local var1_14 = arg0_14.chapter
	local var2_14 = getProxy(ChapterProxy)

	if #var0_14.add_flag_list > 0 or #var0_14.del_flag_list > 0 then
		var2_14:updateExtraFlag(var1_14, var0_14.add_flag_list, var0_14.del_flag_list)

		arg0_14.flag = bit.bor(arg0_14.flag, ChapterConst.DirtyFleet, ChapterConst.DirtyStrategy, ChapterConst.DirtyCellFlag, ChapterConst.DirtyFloatItems, ChapterConst.DirtyAttachment)
	end
end

function var0_0.doRetreat(arg0_15)
	local var0_15 = arg0_15.op
	local var1_15 = arg0_15.flag
	local var2_15 = arg0_15.chapter

	if var0_15.id then
		if #var2_15.fleets > 0 then
			local var3_15 = var2_15.fleets[var0_15.id]

			var2_15.fleets = _.filter(var2_15.fleets, function(arg0_16)
				return arg0_16.id ~= var0_15.id
			end)

			if var3_15 and var3_15:getFleetType() == FleetType.Normal then
				var2_15.findex = 1
			end

			var1_15 = bit.bor(var1_15, ChapterConst.DirtyFleet, ChapterConst.DirtyAttachment, ChapterConst.DirtyChampion, ChapterConst.DirtyStrategy)
		end
	else
		var2_15:retreat(var0_15.win)
	end

	arg0_15.flag = var1_15
end

function var0_0.doMove(arg0_17)
	local var0_17 = arg0_17.extraFlag
	local var1_17 = arg0_17.data
	local var2_17 = arg0_17.chapter
	local var3_17

	if #var1_17.move_path > 0 then
		var3_17 = _.map(_.rest(var1_17.move_path, 1), function(arg0_18)
			return {
				row = arg0_18.row,
				column = arg0_18.column
			}
		end)
		var2_17.moveStep = var2_17.moveStep + #var1_17.move_path
		var0_17 = bit.bor(var0_17, ChapterConst.DirtyAutoAction)
	end

	arg0_17.fullpath = var3_17

	var2_17:IncreaseRound()

	arg0_17.extraFlag = var0_17
end

function var0_0.doOpenBox(arg0_19)
	local var0_19 = arg0_19.items
	local var1_19 = arg0_19.flag
	local var2_19 = arg0_19.chapter
	local var3_19 = var2_19.fleet
	local var4_19 = var3_19.line
	local var5_19 = var2_19:getChapterCell(var4_19.row, var4_19.column)

	var5_19.flag = ChapterConst.CellFlagDisabled

	local var6_19 = bit.bor(var1_19, ChapterConst.DirtyAttachment)
	local var7_19 = pg.box_data_template[var5_19.attachmentId]

	assert(var7_19, "box_data_template not exist: " .. var5_19.attachmentId)

	if var7_19.type == ChapterConst.BoxStrategy then
		local var8_19 = var7_19.effect_id
		local var9_19 = var7_19.effect_arg

		var3_19:achievedStrategy(var8_19, var9_19)
		table.insert(var0_19, Drop.New({
			type = DROP_TYPE_STRATEGY,
			id = var8_19,
			count = var9_19
		}))

		var6_19 = bit.bor(var6_19, ChapterConst.DirtyStrategy)
	elseif var7_19.type == ChapterConst.BoxSupply then
		local var10_19, var11_19 = var2_19:getFleetAmmo(var3_19)

		var3_19.restAmmo = var3_19.restAmmo + math.min(var10_19 - var11_19, var7_19.effect_id)
		var6_19 = bit.bor(var6_19, ChapterConst.DirtyFleet)

		pg.TipsMgr.GetInstance():ShowTips(i18n("level_ammo_supply_p1", var7_19.effect_id))
	end

	var2_19:clearChapterCell(var4_19.row, var4_19.column)

	arg0_19.flag = var6_19
	arg0_19.extraFlag = bit.bor(arg0_19.extraFlag, ChapterConst.DirtyAutoAction)
end

function var0_0.doPlayStory(arg0_20)
	local var0_20 = arg0_20.flag
	local var1_20 = arg0_20.chapter
	local var2_20 = var1_20.fleet.line
	local var3_20 = var1_20:getChapterCell(var2_20.row, var2_20.column)

	var3_20.flag = ChapterConst.CellFlagDisabled

	var1_20:updateChapterCell(var3_20)

	arg0_20.flag = bit.bor(var0_20, ChapterConst.DirtyAttachment)
end

function var0_0.doAmbush(arg0_21)
	local var0_21 = arg0_21.op
	local var1_21 = arg0_21.chapter
	local var2_21 = var1_21.fleet

	if var0_21.arg1 == 1 then
		local var3_21 = var2_21.line
		local var4_21 = var1_21:getChapterCell(var3_21.row, var3_21.column)

		if var4_21.flag == ChapterConst.CellFlagAmbush then
			var1_21:clearChapterCell(var3_21.row, var3_21.column)
		end

		pg.TipsMgr.GetInstance():ShowTips(var4_21.flag == ChapterConst.CellFlagActive and i18n("chapter_tip_aovid_failed") or i18n("chapter_tip_aovid_succeed"))
	end
end

function var0_0.doStrategy(arg0_22)
	local var0_22 = arg0_22.flag
	local var1_22 = arg0_22.op
	local var2_22 = arg0_22.chapter
	local var3_22 = pg.strategy_data_template[var1_22.arg1]

	if var3_22.type == ChapterConst.StgTypeForm then
		local var4_22 = var2_22.fleet

		for iter0_22, iter1_22 in ipairs(var4_22.stgIds) do
			if pg.strategy_data_template[iter1_22].type == ChapterConst.StgTypeForm then
				var4_22.stgIds[iter0_22] = var3_22.id
			end
		end

		PlayerPrefs.SetInt("team_formation_" .. var4_22.id, var3_22.id)
		pg.TipsMgr.GetInstance():ShowTips(i18n("chapter_tip_change", var3_22.name))
	elseif var3_22.type == ChapterConst.StgTypeConsume then
		var2_22.fleet:consumeOneStrategy(var3_22.id)

		if var3_22.id == ChapterConst.StrategyRepair or var3_22.id == ChapterConst.StrategyExchange then
			pg.TipsMgr.GetInstance():ShowTips(i18n("chapter_tip_use", var3_22.name))
		end

		if var3_22.id == ChapterConst.StrategyExchange then
			local var5_22 = var2_22:getFleetById(var1_22.id)
			local var6_22 = var2_22:getFleetById(var1_22.arg2)

			var5_22.line, var6_22.line = var6_22.line, var5_22.line
			var0_22 = bit.bor(var0_22, ChapterConst.DirtyFleet)
		end
	elseif var3_22.type == ChapterConst.StgTypeBindSupportConsume then
		var2_22:getChapterSupportFleet():consumeOneStrategy(var3_22.id)
	end

	arg0_22.flag = bit.bor(var0_22, ChapterConst.DirtyStrategy)
end

function var0_0.doRepair(arg0_23)
	local var0_23 = getProxy(ChapterProxy)

	var0_23.repairTimes = var0_23.repairTimes + 1

	local var1_23, var2_23, var3_23 = ChapterConst.GetRepairParams()

	if var1_23 < var0_23.repairTimes then
		local var4_23 = getProxy(PlayerProxy)
		local var5_23 = var4_23:getData()

		var5_23:consume({
			gem = var3_23
		})
		var4_23:updatePlayer(var5_23)
	end
end

function var0_0.doSupply(arg0_24)
	local var0_24 = arg0_24.flag
	local var1_24 = arg0_24.chapter
	local var2_24 = var1_24.fleet
	local var3_24, var4_24 = var1_24:getFleetAmmo(var2_24)
	local var5_24 = var2_24.line
	local var6_24 = var1_24:getChapterCell(var5_24.row, var5_24.column)
	local var7_24 = math.min(var6_24.attachmentId, var3_24 - var4_24)

	var6_24.attachmentId = var6_24.attachmentId - var7_24
	var2_24.restAmmo = var2_24.restAmmo + var7_24

	var1_24:updateChapterCell(var6_24)

	if var6_24.attachmentId > 20 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("level_ammo_supply_p1", var7_24))
	elseif var6_24.attachmentId > 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("level_ammo_supply", var7_24, var6_24.attachmentId))
	else
		pg.TipsMgr.GetInstance():ShowTips(i18n("level_ammo_empty", var7_24))
	end

	arg0_24.flag = bit.bor(var0_24, ChapterConst.DirtyAttachment, ChapterConst.DirtyFleet)
end

function var0_0.doSubState(arg0_25)
	local var0_25 = arg0_25.flag
	local var1_25 = arg0_25.op

	arg0_25.chapter.subAutoAttack = var1_25.arg1
	arg0_25.flag = bit.bor(var0_25, ChapterConst.DirtyStrategy)
end

function var0_0.doCollectAI(arg0_26)
	local var0_26 = arg0_26.data

	arg0_26.aiActs = arg0_26.aiActs or {}

	if var0_26.submarine_act_list then
		_.each(var0_26.submarine_act_list, function(arg0_27)
			table.insert(arg0_26.aiActs, SubAIAction.New(arg0_27))
		end)
	end

	if var0_26.escort_act_list then
		_.each(var0_26.escort_act_list, function(arg0_28)
			table.insert(arg0_26.aiActs, TransportAIAction.New(arg0_28))
		end)
	end

	_.each(var0_26.ai_act_list, function(arg0_29)
		local var0_29

		if arg0_29.act_type == ChapterConst.ActType_TargetDown then
			if arg0_26.op.type == ChapterConst.OpStrategy then
				if arg0_26.op.arg1 == ChapterConst.StrategyMissileStrike then
					var0_29 = ChapterMissileExplodeAction.New(arg0_29)
				elseif arg0_26.op.arg1 == ChapterConst.StrategyAirSupport then
					var0_29 = ChapterAirSupportAIAction.New(arg0_29)
				end

				var0_29:SetTargetLine({
					row = arg0_26.op.arg2,
					column = arg0_26.op.arg3
				})
			else
				var0_29 = ChapterMissileExplodeAction.New(arg0_29)
			end
		elseif arg0_29.act_type == ChapterConst.ActType_Expel then
			var0_29 = ChapterExpelAIAction.New(arg0_29)

			var0_29:SetTargetLine({
				row = arg0_26.op.arg2,
				column = arg0_26.op.arg3
			}, {
				row = arg0_26.op.arg4,
				column = arg0_26.op.arg5
			})
		else
			var0_29 = ChapterAIAction.New(arg0_29)
		end

		table.insert(arg0_26.aiActs, var0_29)
	end)
	_.each(var0_26.fleet_act_list, function(arg0_30)
		table.insert(arg0_26.aiActs, FleetAIAction.New(arg0_30))
	end)
end

function var0_0.doBarrier(arg0_31)
	local var0_31 = arg0_31.flag
	local var1_31 = arg0_31.op
	local var2_31 = arg0_31.chapter
	local var3_31 = var2_31:getChapterCell(var1_31.arg1, var1_31.arg2)

	assert(var3_31, "cell not exist: " .. var1_31.arg1 .. ", " .. var1_31.arg2)

	local var4_31 = ChapterConst.AttachBox
	local var5_31 = _.detect(pg.box_data_template.all, function(arg0_32)
		return pg.box_data_template[arg0_32].type == ChapterConst.BoxBarrier
	end)

	if var3_31.attachment ~= var4_31 or var3_31.attachmentId ~= var5_31 then
		var3_31.attachment = var4_31
		var3_31.attachmentId = var5_31
		var3_31.flag = ChapterConst.CellFlagDisabled
	end

	var2_31.modelCount = var2_31.modelCount + (var3_31.flag == ChapterConst.CellFlagDisabled and -1 or 1)
	var3_31.flag = 1 - var3_31.flag

	var2_31:updateChapterCell(var3_31)

	arg0_31.flag = bit.bor(var0_31, ChapterConst.DirtyAttachment, ChapterConst.DirtyStrategy)
end

function var0_0.doRequest(arg0_33)
	local var0_33 = arg0_33.data
	local var1_33 = -1
	local var2_33 = arg0_33.chapter.fleet

	if #var0_33.move_path > 0 then
		local var3_33 = var0_33.move_path[#var0_33.move_path]

		var2_33.line = {
			row = var3_33.row,
			column = var3_33.column
		}
	end

	arg0_33.flag = var1_33
end

function var0_0.doSkipBattle(arg0_34)
	local var0_34 = arg0_34.flag

	arg0_34.flag = bit.bor(var0_34, ChapterConst.DirtyStrategy, ChapterConst.DirtyAttachment, ChapterConst.DirtyAchieve, ChapterConst.DirtyFleet, ChapterConst.DirtyChampion)
end

function var0_0.doTeleportSub(arg0_35)
	local var0_35 = arg0_35.op
	local var1_35 = arg0_35.chapter
	local var2_35 = _.detect(var1_35.fleets, function(arg0_36)
		return arg0_36.id == var0_35.id
	end).startPos

	arg0_35.fullpath = {
		var2_35,
		{
			row = var0_35.arg1,
			column = var0_35.arg2
		}
	}
end

function var0_0.doEnemyRound(arg0_37)
	local var0_37 = arg0_37.chapter
	local var1_37 = arg0_37.extraFlag

	var0_37:IncreaseRound()

	if var0_37:getPlayType() == ChapterConst.TypeDefence then
		arg0_37.flag = bit.bor(arg0_37.flag, ChapterConst.DirtyAttachment)
	end

	arg0_37.extraFlag = bit.bor(var1_37, ChapterConst.DirtyAutoAction)
end

function var0_0.doTeleportByPortal(arg0_38)
	local var0_38 = arg0_38.fullpath and arg0_38.fullpath[#arg0_38.fullpath]

	if not var0_38 then
		return
	end

	local var1_38 = arg0_38.chapter
	local var2_38

	if arg0_38.op.type == ChapterConst.OpMove then
		var2_38 = var1_38:GetCellEventByKey("jump", var0_38.row, var0_38.column)
	elseif arg0_38.op.type == ChapterConst.OpSubTeleport then
		var2_38 = var1_38:GetCellEventByKey("jumpsub", var0_38.row, var0_38.column)
	end

	if not var2_38 then
		return
	end

	local var3_38 = {
		row = var2_38[1],
		column = var2_38[2]
	}

	if arg0_38.op.type == ChapterConst.OpMove and var1_38:getFleet(FleetType.Normal, var3_38.row, var3_38.column) then
		return
	end

	arg0_38.teleportPaths = arg0_38.teleportPaths or {}

	table.insert(arg0_38.teleportPaths, {
		row = var0_38.row,
		column = var0_38.column
	})
	table.insert(arg0_38.teleportPaths, var3_38)
end

function var0_0.doCollectCommonAction(arg0_39)
	arg0_39.aiActs = arg0_39.aiActs or {}

	table.insert(arg0_39.aiActs, ChapterCommonAction.New(arg0_39))
end

function var0_0.AddBoxAction(arg0_40)
	local var0_40 = arg0_40.chapter
	local var1_40 = var0_40.fleet.line
	local var2_40 = var0_40:getChapterCell(var1_40.row, var1_40.column)
	local var3_40 = pg.box_data_template[var2_40.attachmentId]

	assert(var3_40, "box_data_template not exist: " .. var2_40.attachmentId)

	if var3_40.type == ChapterConst.BoxStrategy then
		local var4_40 = var3_40.effect_id
		local var5_40 = var3_40.effect_arg

		table.insert(arg0_40.items, Drop.New({
			type = DROP_TYPE_STRATEGY,
			id = var4_40,
			count = var5_40
		}))
	end

	arg0_40.aiActs = arg0_40.aiActs or {}

	table.insert(arg0_40.aiActs, ChapterBoxAction.New(arg0_40))
end

return var0_0
