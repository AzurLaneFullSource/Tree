local var0 = class("WSCommand", import(".WSBaseCommand"))
local var1

function var0.Bind(arg0)
	var1 = arg0
end

function var0.Unbind()
	var1 = nil
end

function var0.OpCall(arg0, arg1)
	arg1(function()
		arg0:OpDone()
	end)
end

function var0.OpSwitchMap(arg0, arg1, arg2)
	local var0 = nowWorld()

	arg2 = defaultValue(arg2, function()
		arg0:OpInteractive()
	end)

	local var1 = var0:GetActiveMap()

	if not var1:GetInMap() then
		arg0:OpDone()
		arg1:Apply()

		local var2 = var0:GetActiveEntrance()
		local var3 = var0:GetActiveMap()

		var0:TriggerAutoFight(var0.isAutoSwitch or World.ReplacementMapType(var2, var3) == "complete_chapter" and getProxy(SettingsProxy):GetWorldFlag("auto_save_area"))
		arg0:OpSetInMap(true, arg2)
	elseif arg1.destMapId ~= var1.id or arg1.destGridId ~= var1.gid then
		local var4 = {}

		table.insert(var4, function(arg0)
			pg.UIMgr.GetInstance():BlurCamera(pg.UIMgr.CameraOverlay, true)
			var1.wsTimer:AddInMapTimer(arg0, 1, 1):Start()
		end)
		table.insert(var4, function(arg0)
			pg.UIMgr.GetInstance():UnblurCamera(pg.UIMgr.CameraOverlay)
			var1:StopAnim()
			var1:HideMap()
			var1:HideMapUI()
			arg0()
		end)
		table.insert(var4, function(arg0)
			arg1:Apply()

			local var0 = var0:GetActiveEntrance()
			local var1 = var0:GetActiveMap()

			var0:TriggerAutoFight(var0.isAutoSwitch or World.ReplacementMapType(var0, var1) == "complete_chapter" and getProxy(SettingsProxy):GetWorldFlag("auto_save_area"))
			assert(var1, "active map not exist")
			parallelAsync({
				function(arg0)
					var1:DisplayEnv(arg0)
				end,
				function(arg0)
					var1:LoadMap(var1, arg0)
				end
			}, arg0)
		end)
		table.insert(var4, function(arg0)
			var1:DisplayMap()
			var1:DisplayMapUI()
			var1:UpdateMapUI()
			arg0()
		end)
		table.insert(var4, function(arg0)
			var1.wsTimer:AddInMapTimer(arg0, 0.5, 1):Start()
		end)
		seriesAsync(var4, function()
			arg0:OpDone()

			return arg2()
		end)
	else
		arg0:OpDone()
		arg1:Apply()
		var1.wsDragProxy:Focus(var1.wsMap:GetFleet().transform.position)

		return arg2()
	end
end

function var0.OpOpenLayer(arg0, arg1)
	arg0:OpDone()
	var1:emit(WorldMediator.OnOpenLayer, arg1)
end

function var0.OpOpenScene(arg0, arg1, ...)
	arg0:OpDone()
	var1:emit(WorldMediator.OnOpenScene, arg1, ...)
end

function var0.OpChangeScene(arg0, arg1, ...)
	arg0:OpDone()
	var1:emit(WorldMediator.OnChangeScene, arg1, ...)
end

function var0.OpInteractive(arg0, arg1)
	local var0 = nowWorld()

	if var0.forceLock then
		return
	end

	arg0:OpDone()

	if var1.contextData.inShop then
		var1.contextData.inShop = false

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("world_shop_init_notice"),
			onYes = function()
				var1:MoveAndOpenLayer({
					inMap = false,
					context = Context.New({
						mediator = WorldShopMediator,
						viewComponent = WorldShopLayer
					})
				})
			end,
			onNo = function()
				arg0:OpInteractive()
			end
		})

		return
	end

	if var0:GetRound() == WorldConst.RoundElse then
		arg0:OpReqRound()

		return
	end

	var1:InteractiveMoveQueue()

	if not var1:GetInMap() then
		return
	end

	local var1 = var0:GetActiveMap()
	local var2 = {}

	table.insert(var2, function(arg0)
		local var0 = var0:GetTaskProxy():getAutoSubmitTaskVO()

		if var0 then
			arg0:OpAutoSubmitTask(var0)
		else
			arg0()
		end
	end)
	table.insert(var2, function(arg0)
		if var1:CheckEventForMsg() then
			local var0 = getProxy(EventProxy)
			local var1 = var0.eventForMsg.id or 0
			local var2 = pg.collection_template[var1] and pg.collection_template[var1].title or ""

			if var0.isAutoFight then
				var0:AddAutoInfo("message", i18n("autofight_entrust", var2))
				arg0()
			else
				local function var3()
					arg0:OpInteractive()
				end

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					hideNo = true,
					content = i18n("event_special_update", var2),
					onYes = var3,
					onNo = var3
				})
			end

			var0.eventForMsg = nil
		else
			arg0()
		end
	end)
	table.insert(var2, function(arg0)
		local var0 = pg.GuildMsgBoxMgr.GetInstance()

		if var0.isAutoFight then
			if var0:GetShouldShowBattleTip() then
				var0:SubmitTask(function(arg0, arg1, arg2)
					var0:AddAutoInfo("message", i18n("autofight_task", pg.task_data_template[arg2].desc))

					if arg1 then
						if arg0 then
							var0:AddAutoInfo("message", i18n("guild_task_autoaccept_1", pg.task_data_template[arg2].desc))
						end

						var0:CancelShouldShowBattleTip()
						arg0()
					else
						var0:NotificationForWorld(arg0)
					end
				end)
			else
				arg0()
			end
		else
			var0:NotificationForWorld(arg0)
		end
	end)
	table.insert(var2, function(arg0)
		local var0 = var1.isLoss

		var1.isLoss = false

		if var0 then
			if WorldConst.IsRookieMap(var1.id) then
				arg0:OpStory(WorldConst.GetRookieBattleLoseStory(), true, false, false, function()
					arg0:OpKillWorld()
				end)

				return
			elseif WorldGuider.GetInstance():PlayGuide("WorldG161") then
				var0:TriggerAutoFight(false)
				arg0:OpInteractive()

				return
			end
		end

		arg0()
	end)
	table.insert(var2, function(arg0)
		if #var1.achievedList > 0 then
			var1:ShowSubView("Achievement", var1.achievedList[1])
		else
			arg0()
		end
	end)
	table.insert(var2, function(arg0)
		if #var1.phaseDisplayList > 0 then
			var1:DisplayPhaseAction(var1.phaseDisplayList)
		else
			arg0()
		end
	end)
	table.insert(var2, function(arg0)
		if var1:CheckFleetSalvage() then
			arg0:OpReqCatSalvage()
		else
			arg0()
		end
	end)
	table.insert(var2, function(arg0)
		local var0 = var0:GetBossProxy()

		if not var0:ShouldTipProgress() then
			arg0()
		else
			var0:ClearTipProgress()
			var0:TriggerAutoFight(false)

			if WorldGuider.GetInstance():PlayGuide("WorldG190") then
				-- block empty
			else
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("world_boss_get_item"),
					onYes = function()
						arg0:OpOpenScene(SCENE.WORLDBOSS)
					end,
					onNo = function()
						arg0:OpInteractive()
					end
				})
			end
		end
	end)
	table.insert(var2, function(arg0)
		local var0 = var1:CheckInteractive()

		if var0 then
			local var1 = var1:GetFleet()

			if var0.type == WorldMapAttachment.TypeEvent then
				if var0:RemainOpEffect() then
					arg0:OpEventOp(var0)
				else
					arg0:OpEvent(var1, var0)
				end
			elseif WorldMapAttachment.IsEnemyType(var0.type) then
				if var0.isAutoFight or arg1 then
					local var2 = var0:GetBattleStageId()
					local var3 = pg.expedition_data_template[var2]

					assert(var3, "expedition_data_template not exist: " .. var2)

					if var0:CheckSkipBattle() then
						arg0:OpReqSkipBattle(var1.id)
					elseif var0.isAutoFight or PlayerPrefs.GetInt("world_skip_precombat", 0) == 1 then
						var1:emit(WorldMediator.OnStart, var2, var1, var0)
					else
						local var4 = pg.world_expedition_data[var2]
						local var5 = var4 and var4.battle_type and var4.battle_type ~= 0
						local var6 = {}

						if var5 then
							var6.mediator = WorldBossInformationMediator
							var6.viewComponent = WorldBossInformationLayer
						else
							var6.mediator = WorldPreCombatMediator
							var6.viewComponent = WorldPreCombatLayer
						end

						arg0:OpOpenLayer(Context.New(var6))
					end
				else
					arg0()
				end
			elseif var0.type == WorldMapAttachment.TypeBox then
				arg0:OpReqBox(var1, var0)
			else
				assert(false, "invalide interactive type: " .. var0.type)
			end
		else
			arg0()
		end
	end)
	table.insert(var2, function(arg0)
		if var1.inLoopAutoFight then
			var1.inLoopAutoFight = false

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				content = i18n("autofight_tip_bigworld_loop"),
				onYes = arg0,
				onNo = arg0
			})
		else
			arg0()
		end
	end)
	table.insert(var2, function(arg0)
		if not var0.isAutoFight and not var0.isAutoSwitch and var0:HasAutoFightDrops() then
			arg0:OpOpenLayer(Context.New({
				mediator = WorldAutoFightRewardMediator,
				viewComponent = WorldAutoFightRewardLayer,
				onRemoved = arg0
			}))
		else
			arg0()
		end
	end)
	seriesAsync(var2, function()
		arg0:OpReqDiscover()
	end)
end

function var0.OpReqDiscover(arg0)
	local var0 = nowWorld():GetActiveMap()
	local var1 = var0:CheckDiscover()

	if #var1 > 0 then
		local var2 = {}
		local var3 = {}

		_.each(var1, function(arg0)
			local var0 = var0:GetCell(arg0.row, arg0.column)

			table.insert(var2, var0)
			_.each(var0.attachments, function(arg0)
				if arg0:ShouldMarkAsLurk() then
					table.insert(var3, arg0)
				end
			end)
		end)
		var1:emit(WorldMediator.OnMapOp, var1:NewMapOp({
			op = WorldConst.OpReqDiscover,
			locations = var1,
			hiddenCells = var2,
			hiddenAttachments = var3
		}))
	else
		arg0:OpDone("OpReqDiscoverDone")
	end
end

function var0.OpReqDiscoverDone(arg0, arg1)
	local var0 = nowWorld()
	local var1 = var0:GetActiveMap()
	local var2 = {}

	if arg1 and #arg1.hiddenAttachments > 0 then
		table.insert(var2, function(arg0)
			arg0:OpAnim(WorldConst.AnimRadar, arg0)
		end)
	end

	seriesAsync(var2, function()
		if arg1 then
			arg1:Apply()
			arg0:OpInteractive()
		elseif var1:CheckMapPressing() then
			arg0:OpReqPressingMap()
		elseif var0:CheckFleetMovable() then
			arg0:OpReadyToMove()
		else
			local var0 = var1:GetFleet()

			if not var1:CheckFleetMovable(var0) and var1:GetFleetTerrain(var0) == WorldMapCell.TerrainWind then
				pg.TipsMgr.GetInstance():ShowTips(i18n("world_wind_move"))
			end
		end
	end)
end

function var0.OpAnim(arg0, arg1, arg2)
	var1:DoAnim(arg1, function()
		arg0:OpDone()
		arg2()
	end)
end

function var0.OpReadyToMove(arg0)
	arg0:OpDone()

	local var0 = var1.wsMap
	local var1 = var0.map
	local var2 = var1:GetFleet()

	if #var2:GetBuffsByTrap(WorldBuff.TrapDisturbance) > 0 then
		local var3 = var1:GetMoveRange(var2)
		local var4 = math.clamp(math.ceil(math.random() * #var3), 1, #var3)

		if var3[var4] then
			var1:ClearMoveQueue()
			arg0:OpReqMoveFleet(var2, var3[var4].row, var3[var4].column)

			return
		end
	end

	local var5 = nowWorld()

	if var5.isAutoFight then
		if #var1.moveQueue > 0 then
			var1:DoQueueMove(var2)
		elseif var1:CheckLostMoveQueueCount() then
			var1:ResetLostMoveQueueCount(true)
			var5:TriggerAutoFight(false)
			arg0:OpInteractive()
		else
			arg0:OpAutoFightSeach()
		end

		return
	end

	if #var1.moveQueue > 0 and var1:CanLongMove(var2) then
		var1:DoQueueMove(var2)

		return
	end

	var1:ClearMoveQueue()
	var0:UpdateRangeVisible(true)

	local var6 = var1.contextData.inPort

	var1.contextData.inPort = false

	if var6 and checkExist(var1, {
		"GetPort"
	}, {
		"IsOpen",
		{
			var5:GetRealm(),
			var5:GetProgress()
		}
	}) then
		arg0:OpReqEnterPort()

		return
	end

	var1:CheckGuideSLG(var1, var2)
end

function var0.OpLongMoveFleet(arg0, arg1, arg2, arg3)
	arg0:OpDone()

	local var0 = nowWorld()
	local var1 = var0:GetActiveMap()

	if var0:CheckFleetMovable() then
		local var2 = {
			row = arg1.row,
			column = arg1.column
		}
		local var3 = {
			row = arg2,
			column = arg3
		}
		local var4, var5 = var1:GetLongMoveRange(arg1)

		if not _.any(var4, function(arg0)
			return arg0.row == var3.row and arg0.column == var3.column
		end) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("destination_not_in_range"))
		else
			local var6 = {}
			local var7 = 0
			local var8

			local function var9(arg0, arg1)
				if arg0.last[arg1] then
					var9(arg0.last[arg1][1], arg0.last[arg1][2])

					var7 = var7 + 1

					table.insert(var6, {
						row = arg0.row,
						column = arg0.column,
						step = var7,
						stay = arg1 == 0
					})
				end
			end

			var9(var5[var3.row][var3.column], 0)
			var1:SetMoveQueue(var6)
			var1:DoQueueMove(arg1)
		end
	end
end

function var0.OpReqMoveFleet(arg0, arg1, arg2, arg3)
	local var0 = nowWorld()
	local var1 = var0:GetActiveMap()

	if var0:CheckFleetMovable() then
		local var2 = {
			row = arg1.row,
			column = arg1.column
		}
		local var3 = {
			row = arg2,
			column = arg3
		}
		local var4

		if var1:IsSign(var3.row, var3.column) then
			local var5, var6 = var1:FindPath(var2, var3)

			if var5 < PathFinding.PrioObstacle then
				var4 = var3
				var3 = var6[#var6 - 1]
			end
		end

		local var7 = var1:GetMoveRange(arg1)

		if _.detect(var7, function(arg0)
			return arg0.row == var3.row and arg0.column == var3.column
		end) then
			local var8
			local var9 = arg1:GetBuffsByTrap(WorldBuff.TrapVortex)

			if #var9 > 0 then
				local var10 = math.random() * 100

				if underscore.all(var9, function(arg0)
					return var10 < arg0:GetTrapParams()[1]
				end) then
					var3.row, var3.column = arg1.row, arg1.column
					var8 = WorldBuff.TrapVortex
				end
			end

			local var11, var12 = var1:FindPath(var2, var3)

			if var11 < PathFinding.PrioObstacle then
				var1:emit(WorldMediator.OnMapOp, var1:NewMapOp({
					op = WorldConst.OpReqMoveFleet,
					id = arg1.id,
					arg1 = var3.row,
					arg2 = var3.column,
					sign = var4,
					trap = var8
				}))

				return
			elseif var11 < PathFinding.PrioForbidden then
				pg.TipsMgr.GetInstance():ShowTips(i18n("destination_can_not_reach_safety"))
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("destination_can_not_reach"))
			end
		else
			local var13 = trap and "world_fleet_in_vortex" or "destination_not_in_range"

			pg.TipsMgr.GetInstance():ShowTips(i18n(var13))
		end
	end

	var1:ClearMoveQueue()
	arg0:OpDone()
end

function var0.OpReqMoveFleetDone(arg0, arg1)
	local var0 = {}
	local var1 = var1.wsMap
	local var2 = var1.map
	local var3 = var2:GetFleet()

	table.insert(var0, function(arg0)
		var1:UpdateRangeVisible(false)

		if var3.row ~= arg1.arg1 or var3.column ~= arg1.arg2 then
			var1:DisplayTargetArrow(arg1.arg1, arg1.arg2)
		end

		arg0:OpActions(arg1.childOps, arg0)
	end)
	table.insert(var0, function(arg0)
		var1:CheckMoveQueue(arg1.path)
		arg0()
	end)

	if arg1.sign then
		table.insert(var0, function(arg0)
			var1:ClearMoveQueue()

			if var3.row == arg1.arg1 and var3.column == arg1.arg2 then
				local var0 = var2:GetCell(arg1.sign.row, arg1.sign.column)

				arg0:OpTriggerSign(var3, var0:GetEventAttachment(), arg0)
			else
				arg0()
			end
		end)
	end

	seriesAsync(var0, function()
		var1:HideTargetArrow()
		arg1:Apply()
		arg0:OpInteractive()
	end)
end

function var0.OpMoveFleet(arg0, arg1, arg2)
	arg2 = var1:DoTopBlock(arg2)

	local var0 = var1.wsMap
	local var1 = var0.map:GetFleet(arg1.id)
	local var2 = var0:GetFleet(var1)
	local var3 = var2.fleet
	local var4 = var0.map:GetCell(var3.row, var3.column)
	local var5 = var0:MovePath(var2, arg1.path, arg1.pos, WorldConst.DirType2, var4:GetTerrain() == WorldMapCell.TerrainWind)

	local function var6(arg0, arg1)
		local var0 = arg1.stepOps[arg0]

		assert(var0, "step op not exist: " .. arg0)

		local var1 = {}

		if #var0.hiddenAttachments > 0 then
			table.insert(var1, function(arg0)
				if arg0 < #arg1.stepOps then
					var5:UpdatePaused(true)
				end

				var1:DoAnim(WorldConst.AnimRadar, function()
					if arg0 < #arg1.stepOps then
						var5:UpdatePaused(false)
					end

					arg0()
				end)
			end)
		end

		seriesAsync(var1, function()
			var0:Apply()

			return existCall(arg1)
		end)
	end

	local function var7(arg0)
		local var0 = arg1.path[arg0 + 1]
		local var1 = var0:GetCell(var0.row, var0.column).transform.position

		var1.wsDragProxy:Focus(var1, var0.duration, LeanTweenType.linear)
	end

	local var8 = 0

	var7(var8)

	local function var9(arg0, arg1)
		var8 = var8 + 1

		var7(var8)
		var1.wsMapRight:UpdateCompassRotation(arg1.path[var8 + 1])
		var6(var8)
	end

	local var10

	local function var11()
		var5:RemoveListener(WSMapPath.EventArrivedStep, var9)
		var5:RemoveListener(WSMapPath.EventArrived, var11)

		var8 = var8 + 1

		var6(var8, function()
			if #arg1.locations > 0 then
				var1:emit(WorldMediator.OnMapOp, var1:NewMapOp({
					op = WorldConst.OpReqDiscover,
					locations = arg1.locations,
					hiddenCells = {},
					hiddenAttachments = {},
					routine = function(arg0)
						arg0:Apply()
						arg0:OpDone()
						arg2()
					end
				}))
			else
				arg0:OpDone()
				arg2()
			end
		end)
	end

	var5:AddListener(WSMapPath.EventArrivedStep, var9)
	var5:AddListener(WSMapPath.EventArrived, var11)

	for iter0, iter1 in ipairs(var3:GetCarries()) do
		local var12 = var0:GetCarryItem(iter1)
		local var13 = var3:BuildCarryPath(iter1, arg1.pos, arg1.path)

		var12:FollowPath(var13)
	end

	var1.wsMapRight:UpdateCompassRotation(arg1.path[1])
end

function var0.OpMoveAttachment(arg0, arg1, arg2)
	arg2 = var1:DoTopBlock(arg2)

	local var0 = var1.wsMap
	local var1 = var0.map
	local var2 = arg1.attachment
	local var3 = var0:GetAttachment(var2.row, var2.column, var2.type)

	var0:FlushMovingAttachment(var3)

	local var4 = 0
	local var5 = var0:MovePath(var3, arg1.path, arg1.pos, var2:GetDirType())

	local function var6(arg0, arg1)
		var4 = var4 + 1

		var0:FlushMovingAttachmentOrder(var3, arg1.path[var4])
	end

	local var7

	local function var8()
		var5:RemoveListener(WSMapPath.EventArrivedStep, var6)
		var5:RemoveListener(WSMapPath.EventArrived, var8)
		arg0:OpDone()
		arg2()
	end

	var5:AddListener(WSMapPath.EventArrivedStep, var6)
	var5:AddListener(WSMapPath.EventArrived, var8)
end

function var0.OpReqRound(arg0)
	var1:emit(WorldMediator.OnMapOp, var1:NewMapOp({
		op = WorldConst.OpReqRound
	}))
end

function var0.OpReqRoundDone(arg0, arg1)
	arg0:OpActions(arg1.childOps, function()
		arg1:Apply()
		arg0:OpInteractive(true)
	end)
end

function var0.OpActions(arg0, arg1, arg2)
	arg0:OpDone()

	local var0 = _.map(arg1 or {}, function(arg0)
		return function(arg0)
			arg0:OpAction(arg0, arg0)
		end
	end)

	seriesAsync(var0, arg2)
end

function var0.OpAction(arg0, arg1, arg2)
	arg0:OpDone()

	local var0 = {}

	if arg1.childOps then
		table.insert(var0, function(arg0)
			arg0:OpActions(arg1.childOps, arg0)
		end)
	end

	if arg1.op == WorldConst.OpActionUpdate then
		table.insert(var0, function(arg0)
			arg1:Apply()
			arg0()
		end)
	elseif arg1.op == WorldConst.OpActionFleetMove then
		table.insert(var0, function(arg0)
			arg0:OpMoveFleet(arg1, function()
				arg1:Apply()
				arg0()
			end)
		end)
	elseif arg1.op == WorldConst.OpActionAttachmentMove then
		table.insert(var0, function(arg0)
			arg0:OpMoveAttachment(arg1, function()
				arg1:Apply()
				arg0()
			end)
		end)
	elseif arg1.op == WorldConst.OpActionAttachmentAnim then
		table.insert(var0, function(arg0)
			arg0:OpAttachmentAnim(arg1, function()
				arg1:Apply()
				arg0()
			end)
		end)
	elseif arg1.op == WorldConst.OpActionFleetAnim then
		table.insert(var0, function(arg0)
			arg0:OpFleetAnim(arg1, function()
				arg1:Apply()
				arg0()
			end)
		end)
	elseif arg1.op == WorldConst.OpActionEventEffect then
		table.insert(var0, function(arg0)
			arg0:OpTriggerEvent(arg1, arg0)
		end)
	elseif arg1.op == WorldConst.OpActionCameraMove then
		table.insert(var0, function(arg0)
			arg0:OpMoveCameraTarget(arg1.attachment, 0.1, function()
				arg1:Apply()
				arg0()
			end)
		end)
	elseif arg1.op == WorldConst.OpActionTrapGravityAnim then
		table.insert(var0, function(arg0)
			arg0:OpTrapGravityAnim(arg1.attachment, function()
				arg1:Apply()
				arg0()
			end)
		end)
	else
		assert(false)
	end

	seriesAsync(var0, arg2)
end

function var0.OpEvent(arg0, arg1, arg2)
	arg0:OpDone()

	local var0 = nowWorld()
	local var1
	local var2
	local var3 = arg2:GetEventEffect()
	local var4 = var3.effect_type
	local var5 = var3.effect_paramater
	local var6 = {}

	if var4 == WorldMapAttachment.EffectEventStoryOption then
		local var7 = var5[1]
		local var8 = var3.autoflag[1]

		if var8 and WorldConst.CheckWorldStorySkip(var7) then
			table.insert(var6, function(arg0)
				arg0(var8)
			end)
		else
			table.insert(var6, function(arg0)
				arg0:OpStory(var7, true, true, var0.isAutoFight and var8 and {
					var8
				} or false, arg0)
			end)
		end

		table.insert(var6, function(arg0, arg1)
			assert(arg1, "without option in story:" .. var5[1])

			local var0 = underscore.detect(var5[2], function(arg0)
				return arg0[1] == arg1
			end)

			if var0 then
				var1 = var0[2]

				arg0()
			else
				arg2.triggered = true

				arg0:OpInteractive()
			end
		end)
	elseif var4 == WorldMapAttachment.EffectEventConsumeItem then
		if var0.isAutoFight then
			-- block empty
		else
			table.insert(var6, function(arg0)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_ITEM_BOX,
					content = i18n("sub_item_warning"),
					items = {
						{
							type = DROP_TYPE_WORLD_ITEM,
							id = var5[1],
							count = var5[2]
						}
					},
					onYes = arg0,
					onNo = function()
						arg2.triggered = true

						arg0:OpInteractive()
					end
				})
			end)
		end

		table.insert(var6, function(arg0)
			if var0:GetInventoryProxy():GetItemCount(var5[1]) < var5[2] then
				var0:TriggerAutoFight(false)

				arg2.triggered = true

				arg0:OpStory(var5[3], true, false, false, function()
					arg0:OpInteractive()
				end)
			else
				arg0()
			end
		end)
	elseif var4 == WorldMapAttachment.EffectEventGuide then
		table.insert(var6, function(arg0)
			if arg2:IsAttachmentFinish() then
				arg0()
			else
				arg0:OpGuide(var5[1], var5[2], function()
					arg2.finishMark = arg2.data

					if var1 then
						arg0:OpInteractive()
					end
				end)
			end
		end)
	elseif var4 == WorldMapAttachment.EffectEventConsumeCarry then
		local var9 = var3.effect_paramater[1] or {}

		if _.any(var9, function(arg0)
			return not arg1:ExistCarry(arg0)
		end) then
			arg2.triggered = true

			var0:TriggerAutoFight(false)

			local var10 = var3.effect_paramater[2]

			if var10 then
				table.insert(var6, function(arg0)
					arg0:OpStory(var10, true, false, false, arg0)
				end)
			end

			table.insert(var6, function(arg0)
				arg0:OpInteractive()
			end)
		end
	elseif var4 == WorldMapAttachment.EffectEventCatSalvage then
		if arg1:GetDisplayCommander() and not arg1:IsCatSalvage() then
			if not var0.isAutoFight then
				table.insert(var6, function(arg0)
					arg0:OpStory(var5[1], true, true, false, function(arg0)
						if arg0 == var5[2] then
							arg0()
						else
							arg2.triggered = true

							arg0:OpInteractive()
						end
					end)
				end)
			end
		else
			arg2.triggered = true

			if not var0.isAutoFight then
				local var11 = pg.gameset.world_catsearch_failure.description[1]

				table.insert(var6, function(arg0)
					arg0:OpStory(var11, true, false, false, arg0)
				end)
			end

			table.insert(var6, function(arg0)
				arg0:OpInteractive()
			end)
		end
	elseif var4 == WorldMapAttachment.EffectEventMsgbox then
		table.insert(var6, function(arg0)
			var0:TriggerAutoFight(false)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n(var5[1]),
				onYes = arg0,
				onNo = var5[1] == 0 and arg0 or function()
					arg2.triggered = true

					arg0:OpInteractive()
				end,
				hideNo = var5[1] == 0
			})
		end)
	elseif var4 == WorldMapAttachment.EffectEventStoryBattle then
		table.insert(var6, function(arg0)
			if arg2:IsAttachmentFinish() then
				arg0()
			else
				var1:emit(WorldMediator.OnStartPerform, var5[1], function()
					arg2.finishMark = arg2.data
				end)
			end
		end)
	end

	seriesAsync(var6, function()
		local var0 = var1:NewMapOp({
			op = WorldConst.OpReqEvent,
			id = arg1.id,
			arg1 = var1,
			arg2 = var2,
			attachment = arg2,
			effect = var3,
			locations = {
				{
					row = arg2.row,
					column = arg2.column
				}
			}
		})

		arg0:OpReqEvent(var0)
	end)
end

function var0.OpReqEvent(arg0, arg1)
	var1:emit(WorldMediator.OnMapOp, arg1)
end

function var0.OpReqEventDone(arg0, arg1)
	arg0:OpTriggerEvent(arg1, function()
		arg0:OpInteractive(true)
	end)
end

function var0.OpEventOp(arg0, arg1)
	arg0:OpDone()

	local var0 = var1:NewMapOp({
		op = WorldConst.OpActionEventOp,
		attachment = arg1,
		effect = arg1:GetOpEffect()
	})

	arg0:OpTriggerEvent(var0, function()
		arg0:OpInteractive()
	end)
end

function var0.OpTriggerEvent(arg0, arg1, arg2)
	arg0:OpDone()

	local var0 = nowWorld()
	local var1 = {}
	local var2 = arg1.effect
	local var3 = var2.effect_type
	local var4 = var2.effect_paramater

	if var3 == WorldMapAttachment.EffectEventStory then
		local var5 = getProxy(WorldProxy)
		local var6 = var4[1]

		if WorldConst.CheckWorldStorySkip(var6) then
			table.insert(var1, function(arg0)
				var1:ReContinueMoveQueue()
				arg0()
			end)
		else
			table.insert(var1, function(arg0)
				arg0:OpStory(var6, true, false, var0.isAutoFight and {} or false, arg0)
			end)
		end

		table.insert(var1, function(arg0)
			arg1:Apply()
			arg0()
		end)
	elseif var3 == WorldMapAttachment.EffectEventTeleport or var3 == WorldMapAttachment.EffectEventTeleportBack then
		local var7 = arg1.attachment

		assert(var7 and var7.type == WorldMapAttachment.TypeEvent)

		local var8 = var0:GetMap(arg1.destMapId)
		local var9 = arg1.effect.effect_paramater[1]

		if var9[#var9] == 1 then
			table.insert(var1, function(arg0)
				var1:ShowTransportMarkOverview({
					ids = {
						arg1.entranceId
					}
				}, arg0)
			end)
		end

		if var1:GetInMap() and var7.config.icon == "chuansong01" then
			table.insert(var1, function(arg0)
				arg0:OpAttachmentAnim(var1:NewMapOp({
					anim = "chuansong_open",
					attachment = var7
				}), arg0)
			end)
		end

		table.insert(var1, function(arg0)
			arg0:OpSwitchMap(arg1, arg0)
		end)
	elseif var3 == WorldMapAttachment.EffectEventShowMapMark then
		if var0.isAutoFight then
			-- block empty
		else
			table.insert(var1, function(arg0)
				arg0:OpShowMarkOverview({
					ids = var4
				}, arg0)
			end)
		end

		table.insert(var1, function(arg0)
			arg1:Apply()
			arg0()
		end)
	elseif var3 == WorldMapAttachment.EffectEventCameraMove then
		table.insert(var1, function(arg0)
			arg0:OpMoveCamera(var4[1], var4[2], function()
				arg1:Apply()
				arg0()
			end)
		end)
	elseif var3 == WorldMapAttachment.EffectEventShakePlane then
		table.insert(var1, function(arg0)
			arg0:OpShakePlane(var4[1], var4[2], var4[3], var4[4], function()
				arg1:Apply()
				arg0()
			end)
		end)
	elseif var3 == WorldMapAttachment.EffectEventBlink1 or var3 == WorldMapAttachment.EffectEventBlink2 then
		table.insert(var1, function(arg0)
			var0:TriggerAutoFight(false)
			arg0:OpActions(arg1.childOps, function()
				arg1:Apply()
				arg0()
			end)
		end)
	elseif var3 == WorldMapAttachment.EffectEventFlash then
		table.insert(var1, function(arg0)
			local var0 = Color.New(var4[4][1] / 255, var4[4][2] / 255, var4[4][3] / 255, var4[4][4] / 255)

			arg0:OpFlash(var4[1], var4[2], var4[3], var0, function()
				arg1:Apply()
				arg0()
			end)
		end)
	elseif var3 == WorldMapAttachment.EffectEventShipBuff then
		table.insert(var1, function(arg0)
			arg1:Apply()
			arg0()
		end)
	elseif var3 == WorldMapAttachment.EffectEventHelp then
		if var0.isAutoFight then
			-- block empty
		else
			table.insert(var1, function(arg0)
				local var0 = WorldConst.BuildHelpTips(var0:GetProgress())

				var0.defaultpage = var4[1]

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_HELP,
					helps = var0,
					weight = LayerWeightConst.SECOND_LAYER,
					onClose = arg0
				})
			end)
		end

		table.insert(var1, function(arg0)
			arg1:Apply()
			arg0()
		end)
	elseif var3 == WorldMapAttachment.EffectEventProgress then
		table.insert(var1, function(arg0)
			arg0:OpActions(arg1.childOps, function()
				arg1:Apply()
				arg0()
			end)
		end)
	elseif var3 == WorldMapAttachment.EffectEventReturn2World then
		table.insert(var1, function(arg0)
			var0:TriggerAutoFight(false)
			arg0:OpSetInMap(false, function()
				arg1:Apply()
				arg0()
			end)
		end)
	elseif var3 == WorldMapAttachment.EffectEventShowPort then
		table.insert(var1, function(arg0)
			arg1:Apply()
			var0:TriggerAutoFight(false)
			var1:OpenPortLayer({
				page = var4[1]
			})
			arg0()
		end)
	elseif var3 == WorldMapAttachment.EffectEventGlobalBuff then
		local var10 = {
			id = var4[1],
			floor = var4[2],
			before = var0:GetGlobalBuff(var4[1]):GetFloor()
		}

		if var0.isAutoFight then
			var0:AddAutoInfo("buffs", var10)
		else
			table.insert(var1, function(arg0)
				var1:ShowSubView("GlobalBuff", {
					var10,
					arg0
				})
			end)
		end

		table.insert(var1, function(arg0)
			arg1:Apply()
			arg0()
		end)
	elseif var3 == WorldMapAttachment.EffectEventSound then
		table.insert(var1, function(arg0)
			arg0:OpPlaySound(var4[1], function()
				arg1:Apply()
				arg0()
			end)
		end)
	elseif var3 == WorldMapAttachment.EffectEventHelpLayer then
		table.insert(var1, function(arg0)
			var0:TriggerAutoFight(false)
			arg1:Apply()
			arg0:OpOpenLayer(Context.New({
				mediator = WorldHelpMediator,
				viewComponent = WorldHelpLayer,
				data = {
					titleId = var4[1],
					pageId = var4[2]
				},
				onRemoved = arg0
			}))
		end)
	elseif var3 == WorldMapAttachment.EffectEventFleetShipHP then
		table.insert(var1, function(arg0)
			arg1:Apply()

			if var4[1] > 0 then
				arg0:OpShowAllFleetHealth(arg0)
			else
				arg0()
			end
		end)
	elseif var3 == WorldMapAttachment.EffectEventCatSalvage then
		table.insert(var1, function(arg0)
			arg1:Apply()
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_catsearch_success"))
			arg0()
		end)
	elseif var3 == WorldMapAttachment.EffectEventTeleportEvent then
		table.insert(var1, function(arg0)
			arg1:Apply()

			local var0 = var1.wsMap:GetFleet()

			var1.wsDragProxy:Focus(var0.transform.position, nil, LeanTweenType.easeInOutSine, arg0)
		end)
	else
		table.insert(var1, function(arg0)
			arg1:Apply()
			arg0()
		end)
	end

	seriesAsync(var1, arg2)
end

function var0.OpReqRetreat(arg0, arg1)
	local var0 = nowWorld():GetActiveMap():GetCell(arg1.row, arg1.column)

	assert(var0:ExistEnemy())

	local var1 = var0:GetAliveAttachment()

	var1:emit(WorldMediator.OnMapOp, var1:NewMapOp({
		op = WorldConst.OpReqRetreat,
		id = arg1.id,
		attachment = var1
	}))
end

function var0.OpReqRetreatDone(arg0, arg1)
	local var0 = {}

	table.insert(var0, function(arg0)
		arg0:OpActions(arg1.childOps, arg0)
	end)
	seriesAsync(var0, function()
		arg1:Apply()
		arg0:OpInteractive()
	end)
end

function var0.OpTransport(arg0, arg1, arg2)
	arg0:OpDone()

	local var0 = nowWorld()
	local var1 = var0:GetActiveMap()

	if not var0:IsSystemOpen(WorldConst.SystemOutMap) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("word_systemClose"))
	elseif not arg2:IsMapOpen() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_map_not_open"))
	else
		arg0:OpReqTransport(var1:GetFleet(), arg1, arg2)
	end
end

function var0.OpReqTransport(arg0, arg1, arg2, arg3)
	var1:emit(WorldMediator.OnMapOp, var1:NewMapOp({
		op = WorldConst.OpReqTransport,
		id = arg1.id,
		arg1 = arg3.id,
		arg2 = arg2.id,
		locations = {
			arg3:CalcTransportPos(nowWorld():GetActiveEntrance(), arg2)
		}
	}))
end

function var0.OpReqTransportDone(arg0, arg1)
	local var0 = {}

	seriesAsync(var0, function()
		arg0:OpSwitchMap(arg1)
	end)
end

function var0.OpReqSub(arg0, arg1)
	assert(nowWorld():CanCallSubmarineSupport())

	var1.subCallback = arg1

	var1:emit(WorldMediator.OnMapOp, var1:NewMapOp({
		op = WorldConst.OpReqSub,
		id = nowWorld():GetSubmarineFleet().id
	}))
end

function var0.OpReqSubDone(arg0, arg1)
	local var0 = nowWorld()
	local var1 = var0:CalcOrderCost(WorldConst.OpReqSub)

	var0.staminaMgr:ConsumeStamina(var1)
	var0:SetReqCDTime(WorldConst.OpReqSub, pg.TimeMgr.GetInstance():GetServerTime())

	local var2 = var0:GetSubmarineFleet():GetFlagShipVO()

	var1:DoStrikeAnim(var2:GetMapStrikeAnim(), var2, function()
		arg1:Apply()

		if var1.subCallback then
			local var0 = var1.subCallback

			var1.subCallback = nil

			var0()
		end
	end)
end

function var0.OpReqJumpOut(arg0, arg1, arg2)
	local var0 = {}

	if not arg2 then
		table.insert(var0, function(arg0)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = pg.world_chapter_template_reset[arg1].tip,
				onYes = arg0,
				onNo = function()
					arg0:OpDone()
				end
			})
		end)
	end

	seriesAsync(var0, function()
		var1:emit(WorldMediator.OnMapOp, var1:NewMapOp({
			op = WorldConst.OpReqJumpOut,
			skipDisplay = arg2
		}))
	end)
end

function var0.OpReqJumpOutDone(arg0, arg1)
	local var0 = {}

	if not arg1.skipDisplay then
		table.insert(var0, function(arg0)
			var1:ShowTransportMarkOverview({
				ids = {
					arg1.entranceId
				}
			}, arg0)
		end)
	end

	seriesAsync(var0, function()
		arg0:OpSwitchMap(arg1)
	end)
end

function var0.OpReqSwitchFleet(arg0, arg1)
	var1:emit(WorldMediator.OnMapOp, var1:NewMapOp({
		op = WorldConst.OpReqSwitchFleet,
		id = arg1.id
	}))
end

function var0.OpReqSwitchFleetDone(arg0, arg1)
	local var0 = nowWorld()
	local var1 = table.indexof(var0.fleets, var0:GetFleet(arg1.id))

	var0:GetActiveMap():UpdateFleetIndex(var1)
	var1.wsMap:UpdateRangeVisible(false)
	arg0:OpInteractive()
end

function var0.OpStory(arg0, arg1, arg2, arg3, arg4, arg5)
	local function var0(arg0, arg1)
		arg0:OpDone()
		existCall(arg5, arg1)
	end

	pg.NewStoryMgr.GetInstance():PlayForWorld(arg1, arg4, var0, arg2, false, tobool(arg4), arg3)
end

function var0.OpTriggerSign(arg0, arg1, arg2, arg3)
	assert(arg2:IsSign())
	arg0:OpDone()

	if arg2:IsAvatar() then
		local var0 = var1.wsMap:GetAttachment(arg2.row, arg2.column, arg2.type)
		local var1 = var1.wsMap:GetFleet()

		if arg2.column ~= var1.fleet.column then
			local var2 = var0:GetModelAngles()

			var2.y = arg2.column < var1.fleet.column and 0 or 180

			var0:UpdateModelAngles(var2)

			local var3 = var1:GetModelAngles()

			var3.y = 180 - var2.y

			var1:UpdateModelAngles(var3)
		end
	end

	local var4 = {}
	local var5 = arg2:GetEventEffects()

	_.each(var5, function(arg0)
		local var0 = arg0.effect_type
		local var1 = arg0.effect_paramater

		if var0 == WorldMapAttachment.EffectEventStoryOptionClient then
			local var2 = var1[1]
			local var3 = arg0.autoflag[1]

			if var3 and WorldConst.CheckWorldStorySkip(var2) then
				table.insert(var4, function(arg0)
					arg0(var3)
				end)
			else
				table.insert(var4, function(arg0)
					arg0:OpStory(var2, true, true, nowWorld().isAutoFight and var3 and {
						var3
					} or false, arg0)
				end)
			end

			table.insert(var4, function(arg0, arg1)
				assert(arg1, "without option in story:" .. var1[1])

				local var0 = _.detect(var1[2], function(arg0)
					return arg0[1] == arg1
				end)

				if var0 and var0[2] > 0 then
					arg0:OpTriggerEvent(var1:NewMapOp({
						attachment = arg2,
						effect = pg.world_effect_data[var0[2]]
					}), arg0)
				else
					arg0()
				end
			end)
		else
			table.insert(var4, function(arg0)
				arg0:OpTriggerEvent(var1:NewMapOp({
					attachment = arg2,
					effect = arg0
				}), arg0)
			end)
		end
	end)
	seriesAsync(var4, arg3)
end

function var0.OpShowMarkOverview(arg0, arg1, arg2)
	var1:emit(WorldMediator.OnOpenLayer, Context.New({
		mediator = WorldOverviewMediator,
		viewComponent = WorldOverviewLayer,
		data = {
			info = arg1
		},
		onRemoved = function()
			arg0:OpDone()

			return existCall(arg2)
		end
	}))
end

function var0.OpFocusTargetEntrance(arg0, arg1)
	arg0:OpDone()

	local var0 = {}

	if var1:GetInMap() then
		table.insert(var0, function(arg0)
			var1:QueryTransport(arg0)
		end)
	end

	seriesAsync(var0, function()
		var1:EnterTransportWorld(arg1)
	end)
end

function var0.OpShowOrderPanel(arg0)
	arg0:OpDone()

	local var0 = nowWorld()

	var1:ShowSubView("OrderPanel", {
		var0:GetActiveEntrance(),
		var0:GetActiveMap(),
		var1.wsMapRight.wsCompass:GetAnchorEulerAngles()
	})
end

function var0.OpShowScannerPanel(arg0, arg1, arg2)
	arg0:OpDone()

	local var0 = nowWorld()

	var1:ShowSubView("ScannerPanel", {
		var0:GetActiveMap(),
		var1.wsDragProxy
	}, {
		arg1,
		arg2
	})
end

function var0.OpMoveCamera(arg0, arg1, arg2, arg3)
	arg3 = var1:DoTopBlock(arg3)

	local var0 = {}

	if arg1 > 0 then
		local var1 = var1.wsMap.map:FindAttachments(WorldMapAttachment.TypeEvent, arg1)

		for iter0, iter1 in ipairs(var1) do
			table.insert(var0, {
				focusPos = function()
					return var1.wsMap:GetAttachment(iter1.row, iter1.column, iter1.type).transform.position
				end,
				row = iter1.row,
				column = iter1.column
			})
		end
	else
		local var2 = var1.wsMap:GetFleet()

		table.insert(var0, {
			focusPos = function()
				return var2.transform.position
			end,
			row = var2.fleet.row,
			column = var2.fleet.column
		})
	end

	local var3 = {}

	for iter2, iter3 in ipairs(var0) do
		table.insert(var3, function(arg0)
			var1.wsMapRight:UpdateCompossView(iter3.row, iter3.column)
			arg0()
		end)
		table.insert(var3, function(arg0)
			var1.wsDragProxy:Focus(iter3.focusPos(), nil, LeanTweenType.easeInOutSine, arg0)
		end)
		table.insert(var3, function(arg0)
			var1.wsTimer:AddInMapTimer(arg0, arg2, 1):Start()
		end)
	end

	seriesAsync(var3, function()
		arg0:OpDone()

		return existCall(arg3)
	end)
end

function var0.OpMoveCameraTarget(arg0, arg1, arg2, arg3)
	arg3 = var1:DoTopBlock(arg3)

	if not arg1 then
		local var0 = var1.wsMap:GetFleet()

		arg1 = {
			row = var0.fleet.row,
			column = var0.fleet.column
		}
	end

	local var1 = {}

	table.insert(var1, function(arg0)
		var1.wsMapRight:UpdateCompossView(arg1.row, arg1.column)
		arg0()
	end)
	table.insert(var1, function(arg0)
		var1.wsDragProxy:Focus(var1.wsMap:GetCell(arg1.row, arg1.column).transform.position, nil, LeanTweenType.easeInOutSine, arg0)
	end)
	table.insert(var1, function(arg0)
		var1.wsTimer:AddInMapTimer(arg0, arg2, 1):Start()
	end)
	seriesAsync(var1, function()
		arg0:OpDone()

		return existCall(arg3)
	end)
end

function var0.OpShakePlane(arg0, arg1, arg2, arg3, arg4, arg5)
	var1.wsDragProxy:ShakePlane(arg1, arg2, arg3, arg4, function()
		arg0:OpDone()

		if arg5 then
			arg5()
		end
	end)
end

function var0.OpAttachmentAnim(arg0, arg1, arg2)
	local var0 = arg1.attachment
	local var1 = var1.wsMap:GetAttachment(var0.row, var0.column, var0.type)

	seriesAsync({
		function(arg0)
			var1:PlayModelAction(arg1.anim, arg1.duration, arg0)
		end
	}, function()
		var1:FlushModelAction()
		arg0:OpDone()
		arg2()
	end)
end

function var0.OpFleetAnim(arg0, arg1, arg2)
	local var0 = var1.wsMap.map:GetFleet(arg1.id)
	local var1 = var1.wsMap:GetFleet(var0)

	seriesAsync({
		function(arg0)
			var1:PlayModelAction(arg1.anim, arg1.duration, arg0)
		end
	}, function()
		var1:FlushModelAction()
		arg0:OpDone()
		arg2()
	end)
end

function var0.OpFlash(arg0, arg1, arg2, arg3, arg4, arg5)
	local var0 = var1.rtTop:Find("flash")

	setActive(var0, true)
	setImageColor(var0, arg4)
	setImageAlpha(var0, 0)
	var1.wsTimer:AddInMapTween(LeanTween.alpha(var0, arg4.a, arg1).uniqueId)
	var1.wsTimer:AddInMapTween(LeanTween.alpha(var0, 0, arg3):setDelay(arg1 + arg2):setOnComplete(System.Action(function()
		setActive(var0, false)
		arg0:OpDone()
		arg5()
	end)).uniqueId)
end

function var0.OpReqBox(arg0, arg1, arg2)
	assert(arg2 and arg2.type == WorldMapAttachment.TypeBox)
	var1:emit(WorldMediator.OnMapOp, var1:NewMapOp({
		op = WorldConst.OpReqBox,
		id = arg1.id,
		attachment = arg2
	}))
end

function var0.OpReqBoxDone(arg0, arg1)
	arg1:Apply()
	arg0:OpInteractive()
end

function var0.OpSetInMap(arg0, arg1, arg2)
	arg0:OpDone()
	var1:SetInMap(arg1, arg2)
end

function var0.OpSwitchInMap(arg0, arg1)
	local var0 = {}

	table.insert(var0, function(arg0)
		var1:DisplayMap()
		var1:DisplayMapUI()
		var1:UpdateMapUI()

		return arg0()
	end)
	table.insert(var0, function(arg0)
		var1:EaseInMapUI(arg0)
	end)
	table.insert(var0, function(arg0)
		arg0:OpDone()

		return arg0()
	end)
	seriesAsync(var0, arg1)
end

function var0.OpSwitchOutMap(arg0, arg1)
	local var0 = {}

	table.insert(var0, function(arg0)
		var1:EaseOutMapUI(arg0)
	end)
	table.insert(var0, function(arg0)
		var1:HideMap()
		var1:HideMapUI()

		return arg0()
	end)
	table.insert(var0, function(arg0)
		arg0:OpDone()

		return arg0()
	end)
	seriesAsync(var0, arg1)
end

function var0.OpSwitchInWorld(arg0, arg1)
	local var0 = {}

	table.insert(var0, function(arg0)
		var1:DisplayAtlas()
		var1:DisplayAtlasUI()

		return arg0()
	end)
	table.insert(var0, function(arg0)
		var1:EaseInAtlasUI(arg0)
	end)
	table.insert(var0, function(arg0)
		arg0:OpDone()

		return arg0()
	end)
	seriesAsync(var0, arg1)
end

function var0.OpSwitchOutWorld(arg0, arg1)
	local var0 = {}

	table.insert(var0, function(arg0)
		var1:EaseOutAtlasUI(arg0)
	end)
	table.insert(var0, function(arg0)
		var1:HideAtlas()
		var1:HideAtlasUI()

		return arg0()
	end)
	table.insert(var0, function(arg0)
		arg0:OpDone()

		return arg0()
	end)
	seriesAsync(var0, arg1)
end

function var0.OpRedeploy(arg0)
	arg0:OpDone()

	local var0 = nowWorld()
	local var1 = var0:GetActiveMap()

	if underscore.any(var1:GetNormalFleets(), function(arg0)
		return #arg0:GetCarries() > 0
	end) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_instruction_redeploy_3"))

		return
	end

	if var1:CheckFleetSalvage(true) then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("world_catsearch_fleetcheck"),
			onYes = function()
				var1.salvageAutoResult = true

				arg0:OpInteractive()
			end
		})
	else
		local var2, var3 = var0:BuildFormationIds()

		arg0:OpOpenScene(SCENE.WORLD_FLEET_SELECT, {
			type = var2,
			fleets = var3
		})
	end
end

function var0.OpKillWorld(arg0)
	getProxy(ContextProxy):getContextByMediator(WorldMediator).onRemoved = function()
		pg.m02:sendNotification(GAME.WORLD_KILL)
	end

	var1:ExitWorld(function()
		arg0:OpDone()
	end, true)
end

function var0.OpReqMaintenance(arg0, arg1)
	var1:emit(WorldMediator.OnMapOp, var1:NewMapOp({
		op = WorldConst.OpReqMaintenance,
		id = arg1
	}))
end

function var0.OpReqMaintenanceDone(arg0, arg1)
	arg1:Apply()

	local var0 = nowWorld()
	local var1 = var0:GetFleets()

	_.each(var1, function(arg0)
		arg0:ClearDamageLevel()

		for iter0, iter1 in ipairs(arg0:GetShips(true)) do
			iter1:Repair()
		end
	end)

	local var2 = var0:CalcOrderCost(WorldConst.OpReqMaintenance)

	var0.staminaMgr:ConsumeStamina(var2)
	var0:SetReqCDTime(WorldConst.OpReqMaintenance, pg.TimeMgr.GetInstance():GetServerTime())
	var1.wsMap:UpdateRangeVisible(false)
	arg0:OpShowAllFleetHealth(function()
		arg0:OpInteractive()
	end)
end

function var0.OpReqVision(arg0)
	var1:emit(WorldMediator.OnMapOp, var1:NewMapOp({
		op = WorldConst.OpReqVision
	}))
end

function var0.OpReqVisionDone(arg0, arg1)
	arg1:Apply()

	local var0 = nowWorld()
	local var1 = var0:CalcOrderCost(WorldConst.OpReqVision)

	var0.staminaMgr:ConsumeStamina(var1)
	var0:SetReqCDTime(WorldConst.OpReqVision, pg.TimeMgr.GetInstance():GetServerTime())
	var0:GetActiveMap():UpdateVisionFlag(true)
	var1.wsMap:UpdateRangeVisible(false)
	arg0:OpInteractive()
end

function var0.OpReqPressingMap(arg0)
	local var0 = nowWorld():GetActiveMap()
	local var1 = var0:GetFleet().id

	var1:emit(WorldMediator.OnMapOp, var1:NewMapOp({
		op = WorldConst.OpReqPressingMap,
		id = var1,
		arg1 = var0.id
	}))
end

function var0.OpReqPressingMapDone(arg0, arg1, arg2)
	local var0 = arg2
	local var1 = arg1.arg1
	local var2 = nowWorld()

	if var2:GetMap(var1):CheckMapPressingDisplay() then
		table.insert(var0, 1, function(arg0)
			var1:BuildCutInAnim("WorldPressingWindow", arg0)
		end)
	end

	local var3 = var2:GetPressingAward(var1)

	if var3 and var3.flag then
		local var4 = pg.world_event_complete[var3.id].event_reward_slgbuff

		if #var4 > 1 then
			local var5 = {
				id = var4[1],
				floor = var4[2],
				before = var2:GetGlobalBuff(var4[1]):GetFloor()
			}

			if var2.isAutoFight then
				var2:AddAutoInfo("buffs", var5)
			else
				table.insert(var0, function(arg0)
					var1:ShowSubView("GlobalBuff", {
						var5,
						arg0
					})
				end)
			end

			table.insert(var0, function(arg0)
				var2:AddGlobalBuff(var4[1], var4[2])
				arg0()
			end)
		end
	end

	seriesAsync(var0, function()
		arg1:Apply()
		var1.wsMap:UpdateRangeVisible(false)
		arg0:OpInteractive()
	end)
end

function var0.OpReqEnterPort(arg0)
	local var0 = nowWorld()
	local var1 = var0:GetActiveMap():GetPort()

	if var1:IsOpen(var0:GetRealm(), var0:GetProgress()) then
		var1:emit(WorldMediator.OnMapOp, var1:NewMapOp({
			op = WorldConst.OpReqEnterPort
		}))
	else
		pg.TipsMgr.GetInstance():ShowTips("port is not open: " .. var1.id)
	end
end

function var0.OpReqEnterPortDone(arg0, arg1)
	arg1:Apply()
	var1:OpenPortLayer()
end

function var0.OpReqCatSalvage(arg0, arg1)
	arg1 = arg1 or nowWorld():GetActiveMap():CheckFleetSalvage()

	var1:emit(WorldMediator.OnMapOp, var1:NewMapOp({
		op = WorldConst.OpReqCatSalvage,
		id = arg1
	}))
end

function var0.OpReqCatSalvageDone(arg0, arg1, arg2)
	local var0 = arg2
	local var1 = nowWorld()

	if var1.isAutoFight then
		-- block empty
	else
		table.insert(var0, 1, function(arg0)
			local var0 = var1:GetFleet(arg1.id):GetRarityState() > 0 and 2 or 1

			pg.NewStoryMgr.GetInstance():Play(pg.gameset.world_catsearch_completed.description[var0], arg0, true)
		end)
	end

	seriesAsync(var0, function()
		arg1:Apply()
		arg0:OpInteractive()
	end)
end

function var0.OpReqSkipBattle(arg0, arg1)
	var1:emit(WorldMediator.OnMapOp, var1:NewMapOp({
		op = WorldConst.OpReqSkipBattle,
		id = arg1
	}))
end

function var0.OpReqSkipBattleDone(arg0, arg1)
	arg1:Apply()
	arg0:OpInteractive()
end

function var0.OpPlaySound(arg0, arg1, arg2)
	var1:PlaySound(arg1, arg2)
end

function var0.OpGuide(arg0, arg1, arg2, arg3)
	arg0:OpDone()

	local var0 = WorldGuider.GetInstance()

	arg1 = var0:SpecialCheck(arg1)
	arg2 = arg2 == 1 and true or false

	if var0:PlayGuide(arg1, arg2, arg3) then
		nowWorld():TriggerAutoFight(false)
	end
end

function var0.OpTaskGoto(arg0, arg1)
	arg0:OpDone()

	local var0 = nowWorld()
	local var1 = var0:GetTaskProxy():getTaskById(arg1)

	if var1:GetFollowingAreaId() then
		arg0:OpShowMarkOverview({
			mode = "Task",
			taskId = arg1
		})
	elseif var0:GetActiveEntrance().id ~= var1:GetFollowingEntrance() then
		local var2 = var1:GetFollowingEntrance()
		local var3 = var0:GetAtlas():GetTaskDic(var1.id)

		var1:QueryTransport(function()
			var1:EnterTransportWorld({
				entrance = var0:GetEntrance(var2),
				mapTypes = var3[var2] and {
					"task_chapter"
				} or {
					"complete_chapter",
					"base_chapter"
				}
			})
		end)
	else
		local var4 = var1.config.task_goto
		local var5 = var1.config.following_random
		local var6 = var0:GetActiveMap()

		if #var5 > 0 and not _.any(var5, function(arg0)
			return arg0 == var6.id
		end) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_task_goto0"))

			return
		end

		if not var4[1] then
			return
		elseif var4[1] == 1 then
			local var7 = {}

			for iter0, iter1 in ipairs(var4[2]) do
				assert(pg.world_effect_data[iter1], "without effect: " .. iter1)
				table.insert(var7, function(arg0)
					local var0 = var1:NewMapOp({
						op = WorldConst.OpActionTaskGoto,
						effect = pg.world_effect_data[iter1]
					})

					arg0:OpTriggerEvent(var0, arg0)
				end)
			end

			seriesAsync(var7, function()
				arg0:OpInteractive()
			end)
		elseif var4[1] == 2 then
			local var8 = checkExist(var0:GetActiveMap(), {
				"GetPort"
			})
			local var9 = var0:GetRealm()

			if var9 == checkExist(var8, {
				"GetRealm"
			}) and checkExist(var8, {
				"IsOpen",
				{
					var9,
					var0:GetProgress()
				}
			}) then
				arg0:OpRedeploy()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("world_instruction_redeploy_1"))

				return
			end
		elseif var4[1] == 3 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_task_goto3"))

			return
		else
			assert(false, "goto info error:" .. var4[1])

			return
		end
	end
end

function var0.OpShowAllFleetHealth(arg0, arg1)
	arg0:OpDone()

	if var1:GetInMap() then
		for iter0, iter1 in ipairs(var1.wsMap.wsMapFleets) do
			iter1:DisplayHealth()
		end
	end

	return existCall(arg1)
end

function var0.OpAutoSubmitTask(arg0, arg1)
	var1:emit(WorldMediator.OnAutoSubmitTask, arg1)
end

function var0.OpAutoSubmitTaskDone(arg0, arg1)
	arg0:OpInteractive()
end

function var0.OpTrapGravityAnim(arg0, arg1, arg2)
	var1:ClearMoveQueue()
	var1.wsMap:GetAttachment(arg1.row, arg1.column, arg1.type):TrapAnimDisplay(function()
		arg0:OpDone()
		existCall(arg2)
	end)
end

function var0.OpAutoFightSeach(arg0)
	arg0:OpDone()

	local var0 = nowWorld()
	local var1 = var0:GetActiveMap()
	local var2 = var1:GetFleet()
	local var3 = var1:GetLongMoveRange(var2)
	local var4
	local var5 = 0

	for iter0, iter1 in ipairs(var3) do
		local var6 = var1:GetCell(iter1.row, iter1.column):GetEventAttachment()
		local var7 = var6 and var6:GetEventAutoPri()

		if var7 and var5 < var7 and var1:CheckEventAutoTrigger(var6) then
			var4 = iter1
			var5 = var7
		end
	end

	if var4 then
		arg0:OpLongMoveFleet(var2, var4.row, var4.column)
	elseif var2:IsCatSalvage() then
		local var8 = var3[1]

		arg0:OpLongMoveFleet(var2, var8.row, var8.column)
	else
		local var9 = {}
		local var10 = false

		if var0.isAutoSwitch then
			local var11 = {
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
			local var12 = var1:FindAttachments(WorldMapAttachment.TypeEvent)

			local function var13(arg0)
				if arg0[1] and PlayerPrefs.GetInt(arg0[1], 0) == 0 then
					return false
				else
					local var0 = {}

					for iter0, iter1 in ipairs(pg.gameset[arg0[2]].description) do
						var0[iter1] = true
					end

					return underscore.any(var12, function(arg0)
						return arg0:IsAlive() and var0[arg0.id]
					end)
				end
			end

			switch(PlayerPrefs.GetInt("auto_switch_mode", 0), {
				[WorldSwitchPlanningLayer.MODE_DIFFICULT] = function()
					var10 = var1.isPressing and not underscore.any({
						"event_1",
						"event_2"
					}, function(arg0)
						return var13(var11[arg0])
					end)
				end,
				[WorldSwitchPlanningLayer.MODE_SAFE] = function()
					local var0 = PlayerPrefs.GetString("auto_switch_difficult_safe", "only") == "only" and World.ReplacementMapType(var0:GetActiveEntrance(), var1) == "base_chapter"

					var10 = var1.isPressing and (var0 or not underscore.any({
						"event_1",
						"event_2"
					}, function(arg0)
						return var13(var11[arg0])
					end))
				end,
				[WorldSwitchPlanningLayer.MODE_TREASURE] = function()
					var10 = World.ReplacementMapType(var0:GetActiveEntrance(), var1) ~= "teasure_chapter" or not underscore.any({
						"event_1",
						"event_3"
					}, function(arg0)
						return var13(var11[arg0])
					end)
				end
			})
		end

		if var10 then
			table.insert(var9, function(arg0)
				arg0:OpAutoSwitchMap(arg0)
			end)
		end

		seriesAsync(var9, function()
			pg.TipsMgr.GetInstance():ShowTips(i18n("autofight_tip_bigworld_suspend"))
			var0:TriggerAutoFight(false)
			arg0:OpInteractive()
		end)
	end
end

function var0.OpAutoSwitchMap(arg0, arg1)
	arg0:OpDone()

	local var0 = nowWorld()
	local var1 = var0:GetAtlas()
	local var2 = var0:GetActiveEntrance()
	local var3 = var0:GetActiveMap()
	local var4 = false
	local var5
	local var6

	switch(PlayerPrefs.GetInt("auto_switch_mode", 0), {
		[WorldSwitchPlanningLayer.MODE_DIFFICULT] = function()
			local var0 = underscore.values(var1.entranceDic)

			table.sort(var0, CompareFuncs({
				function(arg0)
					return arg0:GetBaseMap():GetDanger()
				end,
				function(arg0)
					return arg0.id
				end
			}))

			local var1 = PlayerPrefs.GetString("auto_switch_difficult_base", "all")

			for iter0, iter1 in ipairs(var0) do
				if var1.transportDic[iter1.id] then
					local var2 = iter1:GetBaseMap()

					if var2:GetPressingLevel() > 0 and not var2.isPressing and var2:IsMapOpen() and WorldSwitchPlanningLayer.checkDifficultValid(var1, var2:GetDanger()) and not var5 then
						var5, var6 = var2, iter1

						break
					end
				end
			end
		end,
		[WorldSwitchPlanningLayer.MODE_SAFE] = function()
			local var0 = PlayerPrefs.GetString("auto_switch_difficult_safe", "only")

			switch(var0, {
				all = function()
					local var0 = var0:GetActiveEntrance()
					local var1 = {}

					for iter0, iter1 in pairs(var1.entranceDic) do
						if iter1 ~= var0 and var1.transportDic[iter1.id] and iter1:GetBaseMap().isPressing and #iter1.config.complete_chapter > 0 then
							local var2 = var0:GetMap(iter1.config.complete_chapter[1])

							if var2:IsMapOpen() then
								table.insert(var1, {
									iter1,
									var2
								})
							end
						end
					end

					if #var1 > 0 then
						var6, var5 = unpack(var1[math.floor(math.random() * #var1) + 1])
					end
				end,
				only = function()
					var6 = var2

					local var0 = var6:GetBaseMapId()
					local var1 = var6.config.complete_chapter[1]

					assert(var0 and var1)

					if var3.id == var0 then
						var5 = var0:GetMap(var1)
					elseif var3.id == var1 then
						var5 = var0:GetMap(var0)
					else
						assert(false)
					end
				end
			})
		end,
		[WorldSwitchPlanningLayer.MODE_TREASURE] = function()
			if World.ReplacementMapType(var2, var3) == "teasure_chapter" then
				var4 = true

				return
			end

			local var0 = underscore.map(var0:GetInventoryProxy():GetItemsByType(WorldItem.UsageWorldMap), function(arg0)
				return arg0.id
			end)
			local var1 = underscore.filter(var0, function(arg0)
				return pg.world_item_data_template[arg0].usage_arg[1] ~= 1
			end)
			local var2 = underscore.map(var1, function(arg0)
				local var0 = var0:FindTreasureEntrance(arg0)
				local var1

				for iter0, iter1 in ipairs(var0.config.teasure_chapter) do
					if arg0 == iter1[1] then
						var1 = iter1[2]

						break
					end
				end

				return {
					var0:GetMap(var1),
					var0
				}
			end)

			table.sort(var2, CompareFuncs({
				function(arg0)
					return arg0[1]:GetDanger()
				end,
				function(arg0)
					return arg0[1].id
				end
			}))

			local var3 = PlayerPrefs.GetString("auto_switch_difficult_treasure", "all")

			for iter0, iter1 in ipairs(var2) do
				local var4, var5 = unpack(iter1)

				if var1.transportDic[var5.id] and var4:IsMapOpen() and WorldSwitchPlanningLayer.checkDifficultValid(var3, var4:GetDanger()) and not var5 then
					var5, var6 = var4, var5

					break
				end
			end
		end
	})

	if var4 then
		arg0:OpReqJumpOut(var3.gid, true)
	elseif not var5 then
		var0:TriggerAutoSwitch(false)
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_automode_start_tip1"))

		return existCall(arg1)
	elseif not var5.isCost and var0.staminaMgr:GetTotalStamina() < var5.config.enter_cost then
		var0:TriggerAutoSwitch(false)
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_automode_start_tip2"))

		return existCall(arg1)
	else
		nowWorld():TriggerAutoSwitch(true)

		if var5.active then
			nowWorld():TriggerAutoFight(true)
			arg0:OpSetInMap(true)
		else
			arg0:OpTransport(var6, var5)
		end
	end
end

return var0
