local var0 = class("PlayerVitaeMediator", import("..base.ContextMediator"))

var0.CHANGE_SKIN = "PlayerVitaeMediator:CHANGE_SKIN"
var0.ON_ATTIRE = "PlayerVitaeMediator:ON_ATTIRE"
var0.CHANGE_MANIFESTO = "PlayerVitaeMediator:CHANGE_MANIFESTO"
var0.ON_CHANGE_PLAYER_NAME = "PlayerVitaeMediator:ON_CHANGE_PLAYER_NAME"
var0.CHANGE_PAINTS = "PlayerVitaeMediator:CHANGE_PAINTS"
var0.CHANGE_PAINT = "PlayerVitaeMediator:CHANGE_PAINT"
var0.CHANGE_RANDOM_SETTING = "PlayerVitaeMediator:CHANGE_RANDOM_SETTING"
var0.GO_SCENE = "PlayerVitaeMediator:GO_SCENE"
var0.ON_SWITCH_RANDOM_FLAG_SHIP_BTN = "PlayerVitaeMediator:ON_SWITCH_RANDOM_FLAG_SHIP_BTN"
var0.OPEN_CRYPTOLALIA = "PlayerVitaeMediator:OPEN_CRYPTOLALIA"
var0.ON_SEL_EDUCATE_CHAR = "PlayerVitaeMediator:ON_SEL_EDUCATE_CHAR"

function var0.register(arg0)
	arg0:bind(var0.ON_SEL_EDUCATE_CHAR, function(arg0)
		arg0:addSubLayers(Context.New({
			mediator = EducateCharDockMediator,
			viewComponent = EducateCharDockScene,
			data = {
				OnSelected = function(arg0)
					arg0:sendNotification(GAME.CHANGE_EDUCATE, {
						id = arg0
					})
				end
			}
		}))
	end)
	arg0:bind(var0.OPEN_CRYPTOLALIA, function(arg0, arg1)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.CRYPTOLALIA, {
			groupId = arg1
		})
	end)
	arg0:bind(var0.ON_SWITCH_RANDOM_FLAG_SHIP_BTN, function(arg0, arg1)
		arg0:sendNotification(GAME.RANDOM_FLAG_SHIP, {
			isOn = arg1
		})
	end)
	arg0:bind(var0.GO_SCENE, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.GO_SCENE, arg1, arg2)
	end)
	arg0:bind(var0.CHANGE_RANDOM_SETTING, function(arg0, arg1)
		arg0:sendNotification(GAME.CHANGE_RANDOM_SHIP_AND_SKIN_SETTING, arg1)
	end)
	arg0:bind(var0.CHANGE_SKIN, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = SwichSkinMediator,
			viewComponent = SwichSkinLayer,
			data = {
				shipVO = arg1
			}
		}))
	end)
	arg0:bind(var0.CHANGE_PAINTS, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.CHANGE_PLAYER_ICON, {
			characterId = arg1,
			callback = arg2
		})
	end)
	arg0:bind(var0.ON_CHANGE_PLAYER_NAME, function(arg0, arg1)
		arg0:sendNotification(GAME.CHANGE_PLAYER_NAME, {
			name = arg1
		})
	end)
	arg0:bind(var0.ON_ATTIRE, function()
		arg0:sendNotification(GAME.GO_SCENE, SCENE.ATTIRE)
	end)
	arg0:bind(var0.CHANGE_MANIFESTO, function(arg0, arg1)
		arg0:sendNotification(GAME.CHANGE_PLAYER_MANIFESTO, {
			manifesto = arg1
		})
	end)
	arg0:bind(var0.CHANGE_PAINT, function(arg0, arg1)
		local var0 = {}

		arg0.contextData.showSelectCharacters = true

		local var1 = getProxy(PlayerProxy):getRawData()
		local var2 = {}

		for iter0, iter1 in ipairs(var1.characters) do
			if not arg1 or iter1 ~= arg1.id then
				table.insert(var0, iter1)
			end

			table.insert(var2, iter1)
		end

		local var3, var4 = PlayerVitaeShipsPage.GetSlotMaxCnt()
		local var5 = {
			callbackQuit = true,
			selectedMax = var4,
			hideTagFlags = ShipStatus.TAG_HIDE_ADMIRAL,
			selectedIds = var0,
			ignoredIds = pg.ShipFlagMgr.GetInstance():FilterShips({
				isActivityNpc = true
			}),
			onSelected = function(arg0, arg1)
				local var0 = arg0:ReSortShipIds(var2, arg0)

				arg0.contextData.showSelectCharacters = false

				arg0:sendNotification(GAME.CHANGE_PLAYER_ICON, {
					characterId = var0,
					callback = arg1
				})
			end
		}

		arg0:addSubLayers(Context.New({
			viewComponent = PlayerVitaeDockyardScene,
			mediator = DockyardMediator,
			data = var5
		}))
	end)
end

function var0.ReSortShipIds(arg0, arg1, arg2)
	local var0 = {}
	local var1 = math.max(#arg1, #arg2)

	for iter0, iter1 in ipairs(arg1) do
		if table.contains(arg2, iter1) then
			var0[iter0] = iter1

			table.removebyvalue(arg2, iter1)
		end
	end

	for iter2 = 1, var1 do
		if not var0[iter2] and #arg2 > 0 then
			var0[iter2] = table.remove(arg2, 1)
		end
	end

	local var2 = {}

	for iter3, iter4 in pairs(var0) do
		table.insert(var2, iter4)
	end

	return var2
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.CHANGE_PLAYER_NAME_DONE,
		SetShipSkinCommand.SKIN_UPDATED,
		GAME.UPDATE_SKINCONFIG,
		GAME.CHANGE_PLAYER_ICON_DONE,
		PaintingGroupConst.NotifyPaintingDownloadFinish,
		GAME.CHANGE_EDUCATE_DONE,
		GAME.CLEAR_EDUCATE_TIP
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.CHANGE_PLAYER_NAME_DONE then
		arg0.viewComponent:OnPlayerNameChange()
	elseif var0 == SetShipSkinCommand.SKIN_UPDATED then
		arg0.viewComponent:OnShipSkinChanged(var1.ship)
	elseif var0 == GAME.UPDATE_SKINCONFIG then
		arg0.viewComponent:ReloadPanting(var1.skinId)
	elseif var0 == GAME.CHANGE_PLAYER_ICON_DONE then
		arg0.viewComponent:RefreshShips()
	elseif var0 == PaintingGroupConst.NotifyPaintingDownloadFinish then
		arg0.viewComponent:updateSwitchSkinBtnTag()

		if arg0.viewComponent.shipsPage and arg0.viewComponent.shipsPage:GetLoaded() then
			arg0.viewComponent.shipsPage:UpdateCardPaintingTag()
		end
	elseif var0 == GAME.CHANGE_EDUCATE_DONE then
		arg0.viewComponent:UpdatePainting(true)

		if arg0.viewComponent.shipsPage and arg0.viewComponent.shipsPage:GetLoaded() then
			arg0.viewComponent.shipsPage:UpdateEducateChar()
		end
	elseif var0 == GAME.CLEAR_EDUCATE_TIP and arg0.viewComponent.shipsPage and arg0.viewComponent.shipsPage:GetLoaded() then
		arg0.viewComponent.shipsPage:UpdateEducateCharTrTip()
	end
end

return var0
