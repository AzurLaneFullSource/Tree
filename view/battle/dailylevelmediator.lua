local var0_0 = class("DailyLevelMediator", import("..base.ContextMediator"))

var0_0.ON_STAGE = "DailyLevelMediator:ON_STAGE"
var0_0.ON_CHALLENGE = "DailyLevelMediator:ON_CHALLENGE"
var0_0.ON_RESET_CHALLENGE = "DailyLevelMediator:ON_RESET_CHALLENGE"
var0_0.ON_CONTINUE_CHALLENGE = "DailyLevelMediator:ON_CONTINUE_CHALLENGE"
var0_0.ON_CHALLENGE_EDIT_FLEET = "DailyLevelMediator:ON_CHALLENGE_EDIT_FLEET"
var0_0.ON_REQUEST_CHALLENGE = "DailyLevelMediator:ON_REQUEST_CHALLENGE"
var0_0.ON_CHALLENGE_FLEET_CLEAR = "DailyLevelMediator.ON_CHALLENGE_FLEET_CLEAR"
var0_0.ON_CHALLENGE_FLEET_RECOMMEND = "DailyLevelMediator.ON_CHALLENGE_FLEET_RECOMMEND"
var0_0.ON_CHALLENGE_OPEN_DOCK = "DailyLevelMediator:ON_CHALLENGE_OPEN_DOCK"
var0_0.ON_CHALLENGE_OPEN_RANK = "DailyLevelMediator:ON_CHALLENGE_OPEN_RANK"
var0_0.ON_QUICK_BATTLE = "DailyLevelMediator:ON_QUICK_BATTLE"

function var0_0.register(arg0_1)
	local var0_1 = getProxy(DailyLevelProxy)

	arg0_1.viewComponent:setDailyCounts(var0_1:getRawData())

	arg0_1.ships = getProxy(BayProxy):getRawData()

	arg0_1.viewComponent:setShips(arg0_1.ships)

	local var1_1 = getProxy(PlayerProxy):getData()

	arg0_1.viewComponent:updateRes(var1_1)
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
	arg0_1:bind(var0_0.ON_CHALLENGE, function()
		arg0_1.viewComponent:openChallengeView()
	end)
	arg0_1:bind(var0_0.ON_CHALLENGE_EDIT_FLEET, function(arg0_7, arg1_7)
		local var0_7 = challengeProxy:getCurrentChallengeInfo()

		var0_7:setDamageRateID(arg1_7.damageRateID)
		var0_7:setLevelRateID(arg1_7.levelRateID)
		challengeProxy:updateChallenge(var0_7)
		arg0_1.viewComponent:openChallengeFleetEditView()
	end)
	arg0_1:bind(var0_0.ON_CONTINUE_CHALLENGE, function()
		arg0_1:addSubLayers(Context.New({
			mediator = ChallengePreCombatMediator,
			viewComponent = ChallengePreCombatLayer,
			data = {}
		}))
	end)
	arg0_1:bind(var0_0.ON_RESET_CHALLENGE, function()
		arg0_1:sendNotification(GAME.CHALLENGE_RESET)
	end)
	arg0_1:bind(var0_0.ON_CHALLENGE_FLEET_CLEAR, function()
		challengeProxy:clearEdittingFleet()
		arg0_1.viewComponent:flushFleetEditButton()
	end)
	arg0_1:bind(var0_0.ON_CHALLENGE_FLEET_RECOMMEND, function()
		challengeProxy:recommendChallengeFleet()
		arg0_1.viewComponent:flushFleetEditButton()
	end)
	arg0_1:bind(var0_0.ON_REQUEST_CHALLENGE, function()
		local var0_12 = challengeProxy:getCurrentChallengeInfo()
		local var1_12 = var0_12:getGSRateID()

		for iter0_12 = 1, 4 do
			PlayerPrefs.SetInt("challengeShipUID_" .. iter0_12, nil)
		end

		for iter1_12 = 1, #var0_12:getShips() do
			PlayerPrefs.SetInt("challengeShipUID_" .. iter1_12, var0_12:getShips()[iter1_12].id)
		end

		arg0_1:sendNotification(GAME.CHALLENGE_REQUEST, {
			shipIDList = var0_12:getShips(),
			levelRate = var0_12:getLevelRateID(),
			damageRate = var0_12:getDamageRateID(),
			gsRate = var1_12
		})
	end)
	arg0_1:bind(var0_0.ON_CHALLENGE_OPEN_RANK, function()
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.BILLBOARD, {
			page = PowerRank.TYPE_CHALLENGE
		})
	end)
	arg0_1:bind(var0_0.ON_CHALLENGE_OPEN_DOCK, function(arg0_14, arg1_14)
		local var0_14 = arg1_14.shipType
		local var1_14 = arg1_14.shipVO
		local var2_14 = arg1_14.fleet
		local var3_14 = arg1_14.teamType
		local var4_14 = getProxy(BayProxy):getRawData()
		local var5_14 = {}

		for iter0_14, iter1_14 in pairs(var4_14) do
			if iter1_14:getTeamType() ~= var3_14 or var0_14 ~= 0 and not table.contains({
				var0_14
			}, iter1_14:getShipType()) then
				table.insert(var5_14, iter0_14)
			end
		end

		local var6_14
		local var7_14
		local var8_14

		if var1_14 == nil then
			var6_14 = false
			var8_14 = nil
		else
			var6_14 = true
			var8_14 = var1_14.id
		end

		local var9_14 = {
			inChallenge = true,
			inEvent = false,
			inBackyard = false,
			inFleet = false,
			inClass = false,
			inTactics = false,
			inAdmiral = false
		}

		arg0_1.contextData.challenge = true

		local var10_14, var11_14, var12_14 = arg0_1:getDockCallbackFuncs(var2_14, var1_14)

		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			selectedMin = 0,
			selectedMax = 1,
			ignoredIds = var5_14,
			activeShipId = var8_14,
			leastLimitMsg = i18n("ship_formationMediator_leastLimit"),
			quitTeam = var6_14,
			leftTopInfo = i18n("word_formation"),
			onShip = var10_14,
			confirmSelect = var11_14,
			onSelected = var12_14,
			flags = var9_14
		})
	end)

	if arg0_1.contextData.loadBillBoard then
		arg0_1.contextData.loadBillBoard = nil

		arg0_1.viewComponent:emit(var0_0.ON_CHALLENGE_OPEN_RANK)
	end
end

function var0_0.CheckShipExpItemOverflow(arg0_15, arg1_15, arg2_15)
	local var0_15 = pg.expedition_data_template[arg1_15].award_display

	if _.any(var0_15, function(arg0_16)
		local var0_16 = getProxy(BagProxy):getItemCountById(arg0_16[2])
		local var1_16 = Item.getConfigData(arg0_16[2])

		return arg0_16[1] == DROP_TYPE_ITEM and var1_16.type == Item.EXP_BOOK_TYPE and var0_16 >= var1_16.max_num
	end) then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("player_expResource_mail_fullBag"),
			onYes = arg2_15,
			weight = LayerWeightConst.THIRD_LAYER
		})
	else
		arg2_15()
	end
end

function var0_0.listNotificationInterests(arg0_17)
	return {
		PlayerProxy.UPDATED,
		ChallengeProxy.PRECOMBAT,
		ChallengeProxy.CHALLENGE_UPDATED,
		GAME.CHALLENGE_REQUEST_DONE,
		GAME.CHALLENGE_RESET_DONE,
		GAME.DAILY_LEVEL_QUICK_BATTLE_DONE,
		GAME.REMOVE_LAYERS
	}
end

function var0_0.handleNotification(arg0_18, arg1_18)
	local var0_18 = arg1_18:getName()
	local var1_18 = arg1_18:getBody()

	if var0_18 == PlayerProxy.UPDATED then
		arg0_18.viewComponent:updateRes(var1_18)
	elseif var0_18 == ChallengeProxy.PRECOMBAT then
		arg0_18:addSubLayers(Context.New({
			mediator = ChallengePreCombatMediator,
			viewComponent = ChallengePreCombatLayer,
			data = {
				stageId = stage.id,
				system = SYSTEM_ROUTINE
			}
		}))
	elseif var0_18 == GAME.CHALLENGE_REQUEST_DONE then
		arg0_18:addSubLayers(Context.New({
			mediator = ChallengePreCombatMediator,
			viewComponent = ChallengePreCombatLayer,
			data = {}
		}))
		arg0_18.viewComponent:closeChallengeFleetEditView()
	elseif var0_18 == GAME.CHALLENGE_RESET_DONE then
		arg0_18.viewComponent:closeChallengeSettingView()
		arg0_18.viewComponent:openChallengeSettingView()
	elseif var0_18 == ChallengeProxy.CHALLENGE_UPDATED then
		local var2_18 = getProxy(ChallengeProxy):getCurrentChallengeInfo()

		arg0_18.viewComponent:setChallengeInfo(var2_18)
	elseif var0_18 == GAME.DAILY_LEVEL_QUICK_BATTLE_DONE then
		local var3_18 = var1_18.awards

		if #var3_18 > 0 then
			arg0_18:DisplayAwards(var3_18)
		end

		local var4_18 = getProxy(DailyLevelProxy)

		arg0_18.viewComponent:setDailyCounts(var4_18:getRawData())
		arg0_18.viewComponent:UpdateBattleBtn({
			id = var1_18.stageId
		})
		arg0_18.viewComponent:UpdateDailyLevelCnt(var1_18.dailyLevelId)
		arg0_18.viewComponent:UpdateDailyLevelCntForDescPanel(var1_18.dailyLevelId)
	elseif var0_18 == GAME.REMOVE_LAYERS and var1_18.context.mediator.__cname == "PreCombatMediator" then
		setActive(arg0_18.viewComponent.blurPanel, true)
	end
end

function var0_0.getDockCallbackFuncs(arg0_19, arg1_19, arg2_19)
	local var0_19 = getProxy(BayProxy)
	local var1_19 = getProxy(ChallengeProxy)
	local var2_19 = var1_19:getCurrentChallengeInfo()
	local var3_19 = var2_19:getShips()

	local function var4_19(arg0_20, arg1_20)
		if arg2_19 and arg2_19:isSameKind(arg0_20) then
			return true
		end

		local var0_20 = Challenge.shipTypeFixer(arg0_20:getShipType())
		local var1_20 = 0

		for iter0_20, iter1_20 in pairs(arg1_19) do
			if Challenge.shipTypeFixer(iter0_20:getShipType()) == var0_20 then
				var1_20 = var1_20 + 1
			end

			if arg0_20:isSameKind(iter0_20) then
				return false, i18n("event_same_type_not_allowed")
			end
		end

		if arg2_19 and Challenge.shipTypeFixer(arg2_19:getShipType()) == var0_20 then
			var1_20 = var1_20 - 1
		end

		if var1_20 >= Challenge.SAME_TYPE_LIMIT then
			return false, i18n("challenge_fleet_type_fail")
		end

		return true
	end

	local function var5_19(arg0_21, arg1_21, arg2_21)
		arg1_21()
	end

	local function var6_19(arg0_22)
		if arg2_19 then
			local var0_22

			for iter0_22, iter1_22 in ipairs(var3_19) do
				if iter1_22.id == arg2_19.id then
					var0_22 = iter0_22

					break
				end
			end

			table.remove(var3_19, var0_22)
		end

		if #arg0_22 > 0 then
			var3_19[#var3_19 + 1] = {
				id = arg0_22[1]
			}
		end

		var1_19:updateChallenge(var2_19)
	end

	return var4_19, var5_19, var6_19
end

function var0_0.DisplayAwards(arg0_23, arg1_23)
	local var0_23 = {}

	for iter0_23, iter1_23 in ipairs(arg1_23) do
		for iter2_23, iter3_23 in ipairs(iter1_23) do
			table.insert(var0_23, iter3_23)
		end
	end

	arg0_23.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_23)
end

return var0_0
