local var0_0 = class("IslandMediator", import(".base.IslandBaseMediator"))

var0_0.ON_UPGRADE = "IslandMediator:ON_UPGRADE"
var0_0.SET_NAME = "IslandMediator:SET_NAME"
var0_0.ON_EDIT_MANIFESTO = "IslandMediator:ON_EDIT_MANIFESTO"
var0_0.GET_PROSPERITY_AWARD = "IslandMediator:GET_PROSPERITY_AWARD"
var0_0.ON_UPGRADE_INVENTORY = "IslandMediator:ON_UPGRADE_INVENTORY"
var0_0.ON_SELL_ITEM = "IslandMediator:ON_SELL_ITEM"
var0_0.ON_BATCH_SELL_ITEM = "IslandMediator:ON_BATCH_SELL_ITEM"
var0_0.ON_BATCH_SELL_ITEM_4_OVERFLOW = "IslandMediator:ON_BATCH_SELL_ITEM_4_OVERFLOW"
var0_0.ON_REPLACE_ORDER = "IslandMediator:ON_REPLACE_ORDER"
var0_0.ON_SUBMIT_ORDER = "IslandMediator:ON_SUBMIT_ORDER"
var0_0.ON_GET_ORDER_EXP_AWARD = "IslandMediator:ON_GET_ORDER_EXP_AWARD"
var0_0.ON_GEN_NEW_ORDER = "IslandMediator:ON_GEN_NEW_ORDER"
var0_0.ON_USE_ITEM = "IslandMediator:ON_USE_ITEM"
var0_0.ON_ACCEPT_TASK = "IslandMediator.ON_ACCEPT_TASK"
var0_0.ON_SUBMIT_TASK = "IslandMediator.ON_SUBMIT_TASK"
var0_0.ON_CLIENT_UPDATE_TASK = "IslandMediator.ON_CLIENT_UPDATE_TASK"
var0_0.ON_SET_TRACE_ID = "IslandMediator.ON_SET_TRACE_ID"
var0_0.OPEN_SHIP_INDEX = "IslandMediator:OPEN_SHIP_INDEX"
var0_0.UPGRADE_SKILL = "IslandMediator:UPGRADE_SKILL"
var0_0.GET_EXTRA_AWARD = "IslandMediator:GET_EXTRA_AWARD"
var0_0.ON_GIVE_GIFT = "IslandMediator:ON_GIVE_GIFT"
var0_0.ON_UNLOCK_BUILDING = "IslandMediator:ON_UNLOCK_BUILDING"
var0_0.ON_UPGRADE_BUILDING = "IslandMediator:ON_UPGRADE_BUILDING"
var0_0.ON_GET_COMMISSION_AWARD = "IslandMediator:ON_GET_COMMISSION_AWARD"
var0_0.ON_CHANGE_COMMISSION_FORMULA = "IslandMediator:ON_CHANGE_COMMISSION_FORMULA"
var0_0.ON_CHANGE_COMMISSION_SHIP = "IslandMediator:ON_CHANGE_COMMISSION_SHIP"
var0_0.ON_KICK_PLAYER = "IslandMediator:ON_KICK_PLAYER"
var0_0.SWITCH_MAP = "IslandMediator:SWITCH_MAP"
var0_0.SAVE_AGORA = "IslandMediator:SAVE_AGORA"
var0_0.UPGRADE_AGORA = "IslandMediator:UPGRADE_AGORA"
var0_0.OPEN_FRIEND = "IslandMediator:OPEN_FRIEND"
var0_0.ONE_KEY = "IslandMediator:ONE_KEY"
var0_0.ON_UNLOCK_TECH = "IslandMediator:ON_UNLOCK_TECH"
var0_0.ON_FINISH_TECH_IMMD = "IslandMediator:ON_FINISH_TECH_IMMD"
var0_0.SET_ORDER_TENDENCY = "IslandMediator:SET_ORDER_TENDENCY"
var0_0.SUBMIT_SHIP_ORDER_ITME = "IslandMediator:SUBMIT_SHIP_ORDER_ITME"
var0_0.GET_SHIP_ORDER_AWARD = "IslandMediator:GET_SHIP_ORDER_AWARD"
var0_0.UNLOKC_SHIP_ORDER = "IslandMediator:UNLOKC_SHIP_ORDER"
var0_0.OPEN_PAGE = "IslandMediator:OPEN_PAGE"
var0_0.OPEN_SHOP = "IslandMediator:OPEN_SHOP"
var0_0.GET_SHOP_DATA = "IslandMediator:GET_SHOP_DATA"
var0_0.BUY_COMMODITY = "IslandMediator:BUY_COMMODITY"
var0_0.REFRESH_SHOP_BY_PLAYER = "IslandMediator:REFRESH_SHOP_BY_PLAYER"
var0_0.START_DELEGATION = "IslandMediator:START_DELEGATION"
var0_0.STOP_DELEGATION = "IslandMediator:STOP_DELEGATION"
var0_0.GET_DELEGATION_AWARD = "IslandMediator:GET_DELEGATION_AWARD"
var0_0.USE_SPEEDUPCARD = "IslandMediator:USE_SPEEDUPCARD"

function var0_0._register(arg0_1)
	arg0_1:bind(var0_0.OPEN_PAGE, function(arg0_2, arg1_2)
		arg0_1.viewComponent:OpenPage(_G[arg1_2[1]], arg1_2[2])
	end)
	arg0_1:bind(var0_0.UNLOKC_SHIP_ORDER, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.ISLAND_SHIP_ORDER_OP, {
			op = IslandShipOrder.OP_TYPE_UNLOCK,
			slotId = arg1_3
		})
	end)
	arg0_1:bind(var0_0.GET_SHIP_ORDER_AWARD, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.ISLAND_SHIP_ORDER_OP, {
			op = IslandShipOrder.OP_TYPE_GET_AWARD,
			slotId = arg1_4
		})
	end)
	arg0_1:bind(var0_0.SUBMIT_SHIP_ORDER_ITME, function(arg0_5, arg1_5, arg2_5)
		arg0_1:sendNotification(GAME.ISLAND_SHIP_ORDER_OP, {
			op = IslandShipOrder.OP_TYPE_LOADUP,
			slotId = arg1_5,
			index = arg2_5
		})
	end)
	arg0_1:bind(var0_0.SET_ORDER_TENDENCY, function(arg0_6, arg1_6)
		arg0_1:sendNotification(GAME.ISLAND_SET_ORDER_TENDENCY, {
			value = arg1_6
		})
	end)
	arg0_1:bind(var0_0.ONE_KEY, function(arg0_7)
		arg0_1:sendNotification(GAME.ISLAND_GET_OVERFLOW_ITEM)
	end)
	arg0_1:bind(var0_0.ON_BATCH_SELL_ITEM_4_OVERFLOW, function(arg0_8, arg1_8)
		arg0_1:sendNotification(GAME.ISLAND_BATCH_SELL_ITEM, {
			overflow = true,
			list = arg1_8
		})
	end)
	arg0_1:bind(var0_0.UPGRADE_AGORA, function(arg0_9)
		arg0_1:sendNotification(GAME.ISLAND_UPGRADE_AGORA)
	end)
	arg0_1:bind(var0_0.SAVE_AGORA, function(arg0_10, arg1_10)
		arg0_1:sendNotification(GAME.ISLAND_SAVE_AGORA, {
			list = arg1_10
		})
	end)
	arg0_1:bind(var0_0.OPEN_FRIEND, function(arg0_11)
		arg0_1:addSubLayers(Context.New({
			mediator = IslandFriendMediator,
			viewComponent = IslandFriendScene
		}))
	end)
	arg0_1:bind(var0_0.SWITCH_MAP, function(arg0_12, arg1_12, arg2_12)
		local var0_12 = arg0_1.viewComponent:GetIsland().id

		arg0_1:sendNotification(GAME.ISLAND_ENTER_MAP, {
			islandId = var0_12,
			mapId = arg1_12,
			callback = function()
				arg0_1:SwitchScene(arg1_12, arg2_12)
			end
		})
	end)
	arg0_1:bind(var0_0.ON_KICK_PLAYER, function(arg0_14, arg1_14, arg2_14)
		arg0_1:sendNotification(GAME.ISLAND_ACCESS_OP, {
			op = arg1_14,
			list = {
				arg2_14
			}
		})
	end)
	arg0_1:bind(var0_0.ON_GIVE_GIFT, function(arg0_15, arg1_15, arg2_15, arg3_15)
		arg0_1:sendNotification(GAME.ISLAND_USE_ITEM, {
			id = arg1_15,
			count = arg2_15,
			arg = {
				arg3_15
			}
		})
	end)
	arg0_1:bind(var0_0.GET_EXTRA_AWARD, function(arg0_16, arg1_16, arg2_16)
		arg0_1:sendNotification(GAME.ISLAND_GET_EXTRA_AWARD, {
			id = arg1_16,
			op = arg2_16
		})
	end)
	arg0_1:bind(var0_0.UPGRADE_SKILL, function(arg0_17, arg1_17)
		arg0_1:sendNotification(GAME.ISLAND_UPGRADE_SKILL, {
			id = arg1_17
		})
	end)
	arg0_1:bind(var0_0.OPEN_SHIP_INDEX, function(arg0_18, arg1_18)
		arg0_1:addSubLayers(Context.New({
			viewComponent = IslandShipIndexLayer,
			mediator = CustomIndexMediator,
			data = arg1_18
		}))
	end)
	arg0_1:bind(var0_0.ON_USE_ITEM, function(arg0_19, arg1_19, arg2_19)
		arg0_1:sendNotification(GAME.ISLAND_USE_ITEM, {
			id = arg1_19,
			count = arg2_19
		})
	end)
	arg0_1:bind(var0_0.ON_GEN_NEW_ORDER, function(arg0_20, arg1_20)
		arg0_1:sendNotification(GAME.ISLAND_GEN_NEW_ORDER, {
			slotId = arg1_20
		})
	end)
	arg0_1:bind(var0_0.ON_GET_ORDER_EXP_AWARD, function(arg0_21, arg1_21, arg2_21)
		arg0_1:sendNotification(GAME.ISLAND_GET_ORDER_EXP_AWARD, {
			level = arg1_21,
			callback = arg2_21
		})
	end)
	arg0_1:bind(var0_0.ON_REPLACE_ORDER, function(arg0_22, arg1_22)
		arg0_1:sendNotification(GAME.ISLAND_REPLACE_ORDER, {
			slotId = arg1_22
		})
	end)
	arg0_1:bind(var0_0.ON_SUBMIT_ORDER, function(arg0_23, arg1_23)
		arg0_1:sendNotification(GAME.ISLAND_SUBMIT_ORDER, {
			slotId = arg1_23
		})
	end)
	arg0_1:bind(var0_0.ON_SELL_ITEM, function(arg0_24, arg1_24, arg2_24)
		arg0_1:sendNotification(GAME.ISLAND_SELL_ITEM, {
			id = arg1_24,
			count = arg2_24
		})
	end)
	arg0_1:bind(var0_0.ON_BATCH_SELL_ITEM, function(arg0_25, arg1_25)
		arg0_1:sendNotification(GAME.ISLAND_BATCH_SELL_ITEM, {
			list = arg1_25
		})
	end)
	arg0_1:bind(var0_0.ON_UPGRADE_INVENTORY, function(arg0_26)
		arg0_1:sendNotification(GAME.ISLAND_UPGRADE_INVENTORY)
	end)
	arg0_1:bind(var0_0.GET_PROSPERITY_AWARD, function(arg0_27, arg1_27)
		arg0_1:sendNotification(GAME.ISLAND_PROSPERITY_AWARD, {
			level = arg1_27
		})
	end)
	arg0_1:bind(var0_0.ON_EDIT_MANIFESTO, function(arg0_28, arg1_28)
		arg0_1:sendNotification(GAME.ISLAND_SET_MANIFESTO, {
			manifesto = arg1_28
		})
	end)
	arg0_1:bind(var0_0.ON_UPGRADE, function(arg0_29)
		arg0_1:sendNotification(GAME.ISLAND_UPGRADE)
	end)
	arg0_1:bind(var0_0.SET_NAME, function(arg0_30, arg1_30, arg2_30)
		arg0_1:sendNotification(GAME.ISLAND_SET_NAME, {
			name = arg1_30,
			currency = arg2_30
		})
	end)
	arg0_1:bind(var0_0.ON_ACCEPT_TASK, function(arg0_31, arg1_31)
		arg0_1:sendNotification(GAME.ISLAND_ACCEPT_TASK, {
			taskIds = arg1_31
		})
	end)
	arg0_1:bind(var0_0.ON_SUBMIT_TASK, function(arg0_32, arg1_32)
		arg0_1:sendNotification(GAME.ISLAND_SUBMIT_TASK, {
			taskId = arg1_32
		})
	end)
	arg0_1:bind(var0_0.ON_CLIENT_UPDATE_TASK, function(arg0_33, arg1_33)
		arg0_1:sendNotification(GAME.ISLAND_UPDATE_TASK, {
			taskId = arg1_33.taskId,
			targetId = arg1_33.targetId,
			progress = arg1_33.progress
		})
	end)
	arg0_1:bind(var0_0.ON_SET_TRACE_ID, function(arg0_34, arg1_34)
		arg0_1:sendNotification(GAME.ISLAND_SET_TRACE_TASK, {
			traceId = arg1_34
		})
	end)
	arg0_1:bind(var0_0.ON_UNLOCK_BUILDING, function(arg0_35, arg1_35)
		arg0_1:sendNotification(GAME.ISLAND_UNLOCK_BUILDING, {
			buildingId = arg1_35
		})
	end)
	arg0_1:bind(var0_0.ON_UPGRADE_BUILDING, function(arg0_36, arg1_36)
		arg0_1:sendNotification(GAME.ISLAND_UPGRADE_BUILDING, {
			buildingId = arg1_36
		})
	end)
	arg0_1:bind(var0_0.ON_GET_COMMISSION_AWARD, function(arg0_37, arg1_37, arg2_37)
		arg0_1:sendNotification(GAME.ISLAND_GET_COMMISSION_AWARD, {
			buildingId = arg1_37,
			commissionId = arg2_37
		})
	end)
	arg0_1:bind(var0_0.ON_CHANGE_COMMISSION_FORMULA, function(arg0_38, arg1_38)
		arg0_1:sendNotification(GAME.ISLAND_CHANGE_COMMISSION_FORMULA, {
			buildingId = arg1_38.buildingId,
			commissionId = arg1_38.commissionId,
			formulaId = arg1_38.formulaId,
			callback = arg1_38.callback
		})
	end)
	arg0_1:bind(var0_0.ON_CHANGE_COMMISSION_SHIP, function(arg0_39, arg1_39)
		arg0_1:sendNotification(GAME.ISLAND_CHANGE_COMMISSION_SHIP, {
			buildingId = arg1_39.buildingId,
			commissionId = arg1_39.commissionId,
			shipId = arg1_39.shipId,
			callback = arg1_39.callback
		})
	end)
	arg0_1:bind(var0_0.ON_UNLOCK_TECH, function(arg0_40, arg1_40)
		arg0_1:sendNotification(GAME.ISLAND_UNLOCK_TECH, {
			techId = arg1_40
		})
	end)
	arg0_1:bind(var0_0.ON_FINISH_TECH_IMMD, function(arg0_41, arg1_41, arg2_41)
		arg0_1:sendNotification(GAME.ISLAND_FINISH_TECH_IMMD, {
			techId = arg1_41,
			callback = arg2_41
		})
	end)
	arg0_1:bind(var0_0.START_DELEGATION, function(arg0_42, arg1_42, arg2_42, arg3_42, arg4_42, arg5_42)
		arg0_1:sendNotification(GAME.ISLAND_START_DELEGATION, {
			build_id = arg1_42,
			area_id = arg2_42,
			ship_id = arg3_42,
			formula_id = arg4_42,
			num = arg5_42
		})
	end)
	arg0_1:bind(var0_0.STOP_DELEGATION, function(arg0_43, arg1_43, arg2_43)
		arg0_1:sendNotification(GAME.ISLAND_FINISH_DELEGATION, {
			build_id = arg1_43,
			area_id = arg2_43
		})
	end)
	arg0_1:bind(var0_0.GET_DELEGATION_AWARD, function(arg0_44, arg1_44, arg2_44, arg3_44)
		arg0_1:sendNotification(GAME.ISLAND_GET_DELEGATION_AWARD, {
			build_id = arg1_44,
			area_id = arg2_44,
			type = arg3_44
		})
	end)
	arg0_1:bind(var0_0.USE_SPEEDUPCARD, function(arg0_45, arg1_45, arg2_45, arg3_45, arg4_45)
		arg0_1:sendNotification(GAME.ISLAND_USESPEEDUPCARD, {
			build_id = arg1_45,
			area_id = arg2_45,
			item_id = arg3_45,
			num = arg4_45
		})
	end)
	arg0_1:bind(var0_0.GET_SHOP_DATA, function(arg0_46, arg1_46, arg2_46)
		arg0_1:sendNotification(GAME.ISLAND_SHOP_OP, {
			operation = IslandConst.SHOP_GET_DATA,
			shopId = arg1_46,
			refreshAll = arg2_46
		})
	end)
	arg0_1:bind(var0_0.BUY_COMMODITY, function(arg0_47, arg1_47, arg2_47, arg3_47)
		arg0_1:sendNotification(GAME.ISLAND_SHOP_OP, {
			operation = IslandConst.SHOP_BUY_COMMODITY,
			shopId = arg1_47,
			commodityId = arg2_47,
			count = arg3_47
		})
	end)
	arg0_1:bind(var0_0.REFRESH_SHOP_BY_PLAYER, function(arg0_48, arg1_48, arg2_48)
		arg0_1:sendNotification(GAME.ISLAND_SHOP_OP, {
			operation = IslandConst.SHOP_REFRESH_BY_PLAYER,
			shopId = arg1_48,
			resource = arg2_48
		})
	end)
end

function var0_0._listNotificationInterests(arg0_49)
	return {
		GAME.ISLAND_SET_NAME_DONE,
		GAME.ISLAND_PROSPERITY_AWARD_DONE,
		GAME.ISLAND_UPGRADE_DONE,
		GAME.ISLAND_SET_MANIFESTO_DONE,
		GAME.ISLAND_UPGRADE_INVENTORY_DONE,
		GAME.ISLAND_SELL_ITEM_DONE,
		GAME.ISLAND_SUBMIT_ORDER_DONE,
		GAME.ISLAND_REPLACE_ORDER_DONE,
		GAME.ISLAND_GET_ORDER_EXP_AWARD_DONE,
		GAME.ISLAND_GET_RANDOM_REFRESH_TASK_DONE,
		GAME.ISLAND_ACCEPT_TASK_DONE,
		GAME.ISLAND_UPDATE_TASK_DONE,
		GAME.ISLAND_SUBMIT_TASK_DONE,
		GAME.ISLAND_SET_TRACE_TASK_DONE,
		GAME.ISLAND_UPGRADE_SKILL_DONE,
		GAME.ISLAND_GET_EXTRA_AWARD_DONE,
		GAME.ISLAND_USE_ITEM_DONE,
		GAME.ISLAND_GET_OVERFLOW_ITEM_DOME,
		GAME.ISLAND_SET_ORDER_TENDENCY_DONE,
		GAME.ISLAND_UNLOCK_TECH_DONE,
		GAME.ISLAND_FINISH_TECH_IMMD_DONE,
		GAME.ISLAND_SHIP_ORDER_OP_DONE,
		GAME.ISLAND_START_DELEGATION_DONE,
		GAME.ISLAND_GET_DELEGATION_AWARD_DONE,
		GAME.ISLAND_FINISH_DELEGATION_DONE,
		GAME.ISLAND_USESPEEDUPCARD_DONE,
		PlayerProxy.UPDATED,
		GAME.ISLAND_SHOP_OP_DONE
	}
end

function var0_0._handleNotification(arg0_50, arg1_50)
	local var0_50 = arg1_50:getName()
	local var1_50 = arg1_50:getBody()

	if var0_50 == GAME.ISLAND_PROSPERITY_AWARD_DONE or var0_50 == GAME.ISLAND_SELL_ITEM_DONE or var0_50 == GAME.ISLAND_FINISH_TECH_DONE or var0_50 == GAME.ISLAND_GET_EXTRA_AWARD_DONE or var0_50 == GAME.ISLAND_FINISH_TECH_IMMD_DONE or var0_50 == GAME.ISLAND_SHIP_ORDER_OP_DONE then
		arg0_50:HandleAwardDisplay(var1_50.dropData, var1_50.callback)
	elseif var0_50 == GAME.ISLAND_GET_ORDER_EXP_AWARD_DONE then
		seriesAsync({
			function(arg0_51)
				arg0_50.viewComponent:emit(IslandOrderPage.ON_UPDADE, {
					level = var1_50.level,
					callback = arg0_51
				})
			end
		}, function()
			arg0_50:HandleAwardDisplay(var1_50.dropData, var1_50.callback)
		end)
	elseif var0_50 == GAME.ISLAND_GET_OVERFLOW_ITEM_DOME then
		if #var1_50.awards <= 0 then
			return
		end

		arg0_50.viewComponent:DisplayAward({
			title = i18n1("以下道具已转移"),
			awards = var1_50.awards,
			callback = var1_50.callback
		})
	elseif var0_50 == GAME.ISLAND_SET_MANIFESTO_DONE then
		pg.TipsMgr.GetInstance():ShowTips(i18n1("修改成功"))
	elseif var0_50 == GAME.ISLAND_SUBMIT_ORDER_DONE then
		local var2_50 = {
			function(arg0_53)
				arg0_50:HandleAwardDisplay(var1_50.dropData, arg0_53)
			end
		}

		seriesAsync(var2_50, function()
			if var1_50.callback then
				var1_50.callback()
			end

			arg0_50.viewComponent:emit(IslandScene.ON_CHECK_ORDER_EXP_AWARD)
		end)
	elseif var0_50 == GAME.ISLAND_ACCEPT_TASK_DONE then
		arg0_50:HandleTaskAccepted(var1_50)
	elseif var0_50 == GAME.ISLAND_SUBMIT_TASK_DONE then
		seriesAsync({
			function(arg0_55)
				local var0_55 = pg.island_task[var1_50.taskId].com_perform

				if var0_55 ~= "" then
					arg0_50.viewComponent:PlayStory({
						name = var0_55,
						callback = arg0_55
					})
				else
					arg0_55()
				end
			end
		}, function()
			arg0_50:HandleAwardDisplay(var1_50.dropData, var1_50.callback)
		end)
	elseif var0_50 == GAME.ISLAND_SET_TRACE_TASK_DONE then
		arg0_50.viewComponent:OnUpdateTrackTask(var1_50.traceId)
	end
end

function var0_0.HandleAwardDisplay(arg0_57, arg1_57, arg2_57)
	seriesAsync({
		function(arg0_58)
			if not arg1_57.drops or #arg1_57.drops <= 0 then
				arg0_58()

				return
			end

			arg0_57.viewComponent:emit(BaseUI.ON_ACHIEVE, arg1_57.drops, arg0_58)
		end,
		function(arg0_59)
			onNextTick(arg0_59)
		end,
		function(arg0_60)
			if not arg1_57.awards or #arg1_57.awards <= 0 then
				arg0_60()

				return
			end

			arg0_57.viewComponent:DisplayAward({
				title = i18n1("获得道具"),
				awards = arg1_57.awards,
				callback = arg0_60
			})
		end,
		function(arg0_61)
			onNextTick(arg0_61)
		end,
		function(arg0_62)
			if not arg1_57.overflowAwards or #arg1_57.overflowAwards == 0 then
				arg0_62()

				return
			end

			arg0_57.viewComponent:DisplayAward({
				titleColor = "#ab4734",
				title = i18n1("以下道具将存入临时背包"),
				awards = arg1_57.overflowAwards,
				callback = arg0_62
			})
		end,
		function(arg0_63)
			if not arg1_57.overflowAwards or #arg1_57.overflowAwards == 0 then
				arg0_63()

				return
			end

			arg0_57.viewComponent:OpenPage(IslandInventoryPage)
			arg0_63()
		end
	}, arg2_57)
end

function var0_0.HandleTaskAccepted(arg0_64, arg1_64)
	local var0_64 = {}

	for iter0_64, iter1_64 in ipairs(arg1_64.taskIds) do
		local var1_64 = pg.island_task[iter1_64]

		if var1_64.rec_perform ~= "" then
			table.insert(var0_64, function(arg0_65)
				arg0_64.viewComponent:PlayStory({
					name = var1_64.rec_perform,
					callback = arg0_65
				})
			end)
		end

		if var1_64.trigger_tips == 1 then
			table.insert(var0_64, function(arg0_66)
				arg0_64.viewComponent:OpenPage(Island3dTaskAcceptPage, iter1_64, arg0_66)
			end)
		end
	end

	seriesAsync(var0_64, function()
		existCall(arg1_64.callback)
	end)
end

return var0_0
