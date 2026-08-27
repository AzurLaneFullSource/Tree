local var0_0 = class("ChapterOpRoutine", pm.SimpleCommand)

function var0_0.initData(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1.op = arg1_1
	arg0_1.data = arg2_1
	arg0_1.chapter = arg3_1
	arg0_1.items = {}
	arg0_1.fullpath = nil
	arg0_1.flag = 0
	arg0_1.extraFlag = 0
end

function var0_0.doDropUpdate(arg0_2)
	arg0_2.items = PlayerConst.addTranDrop(arg0_2.data.drop_list)

	table.insertto(arg0_2.items, underscore.map(PlayerConst.addTranDrop(arg0_2.data.extra_drop_list), function(arg0_3)
		arg0_3.riraty = true

		return arg0_3
	end))
end

function var0_0.doMapUpdate(arg0_4)
	local var0_4 = arg0_4.data
	local var1_4 = arg0_4.flag
	local var2_4 = arg0_4.extraFlag
	local var3_4 = arg0_4.chapter

	if #var0_4.map_update > 0 then
		_.each(var0_4.map_update, function(arg0_5)
			if arg0_5.item_type == ChapterConst.AttachStory and arg0_5.item_data == ChapterConst.StoryTrigger then
				local var0_5 = ChapterCell.Line2Name(arg0_5.pos.row, arg0_5.pos.column)
				local var1_5 = var3_4:GetChapterCellAttachemnts()
				local var2_5 = var1_5[var0_5]

				if var2_5 then
					if var2_5.flag == ChapterConst.CellFlagTriggerActive and arg0_5.item_flag == ChapterConst.CellFlagTriggerDisabled then
						local var3_5 = pg.map_event_template[var2_5.attachmentId].gametip

						if var3_5 ~= "" then
							pg.TipsMgr.GetInstance():ShowTips(i18n(var3_5))
						end
					end

					var2_5.attachment = arg0_5.item_type
					var2_5.attachmentId = arg0_5.item_id
					var2_5.flag = arg0_5.item_flag
					var2_5.data = arg0_5.item_data
				else
					var1_5[var0_5] = ChapterCell.New(arg0_5)
				end
			elseif arg0_5.item_type ~= ChapterConst.AttachNone and arg0_5.item_type ~= ChapterConst.AttachBorn and arg0_5.item_type ~= ChapterConst.AttachBorn_Sub then
				local var4_5 = ChapterCell.New(arg0_5)

				var3_4:mergeChapterCell(var4_5)
			end
		end)

		var1_4 = bit.bor(var1_4, ChapterConst.DirtyAttachment)
		var2_4 = bit.bor(var2_4, ChapterConst.DirtyAutoAction)
	end

	arg0_4.flag = var1_4
	arg0_4.extraFlag = var2_4
end

function var0_0.doCellFlagUpdate(arg0_6)
	local var0_6 = arg0_6.data
	local var1_6 = arg0_6.flag
	local var2_6 = arg0_6.chapter

	if #var0_6.cell_flag_list > 0 then
		_.each(var0_6.cell_flag_list, function(arg0_7)
			local var0_7 = var2_6:getChapterCell(arg0_7.pos.row, arg0_7.pos.column)

			if var0_7 then
				var0_7:updateFlagList(arg0_7)
			else
				var0_7 = ChapterCell.New(arg0_7)
			end

			arg0_6.chapter:updateChapterCell(var0_7)
		end)

		var1_6 = bit.bor(var1_6, ChapterConst.DirtyCellFlag)
	end

	arg0_6.flag = var1_6
end

function var0_0.doAIUpdate(arg0_8)
	local var0_8 = arg0_8.data
	local var1_8 = arg0_8.flag
	local var2_8 = arg0_8.extraFlag
	local var3_8 = arg0_8.chapter

	if #var0_8.ai_list > 0 then
		_.each(var0_8.ai_list, function(arg0_9)
			local var0_9 = ChapterChampionPackage.New(arg0_9)

			var3_8:mergeChampion(var0_9)
		end)

		var1_8 = bit.bor(var1_8, ChapterConst.DirtyChampion)
		var2_8 = bit.bor(var2_8, ChapterConst.DirtyAutoAction)
	end

	arg0_8.flag = var1_8
	arg0_8.extraFlag = var2_8
end

function var0_0.doShipUpdate(arg0_10)
	local var0_10 = arg0_10.data
	local var1_10 = arg0_10.flag
	local var2_10 = arg0_10.chapter

	if #var0_10.ship_update > 0 then
		_.each(var0_10.ship_update, function(arg0_11)
			var2_10:updateFleetShipHp(arg0_11.id, arg0_11.hp_rant)

			var1_10 = bit.bor(var1_10, ChapterConst.DirtyStrategy)
		end)

		var1_10 = bit.bor(var1_10, ChapterConst.DirtyFleet)
	end

	arg0_10.flag = var1_10
end

function var0_0.doBuffUpdate(arg0_12)
	local var0_12 = arg0_12.data

	arg0_12.chapter:UpdateBuffList(var0_12.buff_list)
end

function var0_0.doExtraFlagUpdate(arg0_13)
	local var0_13 = arg0_13.data
	local var1_13 = arg0_13.chapter
	local var2_13 = getProxy(ChapterProxy)

	if #var0_13.add_flag_list > 0 or #var0_13.del_flag_list > 0 then
		var2_13:updateExtraFlag(var1_13, var0_13.add_flag_list, var0_13.del_flag_list)

		arg0_13.flag = bit.bor(arg0_13.flag, ChapterConst.DirtyFleet, ChapterConst.DirtyStrategy, ChapterConst.DirtyCellFlag, ChapterConst.DirtyFloatItems, ChapterConst.DirtyAttachment)
	end
end

function var0_0.doRetreat(arg0_14, arg1_14)
	local var0_14 = arg0_14.op
	local var1_14 = arg0_14.flag
	local var2_14 = arg0_14.chapter

	if var0_14.id then
		if #var2_14.fleets > 0 then
			var2_14:retreatFleet(var0_14.id)

			var1_14 = bit.bor(var1_14, ChapterConst.DirtyFleet, ChapterConst.DirtyAttachment, ChapterConst.DirtyChampion, ChapterConst.DirtyStrategy)
		end
	else
		var2_14:retreat(var0_14.win, var0_14.arg1, arg1_14)
	end

	arg0_14.flag = var1_14
end

function var0_0.doMove(arg0_15)
	local var0_15 = arg0_15.extraFlag
	local var1_15 = arg0_15.data
	local var2_15 = arg0_15.chapter
	local var3_15

	if #var1_15.move_path > 0 then
		var3_15 = _.map(_.rest(var1_15.move_path, 1), function(arg0_16)
			return {
				row = arg0_16.row,
				column = arg0_16.column
			}
		end)
		var2_15.moveStep = var2_15.moveStep + #var1_15.move_path
		var0_15 = bit.bor(var0_15, ChapterConst.DirtyAutoAction, ChapterConst.DirtyWeather)
	end

	arg0_15.fullpath = var3_15

	var2_15:IncreaseRound()

	arg0_15.extraFlag = var0_15
end

function var0_0.doOpenBox(arg0_17)
	local var0_17 = arg0_17.items
	local var1_17 = arg0_17.flag
	local var2_17 = arg0_17.chapter
	local var3_17 = var2_17.fleet
	local var4_17 = var3_17.line
	local var5_17 = var2_17:getChapterCell(var4_17.row, var4_17.column)

	var5_17.flag = ChapterConst.CellFlagDisabled

	local var6_17 = bit.bor(var1_17, ChapterConst.DirtyAttachment)
	local var7_17 = pg.box_data_template[var5_17.attachmentId]

	assert(var7_17, "box_data_template not exist: " .. var5_17.attachmentId)

	if var7_17.type == ChapterConst.BoxStrategy then
		local var8_17 = var7_17.effect_id
		local var9_17 = var7_17.effect_arg

		var3_17:achievedStrategy(var8_17, var9_17)
		table.insert(var0_17, Drop.New({
			type = DROP_TYPE_STRATEGY,
			id = var8_17,
			count = var9_17
		}))

		var6_17 = bit.bor(var6_17, ChapterConst.DirtyStrategy)
	elseif var7_17.type == ChapterConst.BoxSupply then
		local var10_17, var11_17 = var2_17:getFleetAmmo(var3_17)

		var3_17.restAmmo = var3_17.restAmmo + math.min(var10_17 - var11_17, var7_17.effect_id)
		var6_17 = bit.bor(var6_17, ChapterConst.DirtyFleet)

		pg.TipsMgr.GetInstance():ShowTips(i18n("level_ammo_supply_p1", var7_17.effect_id))
	end

	var2_17:clearChapterCell(var4_17.row, var4_17.column)

	arg0_17.flag = var6_17
	arg0_17.extraFlag = bit.bor(arg0_17.extraFlag, ChapterConst.DirtyAutoAction)
end

function var0_0.doPlayStory(arg0_18)
	local var0_18 = arg0_18.flag
	local var1_18 = arg0_18.chapter
	local var2_18 = var1_18.fleet.line
	local var3_18 = var1_18:getChapterCell(var2_18.row, var2_18.column)

	var3_18.flag = ChapterConst.CellFlagDisabled

	var1_18:updateChapterCell(var3_18)

	arg0_18.flag = bit.bor(var0_18, ChapterConst.DirtyAttachment)
end

function var0_0.doAmbush(arg0_19)
	local var0_19 = arg0_19.op
	local var1_19 = arg0_19.chapter
	local var2_19 = var1_19.fleet

	if var0_19.arg1 == 1 then
		local var3_19 = var2_19.line
		local var4_19 = var1_19:getChapterCell(var3_19.row, var3_19.column)

		if var4_19.flag == ChapterConst.CellFlagAmbush then
			var1_19:clearChapterCell(var3_19.row, var3_19.column)
		end

		pg.TipsMgr.GetInstance():ShowTips(var4_19.flag == ChapterConst.CellFlagActive and i18n("chapter_tip_aovid_failed") or i18n("chapter_tip_aovid_succeed"))
	end
end

function var0_0.doStrategy(arg0_20)
	local var0_20 = arg0_20.flag
	local var1_20 = arg0_20.op
	local var2_20 = arg0_20.chapter
	local var3_20 = pg.strategy_data_template[var1_20.arg1]

	if var3_20.type == ChapterConst.StgTypeForm then
		local var4_20 = var2_20.fleet

		for iter0_20, iter1_20 in ipairs(var4_20.stgIds) do
			if pg.strategy_data_template[iter1_20].type == ChapterConst.StgTypeForm then
				var4_20.stgIds[iter0_20] = var3_20.id
			end
		end

		PlayerPrefs.SetInt("team_formation_" .. var4_20.id, var3_20.id)
		pg.TipsMgr.GetInstance():ShowTips(i18n("chapter_tip_change", var3_20.name))
	elseif var3_20.type == ChapterConst.StgTypeConsume then
		var2_20.fleet:consumeOneStrategy(var3_20.id)

		if var3_20.id == ChapterConst.StrategyRepair or var3_20.id == ChapterConst.StrategyExchange then
			pg.TipsMgr.GetInstance():ShowTips(i18n("chapter_tip_use", var3_20.name))
		end

		if var3_20.id == ChapterConst.StrategyExchange then
			local var5_20 = var2_20:getFleetById(var1_20.id)
			local var6_20 = var2_20:getFleetById(var1_20.arg2)

			var5_20.line, var6_20.line = var6_20.line, var5_20.line
			var0_20 = bit.bor(var0_20, ChapterConst.DirtyFleet)
		end
	elseif var3_20.type == ChapterConst.StgTypeBindSupportConsume then
		var2_20:getChapterSupportFleet():consumeOneStrategy(var3_20.id)
	end

	arg0_20.flag = bit.bor(var0_20, ChapterConst.DirtyStrategy)
end

function var0_0.doRepair(arg0_21)
	local var0_21 = getProxy(ChapterProxy)

	var0_21.repairTimes = var0_21.repairTimes + 1

	local var1_21, var2_21, var3_21 = ChapterConst.GetRepairParams()

	if var1_21 < var0_21.repairTimes then
		local var4_21 = getProxy(PlayerProxy)
		local var5_21 = var4_21:getData()

		var5_21:consume({
			gem = var3_21
		})
		var4_21:updatePlayer(var5_21)
	end
end

function var0_0.doSupply(arg0_22)
	local var0_22 = arg0_22.flag
	local var1_22 = arg0_22.chapter
	local var2_22 = var1_22.fleet
	local var3_22, var4_22 = var1_22:getFleetAmmo(var2_22)
	local var5_22 = var2_22.line
	local var6_22 = var1_22:getChapterCell(var5_22.row, var5_22.column)
	local var7_22 = math.min(var6_22.attachmentId, var3_22 - var4_22)

	var6_22.attachmentId = var6_22.attachmentId - var7_22
	var2_22.restAmmo = var2_22.restAmmo + var7_22

	var1_22:updateChapterCell(var6_22)

	if var6_22.attachmentId > 20 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("level_ammo_supply_p1", var7_22))
	elseif var6_22.attachmentId > 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("level_ammo_supply", var7_22, var6_22.attachmentId))
	else
		pg.TipsMgr.GetInstance():ShowTips(i18n("level_ammo_empty", var7_22))
	end

	arg0_22.flag = bit.bor(var0_22, ChapterConst.DirtyAttachment, ChapterConst.DirtyFleet)
end

function var0_0.doSubState(arg0_23)
	local var0_23 = arg0_23.flag
	local var1_23 = arg0_23.op

	arg0_23.chapter.subAutoAttack = var1_23.arg1
	arg0_23.flag = bit.bor(var0_23, ChapterConst.DirtyStrategy)
end

function var0_0.doCollectAI(arg0_24)
	local var0_24 = arg0_24.data

	arg0_24.aiActs = arg0_24.aiActs or {}

	if var0_24.submarine_act_list then
		_.each(var0_24.submarine_act_list, function(arg0_25)
			table.insert(arg0_24.aiActs, SubAIAction.New(arg0_25))
		end)
	end

	if var0_24.escort_act_list then
		_.each(var0_24.escort_act_list, function(arg0_26)
			table.insert(arg0_24.aiActs, TransportAIAction.New(arg0_26))
		end)
	end

	_.each(var0_24.ai_act_list, function(arg0_27)
		local var0_27

		if arg0_27.act_type == ChapterConst.ActType_TargetDown then
			if arg0_24.op.type == ChapterConst.OpStrategy then
				if arg0_24.op.arg1 == ChapterConst.StrategyMissileStrike then
					var0_27 = ChapterMissileExplodeAction.New(arg0_27)
				elseif arg0_24.op.arg1 == ChapterConst.StrategyAirSupport then
					var0_27 = ChapterAirSupportAIAction.New(arg0_27)
				end

				var0_27:SetTargetLine({
					row = arg0_24.op.arg2,
					column = arg0_24.op.arg3
				})
			else
				var0_27 = ChapterMissileExplodeAction.New(arg0_27)
			end
		elseif arg0_27.act_type == ChapterConst.ActType_Expel then
			var0_27 = ChapterExpelAIAction.New(arg0_27)

			var0_27:SetTargetLine({
				row = arg0_24.op.arg2,
				column = arg0_24.op.arg3
			}, {
				row = arg0_24.op.arg4,
				column = arg0_24.op.arg5
			})
		else
			var0_27 = ChapterAIAction.New(arg0_27)
		end

		table.insert(arg0_24.aiActs, var0_27)
	end)
	_.each(var0_24.fleet_act_list, function(arg0_28)
		table.insert(arg0_24.aiActs, FleetAIAction.New(arg0_28))
	end)
end

function var0_0.doBarrier(arg0_29)
	local var0_29 = arg0_29.flag
	local var1_29 = arg0_29.op
	local var2_29 = arg0_29.chapter
	local var3_29 = var2_29:getChapterCell(var1_29.arg1, var1_29.arg2)

	assert(var3_29, "cell not exist: " .. var1_29.arg1 .. ", " .. var1_29.arg2)

	local var4_29 = ChapterConst.AttachBox
	local var5_29 = _.detect(pg.box_data_template.all, function(arg0_30)
		return pg.box_data_template[arg0_30].type == ChapterConst.BoxBarrier
	end)

	if var3_29.attachment ~= var4_29 or var3_29.attachmentId ~= var5_29 then
		var3_29.attachment = var4_29
		var3_29.attachmentId = var5_29
		var3_29.flag = ChapterConst.CellFlagDisabled
	end

	var2_29.modelCount = var2_29.modelCount + (var3_29.flag == ChapterConst.CellFlagDisabled and -1 or 1)
	var3_29.flag = 1 - var3_29.flag

	var2_29:updateChapterCell(var3_29)

	arg0_29.flag = bit.bor(var0_29, ChapterConst.DirtyAttachment, ChapterConst.DirtyStrategy)
end

function var0_0.doRequest(arg0_31)
	local var0_31 = arg0_31.data
	local var1_31 = -1
	local var2_31 = arg0_31.chapter.fleet

	if #var0_31.move_path > 0 then
		local var3_31 = var0_31.move_path[#var0_31.move_path]

		var2_31.line = {
			row = var3_31.row,
			column = var3_31.column
		}
	end

	arg0_31.flag = var1_31
end

function var0_0.doSkipBattle(arg0_32)
	local var0_32 = arg0_32.flag

	arg0_32.flag = bit.bor(var0_32, ChapterConst.DirtyStrategy, ChapterConst.DirtyAttachment, ChapterConst.DirtyAchieve, ChapterConst.DirtyFleet, ChapterConst.DirtyChampion)
end

function var0_0.doTeleportSub(arg0_33)
	local var0_33 = arg0_33.op
	local var1_33 = arg0_33.chapter
	local var2_33 = _.detect(var1_33.fleets, function(arg0_34)
		return arg0_34.id == var0_33.id
	end).startPos

	arg0_33.fullpath = {
		var2_33,
		{
			row = var0_33.arg1,
			column = var0_33.arg2
		}
	}
end

function var0_0.doEnemyRound(arg0_35)
	local var0_35 = arg0_35.chapter
	local var1_35 = arg0_35.extraFlag

	var0_35:IncreaseRound()

	if var0_35:getPlayType() == ChapterConst.TypeDefence then
		arg0_35.flag = bit.bor(arg0_35.flag, ChapterConst.DirtyAttachment)
	end

	arg0_35.extraFlag = bit.bor(var1_35, ChapterConst.DirtyAutoAction)
end

function var0_0.doTeleportByPortal(arg0_36)
	local var0_36 = arg0_36.fullpath and arg0_36.fullpath[#arg0_36.fullpath]

	if not var0_36 then
		return
	end

	local var1_36 = arg0_36.chapter
	local var2_36

	if arg0_36.op.type == ChapterConst.OpMove then
		var2_36 = var1_36:GetCellEventByKey("jump", var0_36.row, var0_36.column)
	elseif arg0_36.op.type == ChapterConst.OpSubTeleport then
		var2_36 = var1_36:GetCellEventByKey("jumpsub", var0_36.row, var0_36.column)
	end

	if not var2_36 then
		return
	end

	local var3_36 = {
		row = var2_36[1],
		column = var2_36[2]
	}

	if arg0_36.op.type == ChapterConst.OpMove and var1_36:getFleet(FleetType.Normal, var3_36.row, var3_36.column) then
		return
	end

	arg0_36.teleportPaths = arg0_36.teleportPaths or {}

	table.insert(arg0_36.teleportPaths, {
		row = var0_36.row,
		column = var0_36.column
	})
	table.insert(arg0_36.teleportPaths, var3_36)
end

function var0_0.doCollectCommonAction(arg0_37)
	arg0_37.aiActs = arg0_37.aiActs or {}

	table.insert(arg0_37.aiActs, ChapterCommonAction.New(arg0_37))
end

function var0_0.AddBoxAction(arg0_38)
	local var0_38 = arg0_38.chapter
	local var1_38 = var0_38.fleet.line
	local var2_38 = var0_38:getChapterCell(var1_38.row, var1_38.column)
	local var3_38 = pg.box_data_template[var2_38.attachmentId]

	assert(var3_38, "box_data_template not exist: " .. var2_38.attachmentId)

	if var3_38.type == ChapterConst.BoxStrategy then
		local var4_38 = var3_38.effect_id
		local var5_38 = var3_38.effect_arg

		table.insert(arg0_38.items, Drop.New({
			type = DROP_TYPE_STRATEGY,
			id = var4_38,
			count = var5_38
		}))
	end

	arg0_38.aiActs = arg0_38.aiActs or {}

	table.insert(arg0_38.aiActs, ChapterBoxAction.New(arg0_38))
end

return var0_0
