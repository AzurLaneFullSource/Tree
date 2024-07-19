local var0_0 = class("WorldMediator", import("..base.ContextMediator"))

var0_0.OnMapOp = "WorldMediator.OnMapOp"
var0_0.OnMapReq = "WorldMediator.OnMapReq"
var0_0.OnOpenLayer = "WorldMediator.OnOpenLayer"
var0_0.OnOpenScene = "WorldMediator.OnOpenScene"
var0_0.OnChangeScene = "WorldMediator.OnChangeScene"
var0_0.OnOpenMarkMap = "WorldMediator.OnOpenMarkMap"
var0_0.OnTriggerTaskGo = "WorldMediator.OnTriggerTaskGo"
var0_0.OnAutoSubmitTask = "WorldMediator.OnAutoSubmitTask"
var0_0.OnNotificationOpenLayer = "WorldMediator.OnNotificationOpenLayer"
var0_0.OnStart = "WorldMediator.OnStart"
var0_0.OnStartPerform = "WorldMediator.OnStartPerform"
var0_0.OnStartAutoSwitch = "WorldMediator.OnStartAutoSwitch"
var0_0.OnMoveAndOpenLayer = "WorldMediator.OnMoveAndOpenLayer"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.OnMapOp, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.WORLD_MAP_OP, arg1_2)
	end)
	arg0_1:bind(var0_0.OnMapReq, function(arg0_3, arg1_3, arg2_3)
		assert(arg0_1.fetchCallback == nil)

		arg0_1.fetchCallback = arg2_3

		arg0_1:sendNotification(GAME.WORLD_MAP_REQ, {
			mapId = arg1_3
		})
	end)
	arg0_1:bind(var0_0.OnOpenLayer, function(arg0_4, arg1_4, arg2_4)
		arg0_1:addSubLayers(arg1_4, false, arg2_4)
	end)
	arg0_1:bind(var0_0.OnOpenScene, function(arg0_5, arg1_5, ...)
		local var0_5 = {}

		if arg0_1.viewComponent:GetInMap() then
			table.insert(var0_5, function(arg0_6)
				arg0_1.viewComponent:EaseOutMapUI(arg0_6)
			end)
		else
			table.insert(var0_5, function(arg0_7)
				arg0_1.viewComponent:EaseOutAtlasUI(arg0_7)
			end)
		end

		local var1_5 = packEx(...)

		pg.UIMgr.GetInstance():LoadingOn()
		seriesAsync(var0_5, function()
			pg.UIMgr.GetInstance():LoadingOff()
			arg0_1:sendNotification(GAME.GO_SCENE, arg1_5, unpack(var1_5, 1, var1_5.len))
		end)
	end)
	arg0_1:bind(var0_0.OnChangeScene, function(arg0_9, arg1_9, ...)
		local var0_9 = {}

		if arg0_1.viewComponent:GetInMap() then
			table.insert(var0_9, function(arg0_10)
				arg0_1.viewComponent:EaseOutMapUI(arg0_10)
			end)
		else
			table.insert(var0_9, function(arg0_11)
				arg0_1.viewComponent:EaseOutAtlasUI(arg0_11)
			end)
		end

		local var1_9 = packEx(...)

		pg.UIMgr.GetInstance():LoadingOn()
		seriesAsync(var0_9, function()
			pg.UIMgr.GetInstance():LoadingOff()
			arg0_1:sendNotification(GAME.CHANGE_SCENE, arg1_9, unpack(var1_9, 1, var1_9.len))
		end)
	end)
	arg0_1:bind(var0_0.OnStart, function(arg0_13, arg1_13, arg2_13, arg3_13)
		if arg2_13.damageLevel > arg3_13:GetLimitDamageLevel() then
			nowWorld():TriggerAutoFight(false)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideYes = true,
				content = i18n("world_low_morale")
			})
		else
			arg0_1:sendNotification(GAME.BEGIN_STAGE, {
				system = SYSTEM_WORLD,
				stageId = arg1_13,
				hpRate = arg3_13:GetHP() and arg3_13:GetHP() / arg3_13:GetMaxHP() or nil
			})
		end
	end)
	arg0_1:bind(var0_0.OnStartPerform, function(arg0_14, arg1_14, arg2_14)
		arg0_1:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_PERFORM,
			stageId = arg1_14,
			exitCallback = arg2_14
		})
	end)
	arg0_1:bind(var0_0.OnAutoSubmitTask, function(arg0_15, arg1_15)
		arg0_1:sendNotification(GAME.WORLD_AUTO_SUMBMIT_TASK, {
			taskId = arg1_15.id
		})
	end)
	arg0_1.viewComponent:SetPlayer(getProxy(PlayerProxy):getRawData())
end

function var0_0.listNotificationInterests(arg0_16)
	local var0_16 = {
		PlayerProxy.UPDATED,
		GAME.WORLD_MAP_OP_DONE,
		GAME.BEGIN_STAGE_DONE,
		GAME.WORLD_STAMINA_EXCHANGE_DONE,
		WorldInventoryMediator.OnMap,
		WorldCollectionMediator.ON_MAP,
		var0_0.OnOpenMarkMap,
		GAME.WORLD_TRIGGER_TASK_DONE,
		GAME.WORLD_SUMBMIT_TASK_DONE,
		GAME.WORLD_AUTO_SUMBMIT_TASK_DONE,
		GAME.WORLD_ITEM_USE_DONE,
		GAME.WORLD_RETREAT_FLEET,
		var0_0.OnTriggerTaskGo,
		GAME.WORLD_MAP_REQ_DONE,
		var0_0.OnNotificationOpenLayer,
		GAME.WORLD_TRIGGER_AUTO_FIGHT,
		GAME.WORLD_TRIGGER_AUTO_SWITCH,
		var0_0.OnStartAutoSwitch,
		var0_0.OnMoveAndOpenLayer
	}
	local var1_16 = WorldGuider.GetInstance():GetWorldGuiderNotifies()

	_.each(var1_16, function(arg0_17)
		var0_16[#var0_16 + 1] = arg0_17
	end)

	return var0_16
end

function var0_0.handleNotification(arg0_18, arg1_18)
	local var0_18 = arg1_18:getName()
	local var1_18 = arg1_18:getBody()

	WorldGuider.GetInstance():WorldGuiderNotifyHandler(var0_18, var1_18, arg0_18.viewComponent)

	local var2_18 = nowWorld()

	switch(var0_18, {
		[GAME.WORLD_MAP_OP_DONE] = function()
			local var0_19 = var1_18.mapOp
			local var1_19 = arg0_18.viewComponent:GetCommand(var0_19.depth)

			if var1_18.result ~= 0 then
				var1_19:OpDone()

				if var1_18.result == 130 then
					var2_18.staminaMgr:Show()
				end

				return
			end

			local var2_19 = {}
			local var3_19

			arg0_18.viewComponent:RegistMapOp(var0_19)

			if #var0_19.drops > 0 then
				if var0_19.op == WorldConst.OpReqCatSalvage then
					local var4_19 = var2_18:GetFleet(var0_19.id):GetSalvageScoreRarity()

					if var2_18.isAutoFight then
						var2_18:AddAutoInfo("salvage", {
							drops = var0_19.drops,
							rarity = var4_19
						})
					else
						table.insert(var2_19, function(arg0_20)
							arg0_18.viewComponent:DisplayAwards(var0_19.drops, {
								title = "commander",
								titleExtra = tostring(var4_19)
							}, arg0_20)
						end)
					end
				elseif var2_18.isAutoFight then
					var2_18:AddAutoInfo("drops", var0_19.drops)
				else
					table.insert(var2_19, function(arg0_21)
						arg0_18.viewComponent:DisplayAwards(var0_19.drops, {}, arg0_21)
					end)
				end
			end

			if var0_19.routine then
				function var3_19()
					var0_19.routine(var0_19)
				end
			else
				local var5_19 = var0_19.op

				var0_18 = WorldConst.ReqName[var5_19]

				assert(var0_18, "invalid operation: " .. var5_19)

				if var5_19 == WorldConst.OpReqTask then
					-- block empty
				elseif var5_19 == WorldConst.OpReqPressingMap or var5_19 == WorldConst.OpReqCatSalvage then
					local var6_19 = var2_19

					var2_19 = {}

					function var3_19()
						var1_19:OpDone(var0_18 .. "Done", var0_19, var6_19)
					end
				else
					function var3_19()
						var1_19:OpDone(var0_18 .. "Done", var0_19)
					end
				end
			end

			seriesAsync(var2_19, var3_19)
		end,
		[PlayerProxy.UPDATED] = function()
			arg0_18.viewComponent:SetPlayer(getProxy(PlayerProxy):getRawData())
		end,
		[GAME.BEGIN_STAGE_DONE] = function()
			arg0_18:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1_18)
		end,
		[GAME.WORLD_STAMINA_EXCHANGE_DONE] = function()
			if not arg0_18.viewComponent:GetInMap() then
				local var0_27 = arg0_18.viewComponent.svFloatPanel

				if var0_27:isShowing() then
					var0_27:UpdateCost()
				end
			end
		end,
		[WorldInventoryMediator.OnMap] = function()
			arg0_18.viewComponent:Op("OpFocusTargetEntrance", var1_18)
		end,
		[WorldCollectionMediator.ON_MAP] = function()
			arg0_18.viewComponent:Op("OpFocusTargetEntrance", var1_18)
		end,
		[var0_0.OnOpenMarkMap] = function()
			arg0_18.viewComponent:Op("OpShowMarkOverview", var1_18)
		end,
		[GAME.WORLD_TRIGGER_TASK_DONE] = function()
			pg.WorldToastMgr.GetInstance():ShowToast(var1_18.task, false)
		end,
		[GAME.WORLD_SUMBMIT_TASK_DONE] = function()
			local var0_32 = {}
			local var1_32 = var1_18.task

			if #var1_32.config.task_ed > 0 then
				table.insert(var0_32, function(arg0_33)
					pg.NewStoryMgr.GetInstance():Play(var1_32.config.task_ed, arg0_33, true)
				end)
			end

			if var1_18.drops and #var1_18.drops > 0 then
				if var2_18.isAutoFight then
					var2_18:AddAutoInfo("drops", var1_18.drops)
				else
					table.insert(var0_32, function(arg0_34)
						arg0_18.viewComponent:DisplayAwards(var1_18.drops, {}, arg0_34)
					end)
				end
			end

			for iter0_32, iter1_32 in ipairs(var1_18.expfleets) do
				table.insert(var0_32, function(arg0_35)
					local var0_35 = iter1_32.oldships
					local var1_35 = iter1_32.newships

					arg0_18.viewComponent:emit(BaseUI.ON_SHIP_EXP, {
						title = "without word",
						oldShips = var0_35,
						newShips = var1_35
					}, arg0_35)
				end)
			end

			seriesAsync(var0_32, function()
				pg.WorldToastMgr.GetInstance():ShowToast(var1_32, true)
			end)
		end,
		[GAME.WORLD_AUTO_SUMBMIT_TASK_DONE] = function()
			local var0_37 = {}
			local var1_37 = var1_18.task

			if #var1_37.config.task_ed > 0 then
				table.insert(var0_37, function(arg0_38)
					pg.NewStoryMgr.GetInstance():Play(var1_37.config.task_ed, arg0_38, true)
				end)
			end

			if var1_18.drops and #var1_18.drops > 0 then
				if var2_18.isAutoFight then
					var2_18:AddAutoInfo("drops", var1_18.drops)
				else
					table.insert(var0_37, function(arg0_39)
						arg0_18.viewComponent:DisplayAwards(var1_18.drops, {}, arg0_39)
					end)
				end
			end

			for iter0_37, iter1_37 in ipairs(var1_18.expfleets) do
				table.insert(var0_37, function(arg0_40)
					local var0_40 = iter1_37.oldships
					local var1_40 = iter1_37.newships

					arg0_18.viewComponent:emit(BaseUI.ON_SHIP_EXP, {
						title = "without word",
						oldShips = var0_40,
						newShips = var1_40
					}, arg0_40)
				end)
			end

			seriesAsync(var0_37, function()
				pg.WorldToastMgr.GetInstance():ShowToast(var1_37, true)
				arg0_18.viewComponent:GetCommand():OpDone("OpAutoSubmitTaskDone", var1_37)
			end)
		end,
		[GAME.WORLD_ITEM_USE_DONE] = function()
			local var0_42 = var1_18.item
			local var1_42 = var1_18.drops
			local var2_42 = {}

			switch(var0_42:getWorldItemType(), {
				[WorldItem.UsageWorldClean] = function()
					table.insert(var2_42, function(arg0_44)
						local var0_44 = pg.gameset.world_story_recycle_item.description[1]

						pg.NewStoryMgr.GetInstance():Play(var0_44, arg0_44, true)
					end)
					table.insert(var2_42, function(arg0_45)
						arg0_18.viewComponent:GetAllPessingAward(arg0_45)
					end)
				end,
				[WorldItem.UsageWorldFlag] = function()
					table.insert(var2_42, function(arg0_47)
						local var0_47 = pg.gameset.world_story_treasure_item.description[1]

						pg.NewStoryMgr.GetInstance():Play(var0_47, arg0_47, true)
					end)
				end,
				[WorldItem.UsageWorldBuff] = function()
					local var0_48, var1_48 = var0_42:getItemWorldBuff()
					local var2_48 = var1_48 * var0_42.count

					table.insert(var2_42, function(arg0_49)
						local var0_49 = {
							id = var0_48,
							floor = var2_48,
							before = var2_18:GetGlobalBuff(var0_48):GetFloor()
						}

						arg0_18.viewComponent:ShowSubView("GlobalBuff", {
							var0_49,
							arg0_49
						})
					end)
					table.insert(var2_42, function(arg0_50)
						var2_18:AddGlobalBuff(var0_48, var2_48)
						arg0_50()
					end)
				end,
				[WorldItem.UsageWorldFlag] = function()
					switch(var0_42:getItemFlagKey(), {
						function()
							table.insert(var2_42, function(arg0_53)
								local var0_53 = var2_18:GetActiveMap()

								if not var0_53.visionFlag and var2_18:IsMapVisioned(var0_53.id) then
									var0_53:UpdateVisionFlag(true)
								end

								arg0_53()
							end)
						end
					})
				end
			})

			if #var1_42 > 0 then
				if var2_18.isAutoFight then
					var2_18:AddAutoInfo("drops", var1_42)
				else
					table.insert(var2_42, function(arg0_54)
						arg0_18.viewComponent:DisplayAwards(var1_42, {}, arg0_54)
					end)
				end
			end

			seriesAsync(var2_42, function()
				return
			end)
		end,
		[GAME.WORLD_RETREAT_FLEET] = function()
			local var0_56 = var2_18:GetFleet()

			arg0_18.viewComponent:Op("OpReqRetreat", var0_56)
		end,
		[var0_0.OnTriggerTaskGo] = function()
			arg0_18.viewComponent:Op("OpTaskGoto", var1_18.taskId)
		end,
		[GAME.WORLD_MAP_REQ_DONE] = function()
			assert(arg0_18.fetchCallback)
			existCall(arg0_18.fetchCallback)

			arg0_18.fetchCallback = nil
		end,
		[var0_0.OnNotificationOpenLayer] = function()
			arg0_18:addSubLayers(var1_18.context)
		end,
		[GAME.WORLD_TRIGGER_AUTO_FIGHT] = function()
			arg0_18.viewComponent:UpdateAutoFightDisplay()
		end,
		[GAME.WORLD_TRIGGER_AUTO_SWITCH] = function()
			arg0_18.viewComponent:UpdateAutoSwitchDisplay()
		end,
		[var0_0.OnStartAutoSwitch] = function()
			arg0_18.viewComponent:StartAutoSwitch()
		end,
		[var0_0.OnMoveAndOpenLayer] = function()
			arg0_18.viewComponent:MoveAndOpenLayer(var1_18)
		end
	})
end

return var0_0
