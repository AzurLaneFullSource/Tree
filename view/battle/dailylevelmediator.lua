local var0_0 = class("DailyLevelMediator", import("..base.ContextMediator"))

var0_0.ON_STAGE = "DailyLevelMediator:ON_STAGE"
var0_0.ON_CHALLENGE = "DailyLevelMediator:ON_CHALLENGE"
var0_0.ON_RESET_CHALLENGE = "DailyLevelMediator:ON_RESET_CHALLENGE"
var0_0.ON_CONTINUE_CHALLENGE = "DailyLevelMediator:ON_CONTINUE_CHALLENGE"
var0_0.ON_CHALLENGE_EDIT_FLEET = "DailyLevelMediator:ON_CHALLENGE_EDIT_FLEET"
var0_0.ON_REQUEST_CHALLENGE = "DailyLevelMediator:ON_REQUEST_CHALLENGE"
var0_0.ON_CHALLENGE_FLEET_CLEAR = "DailyLevelMediator.ON_CHALLENGE_FLEET_CLEAR"
var0_0.ON_CHALLENGE_FLEET_RECOMMEND = "DailyLevelMediator.ON_CHALLENGE_FLEET_RECOMMEND"
var0_0.ON_QUICK_BATTLE = "DailyLevelMediator:ON_QUICK_BATTLE"

function var0_0.register(arg0_1)
	local var0_1 = getProxy(DailyLevelProxy)

	arg0_1.viewComponent:setDailyCounts(var0_1:getRawData())

	arg0_1.ships = getProxy(BayProxy):getRawData()

	arg0_1.viewComponent:setShips(arg0_1.ships)

	local var1_1 = getProxy(PlayerProxy):getData()

	arg0_1.viewComponent:updateRes(var1_1)
	arg0_1.viewComponent:setActivity(getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_DAILY_STAGE_BONUS))
	arg0_1:bind(var0_0.ON_QUICK_BATTLE, function(arg0_2, arg1_2, arg2_2, arg3_2)
		arg0_1:CheckShipExpItemOverflow(arg2_2, function()
			arg0_1:sendNotification(GAME.DAILY_LEVEL_QUICK_BATTLE, {
				dailyLevelId = arg1_2,
				stageId = arg2_2,
				cnt = arg3_2
			})
		end)
	end)
	arg0_1:bind(var0_0.ON_STAGE, function(arg0_4, arg1_4)
		var0_1.dailyLevelId = arg0_1.contextData.dailyLevelId

		local var0_4 = PreCombatLayer
		local var1_4 = SYSTEM_ROUTINE

		if pg.expedition_data_template[arg1_4.id].type == Stage.SubmarinStage then
			var0_4 = PreCombatLayerSubmarine
			var1_4 = SYSTEM_SUB_ROUTINE
		end

		arg0_1:addSubLayers(Context.New({
			mediator = PreCombatMediator,
			viewComponent = var0_4,
			data = {
				stageId = arg1_4.id,
				system = var1_4,
				OnConfirm = function(arg0_5)
					arg0_1:CheckShipExpItemOverflow(arg1_4.id, arg0_5)
				end
			}
		}))
	end)
end

function var0_0.CheckShipExpItemOverflow(arg0_6, arg1_6, arg2_6)
	local var0_6 = pg.expedition_data_template[arg1_6].award_display

	if _.any(var0_6, function(arg0_7)
		local var0_7 = getProxy(BagProxy):getItemCountById(arg0_7[2])
		local var1_7 = Item.getConfigData(arg0_7[2])

		return arg0_7[1] == DROP_TYPE_ITEM and var1_7.type == Item.EXP_BOOK_TYPE and var0_7 >= var1_7.max_num
	end) then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("player_expResource_mail_fullBag"),
			onYes = arg2_6
		})
	else
		arg2_6()
	end
end

function var0_0.listNotificationInterests(arg0_8)
	return {
		PlayerProxy.UPDATED,
		GAME.DAILY_LEVEL_QUICK_BATTLE_DONE,
		GAME.REMOVE_LAYERS
	}
end

function var0_0.handleNotification(arg0_9, arg1_9)
	local var0_9 = arg1_9:getName()
	local var1_9 = arg1_9:getBody()

	if var0_9 == PlayerProxy.UPDATED then
		arg0_9.viewComponent:updateRes(var1_9)
	elseif var0_9 == GAME.DAILY_LEVEL_QUICK_BATTLE_DONE then
		local var2_9 = var1_9.awards

		if #var2_9 > 0 then
			arg0_9.viewComponent:emit(BaseUI.ON_ACHIEVE, var2_9)
		end

		local var3_9 = getProxy(DailyLevelProxy)

		arg0_9.viewComponent:setDailyCounts(var3_9:getRawData())
		arg0_9.viewComponent:UpdateBattleBtn({
			id = var1_9.stageId
		})
		arg0_9.viewComponent:UpdateDailyLevelCnt(var1_9.dailyLevelId)
		arg0_9.viewComponent:UpdateDailyLevelCntForDescPanel(var1_9.dailyLevelId)
	elseif var0_9 == GAME.REMOVE_LAYERS and var1_9.context.mediator.__cname == "PreCombatMediator" then
		setActive(arg0_9.viewComponent.blurPanel, true)
	end
end

return var0_0
