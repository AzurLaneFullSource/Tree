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

function var0_0.register(arg0_1)
	local var0_1 = getProxy(PlayerProxy)

	arg0_1.viewComponent:setPlayer(var0_1:getData())
	arg0_1:bind(var0_0.GO_META_BOSS, function(arg0_2)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.WORLDBOSS)
	end)
	arg0_1:bind(var0_0.ON_UR_ACTIVITY, function(arg0_3)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY, {
			id = ActivityConst.UR_ITEM_ACT_ID
		})
	end)
	arg0_1:bind(var0_0.ON_CRUSING, function(arg0_4)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.CRUSING)
	end)
	arg0_1:bind(var0_0.GET_CLASS_RES, function(arg0_5)
		arg0_1:sendNotification(GAME.HARVEST_CLASS_RES)
	end)
	arg0_1:bind(var0_0.ON_TECH_QUEUE_FINISH, function(arg0_6)
		arg0_1:sendNotification(GAME.FINISH_QUEUE_TECHNOLOGY)
	end)
	arg0_1:bind(var0_0.ON_TECH_FINISHED, function(arg0_7, arg1_7)
		arg0_1:sendNotification(GAME.FINISH_TECHNOLOGY, {
			id = arg1_7.id,
			pool_id = arg1_7.pool_id
		})
	end)
	arg0_1:bind(var0_0.FINISH_EVENT, function(arg0_8, arg1_8, arg2_8, arg3_8)
		arg0_1.contextData.oneStepFinishEventCount = arg2_8
		arg0_1.contextData.inFinished = true

		arg0_1:sendNotification(GAME.EVENT_FINISH, {
			id = arg1_8.id,
			callback = function()
				arg0_1.contextData.inFinished = nil
			end,
			onConfirm = function()
				if arg3_8 then
					arg3_8()
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
	arg0_1:bind(var0_0.FINISH_CLASS, function(arg0_11, arg1_11, arg2_11, arg3_11)
		arg0_1:sendNotification(GAME.CANCEL_LEARN_TACTICS, {
			shipId = arg1_11,
			type = arg2_11,
			onConfirm = arg3_11
		})
	end)
	arg0_1:bind(var0_0.ON_ACTIVE_EVENT, function(arg0_12)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.EVENT)
	end)
	arg0_1:bind(var0_0.ON_ACTIVE_CLASS, function(arg0_13)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.NAVALTACTICS)
	end)
	arg0_1:bind(var0_0.ON_ACTIVE_TECH, function(arg0_14)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.TECHNOLOGY)
	end)
	arg0_1:bind(var0_0.GET_OIL_RES, function(arg0_15)
		arg0_1:sendNotification(GAME.HARVEST_RES, PlayerConst.ResOil)
	end)
	arg0_1:bind(var0_0.GET_GOLD_RES, function(arg0_16)
		arg0_1:sendNotification(GAME.HARVEST_RES, PlayerConst.ResGold)
	end)
	arg0_1:bind(var0_0.ON_INS, function(arg0_17)
		arg0_1:sendNotification(GAME.ON_OPEN_INS_LAYER)
		arg0_1.viewComponent:emit(BaseUI.ON_CLOSE)
	end)
	arg0_1:bind(var0_0.FINISH_CLASS_ALL, function()
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.NAVALTACTICS)
	end)
	arg0_1:Notify()
end

function var0_0.Notify(arg0_19)
	local var0_19 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_INSTAGRAM)

	arg0_19.viewComponent:NotifyIns(getProxy(InstagramProxy), var0_19)
	arg0_19.viewComponent:UpdateLinkPanel()
end

function var0_0.continueClass(arg0_20, arg1_20, arg2_20, arg3_20)
	local var0_20 = getProxy(BayProxy):getShipById(arg1_20)
	local var1_20 = getProxy(BagProxy):getItemsByType(Item.LESSON_TYPE)

	if table.getCount(var1_20 or {}) <= 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("tactics_no_lesson"))

		return
	end

	arg0_20:sendNotification(GAME.GO_SCENE, SCENE.NAVALTACTICS, {
		shipToLesson = {
			shipId = arg1_20,
			skillIndex = var0_20:getSkillIndex(arg2_20),
			index = arg3_20
		}
	})
end

function var0_0.listNotificationInterests(arg0_21)
	return {
		PlayerProxy.UPDATED,
		GAME.HARVEST_RES_DONE,
		GAME.EVENT_LIST_UPDATE,
		GAME.EVENT_SHOW_AWARDS,
		GAME.CANCEL_LEARN_TACTICS_DONE,
		GAME.FINISH_TECHNOLOGY_DONE,
		GAME.FINISH_QUEUE_TECHNOLOGY_DONE
	}
end

function var0_0.handleNotification(arg0_22, arg1_22)
	local var0_22 = arg1_22:getName()
	local var1_22 = arg1_22:getBody()

	if var0_22 == PlayerProxy.UPDATED then
		arg0_22.viewComponent:setPlayer(var1_22)
	elseif var0_22 == GAME.HARVEST_RES_DONE then
		local var2_22

		if var1_22.type == 2 then
			var2_22 = i18n("word_oil")
		elseif var1_22.type == 1 then
			var2_22 = i18n("word_gold")
		end

		pg.TipsMgr.GetInstance():ShowTips(i18n("commission_get_award", var2_22, var1_22.outPut))
	elseif var0_22 == GAME.EVENT_LIST_UPDATE then
		local var3_22 = getProxy(EventProxy)

		arg0_22.viewComponent:OnUpdateEventInfo()
	elseif var0_22 == GAME.EVENT_SHOW_AWARDS then
		local var4_22

		var4_22 = coroutine.wrap(function()
			if #var1_22.oldShips > 0 then
				arg0_22.viewComponent:emit(BaseUI.ON_SHIP_EXP, {
					title = pg.collection_template[var1_22.eventId].title,
					oldShips = var1_22.oldShips,
					newShips = var1_22.newShips,
					isCri = var1_22.isCri
				}, var4_22)
				coroutine.yield()
			end

			arg0_22.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_22.awards, function()
				if var1_22.onConfirm then
					var1_22.onConfirm()
				end
			end)
		end)

		var4_22()
	elseif var0_22 == GAME.CANCEL_LEARN_TACTICS_DONE then
		arg0_22.viewComponent:OnUpdateClass()

		local var5_22 = var1_22.totalExp
		local var6_22 = var1_22.oldSkill
		local var7_22 = var1_22.newSkill
		local var8_22 = getProxy(BayProxy):getShipById(var1_22.shipId)
		local var9_22 = var7_22.id
		local var10_22

		if var7_22.level > var6_22.level then
			var10_22 = i18n("tactics_end_to_learn", var8_22:getName(), getSkillName(var9_22), var5_22) .. i18n("tactics_skill_level_up", var6_22.level, var7_22.level)
		else
			var10_22 = i18n("tactics_end_to_learn", var8_22:getName(), getSkillName(var9_22), var5_22)
		end

		if pg.skill_data_template[var9_22].max_level <= var7_22.level then
			arg0_22:HandleClassMaxLevel(var8_22, var1_22, var9_22, var5_22)
		else
			local var11_22 = var10_22 .. i18n("tactics_continue_to_learn")

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				modal = true,
				hideNo = false,
				hideClose = true,
				content = var11_22,
				weight = LayerWeightConst.THIRD_LAYER,
				onYes = function()
					arg0_22.openMsgBox = false

					arg0_22:continueClass(var1_22.shipId, var9_22, var1_22.id)
				end,
				onNo = function()
					arg0_22.openMsgBox = false
				end
			})
		end
	elseif var0_22 == GAME.FINISH_TECHNOLOGY_DONE then
		arg0_22.viewComponent:OnUpdateTechnology()

		if #var1_22.items > 0 then
			arg0_22.viewComponent:emit(BaseUI.ON_AWARD, {
				animation = true,
				items = var1_22.items
			})
		end
	elseif var0_22 == GAME.FINISH_QUEUE_TECHNOLOGY_DONE then
		arg0_22.viewComponent:OnUpdateTechnology()

		local var12_22 = {}

		for iter0_22, iter1_22 in ipairs(var1_22.dropInfos) do
			if #iter1_22 > 0 then
				table.insert(var12_22, function(arg0_27)
					arg0_22.viewComponent:emit(BaseUI.ON_AWARD, {
						animation = true,
						items = iter1_22,
						removeFunc = arg0_27
					})
				end)
			end
		end

		seriesAsync(var12_22, function()
			local var0_28 = getProxy(TechnologyProxy):getActivateTechnology()

			if var0_28 and var0_28:isCompleted() then
				arg0_22:sendNotification(GAME.FINISH_TECHNOLOGY, {
					id = var0_28.id,
					pool_id = var0_28.poolId
				})
			end
		end)
	end
end

function var0_0.HandleClassMaxLevel(arg0_29, arg1_29, arg2_29, arg3_29, arg4_29)
	local var0_29 = i18n("tactics_end_to_learn", arg1_29:getName(), getSkillName(arg3_29), arg4_29)
	local var1_29 = arg1_29:getSkillList()

	if _.all(var1_29, function(arg0_30)
		return ShipSkill.New(arg1_29.skills[arg0_30]):IsMaxLevel()
	end) then
		local var2_29 = var0_29 .. i18n("tactics_continue_to_learn_other_ship_skill")

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			modal = true,
			hideClose = true,
			content = var2_29,
			onYes = function()
				arg0_29:sendNotification(GAME.GO_SCENE, SCENE.NAVALTACTICS)
			end
		})
	else
		local var3_29 = var0_29 .. i18n("tactics_continue_to_learn_other_skill")

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			modal = true,
			hideClose = true,
			content = var3_29,
			weight = LayerWeightConst.THIRD_LAYER,
			onYes = function()
				arg0_29:sendNotification(GAME.GO_SCENE, SCENE.NAVALTACTICS, {
					shipToLesson = {
						shipId = arg2_29.shipId,
						index = arg2_29.id
					}
				})
			end
		})
	end
end

return var0_0
