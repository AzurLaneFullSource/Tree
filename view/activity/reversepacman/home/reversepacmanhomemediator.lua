local var0_0 = class("ReversePacmanHomeMediator", import("view.backYard.CourtYardMediator"))

var0_0.SET_UP = "ReversePacmanHomeMediator::SET_UP"
var0_0.GO_GAME_SCENE = "ReversePacmanHomeMediator::GO_GAME_SCENE"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.SET_UP, function(arg0_2, arg1_2)
		local var0_2 = arg0_1:GenCourtYardData(arg1_2)

		_courtyard = CourtYardBridge.New(var0_2)
	end)
	arg0_1:bind(var0_0.GO_GAME_SCENE, function(arg0_3)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.REVERSE_PACMAN_SELECT)
	end)
end

function var0_0.listNotificationInterests(arg0_4)
	return {
		CourtYardEvent._QUIT,
		CourtYardEvent._INITED,
		GAME.REVERSE_PACMAN_HIRE_ROLE_DONE,
		GAME.REVERSE_PACMAN_REFRESH_TIP
	}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()
	local var2_5 = arg1_5:getType()

	if var0_5 == CourtYardEvent._QUIT then
		arg0_5.viewComponent:emit(BaseUI.ON_BACK)
	elseif var0_5 == CourtYardEvent._INITED then
		arg0_5.viewComponent:OnCourtYardLoaded()
	elseif var0_5 == GAME.REVERSE_PACMAN_HIRE_ROLE_DONE then
		local var3_5 = pg.activity_chasing_character[var1_5]
		local var4_5 = ShipGroup.getDefaultShipConfig(pg.ship_skin_template[var3_5.skin_id].ship_group).id
		local var5_5 = ReversePacmanDormShip.New({
			id = var4_5,
			configId = var4_5,
			skin_id = var3_5.skin_id,
			roleID = var1_5
		})

		_courtyard:GetController():AddShip(var5_5, 0, 0)
		arg0_5.viewComponent:RefreshBtns()
		arg0_5.viewComponent:RefreshTips()
	elseif var0_5 == GAME.REVERSE_PACMAN_REFRESH_TIP then
		arg0_5.viewComponent:RefreshTips()
	end
end

function var0_0.remove(arg0_6)
	if _courtyard then
		_courtyard:Dispose()

		_courtyard = nil
	end
end

return var0_0
