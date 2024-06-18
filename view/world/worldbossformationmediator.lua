local var0_0 = class("WorldBossFormationMediator", import("..base.ContextMediator"))

var0_0.ON_START = "WorldBossFormationMediator:ON_START"
var0_0.ON_COMMIT_EDIT = "WorldBossFormationMediator:ON_COMMIT_EDIT"
var0_0.OPEN_SHIP_INFO = "WorldBossFormationMediator:OPEN_SHIP_INFO"
var0_0.REMOVE_SHIP = "WorldBossFormationMediator:REMOVE_SHIP"
var0_0.CHANGE_FLEET_SHIP = "WorldBossFormationMediator:CHANGE_FLEET_SHIPs"
var0_0.ON_AUTO = "WorldBossFormationMediator:ON_AUTO"
var0_0.CHANGE_FLEET_SHIPS_ORDER = "WorldBossFormationMediator:CHANGE_FLEET_SHIPS_ORDER"

function var0_0.register(arg0_1)
	local var0_1 = getProxy(BayProxy)

	arg0_1.ships = var0_1:getRawData()

	arg0_1.viewComponent:SetShips(arg0_1.ships)

	local var1_1 = nowWorld():GetBossProxy()
	local var2_1 = arg0_1.contextData.editingFleetVO or Clone(var1_1:GetFleet(arg0_1.contextData.bossId))

	arg0_1.viewComponent:SetBossProxy(var1_1, arg0_1.contextData.bossId)
	var1_1:LockCacheBoss(arg0_1.contextData.bossId)
	arg0_1.viewComponent:SetCurrentFleet(var2_1)

	local var3_1 = getProxy(PlayerProxy):getData()

	arg0_1.viewComponent:SetPlayerInfo(var3_1)
	arg0_1:bind(var0_0.REMOVE_SHIP, function(arg0_2, arg1_2, arg2_2)
		if not arg2_2:canRemove(arg1_2) then
			local var0_2, var1_2 = arg2_2:getShipPos(arg1_2)

			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_formationUI_removeError_onlyShip", arg1_2:getConfigTable().name, arg2_2.name, Fleet.C_TEAM_NAME[var1_2]))

			return
		end

		arg2_2:removeShip(arg1_2)
		arg0_1.viewComponent:UpdateFleetView(true)
	end)
	arg0_1:bind(var0_0.CHANGE_FLEET_SHIPS_ORDER, function(arg0_3, arg1_3)
		arg0_1.viewComponent:UpdateFleetView()
	end)
	arg0_1:bind(var0_0.OPEN_SHIP_INFO, function(arg0_4, arg1_4, arg2_4)
		arg0_1.contextData.form = PreCombatLayer.FORM_EDIT

		local var0_4 = arg0_1.viewComponent._currentFleetVO
		local var1_4 = {}

		for iter0_4, iter1_4 in ipairs(arg2_4.ships) do
			table.insert(var1_4, arg0_1.ships[iter1_4])
		end

		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			shipId = arg1_4,
			shipVOs = var1_4
		})
	end)
	arg0_1:bind(var0_0.ON_COMMIT_EDIT, function(arg0_5, arg1_5)
		local var0_5 = arg0_1.viewComponent._currentFleetVO

		var1_1:UpdateFleet(arg0_1.contextData.bossId, var0_5)
		var1_1:SavaCacheShips(arg0_1.contextData.bossId, var0_5)
		arg1_5()
	end)
	arg0_1:bind(var0_0.ON_AUTO, function(arg0_6, arg1_6)
		arg0_1:onAutoBtn(arg1_6)
	end)
	arg0_1:bind(var0_0.ON_START, function(arg0_7)
		local var0_7, var1_7 = var1_1:GetFleet(arg0_1.contextData.bossId):isLegalToFight()

		if var0_7 ~= true then
			pg.TipsMgr:GetInstance():ShowTips(i18n("elite_disable_no_fleet"))

			return
		end

		local var2_7 = nowWorld():GetBossProxy():GetBossById(arg0_1.contextData.bossId)

		if not var2_7 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_joint_boss_not_found"))

			return
		end

		if arg0_1.contextData.isOther and var1_1:GetPt() <= 0 and WorldBossConst._IsCurrBoss(var2_7) then
			pg.TipsMgr:GetInstance():ShowTips(i18n("world_joint_count_no_enough"))

			return
		end

		if arg0_1.contextData.isOther then
			WorldBossScene.inOtherBossBattle = arg0_1.contextData.bossId
		end

		arg0_1:sendNotification(GAME.BEGIN_STAGE, {
			actId = 0,
			bossId = arg0_1.contextData.bossId,
			system = SYSTEM_WORLD_BOSS
		})
	end)
	arg0_1:bind(var0_0.CHANGE_FLEET_SHIP, function(arg0_8, arg1_8, arg2_8, arg3_8)
		arg0_1.contextData.form = WorldBossFormationLayer.FORM_EDIT
		CurrentWorldBossDetailPage.formDock = true

		local var0_8 = tobool(arg1_8)
		local var1_8 = arg1_8 and arg1_8.id or nil
		local var2_8 = arg2_8.ships or {}

		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			selectedMin = 1,
			selectedMax = 1,
			ignoredIds = var2_8,
			leastLimitMsg = i18n("ship_formationMediator_leastLimit"),
			quitTeam = var0_8,
			teamFilter = arg3_8,
			leftTopInfo = i18n("word_formation"),
			onShip = function(arg0_9)
				if _.any(arg2_8.ships, function(arg0_10)
					return arg0_9:isSameKind(var0_1:getShipById(arg0_10))
				end) then
					return false, i18n("event_same_type_not_allowed")
				end

				return true
			end,
			onSelected = function(arg0_11)
				local var0_11 = arg0_11[1]
				local var1_11 = getProxy(BayProxy):getShipById(var0_11)

				if var1_11 and var2_1:containShip(var1_11) then
					return
				end

				if var1_8 == nil then
					arg2_8:insertShip(var1_11, nil, arg3_8)
				else
					local var2_11 = var2_1:getShipPos(arg1_8)

					arg2_8:removeShipById(var1_8)

					if var1_11 and var2_11 then
						arg2_8:insertShip(var1_11, var2_11, arg3_8)
					end
				end
			end,
			preView = arg0_1.viewComponent.__cname,
			hideTagFlags = ShipStatus.TAG_HIDE_ALL
		})
	end)
end

function var0_0.onAutoBtn(arg0_12, arg1_12)
	local var0_12 = arg1_12.isOn
	local var1_12 = arg1_12.toggle

	arg0_12:sendNotification(GAME.AUTO_BOT, {
		isActiveBot = var0_12,
		toggle = var1_12,
		system = SYSTEM_WORLD
	})
end

function var0_0.listNotificationInterests(arg0_13)
	return {
		GAME.BEGIN_STAGE_DONE,
		GAME.WORLD_BOSS_START_BATTLE_FIALED,
		PlayerProxy.UPDATED,
		GAME.END_GUIDE
	}
end

function var0_0.handleNotification(arg0_14, arg1_14)
	local var0_14 = arg1_14:getName()
	local var1_14 = arg1_14:getBody()

	if var0_14 == GAME.BEGIN_STAGE_DONE then
		arg0_14:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1_14)
	elseif var0_14 == GAME.WORLD_BOSS_START_BATTLE_FIALED then
		arg0_14.viewComponent:emit(BaseUI.ON_CLOSE)
	elseif var0_14 == PlayerProxy.UPDATED then
		arg0_14.viewComponent:SetPlayerInfo(getProxy(PlayerProxy):getData())
	elseif var0_14 == GAME.END_GUIDE then
		arg0_14.viewComponent:TryPlayGuide()
	end
end

return var0_0
