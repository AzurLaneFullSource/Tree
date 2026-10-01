local var0_0 = class("CommissionInfoMediator", import("...base.ContextMediator"))

var0_0.FINISH_EVENT = "CommissionInfoMediator.FINISH_EVENT"
var0_0.FINISH_CLASS = "CommissionInfoMediator.FINISH_CLASS"
var0_0.GET_OIL_RES = "CommissionInfoMediator.GET_OIL_RES"
var0_0.GET_GOLD_RES = "CommissionInfoMediator.GET_GOLD_RES"
var0_0.ON_ACTIVE_EVENT = "CommissionInfoMediator.ON_ACTIVE_EVENT"
var0_0.ON_ACTIVE_CLASS = "CommissionInfoMediator.ON_ACTIVE_CLASS"
var0_0.ON_ACTIVE_TECH = "CommissionInfoMediator.ON_ACTIVE_TECH"
var0_0.ON_TECH_FINISHED = "CommissionInfoMediator.ON_TECH_FINISHED"
var0_0.ON_TECH_QUEUE_FINISH = "CommissionInfoMediator.ON_TECH_QUEUE_FINISH"
var0_0.ON_INS = "CommissionInfoMediator.ON_INS"
var0_0.ON_UR_ACTIVITY = "CommissionInfoMediator:ON_UR_ACTIVITY"
var0_0.ON_CRUSING = "CommissionInfoMediator.ON_CRUSING"
var0_0.GET_CLASS_RES = "CommissionInfoMediator:GET_CLASS_RES"
var0_0.FINISH_CLASS_ALL = "CommissionInfoMediator:FINISH_CLASS_ALL"
var0_0.GO_META_BOSS = "CommissionInfoMediator:GO_META_BOSS"
var0_0.GO_BATTLE = "CommissionInfoMediator.GO_BATTLE"
var0_0.ON_END_CHAPTER_AUTO = "CommissionInfoMediator.ON_END_CHAPTER_AUTO"
var0_0.GO_WORLD = "CommissionInfoMediator.GO_WORLD"

function var0_0.register(arg0_1)
	local var0_1 = getProxy(PlayerProxy)

	arg0_1.viewComponent:setPlayer(var0_1:getData())
	arg0_1:bind(var0_0.GO_WORLD, function(arg0_2, arg1_2, arg2_2)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.WORLD)
	end)
	arg0_1:bind(LevelMediator2.GET_CHAPTER_DROP_SHIP_LIST, function(arg0_3, arg1_3, arg2_3)
		arg0_1:sendNotification(GAME.GET_CHAPTER_DROP_SHIP_LIST, {
			chapterId = arg1_3,
			callback = arg2_3
		})
	end)
	arg0_1:bind(var0_0.ON_END_CHAPTER_AUTO, function(arg0_4)
		local var0_4 = getProxy(ChapterAutoProxy):GetFinishedCnt()

		arg0_1:sendNotification(GAME.END_CHAPTER_AUTO, {
			num = var0_4
		})
	end)
	arg0_1:bind(var0_0.GO_BATTLE, function(arg0_5)
		local var0_5 = getProxy(ChapterProxy):getActiveChapter()

		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, {
			chapterId = var0_5 and var0_5.id,
			mapIdx = var0_5 and var0_5:getConfig("map")
		})
	end)
	arg0_1:bind(var0_0.GO_META_BOSS, function(arg0_6)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.WORLDBOSS)
	end)
	arg0_1:bind(var0_0.ON_UR_ACTIVITY, function(arg0_7)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY, {
			id = ActivityConst.UR_ITEM_ACT_ID
		})
	end)
	arg0_1:bind(var0_0.ON_CRUSING, function(arg0_8)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.CRUSING)
	end)
	arg0_1:bind(var0_0.GET_CLASS_RES, function(arg0_9)
		arg0_1:sendNotification(GAME.HARVEST_CLASS_RES)
	end)
	arg0_1:bind(var0_0.ON_TECH_QUEUE_FINISH, function(arg0_10)
		arg0_1:sendNotification(GAME.FINISH_QUEUE_TECHNOLOGY)
	end)
	arg0_1:bind(var0_0.ON_TECH_FINISHED, function(arg0_11, arg1_11)
		arg0_1:sendNotification(GAME.FINISH_TECHNOLOGY, {
			id = arg1_11.id,
			pool_id = arg1_11.pool_id
		})
	end)
	arg0_1:bind(var0_0.FINISH_EVENT, function(arg0_12, arg1_12, arg2_12, arg3_12)
		arg0_1.contextData.oneStepFinishEventCount = arg2_12
		arg0_1.contextData.inFinished = true

		arg0_1:sendNotification(GAME.EVENT_FINISH, {
			id = arg1_12.id,
			callback = function()
				arg0_1.contextData.inFinished = nil
			end,
			onConfirm = function()
				if arg3_12 then
					arg3_12()
				end

				if arg0_1.contextData.oneStepFinishEventCount then
					arg0_1.contextData.oneStepFinishEventCount = arg0_1.contextData.oneStepFinishEventCount - 1

					if arg0_1.contextData.oneStepFinishEventCount <= 0 then
						MainMetaSkillSequence.New():Execute()
					end
				else
					MainMetaSkillSequence.New():Execute()
				end
			end
		})
	end)
	arg0_1:bind(var0_0.FINISH_CLASS, function(arg0_15, arg1_15, arg2_15, arg3_15)
		arg0_1:sendNotification(GAME.CANCEL_LEARN_TACTICS, {
			shipId = arg1_15,
			type = arg2_15,
			onConfirm = arg3_15
		})
	end)
	arg0_1:bind(var0_0.ON_ACTIVE_EVENT, function(arg0_16)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.EVENT)
	end)
	arg0_1:bind(var0_0.ON_ACTIVE_CLASS, function(arg0_17)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.NAVALTACTICS)
	end)
	arg0_1:bind(var0_0.ON_ACTIVE_TECH, function(arg0_18)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.TECHNOLOGY)
	end)
	arg0_1:bind(var0_0.GET_OIL_RES, function(arg0_19)
		arg0_1:sendNotification(GAME.HARVEST_RES, PlayerConst.ResOil)
	end)
	arg0_1:bind(var0_0.GET_GOLD_RES, function(arg0_20)
		arg0_1:sendNotification(GAME.HARVEST_RES, PlayerConst.ResGold)
	end)
	arg0_1:bind(var0_0.ON_INS, function(arg0_21)
		arg0_1:sendNotification(GAME.ON_OPEN_INS_LAYER)
		arg0_1.viewComponent:emit(BaseUI.ON_CLOSE)
	end)
	arg0_1:bind(var0_0.FINISH_CLASS_ALL, function()
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.NAVALTACTICS)
	end)
	arg0_1:Notify()
end

function var0_0.Notify(arg0_23)
	arg0_23.viewComponent:NotifyIns()
	arg0_23.viewComponent:UpdateLinkPanel()
end

function var0_0.continueClass(arg0_24, arg1_24, arg2_24, arg3_24)
	local var0_24 = getProxy(BayProxy):getShipById(arg1_24)
	local var1_24 = getProxy(BagProxy):getItemsByType(Item.LESSON_TYPE)

	if table.getCount(var1_24 or {}) <= 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("tactics_no_lesson"))

		return
	end

	arg0_24:sendNotification(GAME.GO_SCENE, SCENE.NAVALTACTICS, {
		shipToLesson = {
			shipId = arg1_24,
			skillIndex = var0_24:getSkillIndex(arg2_24),
			index = arg3_24
		}
	})
end

function var0_0.listNotificationInterests(arg0_25)
	return {
		PlayerProxy.UPDATED,
		GAME.HARVEST_RES_DONE,
		GAME.EVENT_LIST_UPDATE,
		GAME.EVENT_FINISH_UPDATE,
		GAME.EVENT_SHOW_AWARDS,
		GAME.CANCEL_LEARN_TACTICS_DONE,
		GAME.FINISH_TECHNOLOGY_DONE,
		GAME.FINISH_QUEUE_TECHNOLOGY_DONE,
		GAME.START_CHAPTER_AUTO_DONE,
		GAME.END_CHAPTER_AUTO_DONE,
		GAME.ZERO_HOUR_OP_DONE
	}
end

function var0_0.handleNotification(arg0_26, arg1_26)
	local var0_26 = arg1_26:getName()
	local var1_26 = arg1_26:getBody()

	if var0_26 == PlayerProxy.UPDATED then
		arg0_26.viewComponent:OnPlayerUpdate(var1_26)
	elseif var0_26 == GAME.HARVEST_RES_DONE then
		local var2_26

		if var1_26.type == 2 then
			var2_26 = i18n("word_oil")
		elseif var1_26.type == 1 then
			var2_26 = i18n("word_gold")
		end

		pg.TipsMgr.GetInstance():ShowTips(i18n("commission_get_award", var2_26, var1_26.outPut))
	elseif var0_26 == GAME.EVENT_LIST_UPDATE or var0_26 == GAME.EVENT_FINISH_UPDATE then
		local var3_26 = getProxy(EventProxy)

		arg0_26.viewComponent:OnUpdateEventInfo()
	elseif var0_26 == GAME.EVENT_SHOW_AWARDS then
		local var4_26

		var4_26 = coroutine.wrap(function()
			if #var1_26.oldShips > 0 then
				arg0_26.viewComponent:emit(BaseUI.ON_SHIP_EXP, {
					title = pg.collection_template[var1_26.eventId].title,
					oldShips = var1_26.oldShips,
					newShips = var1_26.newShips,
					isCri = var1_26.isCri
				}, var4_26)
				coroutine.yield()
			end

			arg0_26.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_26.awards, function()
				if var1_26.onConfirm then
					var1_26.onConfirm()
				end
			end)
		end)

		var4_26()
	elseif var0_26 == GAME.CANCEL_LEARN_TACTICS_DONE then
		arg0_26.viewComponent:OnUpdateClass()

		local var5_26 = var1_26.totalExp
		local var6_26 = var1_26.oldSkill
		local var7_26 = var1_26.newSkill
		local var8_26 = getProxy(BayProxy):getShipById(var1_26.shipId)
		local var9_26 = var7_26.id
		local var10_26

		if var7_26.level > var6_26.level then
			var10_26 = i18n("tactics_end_to_learn", var8_26:getName(), getSkillName(var9_26), var5_26) .. i18n("tactics_skill_level_up", var6_26.level, var7_26.level)
		else
			var10_26 = i18n("tactics_end_to_learn", var8_26:getName(), getSkillName(var9_26), var5_26)
		end

		if pg.skill_data_template[var9_26].max_level <= var7_26.level then
			arg0_26:HandleClassMaxLevel(var8_26, var1_26, var9_26, var5_26)
		else
			local var11_26 = var10_26 .. i18n("tactics_continue_to_learn")

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				modal = true,
				hideNo = false,
				hideClose = true,
				content = var11_26,
				onYes = function()
					arg0_26.openMsgBox = false

					arg0_26:continueClass(var1_26.shipId, var9_26, var1_26.id)
				end,
				onNo = function()
					arg0_26.openMsgBox = false
				end
			})
		end
	elseif var0_26 == GAME.FINISH_TECHNOLOGY_DONE then
		arg0_26.viewComponent:OnUpdateTechnology()

		if #var1_26.items > 0 then
			arg0_26.viewComponent:emit(BaseUI.ON_AWARD, {
				animation = true,
				items = var1_26.items
			})
		end
	elseif var0_26 == GAME.FINISH_QUEUE_TECHNOLOGY_DONE then
		arg0_26.viewComponent:OnUpdateTechnology()

		local var12_26 = {}

		for iter0_26, iter1_26 in ipairs(var1_26.dropInfos) do
			if #iter1_26 > 0 then
				table.insert(var12_26, function(arg0_31)
					arg0_26.viewComponent:emit(BaseUI.ON_AWARD, {
						animation = true,
						items = iter1_26,
						removeFunc = arg0_31
					})
				end)
			end
		end

		seriesAsync(var12_26, function()
			local var0_32 = getProxy(TechnologyProxy):getActivateTechnology()

			if var0_32 and var0_32:isCompleted() then
				arg0_26:sendNotification(GAME.FINISH_TECHNOLOGY, {
					id = var0_32.id,
					pool_id = var0_32.poolId
				})
			end
		end)
	elseif var0_26 == GAME.END_CHAPTER_AUTO_DONE then
		arg0_26:HandleChapterAutoDone(var1_26)
	elseif var0_26 == START_CHAPTER_AUTO_DONE then
		arg0_26.viewComponent:OnUpdateChapterAuto()
	elseif var0_26 == GAME.ZERO_HOUR_OP_DONE then
		arg0_26.viewComponent:OnUpdateChapterAuto()
	end
end

function var0_0.HandleClassMaxLevel(arg0_33, arg1_33, arg2_33, arg3_33, arg4_33)
	local var0_33 = i18n("tactics_end_to_learn", arg1_33:getName(), getSkillName(arg3_33), arg4_33)
	local var1_33 = arg1_33:getSkillList()

	if _.all(var1_33, function(arg0_34)
		return ShipSkill.New(arg1_33.skills[arg0_34]):IsMaxLevel()
	end) then
		local var2_33 = var0_33 .. i18n("tactics_continue_to_learn_other_ship_skill")

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			modal = true,
			hideClose = true,
			content = var2_33,
			onYes = function()
				arg0_33:sendNotification(GAME.GO_SCENE, SCENE.NAVALTACTICS)
			end
		})
	else
		local var3_33 = var0_33 .. i18n("tactics_continue_to_learn_other_skill")

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			modal = true,
			hideClose = true,
			content = var3_33,
			onYes = function()
				arg0_33:sendNotification(GAME.GO_SCENE, SCENE.NAVALTACTICS, {
					shipToLesson = {
						shipId = arg2_33.shipId,
						index = arg2_33.id
					}
				})
			end
		})
	end
end

function var0_0.HandleChapterAutoDone(arg0_37, arg1_37)
	switch(arg1_37.type, {
		[ChapterAutoProxy.TYPE.SLG] = function()
			arg0_37:addSubLayers(Context.New({
				viewComponent = ChapterAutoTotalRewardLayer,
				mediator = ChapterAutoTotalRewardMediator,
				data = {
					rewards = arg1_37.awards,
					totalTimes = arg1_37.allCnt,
					finishTimes = arg1_37.finishCnt,
					proficiency = arg1_37.proficiency,
					onClose = function()
						arg0_37.viewComponent:OnUpdateChapterAuto()
					end
				}
			}), true)
		end,
		[ChapterAutoProxy.TYPE.WORLD] = function()
			local var0_40 = nowWorld()
			local var1_40 = var0_40:GetAtlas()
			local var2_40 = {}

			for iter0_40, iter1_40 in ipairs(arg1_37.mapList) do
				local var3_40 = var0_40.pressingAwardDic[iter1_40]

				if var3_40.flag then
					var0_40:FlagMapPressingAward(iter1_40)
					var1_40:MarkMapTransport(iter1_40)

					local var4_40 = pg.world_event_complete[var3_40.id].event_reward_slgbuff

					if #var4_40 > 0 then
						var2_40[var4_40[1]] = defaultValue(var2_40[var4_40[1]], 0) + var4_40[2]
					end
				end
			end

			local var5_40 = {}

			for iter2_40, iter3_40 in pairs(var2_40) do
				local var6_40 = {
					id = iter2_40,
					floor = iter3_40,
					before = var0_40:GetGlobalBuff(iter2_40):GetFloor()
				}

				table.insert(var5_40, var6_40)
				var0_40:AddGlobalBuff(iter2_40, iter3_40)
			end

			arg0_37:addSubLayers(Context.New({
				viewComponent = WorldChapterAutoRewardLayer,
				mediator = WorldChapterAutoRewardMediator,
				data = {
					awards = arg1_37.awards,
					buffInfos = var5_40,
					proficiency = arg1_37.proficiency,
					onClose = function()
						arg0_37.viewComponent:OnUpdateChapterAuto()
					end
				}
			}), true)
		end
	}, function()
		assert(false, "Unknown commission type: " .. arg1_37.type)
	end)
end

return var0_0
