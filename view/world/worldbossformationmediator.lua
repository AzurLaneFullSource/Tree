local var0 = class("WorldBossFormationMediator", import("..base.ContextMediator"))

var0.ON_START = "WorldBossFormationMediator:ON_START"
var0.ON_COMMIT_EDIT = "WorldBossFormationMediator:ON_COMMIT_EDIT"
var0.OPEN_SHIP_INFO = "WorldBossFormationMediator:OPEN_SHIP_INFO"
var0.REMOVE_SHIP = "WorldBossFormationMediator:REMOVE_SHIP"
var0.CHANGE_FLEET_SHIP = "WorldBossFormationMediator:CHANGE_FLEET_SHIPs"
var0.ON_AUTO = "WorldBossFormationMediator:ON_AUTO"
var0.CHANGE_FLEET_SHIPS_ORDER = "WorldBossFormationMediator:CHANGE_FLEET_SHIPS_ORDER"

function var0.register(arg0)
	local var0 = getProxy(BayProxy)

	arg0.ships = var0:getRawData()

	arg0.viewComponent:SetShips(arg0.ships)

	local var1 = nowWorld():GetBossProxy()
	local var2 = arg0.contextData.editingFleetVO or Clone(var1:GetFleet(arg0.contextData.bossId))

	arg0.viewComponent:SetBossProxy(var1, arg0.contextData.bossId)
	var1:LockCacheBoss(arg0.contextData.bossId)
	arg0.viewComponent:SetCurrentFleet(var2)

	local var3 = getProxy(PlayerProxy):getData()

	arg0.viewComponent:SetPlayerInfo(var3)
	arg0:bind(var0.REMOVE_SHIP, function(arg0, arg1, arg2)
		if not arg2:canRemove(arg1) then
			local var0, var1 = arg2:getShipPos(arg1)

			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_formationUI_removeError_onlyShip", arg1:getConfigTable().name, arg2.name, Fleet.C_TEAM_NAME[var1]))

			return
		end

		arg2:removeShip(arg1)
		arg0.viewComponent:UpdateFleetView(true)
	end)
	arg0:bind(var0.CHANGE_FLEET_SHIPS_ORDER, function(arg0, arg1)
		arg0.viewComponent:UpdateFleetView()
	end)
	arg0:bind(var0.OPEN_SHIP_INFO, function(arg0, arg1, arg2)
		arg0.contextData.form = PreCombatLayer.FORM_EDIT

		local var0 = arg0.viewComponent._currentFleetVO
		local var1 = {}

		for iter0, iter1 in ipairs(arg2.ships) do
			table.insert(var1, arg0.ships[iter1])
		end

		arg0:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			shipId = arg1,
			shipVOs = var1
		})
	end)
	arg0:bind(var0.ON_COMMIT_EDIT, function(arg0, arg1)
		local var0 = arg0.viewComponent._currentFleetVO

		var1:UpdateFleet(arg0.contextData.bossId, var0)
		var1:SavaCacheShips(arg0.contextData.bossId, var0)
		arg1()
	end)
	arg0:bind(var0.ON_AUTO, function(arg0, arg1)
		arg0:onAutoBtn(arg1)
	end)
	arg0:bind(var0.ON_START, function(arg0)
		local var0, var1 = var1:GetFleet(arg0.contextData.bossId):isLegalToFight()

		if var0 ~= true then
			pg.TipsMgr:GetInstance():ShowTips(i18n("elite_disable_no_fleet"))

			return
		end

		local var2 = nowWorld():GetBossProxy():GetBossById(arg0.contextData.bossId)

		if not var2 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_joint_boss_not_found"))

			return
		end

		if arg0.contextData.isOther and var1:GetPt() <= 0 and WorldBossConst._IsCurrBoss(var2) then
			pg.TipsMgr:GetInstance():ShowTips(i18n("world_joint_count_no_enough"))

			return
		end

		if arg0.contextData.isOther then
			WorldBossScene.inOtherBossBattle = arg0.contextData.bossId
		end

		arg0:sendNotification(GAME.BEGIN_STAGE, {
			actId = 0,
			bossId = arg0.contextData.bossId,
			system = SYSTEM_WORLD_BOSS
		})
	end)
	arg0:bind(var0.CHANGE_FLEET_SHIP, function(arg0, arg1, arg2, arg3)
		arg0.contextData.form = WorldBossFormationLayer.FORM_EDIT
		CurrentWorldBossDetailPage.formDock = true

		local var0 = tobool(arg1)
		local var1 = arg1 and arg1.id or nil
		local var2 = arg2.ships or {}

		arg0:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			selectedMin = 1,
			selectedMax = 1,
			ignoredIds = var2,
			leastLimitMsg = i18n("ship_formationMediator_leastLimit"),
			quitTeam = var0,
			teamFilter = arg3,
			leftTopInfo = i18n("word_formation"),
			onShip = function(arg0)
				if _.any(arg2.ships, function(arg0)
					return arg0:isSameKind(var0:getShipById(arg0))
				end) then
					return false, i18n("event_same_type_not_allowed")
				end

				return true
			end,
			onSelected = function(arg0)
				local var0 = arg0[1]
				local var1 = getProxy(BayProxy):getShipById(var0)

				if var1 and var2:containShip(var1) then
					return
				end

				if var1 == nil then
					arg2:insertShip(var1, nil, arg3)
				else
					local var2 = var2:getShipPos(arg1)

					arg2:removeShipById(var1)

					if var1 and var2 then
						arg2:insertShip(var1, var2, arg3)
					end
				end
			end,
			preView = arg0.viewComponent.__cname,
			hideTagFlags = ShipStatus.TAG_HIDE_ALL
		})
	end)
end

function var0.onAutoBtn(arg0, arg1)
	local var0 = arg1.isOn
	local var1 = arg1.toggle

	arg0:sendNotification(GAME.AUTO_BOT, {
		isActiveBot = var0,
		toggle = var1,
		system = SYSTEM_WORLD
	})
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.BEGIN_STAGE_DONE,
		GAME.WORLD_BOSS_START_BATTLE_FIALED,
		PlayerProxy.UPDATED,
		GAME.END_GUIDE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.BEGIN_STAGE_DONE then
		arg0:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1)
	elseif var0 == GAME.WORLD_BOSS_START_BATTLE_FIALED then
		arg0.viewComponent:emit(BaseUI.ON_CLOSE)
	elseif var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:SetPlayerInfo(getProxy(PlayerProxy):getData())
	elseif var0 == GAME.END_GUIDE then
		arg0.viewComponent:TryPlayGuide()
	end
end

return var0
