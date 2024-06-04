local var0 = class("WorldMediator", import("..base.ContextMediator"))

var0.OnMapOp = "WorldMediator.OnMapOp"
var0.OnMapReq = "WorldMediator.OnMapReq"
var0.OnOpenLayer = "WorldMediator.OnOpenLayer"
var0.OnOpenScene = "WorldMediator.OnOpenScene"
var0.OnChangeScene = "WorldMediator.OnChangeScene"
var0.OnOpenMarkMap = "WorldMediator.OnOpenMarkMap"
var0.OnTriggerTaskGo = "WorldMediator.OnTriggerTaskGo"
var0.OnAutoSubmitTask = "WorldMediator.OnAutoSubmitTask"
var0.OnNotificationOpenLayer = "WorldMediator.OnNotificationOpenLayer"
var0.OnStart = "WorldMediator.OnStart"
var0.OnStartPerform = "WorldMediator.OnStartPerform"
var0.OnStartAutoSwitch = "WorldMediator.OnStartAutoSwitch"
var0.OnMoveAndOpenLayer = "WorldMediator.OnMoveAndOpenLayer"

function var0.register(arg0)
	arg0:bind(var0.OnMapOp, function(arg0, arg1)
		arg0:sendNotification(GAME.WORLD_MAP_OP, arg1)
	end)
	arg0:bind(var0.OnMapReq, function(arg0, arg1, arg2)
		assert(arg0.fetchCallback == nil)

		arg0.fetchCallback = arg2

		arg0:sendNotification(GAME.WORLD_MAP_REQ, {
			mapId = arg1
		})
	end)
	arg0:bind(var0.OnOpenLayer, function(arg0, arg1, arg2)
		arg0:addSubLayers(arg1, false, arg2)
	end)
	arg0:bind(var0.OnOpenScene, function(arg0, arg1, ...)
		local var0 = {}

		if arg0.viewComponent:GetInMap() then
			table.insert(var0, function(arg0)
				arg0.viewComponent:EaseOutMapUI(arg0)
			end)
		else
			table.insert(var0, function(arg0)
				arg0.viewComponent:EaseOutAtlasUI(arg0)
			end)
		end

		local var1 = packEx(...)

		pg.UIMgr.GetInstance():LoadingOn()
		seriesAsync(var0, function()
			pg.UIMgr.GetInstance():LoadingOff()
			arg0:sendNotification(GAME.GO_SCENE, arg1, unpack(var1, 1, var1.len))
		end)
	end)
	arg0:bind(var0.OnChangeScene, function(arg0, arg1, ...)
		local var0 = {}

		if arg0.viewComponent:GetInMap() then
			table.insert(var0, function(arg0)
				arg0.viewComponent:EaseOutMapUI(arg0)
			end)
		else
			table.insert(var0, function(arg0)
				arg0.viewComponent:EaseOutAtlasUI(arg0)
			end)
		end

		local var1 = packEx(...)

		pg.UIMgr.GetInstance():LoadingOn()
		seriesAsync(var0, function()
			pg.UIMgr.GetInstance():LoadingOff()
			arg0:sendNotification(GAME.CHANGE_SCENE, arg1, unpack(var1, 1, var1.len))
		end)
	end)
	arg0:bind(var0.OnStart, function(arg0, arg1, arg2, arg3)
		if arg2.damageLevel > arg3:GetLimitDamageLevel() then
			nowWorld():TriggerAutoFight(false)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideYes = true,
				content = i18n("world_low_morale")
			})
		else
			arg0:sendNotification(GAME.BEGIN_STAGE, {
				system = SYSTEM_WORLD,
				stageId = arg1
			})
		end
	end)
	arg0:bind(var0.OnStartPerform, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_PERFORM,
			stageId = arg1,
			exitCallback = arg2
		})
	end)
	arg0:bind(var0.OnAutoSubmitTask, function(arg0, arg1)
		arg0:sendNotification(GAME.WORLD_AUTO_SUMBMIT_TASK, {
			taskId = arg1.id
		})
	end)
	arg0.viewComponent:SetPlayer(getProxy(PlayerProxy):getRawData())
end

function var0.listNotificationInterests(arg0)
	local var0 = {
		PlayerProxy.UPDATED,
		GAME.WORLD_MAP_OP_DONE,
		GAME.BEGIN_STAGE_DONE,
		GAME.WORLD_STAMINA_EXCHANGE_DONE,
		WorldInventoryMediator.OnMap,
		WorldCollectionMediator.ON_MAP,
		var0.OnOpenMarkMap,
		GAME.WORLD_TRIGGER_TASK_DONE,
		GAME.WORLD_SUMBMIT_TASK_DONE,
		GAME.WORLD_AUTO_SUMBMIT_TASK_DONE,
		GAME.WORLD_ITEM_USE_DONE,
		GAME.WORLD_RETREAT_FLEET,
		var0.OnTriggerTaskGo,
		GAME.WORLD_MAP_REQ_DONE,
		var0.OnNotificationOpenLayer,
		GAME.WORLD_TRIGGER_AUTO_FIGHT,
		GAME.WORLD_TRIGGER_AUTO_SWITCH,
		var0.OnStartAutoSwitch,
		var0.OnMoveAndOpenLayer
	}
	local var1 = WorldGuider.GetInstance():GetWorldGuiderNotifies()

	_.each(var1, function(arg0)
		var0[#var0 + 1] = arg0
	end)

	return var0
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	WorldGuider.GetInstance():WorldGuiderNotifyHandler(var0, var1, arg0.viewComponent)

	local var2 = nowWorld()

	switch(var0, {
		[GAME.WORLD_MAP_OP_DONE] = function()
			local var0 = var1.mapOp
			local var1 = arg0.viewComponent:GetCommand(var0.depth)

			if var1.result ~= 0 then
				var1:OpDone()

				if var1.result == 130 then
					var2.staminaMgr:Show()
				end

				return
			end

			local var2 = {}
			local var3

			arg0.viewComponent:RegistMapOp(var0)

			if #var0.drops > 0 then
				if var0.op == WorldConst.OpReqCatSalvage then
					local var4 = var2:GetFleet(var0.id):GetSalvageScoreRarity()

					if var2.isAutoFight then
						var2:AddAutoInfo("salvage", {
							drops = var0.drops,
							rarity = var4
						})
					else
						table.insert(var2, function(arg0)
							arg0.viewComponent:DisplayAwards(var0.drops, {
								title = "commander",
								titleExtra = tostring(var4)
							}, arg0)
						end)
					end
				elseif var2.isAutoFight then
					var2:AddAutoInfo("drops", var0.drops)
				else
					table.insert(var2, function(arg0)
						arg0.viewComponent:DisplayAwards(var0.drops, {}, arg0)
					end)
				end
			end

			if var0.routine then
				function var3()
					var0.routine(var0)
				end
			else
				local var5 = var0.op

				var0 = WorldConst.ReqName[var5]

				assert(var0, "invalid operation: " .. var5)

				if var5 == WorldConst.OpReqTask then
					-- block empty
				elseif var5 == WorldConst.OpReqPressingMap or var5 == WorldConst.OpReqCatSalvage then
					local var6 = var2

					var2 = {}

					function var3()
						var1:OpDone(var0 .. "Done", var0, var6)
					end
				else
					function var3()
						var1:OpDone(var0 .. "Done", var0)
					end
				end
			end

			seriesAsync(var2, var3)
		end,
		[PlayerProxy.UPDATED] = function()
			arg0.viewComponent:SetPlayer(getProxy(PlayerProxy):getRawData())
		end,
		[GAME.BEGIN_STAGE_DONE] = function()
			arg0:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1)
		end,
		[GAME.WORLD_STAMINA_EXCHANGE_DONE] = function()
			if not arg0.viewComponent:GetInMap() then
				local var0 = arg0.viewComponent.svFloatPanel

				if var0:isShowing() then
					var0:UpdateCost()
				end
			end
		end,
		[WorldInventoryMediator.OnMap] = function()
			arg0.viewComponent:Op("OpFocusTargetEntrance", var1)
		end,
		[WorldCollectionMediator.ON_MAP] = function()
			arg0.viewComponent:Op("OpFocusTargetEntrance", var1)
		end,
		[var0.OnOpenMarkMap] = function()
			arg0.viewComponent:Op("OpShowMarkOverview", var1)
		end,
		[GAME.WORLD_TRIGGER_TASK_DONE] = function()
			pg.WorldToastMgr.GetInstance():ShowToast(var1.task, false)
		end,
		[GAME.WORLD_SUMBMIT_TASK_DONE] = function()
			local var0 = {}
			local var1 = var1.task

			if #var1.config.task_ed > 0 then
				table.insert(var0, function(arg0)
					pg.NewStoryMgr.GetInstance():Play(var1.config.task_ed, arg0, true)
				end)
			end

			if var1.drops and #var1.drops > 0 then
				if var2.isAutoFight then
					var2:AddAutoInfo("drops", var1.drops)
				else
					table.insert(var0, function(arg0)
						arg0.viewComponent:DisplayAwards(var1.drops, {}, arg0)
					end)
				end
			end

			for iter0, iter1 in ipairs(var1.expfleets) do
				table.insert(var0, function(arg0)
					local var0 = iter1.oldships
					local var1 = iter1.newships

					arg0.viewComponent:emit(BaseUI.ON_SHIP_EXP, {
						title = "without word",
						oldShips = var0,
						newShips = var1
					}, arg0)
				end)
			end

			seriesAsync(var0, function()
				pg.WorldToastMgr.GetInstance():ShowToast(var1, true)
			end)
		end,
		[GAME.WORLD_AUTO_SUMBMIT_TASK_DONE] = function()
			local var0 = {}
			local var1 = var1.task

			if #var1.config.task_ed > 0 then
				table.insert(var0, function(arg0)
					pg.NewStoryMgr.GetInstance():Play(var1.config.task_ed, arg0, true)
				end)
			end

			if var1.drops and #var1.drops > 0 then
				if var2.isAutoFight then
					var2:AddAutoInfo("drops", var1.drops)
				else
					table.insert(var0, function(arg0)
						arg0.viewComponent:DisplayAwards(var1.drops, {}, arg0)
					end)
				end
			end

			for iter0, iter1 in ipairs(var1.expfleets) do
				table.insert(var0, function(arg0)
					local var0 = iter1.oldships
					local var1 = iter1.newships

					arg0.viewComponent:emit(BaseUI.ON_SHIP_EXP, {
						title = "without word",
						oldShips = var0,
						newShips = var1
					}, arg0)
				end)
			end

			seriesAsync(var0, function()
				pg.WorldToastMgr.GetInstance():ShowToast(var1, true)
				arg0.viewComponent:GetCommand():OpDone("OpAutoSubmitTaskDone", var1)
			end)
		end,
		[GAME.WORLD_ITEM_USE_DONE] = function()
			local var0 = var1.item
			local var1 = var1.drops
			local var2 = {}

			switch(var0:getWorldItemType(), {
				[WorldItem.UsageWorldClean] = function()
					table.insert(var2, function(arg0)
						local var0 = pg.gameset.world_story_recycle_item.description[1]

						pg.NewStoryMgr.GetInstance():Play(var0, arg0, true)
					end)
					table.insert(var2, function(arg0)
						arg0.viewComponent:GetAllPessingAward(arg0)
					end)
				end,
				[WorldItem.UsageWorldFlag] = function()
					table.insert(var2, function(arg0)
						local var0 = pg.gameset.world_story_treasure_item.description[1]

						pg.NewStoryMgr.GetInstance():Play(var0, arg0, true)
					end)
				end,
				[WorldItem.UsageWorldBuff] = function()
					local var0, var1 = var0:getItemWorldBuff()
					local var2 = var1 * var0.count

					table.insert(var2, function(arg0)
						local var0 = {
							id = var0,
							floor = var2,
							before = var2:GetGlobalBuff(var0):GetFloor()
						}

						arg0.viewComponent:ShowSubView("GlobalBuff", {
							var0,
							arg0
						})
					end)
					table.insert(var2, function(arg0)
						var2:AddGlobalBuff(var0, var2)
						arg0()
					end)
				end,
				[WorldItem.UsageWorldFlag] = function()
					switch(var0:getItemFlagKey(), {
						function()
							table.insert(var2, function(arg0)
								local var0 = var2:GetActiveMap()

								if not var0.visionFlag and var2:IsMapVisioned(var0.id) then
									var0:UpdateVisionFlag(true)
								end

								arg0()
							end)
						end
					})
				end
			})

			if #var1 > 0 then
				if var2.isAutoFight then
					var2:AddAutoInfo("drops", var1)
				else
					table.insert(var2, function(arg0)
						arg0.viewComponent:DisplayAwards(var1, {}, arg0)
					end)
				end
			end

			seriesAsync(var2, function()
				return
			end)
		end,
		[GAME.WORLD_RETREAT_FLEET] = function()
			local var0 = var2:GetFleet()

			arg0.viewComponent:Op("OpReqRetreat", var0)
		end,
		[var0.OnTriggerTaskGo] = function()
			arg0.viewComponent:Op("OpTaskGoto", var1.taskId)
		end,
		[GAME.WORLD_MAP_REQ_DONE] = function()
			assert(arg0.fetchCallback)
			existCall(arg0.fetchCallback)

			arg0.fetchCallback = nil
		end,
		[var0.OnNotificationOpenLayer] = function()
			arg0:addSubLayers(var1.context)
		end,
		[GAME.WORLD_TRIGGER_AUTO_FIGHT] = function()
			arg0.viewComponent:UpdateAutoFightDisplay()
		end,
		[GAME.WORLD_TRIGGER_AUTO_SWITCH] = function()
			arg0.viewComponent:UpdateAutoSwitchDisplay()
		end,
		[var0.OnStartAutoSwitch] = function()
			arg0.viewComponent:StartAutoSwitch()
		end,
		[var0.OnMoveAndOpenLayer] = function()
			arg0.viewComponent:MoveAndOpenLayer(var1)
		end
	})
end

return var0
