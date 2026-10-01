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
var0_0.OnFinishDelegate = "WorldMediator.OnFinishDelegate"

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
	arg0_1:bind(var0_0.OnFinishDelegate, function(arg0_16)
		pg.m02:sendNotification(GAME.END_CHAPTER_AUTO, {})
	end)
	arg0_1.viewComponent:SetPlayer(getProxy(PlayerProxy):getRawData())
end

function var0_0.listNotificationInterests(arg0_17)
	local var0_17 = {
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
		var0_0.OnMoveAndOpenLayer,
		GAME.END_CHAPTER_AUTO_DONE,
		GAME.START_WORLD_CHAPTER_AUTO_DONE
	}
	local var1_17 = WorldGuider.GetInstance():GetWorldGuiderNotifies()

	_.each(var1_17, function(arg0_18)
		var0_17[#var0_17 + 1] = arg0_18
	end)

	return var0_17
end

function var0_0.handleNotification(arg0_19, arg1_19)
	local var0_19 = arg1_19:getName()
	local var1_19 = arg1_19:getBody()

	WorldGuider.GetInstance():WorldGuiderNotifyHandler(var0_19, var1_19, arg0_19.viewComponent)

	local var2_19 = nowWorld()

	switch(var0_19, {
		[GAME.WORLD_MAP_OP_DONE] = function()
			local var0_20 = var1_19.mapOp
			local var1_20 = arg0_19.viewComponent:GetCommand(var0_20.depth)

			if var1_19.result ~= 0 then
				var1_20:OpDone()

				if var1_19.result == 130 then
					var2_19.staminaMgr:Show()
				end

				return
			end

			local var2_20 = {}
			local var3_20

			arg0_19.viewComponent:RegistMapOp(var0_20)

			if #var0_20.drops > 0 then
				if var0_20.op == WorldConst.OpReqCatSalvage then
					local var4_20 = var2_19:GetFleet(var0_20.id):GetSalvageScoreRarity()

					if var2_19.isAutoFight then
						var2_19:AddAutoInfo("salvage", {
							drops = var0_20.drops,
							rarity = var4_20
						})
					else
						table.insert(var2_20, function(arg0_21)
							arg0_19.viewComponent:DisplayAwards(var0_20.drops, {
								title = "commander",
								titleExtra = tostring(var4_20)
							}, arg0_21)
						end)
					end
				elseif var2_19.isAutoFight then
					var2_19:AddAutoInfo("drops", var0_20.drops)
				else
					table.insert(var2_20, function(arg0_22)
						arg0_19.viewComponent:DisplayAwards(var0_20.drops, {}, arg0_22)
					end)
				end
			end

			if var0_20.routine then
				function var3_20()
					var0_20.routine(var0_20)
				end
			else
				local var5_20 = var0_20.op

				var0_19 = WorldConst.ReqName[var5_20]

				assert(var0_19, "invalid operation: " .. var5_20)

				if var5_20 == WorldConst.OpReqTask then
					-- block empty
				elseif var5_20 == WorldConst.OpReqPressingMap or var5_20 == WorldConst.OpReqCatSalvage then
					local var6_20 = var2_20

					var2_20 = {}

					function var3_20()
						var1_20:OpDone(var0_19 .. "Done", var0_20, var6_20)
					end
				else
					function var3_20()
						var1_20:OpDone(var0_19 .. "Done", var0_20)
					end
				end
			end

			seriesAsync(var2_20, var3_20)
		end,
		[PlayerProxy.UPDATED] = function()
			arg0_19.viewComponent:SetPlayer(getProxy(PlayerProxy):getRawData())
		end,
		[GAME.BEGIN_STAGE_DONE] = function()
			arg0_19:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1_19)
		end,
		[GAME.WORLD_STAMINA_EXCHANGE_DONE] = function()
			if not arg0_19.viewComponent:GetInMap() then
				local var0_28 = arg0_19.viewComponent.svFloatPanel

				if var0_28:isShowing() then
					var0_28:UpdateCost()
				end
			end
		end,
		[WorldInventoryMediator.OnMap] = function()
			arg0_19.viewComponent:Op("OpFocusTargetEntrance", var1_19)
		end,
		[WorldCollectionMediator.ON_MAP] = function()
			arg0_19.viewComponent:Op("OpFocusTargetEntrance", var1_19)
		end,
		[var0_0.OnOpenMarkMap] = function()
			arg0_19.viewComponent:Op("OpShowMarkOverview", var1_19)
		end,
		[GAME.WORLD_TRIGGER_TASK_DONE] = function()
			pg.WorldToastMgr.GetInstance():ShowToast(var1_19.task, false)
		end,
		[GAME.WORLD_SUMBMIT_TASK_DONE] = function()
			local var0_33 = {}
			local var1_33 = var1_19.task

			if #var1_33.config.task_ed > 0 then
				table.insert(var0_33, function(arg0_34)
					pg.NewStoryMgr.GetInstance():Play(var1_33.config.task_ed, arg0_34, true)
				end)
			end

			if var1_19.drops and #var1_19.drops > 0 then
				if var2_19.isAutoFight then
					var2_19:AddAutoInfo("drops", var1_19.drops)
				else
					table.insert(var0_33, function(arg0_35)
						arg0_19.viewComponent:DisplayAwards(var1_19.drops, {}, arg0_35)
					end)
				end
			end

			for iter0_33, iter1_33 in ipairs(var1_19.expfleets) do
				table.insert(var0_33, function(arg0_36)
					local var0_36 = iter1_33.oldships
					local var1_36 = iter1_33.newships

					arg0_19.viewComponent:emit(BaseUI.ON_SHIP_EXP, {
						title = "without word",
						oldShips = var0_36,
						newShips = var1_36
					}, arg0_36)
				end)
			end

			seriesAsync(var0_33, function()
				pg.WorldToastMgr.GetInstance():ShowToast(var1_33, true)
			end)
		end,
		[GAME.WORLD_AUTO_SUMBMIT_TASK_DONE] = function()
			local var0_38 = {}
			local var1_38 = var1_19.task

			if #var1_38.config.task_ed > 0 then
				table.insert(var0_38, function(arg0_39)
					pg.NewStoryMgr.GetInstance():Play(var1_38.config.task_ed, arg0_39, true)
				end)
			end

			if var1_19.drops and #var1_19.drops > 0 then
				if var2_19.isAutoFight then
					var2_19:AddAutoInfo("drops", var1_19.drops)
				else
					table.insert(var0_38, function(arg0_40)
						arg0_19.viewComponent:DisplayAwards(var1_19.drops, {}, arg0_40)
					end)
				end
			end

			for iter0_38, iter1_38 in ipairs(var1_19.expfleets) do
				table.insert(var0_38, function(arg0_41)
					local var0_41 = iter1_38.oldships
					local var1_41 = iter1_38.newships

					arg0_19.viewComponent:emit(BaseUI.ON_SHIP_EXP, {
						title = "without word",
						oldShips = var0_41,
						newShips = var1_41
					}, arg0_41)
				end)
			end

			seriesAsync(var0_38, function()
				pg.WorldToastMgr.GetInstance():ShowToast(var1_38, true)
				arg0_19.viewComponent:GetCommand():OpDone("OpAutoSubmitTaskDone", var1_38)
			end)
		end,
		[GAME.WORLD_ITEM_USE_DONE] = function()
			local var0_43 = var1_19.item
			local var1_43 = var1_19.drops
			local var2_43 = {}

			switch(var0_43:getWorldItemType(), {
				[WorldItem.UsageWorldClean] = function()
					table.insert(var2_43, function(arg0_45)
						local var0_45 = pg.gameset.world_story_recycle_item.description[1]

						pg.NewStoryMgr.GetInstance():Play(var0_45, arg0_45, true)
					end)
					table.insert(var2_43, function(arg0_46)
						arg0_19.viewComponent:GetAllPessingAward(arg0_46)
					end)
				end,
				[WorldItem.UsageWorldFlag] = function()
					table.insert(var2_43, function(arg0_48)
						local var0_48 = pg.gameset.world_story_treasure_item.description[1]

						pg.NewStoryMgr.GetInstance():Play(var0_48, arg0_48, true)
					end)
				end,
				[WorldItem.UsageWorldBuff] = function()
					local var0_49, var1_49 = var0_43:getItemWorldBuff()
					local var2_49 = var1_49 * var0_43.count

					table.insert(var2_43, function(arg0_50)
						local var0_50 = {
							id = var0_49,
							floor = var2_49,
							before = var2_19:GetGlobalBuff(var0_49):GetFloor()
						}

						arg0_19.viewComponent:ShowSubView("GlobalBuff", {
							var0_50,
							arg0_50
						})
					end)
					table.insert(var2_43, function(arg0_51)
						var2_19:AddGlobalBuff(var0_49, var2_49)
						arg0_51()
					end)
				end,
				[WorldItem.UsageWorldFlag] = function()
					switch(var0_43:getItemFlagKey(), {
						function()
							table.insert(var2_43, function(arg0_54)
								local var0_54 = var2_19:GetActiveMap()

								if not var0_54.visionFlag and var2_19:IsMapVisioned(var0_54.id) then
									var0_54:UpdateVisionFlag(true)
								end

								arg0_54()
							end)
						end
					})
				end
			})

			if #var1_43 > 0 then
				if var2_19.isAutoFight then
					var2_19:AddAutoInfo("drops", var1_43)
				else
					table.insert(var2_43, function(arg0_55)
						arg0_19.viewComponent:DisplayAwards(var1_43, {}, arg0_55)
					end)
				end
			end

			seriesAsync(var2_43, function()
				return
			end)
		end,
		[GAME.WORLD_RETREAT_FLEET] = function()
			local var0_57 = var2_19:GetFleet()

			arg0_19.viewComponent:Op("OpReqRetreat", var0_57)
		end,
		[var0_0.OnTriggerTaskGo] = function()
			arg0_19.viewComponent:Op("OpTaskGoto", var1_19.taskId)
		end,
		[GAME.WORLD_MAP_REQ_DONE] = function()
			assert(arg0_19.fetchCallback)
			existCall(arg0_19.fetchCallback)

			arg0_19.fetchCallback = nil
		end,
		[var0_0.OnNotificationOpenLayer] = function()
			arg0_19:addSubLayers(var1_19.context)
		end,
		[GAME.WORLD_TRIGGER_AUTO_FIGHT] = function()
			arg0_19.viewComponent:UpdateAutoFightDisplay()
		end,
		[GAME.WORLD_TRIGGER_AUTO_SWITCH] = function()
			arg0_19.viewComponent:UpdateAutoSwitchDisplay()
		end,
		[var0_0.OnStartAutoSwitch] = function()
			arg0_19.viewComponent:StartAutoSwitch()
		end,
		[var0_0.OnMoveAndOpenLayer] = function()
			arg0_19.viewComponent:MoveAndOpenLayer(var1_19)
		end,
		[GAME.END_CHAPTER_AUTO_DONE] = function()
			if var1_19.type ~= ChapterAutoProxy.TYPE.WORLD then
				return
			end

			getProxy(WorldProxy):RemoveDelegateAward()

			local var0_65 = {}

			table.insert(var0_65, function(arg0_66)
				arg0_19.viewComponent:GetDelegatedAwards(var1_19.mapList, var1_19.awards, var1_19.proficiency, arg0_66)
			end)
			seriesAsync(var0_65, function()
				arg0_19.viewComponent:UpdateDelegateDisplay()
			end)
		end,
		[GAME.START_WORLD_CHAPTER_AUTO_DONE] = function()
			arg0_19.viewComponent:UpdateDelegateDisplay()
		end
	})
end

return var0_0
