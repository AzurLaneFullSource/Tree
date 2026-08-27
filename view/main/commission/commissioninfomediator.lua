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

function var0_0.register(arg0_1)
	local var0_1 = getProxy(PlayerProxy)

	arg0_1.viewComponent:setPlayer(var0_1:getData())
	arg0_1:bind(LevelMediator2.GET_CHAPTER_DROP_SHIP_LIST, function(arg0_2, arg1_2, arg2_2)
		arg0_1:sendNotification(GAME.GET_CHAPTER_DROP_SHIP_LIST, {
			chapterId = arg1_2,
			callback = arg2_2
		})
	end)
	arg0_1:bind(var0_0.ON_END_CHAPTER_AUTO, function(arg0_3)
		local var0_3 = getProxy(ChapterAutoProxy):GetFinishedCnt()

		arg0_1:sendNotification(GAME.END_CHAPTER_AUTO, {
			num = var0_3
		})
	end)
	arg0_1:bind(var0_0.GO_BATTLE, function(arg0_4)
		local var0_4 = getProxy(ChapterProxy):getActiveChapter()

		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, {
			chapterId = var0_4 and var0_4.id,
			mapIdx = var0_4 and var0_4:getConfig("map")
		})
	end)
	arg0_1:bind(var0_0.GO_META_BOSS, function(arg0_5)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.WORLDBOSS)
	end)
	arg0_1:bind(var0_0.ON_UR_ACTIVITY, function(arg0_6)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY, {
			id = ActivityConst.UR_ITEM_ACT_ID
		})
	end)
	arg0_1:bind(var0_0.ON_CRUSING, function(arg0_7)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.CRUSING)
	end)
	arg0_1:bind(var0_0.GET_CLASS_RES, function(arg0_8)
		arg0_1:sendNotification(GAME.HARVEST_CLASS_RES)
	end)
	arg0_1:bind(var0_0.ON_TECH_QUEUE_FINISH, function(arg0_9)
		arg0_1:sendNotification(GAME.FINISH_QUEUE_TECHNOLOGY)
	end)
	arg0_1:bind(var0_0.ON_TECH_FINISHED, function(arg0_10, arg1_10)
		arg0_1:sendNotification(GAME.FINISH_TECHNOLOGY, {
			id = arg1_10.id,
			pool_id = arg1_10.pool_id
		})
	end)
	arg0_1:bind(var0_0.FINISH_EVENT, function(arg0_11, arg1_11, arg2_11, arg3_11)
		arg0_1.contextData.oneStepFinishEventCount = arg2_11
		arg0_1.contextData.inFinished = true

		arg0_1:sendNotification(GAME.EVENT_FINISH, {
			id = arg1_11.id,
			callback = function()
				arg0_1.contextData.inFinished = nil
			end,
			onConfirm = function()
				if arg3_11 then
					arg3_11()
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
	arg0_1:bind(var0_0.FINISH_CLASS, function(arg0_14, arg1_14, arg2_14, arg3_14)
		arg0_1:sendNotification(GAME.CANCEL_LEARN_TACTICS, {
			shipId = arg1_14,
			type = arg2_14,
			onConfirm = arg3_14
		})
	end)
	arg0_1:bind(var0_0.ON_ACTIVE_EVENT, function(arg0_15)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.EVENT)
	end)
	arg0_1:bind(var0_0.ON_ACTIVE_CLASS, function(arg0_16)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.NAVALTACTICS)
	end)
	arg0_1:bind(var0_0.ON_ACTIVE_TECH, function(arg0_17)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.TECHNOLOGY)
	end)
	arg0_1:bind(var0_0.GET_OIL_RES, function(arg0_18)
		arg0_1:sendNotification(GAME.HARVEST_RES, PlayerConst.ResOil)
	end)
	arg0_1:bind(var0_0.GET_GOLD_RES, function(arg0_19)
		arg0_1:sendNotification(GAME.HARVEST_RES, PlayerConst.ResGold)
	end)
	arg0_1:bind(var0_0.ON_INS, function(arg0_20)
		arg0_1:sendNotification(GAME.ON_OPEN_INS_LAYER)
		arg0_1.viewComponent:emit(BaseUI.ON_CLOSE)
	end)
	arg0_1:bind(var0_0.FINISH_CLASS_ALL, function()
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.NAVALTACTICS)
	end)
	arg0_1:Notify()
end

function var0_0.Notify(arg0_22)
	arg0_22.viewComponent:NotifyIns()
	arg0_22.viewComponent:UpdateLinkPanel()
end

function var0_0.continueClass(arg0_23, arg1_23, arg2_23, arg3_23)
	local var0_23 = getProxy(BayProxy):getShipById(arg1_23)
	local var1_23 = getProxy(BagProxy):getItemsByType(Item.LESSON_TYPE)

	if table.getCount(var1_23 or {}) <= 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("tactics_no_lesson"))

		return
	end

	arg0_23:sendNotification(GAME.GO_SCENE, SCENE.NAVALTACTICS, {
		shipToLesson = {
			shipId = arg1_23,
			skillIndex = var0_23:getSkillIndex(arg2_23),
			index = arg3_23
		}
	})
end

function var0_0.listNotificationInterests(arg0_24)
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

function var0_0.handleNotification(arg0_25, arg1_25)
	local var0_25 = arg1_25:getName()
	local var1_25 = arg1_25:getBody()

	if var0_25 == PlayerProxy.UPDATED then
		arg0_25.viewComponent:OnPlayerUpdate(var1_25)
	elseif var0_25 == GAME.HARVEST_RES_DONE then
		local var2_25

		if var1_25.type == 2 then
			var2_25 = i18n("word_oil")
		elseif var1_25.type == 1 then
			var2_25 = i18n("word_gold")
		end

		pg.TipsMgr.GetInstance():ShowTips(i18n("commission_get_award", var2_25, var1_25.outPut))
	elseif var0_25 == GAME.EVENT_LIST_UPDATE or var0_25 == GAME.EVENT_FINISH_UPDATE then
		local var3_25 = getProxy(EventProxy)

		arg0_25.viewComponent:OnUpdateEventInfo()
	elseif var0_25 == GAME.EVENT_SHOW_AWARDS then
		local var4_25

		var4_25 = coroutine.wrap(function()
			if #var1_25.oldShips > 0 then
				arg0_25.viewComponent:emit(BaseUI.ON_SHIP_EXP, {
					title = pg.collection_template[var1_25.eventId].title,
					oldShips = var1_25.oldShips,
					newShips = var1_25.newShips,
					isCri = var1_25.isCri
				}, var4_25)
				coroutine.yield()
			end

			arg0_25.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_25.awards, function()
				if var1_25.onConfirm then
					var1_25.onConfirm()
				end
			end)
		end)

		var4_25()
	elseif var0_25 == GAME.CANCEL_LEARN_TACTICS_DONE then
		arg0_25.viewComponent:OnUpdateClass()

		local var5_25 = var1_25.totalExp
		local var6_25 = var1_25.oldSkill
		local var7_25 = var1_25.newSkill
		local var8_25 = getProxy(BayProxy):getShipById(var1_25.shipId)
		local var9_25 = var7_25.id
		local var10_25

		if var7_25.level > var6_25.level then
			var10_25 = i18n("tactics_end_to_learn", var8_25:getName(), getSkillName(var9_25), var5_25) .. i18n("tactics_skill_level_up", var6_25.level, var7_25.level)
		else
			var10_25 = i18n("tactics_end_to_learn", var8_25:getName(), getSkillName(var9_25), var5_25)
		end

		if pg.skill_data_template[var9_25].max_level <= var7_25.level then
			arg0_25:HandleClassMaxLevel(var8_25, var1_25, var9_25, var5_25)
		else
			local var11_25 = var10_25 .. i18n("tactics_continue_to_learn")

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				modal = true,
				hideNo = false,
				hideClose = true,
				content = var11_25,
				onYes = function()
					arg0_25.openMsgBox = false

					arg0_25:continueClass(var1_25.shipId, var9_25, var1_25.id)
				end,
				onNo = function()
					arg0_25.openMsgBox = false
				end
			})
		end
	elseif var0_25 == GAME.FINISH_TECHNOLOGY_DONE then
		arg0_25.viewComponent:OnUpdateTechnology()

		if #var1_25.items > 0 then
			arg0_25.viewComponent:emit(BaseUI.ON_AWARD, {
				animation = true,
				items = var1_25.items
			})
		end
	elseif var0_25 == GAME.FINISH_QUEUE_TECHNOLOGY_DONE then
		arg0_25.viewComponent:OnUpdateTechnology()

		local var12_25 = {}

		for iter0_25, iter1_25 in ipairs(var1_25.dropInfos) do
			if #iter1_25 > 0 then
				table.insert(var12_25, function(arg0_30)
					arg0_25.viewComponent:emit(BaseUI.ON_AWARD, {
						animation = true,
						items = iter1_25,
						removeFunc = arg0_30
					})
				end)
			end
		end

		seriesAsync(var12_25, function()
			local var0_31 = getProxy(TechnologyProxy):getActivateTechnology()

			if var0_31 and var0_31:isCompleted() then
				arg0_25:sendNotification(GAME.FINISH_TECHNOLOGY, {
					id = var0_31.id,
					pool_id = var0_31.poolId
				})
			end
		end)
	elseif var0_25 == GAME.END_CHAPTER_AUTO_DONE then
		arg0_25:addSubLayers(Context.New({
			viewComponent = ChapterAutoTotalRewardLayer,
			mediator = ChapterAutoTotalRewardMediator,
			data = {
				rewards = var1_25.awards,
				totalTimes = var1_25.allCnt,
				finishTimes = var1_25.finishCnt,
				proficiency = var1_25.proficiency,
				onClose = function()
					arg0_25.viewComponent:OnUpdateChapterAuto()
				end
			}
		}), true)
	elseif var0_25 == START_CHAPTER_AUTO_DONE then
		arg0_25.viewComponent:OnUpdateChapterAuto()
	elseif var0_25 == GAME.ZERO_HOUR_OP_DONE then
		arg0_25.viewComponent:OnUpdateChapterAuto()
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

return var0_0
