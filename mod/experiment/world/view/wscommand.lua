local var0_0 = class("WSCommand", import(".WSBaseCommand"))
local var1_0

function var0_0.Bind(arg0_1)
	var1_0 = arg0_1
end

function var0_0.Unbind()
	var1_0 = nil
end

function var0_0.OpCall(arg0_3, arg1_3)
	arg1_3(function()
		arg0_3:OpDone()
	end)
end

function var0_0.OpSwitchMap(arg0_5, arg1_5, arg2_5)
	local var0_5 = nowWorld()

	arg2_5 = defaultValue(arg2_5, function()
		arg0_5:OpInteractive()
	end)

	local var1_5 = var0_5:GetActiveMap()

	if not var1_0:GetInMap() then
		arg0_5:OpDone()
		arg1_5:Apply()

		local var2_5 = var0_5:GetActiveEntrance()
		local var3_5 = var0_5:GetActiveMap()

		var0_5:TriggerAutoFight(var0_5.isAutoSwitch or World.ReplacementMapType(var2_5, var3_5) == "complete_chapter" and getProxy(SettingsProxy):GetWorldFlag("auto_save_area"))
		arg0_5:OpSetInMap(true, arg2_5)
	elseif arg1_5.destMapId ~= var1_5.id or arg1_5.destGridId ~= var1_5.gid then
		local var4_5 = {}

		table.insert(var4_5, function(arg0_7)
			pg.UIMgr.GetInstance():BlurCamera(pg.UIMgr.CameraOverlay, true)
			var1_0.wsTimer:AddInMapTimer(arg0_7, 1, 1):Start()
		end)
		table.insert(var4_5, function(arg0_8)
			pg.UIMgr.GetInstance():UnblurCamera(pg.UIMgr.CameraOverlay)
			var1_0:StopAnim()
			var1_0:HideMap()
			var1_0:HideMapUI()
			arg0_8()
		end)
		table.insert(var4_5, function(arg0_9)
			arg1_5:Apply()

			local var0_9 = var0_5:GetActiveEntrance()
			local var1_9 = var0_5:GetActiveMap()

			var0_5:TriggerAutoFight(var0_5.isAutoSwitch or World.ReplacementMapType(var0_9, var1_9) == "complete_chapter" and getProxy(SettingsProxy):GetWorldFlag("auto_save_area"))
			assert(var1_9, "active map not exist")
			parallelAsync({
				function(arg0_10)
					var1_0:DisplayEnv(arg0_10)
				end,
				function(arg0_11)
					var1_0:LoadMap(var1_9, arg0_11)
				end
			}, arg0_9)
		end)
		table.insert(var4_5, function(arg0_12)
			var1_0:DisplayMap()
			var1_0:DisplayMapUI()
			var1_0:UpdateMapUI()
			arg0_12()
		end)
		table.insert(var4_5, function(arg0_13)
			var1_0.wsTimer:AddInMapTimer(arg0_13, 0.5, 1):Start()
		end)
		seriesAsync(var4_5, function()
			arg0_5:OpDone()

			return arg2_5()
		end)
	else
		arg0_5:OpDone()
		arg1_5:Apply()
		var1_0.wsDragProxy:Focus(var1_0.wsMap:GetFleet().transform.position)

		return arg2_5()
	end
end

function var0_0.OpOpenLayer(arg0_15, arg1_15)
	arg0_15:OpDone()
	var1_0:emit(WorldMediator.OnOpenLayer, arg1_15)
end

function var0_0.OpOpenScene(arg0_16, arg1_16, ...)
	arg0_16:OpDone()
	var1_0:emit(WorldMediator.OnOpenScene, arg1_16, ...)
end

function var0_0.OpChangeScene(arg0_17, arg1_17, ...)
	arg0_17:OpDone()
	var1_0:emit(WorldMediator.OnChangeScene, arg1_17, ...)
end

function var0_0.OpInteractive(arg0_18, arg1_18)
	local var0_18 = nowWorld()

	if var0_18.forceLock then
		return
	end

	arg0_18:OpDone()

	if var1_0.contextData.inShop then
		var1_0.contextData.inShop = false

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("world_shop_init_notice"),
			onYes = function()
				var1_0:MoveAndOpenLayer({
					inMap = false,
					context = Context.New({
						mediator = WorldShopMediator,
						viewComponent = WorldShopLayer
					})
				})
			end,
			onNo = function()
				arg0_18:OpInteractive()
			end
		})

		return
	end

	if var0_18:GetRound() == WorldConst.RoundElse then
		arg0_18:OpReqRound()

		return
	end

	var1_0:InteractiveMoveQueue()

	if not var1_0:GetInMap() then
		return
	end

	local var1_18 = var0_18:GetActiveMap()
	local var2_18 = {}

	table.insert(var2_18, function(arg0_21)
		local var0_21 = var0_18:GetTaskProxy():getAutoSubmitTaskVO()

		if var0_21 then
			arg0_18:OpAutoSubmitTask(var0_21)
		else
			arg0_21()
		end
	end)
	table.insert(var2_18, function(arg0_22)
		if var1_0:CheckEventForMsg() then
			local var0_22 = getProxy(EventProxy)
			local var1_22 = var0_22.eventForMsg.id or 0
			local var2_22 = pg.collection_template[var1_22] and pg.collection_template[var1_22].title or ""

			if var0_18.isAutoFight then
				var0_18:AddAutoInfo("message", i18n("autofight_entrust", var2_22))
				arg0_22()
			else
				local function var3_22()
					arg0_18:OpInteractive()
				end

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					hideNo = true,
					content = i18n("event_special_update", var2_22),
					onYes = var3_22,
					onNo = var3_22
				})
			end

			var0_22.eventForMsg = nil
		else
			arg0_22()
		end
	end)
	table.insert(var2_18, function(arg0_24)
		local var0_24 = pg.GuildMsgBoxMgr.GetInstance()

		if var0_18.isAutoFight then
			if var0_24:GetShouldShowBattleTip() then
				var0_24:SubmitTask(function(arg0_25, arg1_25, arg2_25)
					var0_18:AddAutoInfo("message", i18n("autofight_task", pg.task_data_template[arg2_25].desc))

					if arg1_25 then
						if arg0_25 then
							var0_18:AddAutoInfo("message", i18n("guild_task_autoaccept_1", pg.task_data_template[arg2_25].desc))
						end

						var0_24:CancelShouldShowBattleTip()
						arg0_24()
					else
						var0_24:NotificationForWorld(arg0_24)
					end
				end)
			else
				arg0_24()
			end
		else
			var0_24:NotificationForWorld(arg0_24)
		end
	end)
	table.insert(var2_18, function(arg0_26)
		local var0_26 = var1_18.isLoss

		var1_18.isLoss = false

		if var0_26 then
			if WorldConst.IsRookieMap(var1_18.id) then
				arg0_18:OpStory(WorldConst.GetRookieBattleLoseStory(), true, false, false, function()
					arg0_18:OpKillWorld()
				end)

				return
			elseif WorldGuider.GetInstance():PlayGuide("WorldG161") then
				var0_18:TriggerAutoFight(false)
				arg0_18:OpInteractive()

				return
			end
		end

		arg0_26()
	end)
	table.insert(var2_18, function(arg0_28)
		if #var1_0.achievedList > 0 then
			var1_0:ShowSubView("Achievement", var1_0.achievedList[1])
		else
			arg0_28()
		end
	end)
	table.insert(var2_18, function(arg0_29)
		if #var1_18.phaseDisplayList > 0 then
			var1_0:DisplayPhaseAction(var1_18.phaseDisplayList)
		else
			arg0_29()
		end
	end)
	table.insert(var2_18, function(arg0_30)
		if var1_18:CheckFleetSalvage() then
			arg0_18:OpReqCatSalvage()
		else
			arg0_30()
		end
	end)
	table.insert(var2_18, function(arg0_31)
		local var0_31 = var0_18:GetBossProxy()

		if not var0_31:ShouldTipProgress() then
			arg0_31()
		else
			var0_31:ClearTipProgress()
			var0_18:TriggerAutoFight(false)

			if WorldGuider.GetInstance():PlayGuide("WorldG190") then
				-- block empty
			else
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("world_boss_get_item"),
					onYes = function()
						arg0_18:OpOpenScene(SCENE.WORLDBOSS)
					end,
					onNo = function()
						arg0_18:OpInteractive()
					end
				})
			end
		end
	end)
	table.insert(var2_18, function(arg0_34)
		local var0_34 = var1_18:CheckInteractive()

		if var0_34 then
			local var1_34 = var1_18:GetFleet()

			if var0_34.type == WorldMapAttachment.TypeEvent then
				if var0_34:RemainOpEffect() then
					arg0_18:OpEventOp(var0_34)
				else
					arg0_18:OpEvent(var1_34, var0_34)
				end
			elseif WorldMapAttachment.IsEnemyType(var0_34.type) then
				if var0_18.isAutoFight or arg1_18 then
					local var2_34 = var0_34:GetBattleStageId()
					local var3_34 = pg.expedition_data_template[var2_34]

					assert(var3_34, "expedition_data_template not exist: " .. var2_34)

					if var0_18:CheckSkipBattle() then
						arg0_18:OpReqSkipBattle(var1_34.id)
					elseif var0_18.isAutoFight or PlayerPrefs.GetInt("world_skip_precombat", 0) == 1 then
						var1_0:emit(WorldMediator.OnStart, var2_34, var1_34, var0_34)
					else
						local var4_34 = pg.world_expedition_data[var2_34]
						local var5_34 = var4_34 and var4_34.battle_type and var4_34.battle_type ~= 0
						local var6_34 = {}

						if var5_34 then
							var6_34.mediator = WorldBossInformationMediator
							var6_34.viewComponent = WorldBossInformationLayer
						else
							var6_34.mediator = WorldPreCombatMediator
							var6_34.viewComponent = WorldPreCombatLayer
						end

						arg0_18:OpOpenLayer(Context.New(var6_34))
					end
				else
					arg0_34()
				end
			elseif var0_34.type == WorldMapAttachment.TypeBox then
				arg0_18:OpReqBox(var1_34, var0_34)
			else
				assert(false, "invalide interactive type: " .. var0_34.type)
			end
		else
			arg0_34()
		end
	end)
	table.insert(var2_18, function(arg0_35)
		if var1_0.inLoopAutoFight then
			var1_0.inLoopAutoFight = false

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				content = i18n("autofight_tip_bigworld_loop"),
				onYes = arg0_35,
				onNo = arg0_35
			})
		else
			arg0_35()
		end
	end)
	table.insert(var2_18, function(arg0_36)
		if not var0_18.isAutoFight and not var0_18.isAutoSwitch and var0_18:HasAutoFightDrops() then
			arg0_18:OpOpenLayer(Context.New({
				mediator = WorldAutoFightRewardMediator,
				viewComponent = WorldAutoFightRewardLayer,
				onRemoved = arg0_36
			}))
		else
			arg0_36()
		end
	end)
	seriesAsync(var2_18, function()
		arg0_18:OpReqDiscover()
	end)
end

function var0_0.OpReqDiscover(arg0_38)
	local var0_38 = nowWorld():GetActiveMap()
	local var1_38 = var0_38:CheckDiscover()

	if #var1_38 > 0 then
		local var2_38 = {}
		local var3_38 = {}

		_.each(var1_38, function(arg0_39)
			local var0_39 = var0_38:GetCell(arg0_39.row, arg0_39.column)

			table.insert(var2_38, var0_39)
			_.each(var0_39.attachments, function(arg0_40)
				if arg0_40:ShouldMarkAsLurk() then
					table.insert(var3_38, arg0_40)
				end
			end)
		end)
		var1_0:emit(WorldMediator.OnMapOp, var1_0:NewMapOp({
			op = WorldConst.OpReqDiscover,
			locations = var1_38,
			hiddenCells = var2_38,
			hiddenAttachments = var3_38
		}))
	else
		arg0_38:OpDone("OpReqDiscoverDone")
	end
end

function var0_0.OpReqDiscoverDone(arg0_41, arg1_41)
	local var0_41 = nowWorld()
	local var1_41 = var0_41:GetActiveMap()
	local var2_41 = {}

	if arg1_41 and #arg1_41.hiddenAttachments > 0 then
		table.insert(var2_41, function(arg0_42)
			arg0_41:OpAnim(WorldConst.AnimRadar, arg0_42)
		end)
	end

	seriesAsync(var2_41, function()
		if arg1_41 then
			arg1_41:Apply()
			arg0_41:OpInteractive()
		elseif var1_41:CheckMapPressing() then
			arg0_41:OpReqPressingMap()
		elseif var0_41:CheckFleetMovable() then
			arg0_41:OpReadyToMove()
		else
			local var0_43 = var1_41:GetFleet()

			if not var1_41:CheckFleetMovable(var0_43) and var1_41:GetFleetTerrain(var0_43) == WorldMapCell.TerrainWind then
				pg.TipsMgr.GetInstance():ShowTips(i18n("world_wind_move"))
			end
		end
	end)
end

function var0_0.OpAnim(arg0_44, arg1_44, arg2_44)
	var1_0:DoAnim(arg1_44, function()
		arg0_44:OpDone()
		arg2_44()
	end)
end

function var0_0.OpReadyToMove(arg0_46)
	arg0_46:OpDone()

	local var0_46 = var1_0.wsMap
	local var1_46 = var0_46.map
	local var2_46 = var1_46:GetFleet()

	if #var2_46:GetBuffsByTrap(WorldBuff.TrapDisturbance) > 0 then
		local var3_46 = var1_46:GetMoveRange(var2_46)
		local var4_46 = math.clamp(math.ceil(math.random() * #var3_46), 1, #var3_46)

		if var3_46[var4_46] then
			var1_0:ClearMoveQueue()
			arg0_46:OpReqMoveFleet(var2_46, var3_46[var4_46].row, var3_46[var4_46].column)

			return
		end
	end

	local var5_46 = nowWorld()

	if var5_46.isAutoFight then
		if #var1_0.moveQueue > 0 then
			var1_0:DoQueueMove(var2_46)
		elseif var1_0:CheckLostMoveQueueCount() then
			var1_0:ResetLostMoveQueueCount(true)
			var5_46:TriggerAutoFight(false)
			arg0_46:OpInteractive()
		else
			arg0_46:OpAutoFightSeach()
		end

		return
	end

	if #var1_0.moveQueue > 0 and var1_46:CanLongMove(var2_46) then
		var1_0:DoQueueMove(var2_46)

		return
	end

	var1_0:ClearMoveQueue()
	var0_46:UpdateRangeVisible(true)

	local var6_46 = var1_0.contextData.inPort

	var1_0.contextData.inPort = false

	if var6_46 and checkExist(var1_46, {
		"GetPort"
	}, {
		"IsOpen",
		{
			var5_46:GetRealm(),
			var5_46:GetProgress()
		}
	}) then
		arg0_46:OpReqEnterPort()

		return
	end

	var1_0:CheckGuideSLG(var1_46, var2_46)
end

function var0_0.OpLongMoveFleet(arg0_47, arg1_47, arg2_47, arg3_47)
	arg0_47:OpDone()

	local var0_47 = nowWorld()
	local var1_47 = var0_47:GetActiveMap()

	if var0_47:CheckFleetMovable() then
		local var2_47 = {
			row = arg1_47.row,
			column = arg1_47.column
		}
		local var3_47 = {
			row = arg2_47,
			column = arg3_47
		}
		local var4_47, var5_47 = var1_47:GetLongMoveRange(arg1_47)

		if not _.any(var4_47, function(arg0_48)
			return arg0_48.row == var3_47.row and arg0_48.column == var3_47.column
		end) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("destination_not_in_range"))
		else
			local var6_47 = {}
			local var7_47 = 0
			local var8_47

			local function var9_47(arg0_49, arg1_49)
				if arg0_49.last[arg1_49] then
					var9_47(arg0_49.last[arg1_49][1], arg0_49.last[arg1_49][2])

					var7_47 = var7_47 + 1

					table.insert(var6_47, {
						row = arg0_49.row,
						column = arg0_49.column,
						step = var7_47,
						stay = arg1_49 == 0
					})
				end
			end

			var9_47(var5_47[var3_47.row][var3_47.column], 0)
			var1_0:SetMoveQueue(var6_47)
			var1_0:DoQueueMove(arg1_47)
		end
	end
end

function var0_0.OpReqMoveFleet(arg0_50, arg1_50, arg2_50, arg3_50)
	local var0_50 = nowWorld()
	local var1_50 = var0_50:GetActiveMap()

	if var0_50:CheckFleetMovable() then
		local var2_50 = {
			row = arg1_50.row,
			column = arg1_50.column
		}
		local var3_50 = {
			row = arg2_50,
			column = arg3_50
		}
		local var4_50

		if var1_50:IsSign(var3_50.row, var3_50.column) then
			local var5_50, var6_50 = var1_50:FindPath(var2_50, var3_50)

			if var5_50 < PathFinding.PrioObstacle then
				var4_50 = var3_50
				var3_50 = var6_50[#var6_50 - 1]
			end
		end

		local var7_50 = var1_50:GetMoveRange(arg1_50)

		if _.detect(var7_50, function(arg0_51)
			return arg0_51.row == var3_50.row and arg0_51.column == var3_50.column
		end) then
			local var8_50
			local var9_50 = arg1_50:GetBuffsByTrap(WorldBuff.TrapVortex)

			if #var9_50 > 0 then
				local var10_50 = math.random() * 100

				if underscore.all(var9_50, function(arg0_52)
					return var10_50 < arg0_52:GetTrapParams()[1]
				end) then
					var3_50.row, var3_50.column = arg1_50.row, arg1_50.column
					var8_50 = WorldBuff.TrapVortex
				end
			end

			local var11_50, var12_50 = var1_50:FindPath(var2_50, var3_50)

			if var11_50 < PathFinding.PrioObstacle then
				var1_0:emit(WorldMediator.OnMapOp, var1_0:NewMapOp({
					op = WorldConst.OpReqMoveFleet,
					id = arg1_50.id,
					arg1 = var3_50.row,
					arg2 = var3_50.column,
					sign = var4_50,
					trap = var8_50
				}))

				return
			elseif var11_50 < PathFinding.PrioForbidden then
				pg.TipsMgr.GetInstance():ShowTips(i18n("destination_can_not_reach_safety"))
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("destination_can_not_reach"))
			end
		else
			local var13_50 = trap and "world_fleet_in_vortex" or "destination_not_in_range"

			pg.TipsMgr.GetInstance():ShowTips(i18n(var13_50))
		end
	end

	var1_0:ClearMoveQueue()
	arg0_50:OpDone()
end

function var0_0.OpReqMoveFleetDone(arg0_53, arg1_53)
	local var0_53 = {}
	local var1_53 = var1_0.wsMap
	local var2_53 = var1_53.map
	local var3_53 = var2_53:GetFleet()

	table.insert(var0_53, function(arg0_54)
		var1_53:UpdateRangeVisible(false)

		if var3_53.row ~= arg1_53.arg1 or var3_53.column ~= arg1_53.arg2 then
			var1_53:DisplayTargetArrow(arg1_53.arg1, arg1_53.arg2)
		end

		arg0_53:OpActions(arg1_53.childOps, arg0_54)
	end)
	table.insert(var0_53, function(arg0_55)
		var1_0:CheckMoveQueue(arg1_53.path)
		arg0_55()
	end)

	if arg1_53.sign then
		table.insert(var0_53, function(arg0_56)
			var1_0:ClearMoveQueue()

			if var3_53.row == arg1_53.arg1 and var3_53.column == arg1_53.arg2 then
				local var0_56 = var2_53:GetCell(arg1_53.sign.row, arg1_53.sign.column)

				arg0_53:OpTriggerSign(var3_53, var0_56:GetEventAttachment(), arg0_56)
			else
				arg0_56()
			end
		end)
	end

	seriesAsync(var0_53, function()
		var1_53:HideTargetArrow()
		arg1_53:Apply()
		arg0_53:OpInteractive()
	end)
end

function var0_0.OpMoveFleet(arg0_58, arg1_58, arg2_58)
	arg2_58 = var1_0:DoTopBlock(arg2_58)

	local var0_58 = var1_0.wsMap
	local var1_58 = var0_58.map:GetFleet(arg1_58.id)
	local var2_58 = var0_58:GetFleet(var1_58)
	local var3_58 = var2_58.fleet
	local var4_58 = var0_58.map:GetCell(var3_58.row, var3_58.column)
	local var5_58 = var0_58:MovePath(var2_58, arg1_58.path, arg1_58.pos, WorldConst.DirType2, var4_58:GetTerrain() == WorldMapCell.TerrainWind)

	local function var6_58(arg0_59, arg1_59)
		local var0_59 = arg1_58.stepOps[arg0_59]

		assert(var0_59, "step op not exist: " .. arg0_59)

		local var1_59 = {}

		if #var0_59.hiddenAttachments > 0 then
			table.insert(var1_59, function(arg0_60)
				if arg0_59 < #arg1_58.stepOps then
					var5_58:UpdatePaused(true)
				end

				var1_0:DoAnim(WorldConst.AnimRadar, function()
					if arg0_59 < #arg1_58.stepOps then
						var5_58:UpdatePaused(false)
					end

					arg0_60()
				end)
			end)
		end

		seriesAsync(var1_59, function()
			var0_59:Apply()

			return existCall(arg1_59)
		end)
	end

	local function var7_58(arg0_63)
		local var0_63 = arg1_58.path[arg0_63 + 1]
		local var1_63 = var0_58:GetCell(var0_63.row, var0_63.column).transform.position

		var1_0.wsDragProxy:Focus(var1_63, var0_63.duration, LeanTweenType.linear)
	end

	local var8_58 = 0

	var7_58(var8_58)

	local function var9_58(arg0_64, arg1_64)
		var8_58 = var8_58 + 1

		var7_58(var8_58)
		var1_0.wsMapRight:UpdateCompassRotation(arg1_58.path[var8_58 + 1])
		var6_58(var8_58)
	end

	local var10_58

	local function var11_58()
		var5_58:RemoveListener(WSMapPath.EventArrivedStep, var9_58)
		var5_58:RemoveListener(WSMapPath.EventArrived, var11_58)

		var8_58 = var8_58 + 1

		var6_58(var8_58, function()
			if #arg1_58.locations > 0 then
				var1_0:emit(WorldMediator.OnMapOp, var1_0:NewMapOp({
					op = WorldConst.OpReqDiscover,
					locations = arg1_58.locations,
					hiddenCells = {},
					hiddenAttachments = {},
					routine = function(arg0_67)
						arg0_67:Apply()
						arg0_58:OpDone()
						arg2_58()
					end
				}))
			else
				arg0_58:OpDone()
				arg2_58()
			end
		end)
	end

	var5_58:AddListener(WSMapPath.EventArrivedStep, var9_58)
	var5_58:AddListener(WSMapPath.EventArrived, var11_58)

	for iter0_58, iter1_58 in ipairs(var3_58:GetCarries()) do
		local var12_58 = var0_58:GetCarryItem(iter1_58)
		local var13_58 = var3_58:BuildCarryPath(iter1_58, arg1_58.pos, arg1_58.path)

		var12_58:FollowPath(var13_58)
	end

	var1_0.wsMapRight:UpdateCompassRotation(arg1_58.path[1])
end

function var0_0.OpMoveAttachment(arg0_68, arg1_68, arg2_68)
	arg2_68 = var1_0:DoTopBlock(arg2_68)

	local var0_68 = var1_0.wsMap
	local var1_68 = var0_68.map
	local var2_68 = arg1_68.attachment
	local var3_68 = var0_68:GetAttachment(var2_68.row, var2_68.column, var2_68.type)

	var0_68:FlushMovingAttachment(var3_68)

	local var4_68 = 0
	local var5_68 = var0_68:MovePath(var3_68, arg1_68.path, arg1_68.pos, var2_68:GetDirType())

	local function var6_68(arg0_69, arg1_69)
		var4_68 = var4_68 + 1

		var0_68:FlushMovingAttachmentOrder(var3_68, arg1_68.path[var4_68])
	end

	local var7_68

	local function var8_68()
		var5_68:RemoveListener(WSMapPath.EventArrivedStep, var6_68)
		var5_68:RemoveListener(WSMapPath.EventArrived, var8_68)
		arg0_68:OpDone()
		arg2_68()
	end

	var5_68:AddListener(WSMapPath.EventArrivedStep, var6_68)
	var5_68:AddListener(WSMapPath.EventArrived, var8_68)
end

function var0_0.OpReqRound(arg0_71)
	var1_0:emit(WorldMediator.OnMapOp, var1_0:NewMapOp({
		op = WorldConst.OpReqRound
	}))
end

function var0_0.OpReqRoundDone(arg0_72, arg1_72)
	arg0_72:OpActions(arg1_72.childOps, function()
		arg1_72:Apply()
		arg0_72:OpInteractive(true)
	end)
end

function var0_0.OpActions(arg0_74, arg1_74, arg2_74)
	arg0_74:OpDone()

	local var0_74 = _.map(arg1_74 or {}, function(arg0_75)
		return function(arg0_76)
			arg0_74:OpAction(arg0_75, arg0_76)
		end
	end)

	seriesAsync(var0_74, arg2_74)
end

function var0_0.OpAction(arg0_77, arg1_77, arg2_77)
	arg0_77:OpDone()

	local var0_77 = {}

	if arg1_77.childOps then
		table.insert(var0_77, function(arg0_78)
			arg0_77:OpActions(arg1_77.childOps, arg0_78)
		end)
	end

	if arg1_77.op == WorldConst.OpActionUpdate then
		table.insert(var0_77, function(arg0_79)
			arg1_77:Apply()
			arg0_79()
		end)
	elseif arg1_77.op == WorldConst.OpActionFleetMove then
		table.insert(var0_77, function(arg0_80)
			arg0_77:OpMoveFleet(arg1_77, function()
				arg1_77:Apply()
				arg0_80()
			end)
		end)
	elseif arg1_77.op == WorldConst.OpActionAttachmentMove then
		table.insert(var0_77, function(arg0_82)
			arg0_77:OpMoveAttachment(arg1_77, function()
				arg1_77:Apply()
				arg0_82()
			end)
		end)
	elseif arg1_77.op == WorldConst.OpActionAttachmentAnim then
		table.insert(var0_77, function(arg0_84)
			arg0_77:OpAttachmentAnim(arg1_77, function()
				arg1_77:Apply()
				arg0_84()
			end)
		end)
	elseif arg1_77.op == WorldConst.OpActionFleetAnim then
		table.insert(var0_77, function(arg0_86)
			arg0_77:OpFleetAnim(arg1_77, function()
				arg1_77:Apply()
				arg0_86()
			end)
		end)
	elseif arg1_77.op == WorldConst.OpActionEventEffect then
		table.insert(var0_77, function(arg0_88)
			arg0_77:OpTriggerEvent(arg1_77, arg0_88)
		end)
	elseif arg1_77.op == WorldConst.OpActionCameraMove then
		table.insert(var0_77, function(arg0_89)
			arg0_77:OpMoveCameraTarget(arg1_77.attachment, 0.1, function()
				arg1_77:Apply()
				arg0_89()
			end)
		end)
	elseif arg1_77.op == WorldConst.OpActionTrapGravityAnim then
		table.insert(var0_77, function(arg0_91)
			arg0_77:OpTrapGravityAnim(arg1_77.attachment, function()
				arg1_77:Apply()
				arg0_91()
			end)
		end)
	else
		assert(false)
	end

	seriesAsync(var0_77, arg2_77)
end

function var0_0.OpEvent(arg0_93, arg1_93, arg2_93)
	arg0_93:OpDone()

	local var0_93 = nowWorld()
	local var1_93
	local var2_93
	local var3_93 = arg2_93:GetEventEffect()
	local var4_93 = var3_93.effect_type
	local var5_93 = var3_93.effect_paramater
	local var6_93 = {}

	if var4_93 == WorldMapAttachment.EffectEventStoryOption then
		local var7_93 = var5_93[1]
		local var8_93 = var3_93.autoflag[1]

		if var8_93 and WorldConst.CheckWorldStorySkip(var7_93) then
			table.insert(var6_93, function(arg0_94)
				arg0_94(var8_93)
			end)
		else
			table.insert(var6_93, function(arg0_95)
				arg0_93:OpStory(var7_93, true, true, var0_93.isAutoFight and var8_93 and {
					var8_93
				} or false, arg0_95)
			end)
		end

		table.insert(var6_93, function(arg0_96, arg1_96)
			assert(arg1_96, "without option in story:" .. var5_93[1])

			local var0_96 = underscore.detect(var5_93[2], function(arg0_97)
				return arg0_97[1] == arg1_96
			end)

			if var0_96 then
				var1_93 = var0_96[2]

				arg0_96()
			else
				arg2_93.triggered = true

				arg0_93:OpInteractive()
			end
		end)
	elseif var4_93 == WorldMapAttachment.EffectEventConsumeItem then
		if var0_93.isAutoFight then
			-- block empty
		else
			table.insert(var6_93, function(arg0_98)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_ITEM_BOX,
					content = i18n("sub_item_warning"),
					items = {
						{
							type = DROP_TYPE_WORLD_ITEM,
							id = var5_93[1],
							count = var5_93[2]
						}
					},
					onYes = arg0_98,
					onNo = function()
						arg2_93.triggered = true

						arg0_93:OpInteractive()
					end
				})
			end)
		end

		table.insert(var6_93, function(arg0_100)
			if var0_93:GetInventoryProxy():GetItemCount(var5_93[1]) < var5_93[2] then
				var0_93:TriggerAutoFight(false)

				arg2_93.triggered = true

				arg0_93:OpStory(var5_93[3], true, false, false, function()
					arg0_93:OpInteractive()
				end)
			else
				arg0_100()
			end
		end)
	elseif var4_93 == WorldMapAttachment.EffectEventGuide then
		table.insert(var6_93, function(arg0_102)
			if arg2_93:IsAttachmentFinish() then
				arg0_102()
			else
				arg0_93:OpGuide(var5_93[1], var5_93[2], function()
					arg2_93.finishMark = arg2_93.data

					if var1_0 then
						arg0_93:OpInteractive()
					end
				end)
			end
		end)
	elseif var4_93 == WorldMapAttachment.EffectEventConsumeCarry then
		local var9_93 = var3_93.effect_paramater[1] or {}

		if _.any(var9_93, function(arg0_104)
			return not arg1_93:ExistCarry(arg0_104)
		end) then
			arg2_93.triggered = true

			var0_93:TriggerAutoFight(false)

			local var10_93 = var3_93.effect_paramater[2]

			if var10_93 then
				table.insert(var6_93, function(arg0_105)
					arg0_93:OpStory(var10_93, true, false, false, arg0_105)
				end)
			end

			table.insert(var6_93, function(arg0_106)
				arg0_93:OpInteractive()
			end)
		end
	elseif var4_93 == WorldMapAttachment.EffectEventCatSalvage then
		if arg1_93:GetDisplayCommander() and not arg1_93:IsCatSalvage() then
			if not var0_93.isAutoFight then
				table.insert(var6_93, function(arg0_107)
					arg0_93:OpStory(var5_93[1], true, true, false, function(arg0_108)
						if arg0_108 == var5_93[2] then
							arg0_107()
						else
							arg2_93.triggered = true

							arg0_93:OpInteractive()
						end
					end)
				end)
			end
		else
			arg2_93.triggered = true

			if not var0_93.isAutoFight then
				local var11_93 = pg.gameset.world_catsearch_failure.description[1]

				table.insert(var6_93, function(arg0_109)
					arg0_93:OpStory(var11_93, true, false, false, arg0_109)
				end)
			end

			table.insert(var6_93, function(arg0_110)
				arg0_93:OpInteractive()
			end)
		end
	elseif var4_93 == WorldMapAttachment.EffectEventMsgbox then
		table.insert(var6_93, function(arg0_111)
			var0_93:TriggerAutoFight(false)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n(var5_93[1]),
				onYes = arg0_111,
				onNo = var5_93[1] == 0 and arg0_111 or function()
					arg2_93.triggered = true

					arg0_93:OpInteractive()
				end,
				hideNo = var5_93[1] == 0
			})
		end)
	elseif var4_93 == WorldMapAttachment.EffectEventStoryBattle then
		table.insert(var6_93, function(arg0_113)
			if arg2_93:IsAttachmentFinish() then
				arg0_113()
			else
				var1_0:emit(WorldMediator.OnStartPerform, var5_93[1], function()
					arg2_93.finishMark = arg2_93.data
				end)
			end
		end)
	end

	seriesAsync(var6_93, function()
		local var0_115 = var1_0:NewMapOp({
			op = WorldConst.OpReqEvent,
			id = arg1_93.id,
			arg1 = var1_93,
			arg2 = var2_93,
			attachment = arg2_93,
			effect = var3_93,
			locations = {
				{
					row = arg2_93.row,
					column = arg2_93.column
				}
			}
		})

		arg0_93:OpReqEvent(var0_115)
	end)
end

function var0_0.OpReqEvent(arg0_116, arg1_116)
	var1_0:emit(WorldMediator.OnMapOp, arg1_116)
end

function var0_0.OpReqEventDone(arg0_117, arg1_117)
	arg0_117:OpTriggerEvent(arg1_117, function()
		arg0_117:OpInteractive(true)
	end)
end

function var0_0.OpEventOp(arg0_119, arg1_119)
	arg0_119:OpDone()

	local var0_119 = var1_0:NewMapOp({
		op = WorldConst.OpActionEventOp,
		attachment = arg1_119,
		effect = arg1_119:GetOpEffect()
	})

	arg0_119:OpTriggerEvent(var0_119, function()
		arg0_119:OpInteractive()
	end)
end

function var0_0.OpTriggerEvent(arg0_121, arg1_121, arg2_121)
	arg0_121:OpDone()

	local var0_121 = nowWorld()
	local var1_121 = {}
	local var2_121 = arg1_121.effect
	local var3_121 = var2_121.effect_type
	local var4_121 = var2_121.effect_paramater

	if var3_121 == WorldMapAttachment.EffectEventStory then
		local var5_121 = getProxy(WorldProxy)
		local var6_121 = var4_121[1]

		if WorldConst.CheckWorldStorySkip(var6_121) then
			table.insert(var1_121, function(arg0_122)
				var1_0:ReContinueMoveQueue()
				arg0_122()
			end)
		else
			table.insert(var1_121, function(arg0_123)
				arg0_121:OpStory(var6_121, true, false, var0_121.isAutoFight and {} or false, arg0_123)
			end)
		end

		table.insert(var1_121, function(arg0_124)
			arg1_121:Apply()
			arg0_124()
		end)
	elseif var3_121 == WorldMapAttachment.EffectEventTeleport or var3_121 == WorldMapAttachment.EffectEventTeleportBack then
		local var7_121 = arg1_121.attachment

		assert(var7_121 and var7_121.type == WorldMapAttachment.TypeEvent)

		local var8_121 = var0_121:GetMap(arg1_121.destMapId)
		local var9_121 = arg1_121.effect.effect_paramater[1]

		if var9_121[#var9_121] == 1 then
			table.insert(var1_121, function(arg0_125)
				var1_0:ShowTransportMarkOverview({
					ids = {
						arg1_121.entranceId
					}
				}, arg0_125)
			end)
		end

		if var1_0:GetInMap() and var7_121.config.icon == "chuansong01" then
			table.insert(var1_121, function(arg0_126)
				arg0_121:OpAttachmentAnim(var1_0:NewMapOp({
					anim = "chuansong_open",
					attachment = var7_121
				}), arg0_126)
			end)
		end

		table.insert(var1_121, function(arg0_127)
			arg0_121:OpSwitchMap(arg1_121, arg0_127)
		end)
	elseif var3_121 == WorldMapAttachment.EffectEventShowMapMark then
		if var0_121.isAutoFight then
			-- block empty
		else
			table.insert(var1_121, function(arg0_128)
				arg0_121:OpShowMarkOverview({
					ids = var4_121
				}, arg0_128)
			end)
		end

		table.insert(var1_121, function(arg0_129)
			arg1_121:Apply()
			arg0_129()
		end)
	elseif var3_121 == WorldMapAttachment.EffectEventCameraMove then
		table.insert(var1_121, function(arg0_130)
			arg0_121:OpMoveCamera(var4_121[1], var4_121[2], function()
				arg1_121:Apply()
				arg0_130()
			end)
		end)
	elseif var3_121 == WorldMapAttachment.EffectEventShakePlane then
		table.insert(var1_121, function(arg0_132)
			arg0_121:OpShakePlane(var4_121[1], var4_121[2], var4_121[3], var4_121[4], function()
				arg1_121:Apply()
				arg0_132()
			end)
		end)
	elseif var3_121 == WorldMapAttachment.EffectEventBlink1 or var3_121 == WorldMapAttachment.EffectEventBlink2 then
		table.insert(var1_121, function(arg0_134)
			var0_121:TriggerAutoFight(false)
			arg0_121:OpActions(arg1_121.childOps, function()
				arg1_121:Apply()
				arg0_134()
			end)
		end)
	elseif var3_121 == WorldMapAttachment.EffectEventFlash then
		table.insert(var1_121, function(arg0_136)
			local var0_136 = Color.New(var4_121[4][1] / 255, var4_121[4][2] / 255, var4_121[4][3] / 255, var4_121[4][4] / 255)

			arg0_121:OpFlash(var4_121[1], var4_121[2], var4_121[3], var0_136, function()
				arg1_121:Apply()
				arg0_136()
			end)
		end)
	elseif var3_121 == WorldMapAttachment.EffectEventShipBuff then
		table.insert(var1_121, function(arg0_138)
			arg1_121:Apply()
			arg0_138()
		end)
	elseif var3_121 == WorldMapAttachment.EffectEventHelp then
		if var0_121.isAutoFight then
			-- block empty
		else
			table.insert(var1_121, function(arg0_139)
				local var0_139 = WorldConst.BuildHelpTips(var0_121:GetProgress())

				var0_139.defaultpage = var4_121[1]

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_HELP,
					helps = var0_139,
					weight = LayerWeightConst.SECOND_LAYER,
					onClose = arg0_139
				})
			end)
		end

		table.insert(var1_121, function(arg0_140)
			arg1_121:Apply()
			arg0_140()
		end)
	elseif var3_121 == WorldMapAttachment.EffectEventProgress then
		table.insert(var1_121, function(arg0_141)
			arg0_121:OpActions(arg1_121.childOps, function()
				arg1_121:Apply()
				arg0_141()
			end)
		end)
	elseif var3_121 == WorldMapAttachment.EffectEventReturn2World then
		table.insert(var1_121, function(arg0_143)
			var0_121:TriggerAutoFight(false)
			arg0_121:OpSetInMap(false, function()
				arg1_121:Apply()
				arg0_143()
			end)
		end)
	elseif var3_121 == WorldMapAttachment.EffectEventShowPort then
		table.insert(var1_121, function(arg0_145)
			arg1_121:Apply()
			var0_121:TriggerAutoFight(false)
			var1_0:OpenPortLayer({
				page = var4_121[1]
			})
			arg0_145()
		end)
	elseif var3_121 == WorldMapAttachment.EffectEventGlobalBuff then
		local var10_121 = {
			id = var4_121[1],
			floor = var4_121[2],
			before = var0_121:GetGlobalBuff(var4_121[1]):GetFloor()
		}

		if var0_121.isAutoFight then
			var0_121:AddAutoInfo("buffs", var10_121)
		else
			table.insert(var1_121, function(arg0_146)
				var1_0:ShowSubView("GlobalBuff", {
					var10_121,
					arg0_146
				})
			end)
		end

		table.insert(var1_121, function(arg0_147)
			arg1_121:Apply()
			arg0_147()
		end)
	elseif var3_121 == WorldMapAttachment.EffectEventSound then
		table.insert(var1_121, function(arg0_148)
			arg0_121:OpPlaySound(var4_121[1], function()
				arg1_121:Apply()
				arg0_148()
			end)
		end)
	elseif var3_121 == WorldMapAttachment.EffectEventHelpLayer then
		table.insert(var1_121, function(arg0_150)
			var0_121:TriggerAutoFight(false)
			arg1_121:Apply()
			arg0_121:OpOpenLayer(Context.New({
				mediator = WorldHelpMediator,
				viewComponent = WorldHelpLayer,
				data = {
					titleId = var4_121[1],
					pageId = var4_121[2]
				},
				onRemoved = arg0_150
			}))
		end)
	elseif var3_121 == WorldMapAttachment.EffectEventFleetShipHP then
		table.insert(var1_121, function(arg0_151)
			arg1_121:Apply()

			if var4_121[1] > 0 then
				arg0_121:OpShowAllFleetHealth(arg0_151)
			else
				arg0_151()
			end
		end)
	elseif var3_121 == WorldMapAttachment.EffectEventCatSalvage then
		table.insert(var1_121, function(arg0_152)
			arg1_121:Apply()
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_catsearch_success"))
			arg0_152()
		end)
	elseif var3_121 == WorldMapAttachment.EffectEventTeleportEvent then
		table.insert(var1_121, function(arg0_153)
			arg1_121:Apply()

			local var0_153 = var1_0.wsMap:GetFleet()

			var1_0.wsDragProxy:Focus(var0_153.transform.position, nil, LeanTweenType.easeInOutSine, arg0_153)
		end)
	else
		table.insert(var1_121, function(arg0_154)
			arg1_121:Apply()
			arg0_154()
		end)
	end

	seriesAsync(var1_121, arg2_121)
end

function var0_0.OpReqRetreat(arg0_155, arg1_155)
	local var0_155 = nowWorld():GetActiveMap():GetCell(arg1_155.row, arg1_155.column)

	assert(var0_155:ExistEnemy())

	local var1_155 = var0_155:GetAliveAttachment()

	var1_0:emit(WorldMediator.OnMapOp, var1_0:NewMapOp({
		op = WorldConst.OpReqRetreat,
		id = arg1_155.id,
		attachment = var1_155
	}))
end

function var0_0.OpReqRetreatDone(arg0_156, arg1_156)
	local var0_156 = {}

	table.insert(var0_156, function(arg0_157)
		arg0_156:OpActions(arg1_156.childOps, arg0_157)
	end)
	seriesAsync(var0_156, function()
		arg1_156:Apply()
		arg0_156:OpInteractive()
	end)
end

function var0_0.OpTransport(arg0_159, arg1_159, arg2_159)
	arg0_159:OpDone()

	local var0_159 = nowWorld()
	local var1_159 = var0_159:GetActiveMap()

	if not var0_159:IsSystemOpen(WorldConst.SystemOutMap) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("word_systemClose"))
	elseif not arg2_159:IsMapOpen() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_map_not_open"))
	else
		arg0_159:OpReqTransport(var1_159:GetFleet(), arg1_159, arg2_159)
	end
end

function var0_0.OpReqTransport(arg0_160, arg1_160, arg2_160, arg3_160)
	var1_0:emit(WorldMediator.OnMapOp, var1_0:NewMapOp({
		op = WorldConst.OpReqTransport,
		id = arg1_160.id,
		arg1 = arg3_160.id,
		arg2 = arg2_160.id,
		locations = {
			arg3_160:CalcTransportPos(nowWorld():GetActiveEntrance(), arg2_160)
		}
	}))
end

function var0_0.OpReqTransportDone(arg0_161, arg1_161)
	local var0_161 = {}

	seriesAsync(var0_161, function()
		arg0_161:OpSwitchMap(arg1_161)
	end)
end

function var0_0.OpReqSub(arg0_163, arg1_163)
	assert(nowWorld():CanCallSubmarineSupport())

	var1_0.subCallback = arg1_163

	var1_0:emit(WorldMediator.OnMapOp, var1_0:NewMapOp({
		op = WorldConst.OpReqSub,
		id = nowWorld():GetSubmarineFleet().id
	}))
end

function var0_0.OpReqSubDone(arg0_164, arg1_164)
	local var0_164 = nowWorld()
	local var1_164 = var0_164:CalcOrderCost(WorldConst.OpReqSub)

	var0_164.staminaMgr:ConsumeStamina(var1_164)
	var0_164:SetReqCDTime(WorldConst.OpReqSub, pg.TimeMgr.GetInstance():GetServerTime())

	local var2_164 = var0_164:GetSubmarineFleet():GetFlagShipVO()

	var1_0:DoStrikeAnim(var2_164:GetMapStrikeAnim(), var2_164, function()
		arg1_164:Apply()

		if var1_0.subCallback then
			local var0_165 = var1_0.subCallback

			var1_0.subCallback = nil

			var0_165()
		end
	end)
end

function var0_0.OpReqJumpOut(arg0_166, arg1_166, arg2_166)
	local var0_166 = {}

	if not arg2_166 then
		table.insert(var0_166, function(arg0_167)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = pg.world_chapter_template_reset[arg1_166].tip,
				onYes = arg0_167,
				onNo = function()
					arg0_166:OpDone()
				end
			})
		end)
	end

	seriesAsync(var0_166, function()
		var1_0:emit(WorldMediator.OnMapOp, var1_0:NewMapOp({
			op = WorldConst.OpReqJumpOut,
			skipDisplay = arg2_166
		}))
	end)
end

function var0_0.OpReqJumpOutDone(arg0_170, arg1_170)
	local var0_170 = {}

	if not arg1_170.skipDisplay then
		table.insert(var0_170, function(arg0_171)
			var1_0:ShowTransportMarkOverview({
				ids = {
					arg1_170.entranceId
				}
			}, arg0_171)
		end)
	end

	seriesAsync(var0_170, function()
		arg0_170:OpSwitchMap(arg1_170)
	end)
end

function var0_0.OpReqSwitchFleet(arg0_173, arg1_173)
	var1_0:emit(WorldMediator.OnMapOp, var1_0:NewMapOp({
		op = WorldConst.OpReqSwitchFleet,
		id = arg1_173.id
	}))
end

function var0_0.OpReqSwitchFleetDone(arg0_174, arg1_174)
	local var0_174 = nowWorld()
	local var1_174 = table.indexof(var0_174.fleets, var0_174:GetFleet(arg1_174.id))

	var0_174:GetActiveMap():UpdateFleetIndex(var1_174)
	var1_0.wsMap:UpdateRangeVisible(false)
	arg0_174:OpInteractive()
end

function var0_0.OpStory(arg0_175, arg1_175, arg2_175, arg3_175, arg4_175, arg5_175)
	local function var0_175(arg0_176, arg1_176)
		arg0_175:OpDone()
		existCall(arg5_175, arg1_176)
	end

	pg.NewStoryMgr.GetInstance():PlayForWorld(arg1_175, arg4_175, var0_175, arg2_175, false, tobool(arg4_175), arg3_175)
end

function var0_0.OpTriggerSign(arg0_177, arg1_177, arg2_177, arg3_177)
	assert(arg2_177:IsSign())
	arg0_177:OpDone()

	if arg2_177:IsAvatar() then
		local var0_177 = var1_0.wsMap:GetAttachment(arg2_177.row, arg2_177.column, arg2_177.type)
		local var1_177 = var1_0.wsMap:GetFleet()

		if arg2_177.column ~= var1_177.fleet.column then
			local var2_177 = var0_177:GetModelAngles()

			var2_177.y = arg2_177.column < var1_177.fleet.column and 0 or 180

			var0_177:UpdateModelAngles(var2_177)

			local var3_177 = var1_177:GetModelAngles()

			var3_177.y = 180 - var2_177.y

			var1_177:UpdateModelAngles(var3_177)
		end
	end

	local var4_177 = {}
	local var5_177 = arg2_177:GetEventEffects()

	_.each(var5_177, function(arg0_178)
		local var0_178 = arg0_178.effect_type
		local var1_178 = arg0_178.effect_paramater

		if var0_178 == WorldMapAttachment.EffectEventStoryOptionClient then
			local var2_178 = var1_178[1]
			local var3_178 = arg0_178.autoflag[1]

			if var3_178 and WorldConst.CheckWorldStorySkip(var2_178) then
				table.insert(var4_177, function(arg0_179)
					arg0_179(var3_178)
				end)
			else
				table.insert(var4_177, function(arg0_180)
					arg0_177:OpStory(var2_178, true, true, nowWorld().isAutoFight and var3_178 and {
						var3_178
					} or false, arg0_180)
				end)
			end

			table.insert(var4_177, function(arg0_181, arg1_181)
				assert(arg1_181, "without option in story:" .. var1_178[1])

				local var0_181 = _.detect(var1_178[2], function(arg0_182)
					return arg0_182[1] == arg1_181
				end)

				if var0_181 and var0_181[2] > 0 then
					arg0_177:OpTriggerEvent(var1_0:NewMapOp({
						attachment = arg2_177,
						effect = pg.world_effect_data[var0_181[2]]
					}), arg0_181)
				else
					arg0_181()
				end
			end)
		else
			table.insert(var4_177, function(arg0_183)
				arg0_177:OpTriggerEvent(var1_0:NewMapOp({
					attachment = arg2_177,
					effect = arg0_178
				}), arg0_183)
			end)
		end
	end)
	seriesAsync(var4_177, arg3_177)
end

function var0_0.OpShowMarkOverview(arg0_184, arg1_184, arg2_184)
	var1_0:emit(WorldMediator.OnOpenLayer, Context.New({
		mediator = WorldOverviewMediator,
		viewComponent = WorldOverviewLayer,
		data = {
			info = arg1_184
		},
		onRemoved = function()
			arg0_184:OpDone()

			return existCall(arg2_184)
		end
	}))
end

function var0_0.OpFocusTargetEntrance(arg0_186, arg1_186)
	arg0_186:OpDone()

	local var0_186 = {}

	if var1_0:GetInMap() then
		table.insert(var0_186, function(arg0_187)
			var1_0:QueryTransport(arg0_187)
		end)
	end

	seriesAsync(var0_186, function()
		var1_0:EnterTransportWorld(arg1_186)
	end)
end

function var0_0.OpShowOrderPanel(arg0_189)
	arg0_189:OpDone()

	local var0_189 = nowWorld()

	var1_0:ShowSubView("OrderPanel", {
		var0_189:GetActiveEntrance(),
		var0_189:GetActiveMap(),
		var1_0.wsMapRight.wsCompass:GetAnchorEulerAngles()
	})
end

function var0_0.OpShowScannerPanel(arg0_190, arg1_190, arg2_190)
	arg0_190:OpDone()

	local var0_190 = nowWorld()

	var1_0:ShowSubView("ScannerPanel", {
		var0_190:GetActiveMap(),
		var1_0.wsDragProxy
	}, {
		arg1_190,
		arg2_190
	})
end

function var0_0.OpMoveCamera(arg0_191, arg1_191, arg2_191, arg3_191)
	arg3_191 = var1_0:DoTopBlock(arg3_191)

	local var0_191 = {}

	if arg1_191 > 0 then
		local var1_191 = var1_0.wsMap.map:FindAttachments(WorldMapAttachment.TypeEvent, arg1_191)

		for iter0_191, iter1_191 in ipairs(var1_191) do
			table.insert(var0_191, {
				focusPos = function()
					return var1_0.wsMap:GetAttachment(iter1_191.row, iter1_191.column, iter1_191.type).transform.position
				end,
				row = iter1_191.row,
				column = iter1_191.column
			})
		end
	else
		local var2_191 = var1_0.wsMap:GetFleet()

		table.insert(var0_191, {
			focusPos = function()
				return var2_191.transform.position
			end,
			row = var2_191.fleet.row,
			column = var2_191.fleet.column
		})
	end

	local var3_191 = {}

	for iter2_191, iter3_191 in ipairs(var0_191) do
		table.insert(var3_191, function(arg0_194)
			var1_0.wsMapRight:UpdateCompossView(iter3_191.row, iter3_191.column)
			arg0_194()
		end)
		table.insert(var3_191, function(arg0_195)
			var1_0.wsDragProxy:Focus(iter3_191.focusPos(), nil, LeanTweenType.easeInOutSine, arg0_195)
		end)
		table.insert(var3_191, function(arg0_196)
			var1_0.wsTimer:AddInMapTimer(arg0_196, arg2_191, 1):Start()
		end)
	end

	seriesAsync(var3_191, function()
		arg0_191:OpDone()

		return existCall(arg3_191)
	end)
end

function var0_0.OpMoveCameraTarget(arg0_198, arg1_198, arg2_198, arg3_198)
	arg3_198 = var1_0:DoTopBlock(arg3_198)

	if not arg1_198 then
		local var0_198 = var1_0.wsMap:GetFleet()

		arg1_198 = {
			row = var0_198.fleet.row,
			column = var0_198.fleet.column
		}
	end

	local var1_198 = {}

	table.insert(var1_198, function(arg0_199)
		var1_0.wsMapRight:UpdateCompossView(arg1_198.row, arg1_198.column)
		arg0_199()
	end)
	table.insert(var1_198, function(arg0_200)
		var1_0.wsDragProxy:Focus(var1_0.wsMap:GetCell(arg1_198.row, arg1_198.column).transform.position, nil, LeanTweenType.easeInOutSine, arg0_200)
	end)
	table.insert(var1_198, function(arg0_201)
		var1_0.wsTimer:AddInMapTimer(arg0_201, arg2_198, 1):Start()
	end)
	seriesAsync(var1_198, function()
		arg0_198:OpDone()

		return existCall(arg3_198)
	end)
end

function var0_0.OpShakePlane(arg0_203, arg1_203, arg2_203, arg3_203, arg4_203, arg5_203)
	var1_0.wsDragProxy:ShakePlane(arg1_203, arg2_203, arg3_203, arg4_203, function()
		arg0_203:OpDone()

		if arg5_203 then
			arg5_203()
		end
	end)
end

function var0_0.OpAttachmentAnim(arg0_205, arg1_205, arg2_205)
	local var0_205 = arg1_205.attachment
	local var1_205 = var1_0.wsMap:GetAttachment(var0_205.row, var0_205.column, var0_205.type)

	seriesAsync({
		function(arg0_206)
			var1_205:PlayModelAction(arg1_205.anim, arg1_205.duration, arg0_206)
		end
	}, function()
		var1_205:FlushModelAction()
		arg0_205:OpDone()
		arg2_205()
	end)
end

function var0_0.OpFleetAnim(arg0_208, arg1_208, arg2_208)
	local var0_208 = var1_0.wsMap.map:GetFleet(arg1_208.id)
	local var1_208 = var1_0.wsMap:GetFleet(var0_208)

	seriesAsync({
		function(arg0_209)
			var1_208:PlayModelAction(arg1_208.anim, arg1_208.duration, arg0_209)
		end
	}, function()
		var1_208:FlushModelAction()
		arg0_208:OpDone()
		arg2_208()
	end)
end

function var0_0.OpFlash(arg0_211, arg1_211, arg2_211, arg3_211, arg4_211, arg5_211)
	local var0_211 = var1_0.rtTop:Find("flash")

	setActive(var0_211, true)
	setImageColor(var0_211, arg4_211)
	setImageAlpha(var0_211, 0)
	var1_0.wsTimer:AddInMapTween(LeanTween.alpha(var0_211, arg4_211.a, arg1_211).uniqueId)
	var1_0.wsTimer:AddInMapTween(LeanTween.alpha(var0_211, 0, arg3_211):setDelay(arg1_211 + arg2_211):setOnComplete(System.Action(function()
		setActive(var0_211, false)
		arg0_211:OpDone()
		arg5_211()
	end)).uniqueId)
end

function var0_0.OpReqBox(arg0_213, arg1_213, arg2_213)
	assert(arg2_213 and arg2_213.type == WorldMapAttachment.TypeBox)
	var1_0:emit(WorldMediator.OnMapOp, var1_0:NewMapOp({
		op = WorldConst.OpReqBox,
		id = arg1_213.id,
		attachment = arg2_213
	}))
end

function var0_0.OpReqBoxDone(arg0_214, arg1_214)
	arg1_214:Apply()
	arg0_214:OpInteractive()
end

function var0_0.OpSetInMap(arg0_215, arg1_215, arg2_215)
	arg0_215:OpDone()
	var1_0:SetInMap(arg1_215, arg2_215)
end

function var0_0.OpSwitchInMap(arg0_216, arg1_216)
	local var0_216 = {}

	table.insert(var0_216, function(arg0_217)
		var1_0:DisplayMap()
		var1_0:DisplayMapUI()
		var1_0:UpdateMapUI()

		return arg0_217()
	end)
	table.insert(var0_216, function(arg0_218)
		var1_0:EaseInMapUI(arg0_218)
	end)
	table.insert(var0_216, function(arg0_219)
		arg0_216:OpDone()

		return arg0_219()
	end)
	seriesAsync(var0_216, arg1_216)
end

function var0_0.OpSwitchOutMap(arg0_220, arg1_220)
	local var0_220 = {}

	table.insert(var0_220, function(arg0_221)
		var1_0:EaseOutMapUI(arg0_221)
	end)
	table.insert(var0_220, function(arg0_222)
		var1_0:HideMap()
		var1_0:HideMapUI()

		return arg0_222()
	end)
	table.insert(var0_220, function(arg0_223)
		arg0_220:OpDone()

		return arg0_223()
	end)
	seriesAsync(var0_220, arg1_220)
end

function var0_0.OpSwitchInWorld(arg0_224, arg1_224)
	local var0_224 = {}

	table.insert(var0_224, function(arg0_225)
		var1_0:DisplayAtlas()
		var1_0:DisplayAtlasUI()

		return arg0_225()
	end)
	table.insert(var0_224, function(arg0_226)
		var1_0:EaseInAtlasUI(arg0_226)
	end)
	table.insert(var0_224, function(arg0_227)
		arg0_224:OpDone()

		return arg0_227()
	end)
	seriesAsync(var0_224, arg1_224)
end

function var0_0.OpSwitchOutWorld(arg0_228, arg1_228)
	local var0_228 = {}

	table.insert(var0_228, function(arg0_229)
		var1_0:EaseOutAtlasUI(arg0_229)
	end)
	table.insert(var0_228, function(arg0_230)
		var1_0:HideAtlas()
		var1_0:HideAtlasUI()

		return arg0_230()
	end)
	table.insert(var0_228, function(arg0_231)
		arg0_228:OpDone()

		return arg0_231()
	end)
	seriesAsync(var0_228, arg1_228)
end

function var0_0.OpRedeploy(arg0_232)
	arg0_232:OpDone()

	local var0_232 = nowWorld()
	local var1_232 = var0_232:GetActiveMap()

	if underscore.any(var1_232:GetNormalFleets(), function(arg0_233)
		return #arg0_233:GetCarries() > 0
	end) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_instruction_redeploy_3"))

		return
	end

	if var1_232:CheckFleetSalvage(true) then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("world_catsearch_fleetcheck"),
			onYes = function()
				var1_232.salvageAutoResult = true

				arg0_232:OpInteractive()
			end
		})
	else
		local var2_232, var3_232 = var0_232:BuildFormationIds()

		arg0_232:OpOpenScene(SCENE.WORLD_FLEET_SELECT, {
			type = var2_232,
			fleets = var3_232
		})
	end
end

function var0_0.OpKillWorld(arg0_235)
	getProxy(ContextProxy):getContextByMediator(WorldMediator).onRemoved = function()
		pg.m02:sendNotification(GAME.WORLD_KILL)
	end

	var1_0:ExitWorld(function()
		arg0_235:OpDone()
	end, true)
end

function var0_0.OpReqMaintenance(arg0_238, arg1_238)
	var1_0:emit(WorldMediator.OnMapOp, var1_0:NewMapOp({
		op = WorldConst.OpReqMaintenance,
		id = arg1_238
	}))
end

function var0_0.OpReqMaintenanceDone(arg0_239, arg1_239)
	arg1_239:Apply()

	local var0_239 = nowWorld()
	local var1_239 = var0_239:GetFleets()

	_.each(var1_239, function(arg0_240)
		arg0_240:ClearDamageLevel()

		for iter0_240, iter1_240 in ipairs(arg0_240:GetShips(true)) do
			iter1_240:Repair()
		end
	end)

	local var2_239 = var0_239:CalcOrderCost(WorldConst.OpReqMaintenance)

	var0_239.staminaMgr:ConsumeStamina(var2_239)
	var0_239:SetReqCDTime(WorldConst.OpReqMaintenance, pg.TimeMgr.GetInstance():GetServerTime())
	var1_0.wsMap:UpdateRangeVisible(false)
	arg0_239:OpShowAllFleetHealth(function()
		arg0_239:OpInteractive()
	end)
end

function var0_0.OpReqVision(arg0_242)
	var1_0:emit(WorldMediator.OnMapOp, var1_0:NewMapOp({
		op = WorldConst.OpReqVision
	}))
end

function var0_0.OpReqVisionDone(arg0_243, arg1_243)
	arg1_243:Apply()

	local var0_243 = nowWorld()
	local var1_243 = var0_243:CalcOrderCost(WorldConst.OpReqVision)

	var0_243.staminaMgr:ConsumeStamina(var1_243)
	var0_243:SetReqCDTime(WorldConst.OpReqVision, pg.TimeMgr.GetInstance():GetServerTime())
	var0_243:GetActiveMap():UpdateVisionFlag(true)
	var1_0.wsMap:UpdateRangeVisible(false)
	arg0_243:OpInteractive()
end

function var0_0.OpReqPressingMap(arg0_244)
	local var0_244 = nowWorld():GetActiveMap()
	local var1_244 = var0_244:GetFleet().id

	var1_0:emit(WorldMediator.OnMapOp, var1_0:NewMapOp({
		op = WorldConst.OpReqPressingMap,
		id = var1_244,
		arg1 = var0_244.id
	}))
end

function var0_0.OpReqPressingMapDone(arg0_245, arg1_245, arg2_245)
	local var0_245 = arg2_245
	local var1_245 = arg1_245.arg1
	local var2_245 = nowWorld()

	if var2_245:GetMap(var1_245):CheckMapPressingDisplay() then
		table.insert(var0_245, 1, function(arg0_246)
			var1_0:BuildCutInAnim("WorldPressingWindow", arg0_246)
		end)
	end

	local var3_245 = var2_245:GetPressingAward(var1_245)

	if var3_245 and var3_245.flag then
		local var4_245 = pg.world_event_complete[var3_245.id].event_reward_slgbuff

		if #var4_245 > 1 then
			local var5_245 = {
				id = var4_245[1],
				floor = var4_245[2],
				before = var2_245:GetGlobalBuff(var4_245[1]):GetFloor()
			}

			if var2_245.isAutoFight then
				var2_245:AddAutoInfo("buffs", var5_245)
			else
				table.insert(var0_245, function(arg0_247)
					var1_0:ShowSubView("GlobalBuff", {
						var5_245,
						arg0_247
					})
				end)
			end

			table.insert(var0_245, function(arg0_248)
				var2_245:AddGlobalBuff(var4_245[1], var4_245[2])
				arg0_248()
			end)
		end
	end

	seriesAsync(var0_245, function()
		arg1_245:Apply()
		var1_0.wsMap:UpdateRangeVisible(false)
		arg0_245:OpInteractive()
	end)
end

function var0_0.OpReqEnterPort(arg0_250)
	local var0_250 = nowWorld()
	local var1_250 = var0_250:GetActiveMap():GetPort()

	if var1_250:IsOpen(var0_250:GetRealm(), var0_250:GetProgress()) then
		var1_0:emit(WorldMediator.OnMapOp, var1_0:NewMapOp({
			op = WorldConst.OpReqEnterPort
		}))
	else
		pg.TipsMgr.GetInstance():ShowTips("port is not open: " .. var1_250.id)
	end
end

function var0_0.OpReqEnterPortDone(arg0_251, arg1_251)
	arg1_251:Apply()
	var1_0:OpenPortLayer()
end

function var0_0.OpReqCatSalvage(arg0_252, arg1_252)
	arg1_252 = arg1_252 or nowWorld():GetActiveMap():CheckFleetSalvage()

	var1_0:emit(WorldMediator.OnMapOp, var1_0:NewMapOp({
		op = WorldConst.OpReqCatSalvage,
		id = arg1_252
	}))
end

function var0_0.OpReqCatSalvageDone(arg0_253, arg1_253, arg2_253)
	local var0_253 = arg2_253
	local var1_253 = nowWorld()

	if var1_253.isAutoFight then
		-- block empty
	else
		table.insert(var0_253, 1, function(arg0_254)
			local var0_254 = var1_253:GetFleet(arg1_253.id):GetRarityState() > 0 and 2 or 1

			pg.NewStoryMgr.GetInstance():Play(pg.gameset.world_catsearch_completed.description[var0_254], arg0_254, true)
		end)
	end

	seriesAsync(var0_253, function()
		arg1_253:Apply()
		arg0_253:OpInteractive()
	end)
end

function var0_0.OpReqSkipBattle(arg0_256, arg1_256)
	var1_0:emit(WorldMediator.OnMapOp, var1_0:NewMapOp({
		op = WorldConst.OpReqSkipBattle,
		id = arg1_256
	}))
end

function var0_0.OpReqSkipBattleDone(arg0_257, arg1_257)
	arg1_257:Apply()
	arg0_257:OpInteractive()
end

function var0_0.OpPlaySound(arg0_258, arg1_258, arg2_258)
	var1_0:PlaySound(arg1_258, arg2_258)
end

function var0_0.OpGuide(arg0_259, arg1_259, arg2_259, arg3_259)
	arg0_259:OpDone()

	local var0_259 = WorldGuider.GetInstance()

	arg1_259 = var0_259:SpecialCheck(arg1_259)
	arg2_259 = arg2_259 == 1 and true or false

	if var0_259:PlayGuide(arg1_259, arg2_259, arg3_259) then
		nowWorld():TriggerAutoFight(false)
	end
end

function var0_0.OpTaskGoto(arg0_260, arg1_260)
	arg0_260:OpDone()

	local var0_260 = nowWorld()
	local var1_260 = var0_260:GetTaskProxy():getTaskById(arg1_260)

	if var1_260:GetFollowingAreaId() then
		arg0_260:OpShowMarkOverview({
			mode = "Task",
			taskId = arg1_260
		})
	elseif var0_260:GetActiveEntrance().id ~= var1_260:GetFollowingEntrance() then
		local var2_260 = var1_260:GetFollowingEntrance()
		local var3_260 = var0_260:GetAtlas():GetTaskDic(var1_260.id)

		var1_0:QueryTransport(function()
			var1_0:EnterTransportWorld({
				entrance = var0_260:GetEntrance(var2_260),
				mapTypes = var3_260[var2_260] and {
					"task_chapter"
				} or {
					"complete_chapter",
					"base_chapter"
				}
			})
		end)
	else
		local var4_260 = var1_260.config.task_goto
		local var5_260 = var1_260.config.following_random
		local var6_260 = var0_260:GetActiveMap()

		if #var5_260 > 0 and not _.any(var5_260, function(arg0_262)
			return arg0_262 == var6_260.id
		end) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_task_goto0"))

			return
		end

		if not var4_260[1] then
			return
		elseif var4_260[1] == 1 then
			local var7_260 = {}

			for iter0_260, iter1_260 in ipairs(var4_260[2]) do
				assert(pg.world_effect_data[iter1_260], "without effect: " .. iter1_260)
				table.insert(var7_260, function(arg0_263)
					local var0_263 = var1_0:NewMapOp({
						op = WorldConst.OpActionTaskGoto,
						effect = pg.world_effect_data[iter1_260]
					})

					arg0_260:OpTriggerEvent(var0_263, arg0_263)
				end)
			end

			seriesAsync(var7_260, function()
				arg0_260:OpInteractive()
			end)
		elseif var4_260[1] == 2 then
			local var8_260 = checkExist(var0_260:GetActiveMap(), {
				"GetPort"
			})
			local var9_260 = var0_260:GetRealm()

			if var9_260 == checkExist(var8_260, {
				"GetRealm"
			}) and checkExist(var8_260, {
				"IsOpen",
				{
					var9_260,
					var0_260:GetProgress()
				}
			}) then
				arg0_260:OpRedeploy()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("world_instruction_redeploy_1"))

				return
			end
		elseif var4_260[1] == 3 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_task_goto3"))

			return
		else
			assert(false, "goto info error:" .. var4_260[1])

			return
		end
	end
end

function var0_0.OpShowAllFleetHealth(arg0_265, arg1_265)
	arg0_265:OpDone()

	if var1_0:GetInMap() then
		for iter0_265, iter1_265 in ipairs(var1_0.wsMap.wsMapFleets) do
			iter1_265:DisplayHealth()
		end
	end

	return existCall(arg1_265)
end

function var0_0.OpAutoSubmitTask(arg0_266, arg1_266)
	var1_0:emit(WorldMediator.OnAutoSubmitTask, arg1_266)
end

function var0_0.OpAutoSubmitTaskDone(arg0_267, arg1_267)
	arg0_267:OpInteractive()
end

function var0_0.OpTrapGravityAnim(arg0_268, arg1_268, arg2_268)
	var1_0:ClearMoveQueue()
	var1_0.wsMap:GetAttachment(arg1_268.row, arg1_268.column, arg1_268.type):TrapAnimDisplay(function()
		arg0_268:OpDone()
		existCall(arg2_268)
	end)
end

function var0_0.OpAutoFightSeach(arg0_270)
	arg0_270:OpDone()

	local var0_270 = nowWorld()
	local var1_270 = var0_270:GetActiveMap()
	local var2_270 = var1_270:GetFleet()
	local var3_270 = var1_270:GetLongMoveRange(var2_270)
	local var4_270
	local var5_270 = 0

	for iter0_270, iter1_270 in ipairs(var3_270) do
		local var6_270 = var1_270:GetCell(iter1_270.row, iter1_270.column):GetEventAttachment()
		local var7_270 = var6_270 and var6_270:GetEventAutoPri()

		if var7_270 and var5_270 < var7_270 and var1_270:CheckEventAutoTrigger(var6_270) then
			var4_270 = iter1_270
			var5_270 = var7_270
		end
	end

	if var4_270 then
		arg0_270:OpLongMoveFleet(var2_270, var4_270.row, var4_270.column)
	elseif var2_270:IsCatSalvage() then
		local var8_270 = var3_270[1]

		arg0_270:OpLongMoveFleet(var2_270, var8_270.row, var8_270.column)
	else
		local var9_270 = {}
		local var10_270 = false

		if var0_270.isAutoSwitch then
			local var11_270 = {
				event_1 = {
					"auto_switch_wait",
					"world_planning_stop_event"
				},
				event_2 = {
					"auto_switch_wait_2",
					"world_planning_stop_event2"
				},
				event_3 = {
					nil,
					"world_planning_stop_event3"
				}
			}
			local var12_270 = var1_270:FindAttachments(WorldMapAttachment.TypeEvent)

			local function var13_270(arg0_271)
				if arg0_271[1] and PlayerPrefs.GetInt(arg0_271[1], 0) == 0 then
					return false
				else
					local var0_271 = {}

					for iter0_271, iter1_271 in ipairs(pg.gameset[arg0_271[2]].description) do
						var0_271[iter1_271] = true
					end

					return underscore.any(var12_270, function(arg0_272)
						return arg0_272:IsAlive() and var0_271[arg0_272.id]
					end)
				end
			end

			switch(PlayerPrefs.GetInt("auto_switch_mode", 0), {
				[WorldSwitchPlanningLayer.MODE_DIFFICULT] = function()
					var10_270 = var1_270.isPressing and not underscore.any({
						"event_1",
						"event_2"
					}, function(arg0_274)
						return var13_270(var11_270[arg0_274])
					end)
				end,
				[WorldSwitchPlanningLayer.MODE_SAFE] = function()
					local var0_275 = PlayerPrefs.GetString("auto_switch_difficult_safe", "only") == "only" and World.ReplacementMapType(var0_270:GetActiveEntrance(), var1_270) == "base_chapter"

					var10_270 = var1_270.isPressing and (var0_275 or not underscore.any({
						"event_1",
						"event_2"
					}, function(arg0_276)
						return var13_270(var11_270[arg0_276])
					end))
				end,
				[WorldSwitchPlanningLayer.MODE_TREASURE] = function()
					var10_270 = World.ReplacementMapType(var0_270:GetActiveEntrance(), var1_270) ~= "teasure_chapter" or not underscore.any({
						"event_1",
						"event_3"
					}, function(arg0_278)
						return var13_270(var11_270[arg0_278])
					end)
				end
			})
		end

		if var10_270 then
			table.insert(var9_270, function(arg0_279)
				arg0_270:OpAutoSwitchMap(arg0_279)
			end)
		end

		seriesAsync(var9_270, function()
			pg.TipsMgr.GetInstance():ShowTips(i18n("autofight_tip_bigworld_suspend"))
			var0_270:TriggerAutoFight(false)
			arg0_270:OpInteractive()
		end)
	end
end

function var0_0.OpAutoSwitchMap(arg0_281, arg1_281)
	arg0_281:OpDone()

	local var0_281 = nowWorld()
	local var1_281 = var0_281:GetAtlas()
	local var2_281 = var0_281:GetActiveEntrance()
	local var3_281 = var0_281:GetActiveMap()
	local var4_281 = false
	local var5_281
	local var6_281

	switch(PlayerPrefs.GetInt("auto_switch_mode", 0), {
		[WorldSwitchPlanningLayer.MODE_DIFFICULT] = function()
			local var0_282 = underscore.values(var1_281.entranceDic)

			table.sort(var0_282, CompareFuncs({
				function(arg0_283)
					return arg0_283:GetBaseMap():GetDanger()
				end,
				function(arg0_284)
					return arg0_284.id
				end
			}))

			local var1_282 = PlayerPrefs.GetString("auto_switch_difficult_base", "all")

			for iter0_282, iter1_282 in ipairs(var0_282) do
				if var1_281.transportDic[iter1_282.id] then
					local var2_282 = iter1_282:GetBaseMap()

					if var2_282:GetPressingLevel() > 0 and not var2_282.isPressing and var2_282:IsMapOpen() and WorldSwitchPlanningLayer.checkDifficultValid(var1_282, var2_282:GetDanger()) and not var5_281 then
						var5_281, var6_281 = var2_282, iter1_282

						break
					end
				end
			end
		end,
		[WorldSwitchPlanningLayer.MODE_SAFE] = function()
			local var0_285 = PlayerPrefs.GetString("auto_switch_difficult_safe", "only")

			switch(var0_285, {
				all = function()
					local var0_286 = var0_281:GetActiveEntrance()
					local var1_286 = {}

					for iter0_286, iter1_286 in pairs(var1_281.entranceDic) do
						if iter1_286 ~= var0_286 and var1_281.transportDic[iter1_286.id] and iter1_286:GetBaseMap().isPressing and #iter1_286.config.complete_chapter > 0 then
							local var2_286 = var0_281:GetMap(iter1_286.config.complete_chapter[1])

							if var2_286:IsMapOpen() then
								table.insert(var1_286, {
									iter1_286,
									var2_286
								})
							end
						end
					end

					if #var1_286 > 0 then
						var6_281, var5_281 = unpack(var1_286[math.floor(math.random() * #var1_286) + 1])
					end
				end,
				only = function()
					var6_281 = var2_281

					local var0_287 = var6_281:GetBaseMapId()
					local var1_287 = var6_281.config.complete_chapter[1]

					assert(var0_287 and var1_287)

					if var3_281.id == var0_287 then
						var5_281 = var0_281:GetMap(var1_287)
					elseif var3_281.id == var1_287 then
						var5_281 = var0_281:GetMap(var0_287)
					else
						assert(false)
					end
				end
			})
		end,
		[WorldSwitchPlanningLayer.MODE_TREASURE] = function()
			if World.ReplacementMapType(var2_281, var3_281) == "teasure_chapter" then
				var4_281 = true

				return
			end

			local var0_288 = underscore.map(var0_281:GetInventoryProxy():GetItemsByType(WorldItem.UsageWorldMap), function(arg0_289)
				return arg0_289.id
			end)
			local var1_288 = underscore.filter(var0_288, function(arg0_290)
				return pg.world_item_data_template[arg0_290].usage_arg[1] ~= 1
			end)
			local var2_288 = underscore.map(var1_288, function(arg0_291)
				local var0_291 = var0_281:FindTreasureEntrance(arg0_291)
				local var1_291

				for iter0_291, iter1_291 in ipairs(var0_291.config.teasure_chapter) do
					if arg0_291 == iter1_291[1] then
						var1_291 = iter1_291[2]

						break
					end
				end

				return {
					var0_281:GetMap(var1_291),
					var0_291
				}
			end)

			table.sort(var2_288, CompareFuncs({
				function(arg0_292)
					return arg0_292[1]:GetDanger()
				end,
				function(arg0_293)
					return arg0_293[1].id
				end
			}))

			local var3_288 = PlayerPrefs.GetString("auto_switch_difficult_treasure", "all")

			for iter0_288, iter1_288 in ipairs(var2_288) do
				local var4_288, var5_288 = unpack(iter1_288)

				if var1_281.transportDic[var5_288.id] and var4_288:IsMapOpen() and WorldSwitchPlanningLayer.checkDifficultValid(var3_288, var4_288:GetDanger()) and not var5_281 then
					var5_281, var6_281 = var4_288, var5_288

					break
				end
			end
		end
	})

	if var4_281 then
		arg0_281:OpReqJumpOut(var3_281.gid, true)
	elseif not var5_281 then
		var0_281:TriggerAutoSwitch(false)
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_automode_start_tip1"))

		return existCall(arg1_281)
	elseif not var5_281.isCost and var0_281.staminaMgr:GetTotalStamina() < var5_281.config.enter_cost then
		var0_281:TriggerAutoSwitch(false)
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_automode_start_tip2"))

		return existCall(arg1_281)
	else
		nowWorld():TriggerAutoSwitch(true)

		if var5_281.active then
			nowWorld():TriggerAutoFight(true)
			arg0_281:OpSetInMap(true)
		else
			arg0_281:OpTransport(var6_281, var5_281)
		end
	end
end

return var0_0
