local var0 = class("DailyLevelMediator", import("..base.ContextMediator"))

var0.ON_STAGE = "DailyLevelMediator:ON_STAGE"
var0.ON_CHALLENGE = "DailyLevelMediator:ON_CHALLENGE"
var0.ON_RESET_CHALLENGE = "DailyLevelMediator:ON_RESET_CHALLENGE"
var0.ON_CONTINUE_CHALLENGE = "DailyLevelMediator:ON_CONTINUE_CHALLENGE"
var0.ON_CHALLENGE_EDIT_FLEET = "DailyLevelMediator:ON_CHALLENGE_EDIT_FLEET"
var0.ON_REQUEST_CHALLENGE = "DailyLevelMediator:ON_REQUEST_CHALLENGE"
var0.ON_CHALLENGE_FLEET_CLEAR = "DailyLevelMediator.ON_CHALLENGE_FLEET_CLEAR"
var0.ON_CHALLENGE_FLEET_RECOMMEND = "DailyLevelMediator.ON_CHALLENGE_FLEET_RECOMMEND"
var0.ON_CHALLENGE_OPEN_DOCK = "DailyLevelMediator:ON_CHALLENGE_OPEN_DOCK"
var0.ON_CHALLENGE_OPEN_RANK = "DailyLevelMediator:ON_CHALLENGE_OPEN_RANK"
var0.ON_QUICK_BATTLE = "DailyLevelMediator:ON_QUICK_BATTLE"

function var0.register(arg0)
	local var0 = getProxy(DailyLevelProxy)

	arg0.viewComponent:setDailyCounts(var0:getRawData())

	arg0.ships = getProxy(BayProxy):getRawData()

	arg0.viewComponent:setShips(arg0.ships)

	local var1 = getProxy(PlayerProxy):getData()

	arg0.viewComponent:updateRes(var1)
	arg0:bind(var0.ON_QUICK_BATTLE, function(arg0, arg1, arg2, arg3)
		arg0:CheckShipExpItemOverflow(arg2, function()
			arg0:sendNotification(GAME.DAILY_LEVEL_QUICK_BATTLE, {
				dailyLevelId = arg1,
				stageId = arg2,
				cnt = arg3
			})
		end)
	end)
	arg0:bind(var0.ON_STAGE, function(arg0, arg1)
		var0.dailyLevelId = arg0.contextData.dailyLevelId

		local var0 = PreCombatLayer
		local var1 = SYSTEM_ROUTINE

		if pg.expedition_data_template[arg1.id].type == Stage.SubmarinStage then
			var0 = PreCombatLayerSubmarine
			var1 = SYSTEM_SUB_ROUTINE
		end

		arg0:addSubLayers(Context.New({
			mediator = PreCombatMediator,
			viewComponent = var0,
			data = {
				stageId = arg1.id,
				system = var1,
				OnConfirm = function(arg0)
					arg0:CheckShipExpItemOverflow(arg1.id, arg0)
				end
			}
		}))
	end)
	arg0:bind(var0.ON_CHALLENGE, function()
		arg0.viewComponent:openChallengeView()
	end)
	arg0:bind(var0.ON_CHALLENGE_EDIT_FLEET, function(arg0, arg1)
		local var0 = challengeProxy:getCurrentChallengeInfo()

		var0:setDamageRateID(arg1.damageRateID)
		var0:setLevelRateID(arg1.levelRateID)
		challengeProxy:updateChallenge(var0)
		arg0.viewComponent:openChallengeFleetEditView()
	end)
	arg0:bind(var0.ON_CONTINUE_CHALLENGE, function()
		arg0:addSubLayers(Context.New({
			mediator = ChallengePreCombatMediator,
			viewComponent = ChallengePreCombatLayer,
			data = {}
		}))
	end)
	arg0:bind(var0.ON_RESET_CHALLENGE, function()
		arg0:sendNotification(GAME.CHALLENGE_RESET)
	end)
	arg0:bind(var0.ON_CHALLENGE_FLEET_CLEAR, function()
		challengeProxy:clearEdittingFleet()
		arg0.viewComponent:flushFleetEditButton()
	end)
	arg0:bind(var0.ON_CHALLENGE_FLEET_RECOMMEND, function()
		challengeProxy:recommendChallengeFleet()
		arg0.viewComponent:flushFleetEditButton()
	end)
	arg0:bind(var0.ON_REQUEST_CHALLENGE, function()
		local var0 = challengeProxy:getCurrentChallengeInfo()
		local var1 = var0:getGSRateID()

		for iter0 = 1, 4 do
			PlayerPrefs.SetInt("challengeShipUID_" .. iter0, nil)
		end

		for iter1 = 1, #var0:getShips() do
			PlayerPrefs.SetInt("challengeShipUID_" .. iter1, var0:getShips()[iter1].id)
		end

		arg0:sendNotification(GAME.CHALLENGE_REQUEST, {
			shipIDList = var0:getShips(),
			levelRate = var0:getLevelRateID(),
			damageRate = var0:getDamageRateID(),
			gsRate = var1
		})
	end)
	arg0:bind(var0.ON_CHALLENGE_OPEN_RANK, function()
		arg0:sendNotification(GAME.GO_SCENE, SCENE.BILLBOARD, {
			page = PowerRank.TYPE_CHALLENGE
		})
	end)
	arg0:bind(var0.ON_CHALLENGE_OPEN_DOCK, function(arg0, arg1)
		local var0 = arg1.shipType
		local var1 = arg1.shipVO
		local var2 = arg1.fleet
		local var3 = arg1.teamType
		local var4 = getProxy(BayProxy):getRawData()
		local var5 = {}

		for iter0, iter1 in pairs(var4) do
			if iter1:getTeamType() ~= var3 or var0 ~= 0 and not table.contains({
				var0
			}, iter1:getShipType()) then
				table.insert(var5, iter0)
			end
		end

		local var6
		local var7
		local var8

		if var1 == nil then
			var6 = false
			var8 = nil
		else
			var6 = true
			var8 = var1.id
		end

		local var9 = {
			inChallenge = true,
			inEvent = false,
			inBackyard = false,
			inFleet = false,
			inClass = false,
			inTactics = false,
			inAdmiral = false
		}

		arg0.contextData.challenge = true

		local var10, var11, var12 = arg0:getDockCallbackFuncs(var2, var1)

		arg0:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			selectedMin = 0,
			selectedMax = 1,
			ignoredIds = var5,
			activeShipId = var8,
			leastLimitMsg = i18n("ship_formationMediator_leastLimit"),
			quitTeam = var6,
			leftTopInfo = i18n("word_formation"),
			onShip = var10,
			confirmSelect = var11,
			onSelected = var12,
			flags = var9
		})
	end)

	if arg0.contextData.loadBillBoard then
		arg0.contextData.loadBillBoard = nil

		arg0.viewComponent:emit(var0.ON_CHALLENGE_OPEN_RANK)
	end
end

function var0.CheckShipExpItemOverflow(arg0, arg1, arg2)
	local var0 = pg.expedition_data_template[arg1].award_display

	if _.any(var0, function(arg0)
		local var0 = getProxy(BagProxy):getItemCountById(arg0[2])
		local var1 = Item.getConfigData(arg0[2])

		return arg0[1] == DROP_TYPE_ITEM and var1.type == Item.EXP_BOOK_TYPE and var0 >= var1.max_num
	end) then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("player_expResource_mail_fullBag"),
			onYes = arg2,
			weight = LayerWeightConst.THIRD_LAYER
		})
	else
		arg2()
	end
end

function var0.listNotificationInterests(arg0)
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

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:updateRes(var1)
	elseif var0 == ChallengeProxy.PRECOMBAT then
		arg0:addSubLayers(Context.New({
			mediator = ChallengePreCombatMediator,
			viewComponent = ChallengePreCombatLayer,
			data = {
				stageId = stage.id,
				system = SYSTEM_ROUTINE
			}
		}))
	elseif var0 == GAME.CHALLENGE_REQUEST_DONE then
		arg0:addSubLayers(Context.New({
			mediator = ChallengePreCombatMediator,
			viewComponent = ChallengePreCombatLayer,
			data = {}
		}))
		arg0.viewComponent:closeChallengeFleetEditView()
	elseif var0 == GAME.CHALLENGE_RESET_DONE then
		arg0.viewComponent:closeChallengeSettingView()
		arg0.viewComponent:openChallengeSettingView()
	elseif var0 == ChallengeProxy.CHALLENGE_UPDATED then
		local var2 = getProxy(ChallengeProxy):getCurrentChallengeInfo()

		arg0.viewComponent:setChallengeInfo(var2)
	elseif var0 == GAME.DAILY_LEVEL_QUICK_BATTLE_DONE then
		local var3 = var1.awards

		if #var3 > 0 then
			arg0:DisplayAwards(var3)
		end

		local var4 = getProxy(DailyLevelProxy)

		arg0.viewComponent:setDailyCounts(var4:getRawData())
		arg0.viewComponent:UpdateBattleBtn({
			id = var1.stageId
		})
		arg0.viewComponent:UpdateDailyLevelCnt(var1.dailyLevelId)
		arg0.viewComponent:UpdateDailyLevelCntForDescPanel(var1.dailyLevelId)
	elseif var0 == GAME.REMOVE_LAYERS and var1.context.mediator.__cname == "PreCombatMediator" then
		setActive(arg0.viewComponent.blurPanel, true)
	end
end

function var0.getDockCallbackFuncs(arg0, arg1, arg2)
	local var0 = getProxy(BayProxy)
	local var1 = getProxy(ChallengeProxy)
	local var2 = var1:getCurrentChallengeInfo()
	local var3 = var2:getShips()

	local function var4(arg0, arg1)
		if arg2 and arg2:isSameKind(arg0) then
			return true
		end

		local var0 = Challenge.shipTypeFixer(arg0:getShipType())
		local var1 = 0

		for iter0, iter1 in pairs(arg1) do
			if Challenge.shipTypeFixer(iter0:getShipType()) == var0 then
				var1 = var1 + 1
			end

			if arg0:isSameKind(iter0) then
				return false, i18n("event_same_type_not_allowed")
			end
		end

		if arg2 and Challenge.shipTypeFixer(arg2:getShipType()) == var0 then
			var1 = var1 - 1
		end

		if var1 >= Challenge.SAME_TYPE_LIMIT then
			return false, i18n("challenge_fleet_type_fail")
		end

		return true
	end

	local function var5(arg0, arg1, arg2)
		arg1()
	end

	local function var6(arg0)
		if arg2 then
			local var0

			for iter0, iter1 in ipairs(var3) do
				if iter1.id == arg2.id then
					var0 = iter0

					break
				end
			end

			table.remove(var3, var0)
		end

		if #arg0 > 0 then
			var3[#var3 + 1] = {
				id = arg0[1]
			}
		end

		var1:updateChallenge(var2)
	end

	return var4, var5, var6
end

function var0.DisplayAwards(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in ipairs(arg1) do
		for iter2, iter3 in ipairs(iter1) do
			table.insert(var0, iter3)
		end
	end

	arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var0)
end

return var0
