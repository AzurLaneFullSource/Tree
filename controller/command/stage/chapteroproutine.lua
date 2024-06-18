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

function var0_0.doRetreat(arg0_14)
	local var0_14 = arg0_14.op
	local var1_14 = arg0_14.flag
	local var2_14 = arg0_14.chapter

	if var0_14.id then
		if #var2_14.fleets > 0 then
			local var3_14 = var2_14.fleets[var0_14.id]

			var2_14.fleets = _.filter(var2_14.fleets, function(arg0_15)
				return arg0_15.id ~= var0_14.id
			end)

			if var3_14 and var3_14:getFleetType() == FleetType.Normal then
				var2_14.findex = 1
			end

			var1_14 = bit.bor(var1_14, ChapterConst.DirtyFleet, ChapterConst.DirtyAttachment, ChapterConst.DirtyChampion, ChapterConst.DirtyStrategy)
		end
	else
		var2_14:retreat(var0_14.win)
	end

	arg0_14.flag = var1_14
end

function var0_0.doMove(arg0_16)
	local var0_16 = arg0_16.extraFlag
	local var1_16 = arg0_16.data
	local var2_16 = arg0_16.chapter
	local var3_16

	if #var1_16.move_path > 0 then
		var3_16 = _.map(_.rest(var1_16.move_path, 1), function(arg0_17)
			return {
				row = arg0_17.row,
				column = arg0_17.column
			}
		end)
		var2_16.moveStep = var2_16.moveStep + #var1_16.move_path
		var0_16 = bit.bor(var0_16, ChapterConst.DirtyAutoAction)
	end

	arg0_16.fullpath = var3_16

	var2_16:IncreaseRound()

	arg0_16.extraFlag = var0_16
end

function var0_0.doOpenBox(arg0_18)
	local var0_18 = arg0_18.items
	local var1_18 = arg0_18.flag
	local var2_18 = arg0_18.chapter
	local var3_18 = var2_18.fleet
	local var4_18 = var3_18.line
	local var5_18 = var2_18:getChapterCell(var4_18.row, var4_18.column)

	var5_18.flag = ChapterConst.CellFlagDisabled

	local var6_18 = bit.bor(var1_18, ChapterConst.DirtyAttachment)
	local var7_18 = pg.box_data_template[var5_18.attachmentId]

	assert(var7_18, "box_data_template not exist: " .. var5_18.attachmentId)

	if var7_18.type == ChapterConst.BoxStrategy then
		local var8_18 = var7_18.effect_id
		local var9_18 = var7_18.effect_arg

		var3_18:achievedStrategy(var8_18, var9_18)
		table.insert(var0_18, Drop.New({
			type = DROP_TYPE_STRATEGY,
			id = var8_18,
			count = var9_18
		}))

		var6_18 = bit.bor(var6_18, ChapterConst.DirtyStrategy)
	elseif var7_18.type == ChapterConst.BoxSupply then
		local var10_18, var11_18 = var2_18:getFleetAmmo(var3_18)

		var3_18.restAmmo = var3_18.restAmmo + math.min(var10_18 - var11_18, var7_18.effect_id)
		var6_18 = bit.bor(var6_18, ChapterConst.DirtyFleet)

		pg.TipsMgr.GetInstance():ShowTips(i18n("level_ammo_supply_p1", var7_18.effect_id))
	end

	var2_18:clearChapterCell(var4_18.row, var4_18.column)

	arg0_18.flag = var6_18
	arg0_18.extraFlag = bit.bor(arg0_18.extraFlag, ChapterConst.DirtyAutoAction)
end

function var0_0.doPlayStory(arg0_19)
	local var0_19 = arg0_19.flag
	local var1_19 = arg0_19.chapter
	local var2_19 = var1_19.fleet.line
	local var3_19 = var1_19:getChapterCell(var2_19.row, var2_19.column)

	var3_19.flag = ChapterConst.CellFlagDisabled

	var1_19:updateChapterCell(var3_19)

	arg0_19.flag = bit.bor(var0_19, ChapterConst.DirtyAttachment)
end

function var0_0.doAmbush(arg0_20)
	local var0_20 = arg0_20.op
	local var1_20 = arg0_20.chapter
	local var2_20 = var1_20.fleet

	if var0_20.arg1 == 1 then
		local var3_20 = var2_20.line
		local var4_20 = var1_20:getChapterCell(var3_20.row, var3_20.column)

		if var4_20.flag == ChapterConst.CellFlagAmbush then
			var1_20:clearChapterCell(var3_20.row, var3_20.column)
		end

		pg.TipsMgr.GetInstance():ShowTips(var4_20.flag == ChapterConst.CellFlagActive and i18n("chapter_tip_aovid_failed") or i18n("chapter_tip_aovid_succeed"))
	end
end

function var0_0.doStrategy(arg0_21)
	local var0_21 = arg0_21.flag
	local var1_21 = arg0_21.op
	local var2_21 = arg0_21.chapter
	local var3_21 = pg.strategy_data_template[var1_21.arg1]

	if var3_21.type == ChapterConst.StgTypeForm then
		local var4_21 = var2_21.fleet

		for iter0_21, iter1_21 in ipairs(var4_21.stgIds) do
			if pg.strategy_data_template[iter1_21].type == ChapterConst.StgTypeForm then
				var4_21.stgIds[iter0_21] = var3_21.id
			end
		end

		PlayerPrefs.SetInt("team_formation_" .. var4_21.id, var3_21.id)
		pg.TipsMgr.GetInstance():ShowTips(i18n("chapter_tip_change", var3_21.name))
	elseif var3_21.type == ChapterConst.StgTypeConsume then
		var2_21.fleet:consumeOneStrategy(var3_21.id)

		if var3_21.id == ChapterConst.StrategyRepair or var3_21.id == ChapterConst.StrategyExchange then
			pg.TipsMgr.GetInstance():ShowTips(i18n("chapter_tip_use", var3_21.name))
		end

		if var3_21.id == ChapterConst.StrategyExchange then
			local var5_21 = var2_21:getFleetById(var1_21.id)
			local var6_21 = var2_21:getFleetById(var1_21.arg2)

			var5_21.line, var6_21.line = var6_21.line, var5_21.line
			var0_21 = bit.bor(var0_21, ChapterConst.DirtyFleet)
		end
	elseif var3_21.type == ChapterConst.StgTypeBindSupportConsume then
		var2_21:getChapterSupportFleet():consumeOneStrategy(var3_21.id)
	end

	arg0_21.flag = bit.bor(var0_21, ChapterConst.DirtyStrategy)
end

function var0_0.doRepair(arg0_22)
	local var0_22 = getProxy(ChapterProxy)

	var0_22.repairTimes = var0_22.repairTimes + 1

	local var1_22, var2_22, var3_22 = ChapterConst.GetRepairParams()

	if var1_22 < var0_22.repairTimes then
		local var4_22 = getProxy(PlayerProxy)
		local var5_22 = var4_22:getData()

		var5_22:consume({
			gem = var3_22
		})
		var4_22:updatePlayer(var5_22)
	end
end

function var0_0.doSupply(arg0_23)
	local var0_23 = arg0_23.flag
	local var1_23 = arg0_23.chapter
	local var2_23 = var1_23.fleet
	local var3_23, var4_23 = var1_23:getFleetAmmo(var2_23)
	local var5_23 = var2_23.line
	local var6_23 = var1_23:getChapterCell(var5_23.row, var5_23.column)
	local var7_23 = math.min(var6_23.attachmentId, var3_23 - var4_23)

	var6_23.attachmentId = var6_23.attachmentId - var7_23
	var2_23.restAmmo = var2_23.restAmmo + var7_23

	var1_23:updateChapterCell(var6_23)

	if var6_23.attachmentId > 20 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("level_ammo_supply_p1", var7_23))
	elseif var6_23.attachmentId > 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("level_ammo_supply", var7_23, var6_23.attachmentId))
	else
		pg.TipsMgr.GetInstance():ShowTips(i18n("level_ammo_empty", var7_23))
	end

	arg0_23.flag = bit.bor(var0_23, ChapterConst.DirtyAttachment, ChapterConst.DirtyFleet)
end

function var0_0.doSubState(arg0_24)
	local var0_24 = arg0_24.flag
	local var1_24 = arg0_24.op

	arg0_24.chapter.subAutoAttack = var1_24.arg1
	arg0_24.flag = bit.bor(var0_24, ChapterConst.DirtyStrategy)
end

function var0_0.doCollectAI(arg0_25)
	local var0_25 = arg0_25.data

	arg0_25.aiActs = arg0_25.aiActs or {}

	if var0_25.submarine_act_list then
		_.each(var0_25.submarine_act_list, function(arg0_26)
			table.insert(arg0_25.aiActs, SubAIAction.New(arg0_26))
		end)
	end

	if var0_25.escort_act_list then
		_.each(var0_25.escort_act_list, function(arg0_27)
			table.insert(arg0_25.aiActs, TransportAIAction.New(arg0_27))
		end)
	end

	_.each(var0_25.ai_act_list, function(arg0_28)
		local var0_28

		if arg0_28.act_type == ChapterConst.ActType_TargetDown then
			if arg0_25.op.type == ChapterConst.OpStrategy then
				if arg0_25.op.arg1 == ChapterConst.StrategyMissileStrike then
					var0_28 = ChapterMissileExplodeAction.New(arg0_28)
				elseif arg0_25.op.arg1 == ChapterConst.StrategyAirSupport then
					var0_28 = ChapterAirSupportAIAction.New(arg0_28)
				end

				var0_28:SetTargetLine({
					row = arg0_25.op.arg2,
					column = arg0_25.op.arg3
				})
			else
				var0_28 = ChapterMissileExplodeAction.New(arg0_28)
			end
		elseif arg0_28.act_type == ChapterConst.ActType_Expel then
			var0_28 = ChapterExpelAIAction.New(arg0_28)

			var0_28:SetTargetLine({
				row = arg0_25.op.arg2,
				column = arg0_25.op.arg3
			}, {
				row = arg0_25.op.arg4,
				column = arg0_25.op.arg5
			})
		else
			var0_28 = ChapterAIAction.New(arg0_28)
		end

		table.insert(arg0_25.aiActs, var0_28)
	end)
	_.each(var0_25.fleet_act_list, function(arg0_29)
		table.insert(arg0_25.aiActs, FleetAIAction.New(arg0_29))
	end)
end

function var0_0.doBarrier(arg0_30)
	local var0_30 = arg0_30.flag
	local var1_30 = arg0_30.op
	local var2_30 = arg0_30.chapter
	local var3_30 = var2_30:getChapterCell(var1_30.arg1, var1_30.arg2)

	assert(var3_30, "cell not exist: " .. var1_30.arg1 .. ", " .. var1_30.arg2)

	local var4_30 = ChapterConst.AttachBox
	local var5_30 = _.detect(pg.box_data_template.all, function(arg0_31)
		return pg.box_data_template[arg0_31].type == ChapterConst.BoxBarrier
	end)

	if var3_30.attachment ~= var4_30 or var3_30.attachmentId ~= var5_30 then
		var3_30.attachment = var4_30
		var3_30.attachmentId = var5_30
		var3_30.flag = ChapterConst.CellFlagDisabled
	end

	var2_30.modelCount = var2_30.modelCount + (var3_30.flag == ChapterConst.CellFlagDisabled and -1 or 1)
	var3_30.flag = 1 - var3_30.flag

	var2_30:updateChapterCell(var3_30)

	arg0_30.flag = bit.bor(var0_30, ChapterConst.DirtyAttachment, ChapterConst.DirtyStrategy)
end

function var0_0.doRequest(arg0_32)
	local var0_32 = arg0_32.data
	local var1_32 = -1
	local var2_32 = arg0_32.chapter.fleet

	if #var0_32.move_path > 0 then
		local var3_32 = var0_32.move_path[#var0_32.move_path]

		var2_32.line = {
			row = var3_32.row,
			column = var3_32.column
		}
	end

	arg0_32.flag = var1_32
end

function var0_0.doSkipBattle(arg0_33)
	local var0_33 = arg0_33.flag

	arg0_33.flag = bit.bor(var0_33, ChapterConst.DirtyStrategy, ChapterConst.DirtyAttachment, ChapterConst.DirtyAchieve, ChapterConst.DirtyFleet, ChapterConst.DirtyChampion)
end

function var0_0.doTeleportSub(arg0_34)
	local var0_34 = arg0_34.op
	local var1_34 = arg0_34.chapter
	local var2_34 = _.detect(var1_34.fleets, function(arg0_35)
		return arg0_35.id == var0_34.id
	end).startPos

	arg0_34.fullpath = {
		var2_34,
		{
			row = var0_34.arg1,
			column = var0_34.arg2
		}
	}
end

function var0_0.doEnemyRound(arg0_36)
	local var0_36 = arg0_36.chapter
	local var1_36 = arg0_36.extraFlag

	var0_36:IncreaseRound()

	if var0_36:getPlayType() == ChapterConst.TypeDefence then
		arg0_36.flag = bit.bor(arg0_36.flag, ChapterConst.DirtyAttachment)
	end

	arg0_36.extraFlag = bit.bor(var1_36, ChapterConst.DirtyAutoAction)
end

function var0_0.doTeleportByPortal(arg0_37)
	local var0_37 = arg0_37.fullpath and arg0_37.fullpath[#arg0_37.fullpath]

	if not var0_37 then
		return
	end

	local var1_37 = arg0_37.chapter
	local var2_37

	if arg0_37.op.type == ChapterConst.OpMove then
		var2_37 = var1_37:GetCellEventByKey("jump", var0_37.row, var0_37.column)
	elseif arg0_37.op.type == ChapterConst.OpSubTeleport then
		var2_37 = var1_37:GetCellEventByKey("jumpsub", var0_37.row, var0_37.column)
	end

	if not var2_37 then
		return
	end

	local var3_37 = {
		row = var2_37[1],
		column = var2_37[2]
	}

	if arg0_37.op.type == ChapterConst.OpMove and var1_37:getFleet(FleetType.Normal, var3_37.row, var3_37.column) then
		return
	end

	arg0_37.teleportPaths = arg0_37.teleportPaths or {}

	table.insert(arg0_37.teleportPaths, {
		row = var0_37.row,
		column = var0_37.column
	})
	table.insert(arg0_37.teleportPaths, var3_37)
end

function var0_0.doCollectCommonAction(arg0_38)
	arg0_38.aiActs = arg0_38.aiActs or {}

	table.insert(arg0_38.aiActs, ChapterCommonAction.New(arg0_38))
end

function var0_0.AddBoxAction(arg0_39)
	local var0_39 = arg0_39.chapter
	local var1_39 = var0_39.fleet.line
	local var2_39 = var0_39:getChapterCell(var1_39.row, var1_39.column)
	local var3_39 = pg.box_data_template[var2_39.attachmentId]

	assert(var3_39, "box_data_template not exist: " .. var2_39.attachmentId)

	if var3_39.type == ChapterConst.BoxStrategy then
		local var4_39 = var3_39.effect_id
		local var5_39 = var3_39.effect_arg

		table.insert(arg0_39.items, Drop.New({
			type = DROP_TYPE_STRATEGY,
			id = var4_39,
			count = var5_39
		}))
	end

	arg0_39.aiActs = arg0_39.aiActs or {}

	table.insert(arg0_39.aiActs, ChapterBoxAction.New(arg0_39))
end

return var0_0
