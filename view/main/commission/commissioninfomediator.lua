local var0 = class("CommissionInfoMediator", import("...base.ContextMediator"))

var0.FINISH_EVENT = "CommissionInfoMediator.FINISH_EVENT"
var0.FINISH_CLASS = "CommissionInfoMediator.FINISH_CLASS"
var0.GET_OIL_RES = "CommissionInfoMediator.GET_OIL_RES"
var0.GET_GOLD_RES = "CommissionInfoMediator.GET_GOLD_RES"
var0.ON_ACTIVE_EVENT = "CommissionInfoMediator.ON_ACTIVE_EVENT"
var0.ON_ACTIVE_CLASS = "CommissionInfoMediator.ON_ACTIVE_CLASS"
var0.ON_ACTIVE_TECH = "CommissionInfoMediator.ON_ACTIVE_TECH"
var0.ON_TECH_FINISHED = "CommissionInfoMediator.ON_TECH_FINISHED"
var0.ON_TECH_QUEUE_FINISH = "CommissionInfoMediator.ON_TECH_QUEUE_FINISH"
var0.ON_INS = "CommissionInfoMediator.ON_INS"
var0.ON_UR_ACTIVITY = "CommissionInfoMediator:ON_UR_ACTIVITY"
var0.ON_CRUSING = "CommissionInfoMediator.ON_CRUSING"
var0.GET_CLASS_RES = "CommissionInfoMediator:GET_CLASS_RES"
var0.FINISH_CLASS_ALL = "CommissionInfoMediator:FINISH_CLASS_ALL"
var0.GO_META_BOSS = "CommissionInfoMediator:GO_META_BOSS"

function var0.register(arg0)
	local var0 = getProxy(PlayerProxy)

	arg0.viewComponent:setPlayer(var0:getData())
	arg0:bind(var0.GO_META_BOSS, function(arg0)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.WORLDBOSS)
	end)
	arg0:bind(var0.ON_UR_ACTIVITY, function(arg0)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY, {
			id = ActivityConst.UR_ITEM_ACT_ID
		})
	end)
	arg0:bind(var0.ON_CRUSING, function(arg0)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.CRUSING)
	end)
	arg0:bind(var0.GET_CLASS_RES, function(arg0)
		arg0:sendNotification(GAME.HARVEST_CLASS_RES)
	end)
	arg0:bind(var0.ON_TECH_QUEUE_FINISH, function(arg0)
		arg0:sendNotification(GAME.FINISH_QUEUE_TECHNOLOGY)
	end)
	arg0:bind(var0.ON_TECH_FINISHED, function(arg0, arg1)
		arg0:sendNotification(GAME.FINISH_TECHNOLOGY, {
			id = arg1.id,
			pool_id = arg1.pool_id
		})
	end)
	arg0:bind(var0.FINISH_EVENT, function(arg0, arg1, arg2, arg3)
		arg0.contextData.oneStepFinishEventCount = arg2
		arg0.contextData.inFinished = true

		arg0:sendNotification(GAME.EVENT_FINISH, {
			id = arg1.id,
			callback = function()
				arg0.contextData.inFinished = nil
			end,
			onConfirm = function()
				if arg3 then
					arg3()
				end

				if arg0.contextData.oneStepFinishEventCount then
					arg0.contextData.oneStepFinishEventCount = arg0.contextData.oneStepFinishEventCount - 1

					if arg0.contextData.oneStepFinishEventCount <= 0 then
						MainMetaSkillSequence.New():Execute()
					end
				else
					MainMetaSkillSequence.New():Execute()
				end
			end
		})
	end)
	arg0:bind(var0.FINISH_CLASS, function(arg0, arg1, arg2, arg3)
		arg0:sendNotification(GAME.CANCEL_LEARN_TACTICS, {
			shipId = arg1,
			type = arg2,
			onConfirm = arg3
		})
	end)
	arg0:bind(var0.ON_ACTIVE_EVENT, function(arg0)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.EVENT)
	end)
	arg0:bind(var0.ON_ACTIVE_CLASS, function(arg0)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.NAVALTACTICS)
	end)
	arg0:bind(var0.ON_ACTIVE_TECH, function(arg0)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.TECHNOLOGY)
	end)
	arg0:bind(var0.GET_OIL_RES, function(arg0)
		arg0:sendNotification(GAME.HARVEST_RES, PlayerConst.ResOil)
	end)
	arg0:bind(var0.GET_GOLD_RES, function(arg0)
		arg0:sendNotification(GAME.HARVEST_RES, PlayerConst.ResGold)
	end)
	arg0:bind(var0.ON_INS, function(arg0)
		arg0:sendNotification(GAME.ON_OPEN_INS_LAYER)
		arg0.viewComponent:emit(BaseUI.ON_CLOSE)
	end)
	arg0:bind(var0.FINISH_CLASS_ALL, function()
		arg0:sendNotification(GAME.GO_SCENE, SCENE.NAVALTACTICS)
	end)
	arg0:Notify()
end

function var0.Notify(arg0)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_INSTAGRAM)

	arg0.viewComponent:NotifyIns(getProxy(InstagramProxy), var0)
	arg0.viewComponent:UpdateLinkPanel()
end

function var0.continueClass(arg0, arg1, arg2, arg3)
	local var0 = getProxy(BayProxy):getShipById(arg1)
	local var1 = getProxy(BagProxy):getItemsByType(Item.LESSON_TYPE)

	if table.getCount(var1 or {}) <= 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("tactics_no_lesson"))

		return
	end

	arg0:sendNotification(GAME.GO_SCENE, SCENE.NAVALTACTICS, {
		shipToLesson = {
			shipId = arg1,
			skillIndex = var0:getSkillIndex(arg2),
			index = arg3
		}
	})
end

function var0.listNotificationInterests(arg0)
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

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:setPlayer(var1)
	elseif var0 == GAME.HARVEST_RES_DONE then
		local var2

		if var1.type == 2 then
			var2 = i18n("word_oil")
		elseif var1.type == 1 then
			var2 = i18n("word_gold")
		end

		pg.TipsMgr.GetInstance():ShowTips(i18n("commission_get_award", var2, var1.outPut))
	elseif var0 == GAME.EVENT_LIST_UPDATE then
		local var3 = getProxy(EventProxy)

		arg0.viewComponent:OnUpdateEventInfo()
	elseif var0 == GAME.EVENT_SHOW_AWARDS then
		local var4

		var4 = coroutine.wrap(function()
			if #var1.oldShips > 0 then
				arg0.viewComponent:emit(BaseUI.ON_SHIP_EXP, {
					title = pg.collection_template[var1.eventId].title,
					oldShips = var1.oldShips,
					newShips = var1.newShips,
					isCri = var1.isCri
				}, var4)
				coroutine.yield()
			end

			arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards, function()
				if var1.onConfirm then
					var1.onConfirm()
				end
			end)
		end)

		var4()
	elseif var0 == GAME.CANCEL_LEARN_TACTICS_DONE then
		arg0.viewComponent:OnUpdateClass()

		local var5 = var1.totalExp
		local var6 = var1.oldSkill
		local var7 = var1.newSkill
		local var8 = getProxy(BayProxy):getShipById(var1.shipId)
		local var9 = var7.id
		local var10

		if var7.level > var6.level then
			var10 = i18n("tactics_end_to_learn", var8:getName(), getSkillName(var9), var5) .. i18n("tactics_skill_level_up", var6.level, var7.level)
		else
			var10 = i18n("tactics_end_to_learn", var8:getName(), getSkillName(var9), var5)
		end

		if pg.skill_data_template[var9].max_level <= var7.level then
			arg0:HandleClassMaxLevel(var8, var1, var9, var5)
		else
			local var11 = var10 .. i18n("tactics_continue_to_learn")

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				modal = true,
				hideNo = false,
				hideClose = true,
				content = var11,
				weight = LayerWeightConst.THIRD_LAYER,
				onYes = function()
					arg0.openMsgBox = false

					arg0:continueClass(var1.shipId, var9, var1.id)
				end,
				onNo = function()
					arg0.openMsgBox = false
				end
			})
		end
	elseif var0 == GAME.FINISH_TECHNOLOGY_DONE then
		arg0.viewComponent:OnUpdateTechnology()

		if #var1.items > 0 then
			arg0.viewComponent:emit(BaseUI.ON_AWARD, {
				animation = true,
				items = var1.items
			})
		end
	elseif var0 == GAME.FINISH_QUEUE_TECHNOLOGY_DONE then
		arg0.viewComponent:OnUpdateTechnology()

		local var12 = {}

		for iter0, iter1 in ipairs(var1.dropInfos) do
			if #iter1 > 0 then
				table.insert(var12, function(arg0)
					arg0.viewComponent:emit(BaseUI.ON_AWARD, {
						animation = true,
						items = iter1,
						removeFunc = arg0
					})
				end)
			end
		end

		seriesAsync(var12, function()
			local var0 = getProxy(TechnologyProxy):getActivateTechnology()

			if var0 and var0:isCompleted() then
				arg0:sendNotification(GAME.FINISH_TECHNOLOGY, {
					id = var0.id,
					pool_id = var0.poolId
				})
			end
		end)
	end
end

function var0.HandleClassMaxLevel(arg0, arg1, arg2, arg3, arg4)
	local var0 = i18n("tactics_end_to_learn", arg1:getName(), getSkillName(arg3), arg4)
	local var1 = arg1:getSkillList()

	if _.all(var1, function(arg0)
		return ShipSkill.New(arg1.skills[arg0]):IsMaxLevel()
	end) then
		local var2 = var0 .. i18n("tactics_continue_to_learn_other_ship_skill")

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			modal = true,
			hideClose = true,
			content = var2,
			onYes = function()
				arg0:sendNotification(GAME.GO_SCENE, SCENE.NAVALTACTICS)
			end
		})
	else
		local var3 = var0 .. i18n("tactics_continue_to_learn_other_skill")

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			modal = true,
			hideClose = true,
			content = var3,
			weight = LayerWeightConst.THIRD_LAYER,
			onYes = function()
				arg0:sendNotification(GAME.GO_SCENE, SCENE.NAVALTACTICS, {
					shipToLesson = {
						shipId = arg2.shipId,
						index = arg2.id
					}
				})
			end
		})
	end
end

return var0
