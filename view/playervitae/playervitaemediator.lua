local var0_0 = class("PlayerVitaeMediator", import("..base.ContextMediator"))

var0_0.CHANGE_SKIN = "PlayerVitaeMediator:CHANGE_SKIN"
var0_0.ON_ATTIRE = "PlayerVitaeMediator:ON_ATTIRE"
var0_0.CHANGE_MANIFESTO = "PlayerVitaeMediator:CHANGE_MANIFESTO"
var0_0.ON_CHANGE_PLAYER_NAME = "PlayerVitaeMediator:ON_CHANGE_PLAYER_NAME"
var0_0.CHANGE_PAINTS = "PlayerVitaeMediator:CHANGE_PAINTS"
var0_0.CHANGE_PAINT = "PlayerVitaeMediator:CHANGE_PAINT"
var0_0.CHANGE_RANDOM_SETTING = "PlayerVitaeMediator:CHANGE_RANDOM_SETTING"
var0_0.GO_SCENE = "PlayerVitaeMediator:GO_SCENE"
var0_0.ON_SWITCH_RANDOM_FLAG_SHIP_BTN = "PlayerVitaeMediator:ON_SWITCH_RANDOM_FLAG_SHIP_BTN"
var0_0.OPEN_CRYPTOLALIA = "PlayerVitaeMediator:OPEN_CRYPTOLALIA"
var0_0.ON_SEL_EDUCATE_CHAR = "PlayerVitaeMediator:ON_SEL_EDUCATE_CHAR"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_SEL_EDUCATE_CHAR, function(arg0_2)
		arg0_1:addSubLayers(Context.New({
			mediator = EducateCharDockMediator,
			viewComponent = EducateCharDockScene,
			data = {
				OnSelected = function(arg0_3)
					arg0_1:sendNotification(GAME.CHANGE_EDUCATE, {
						id = arg0_3
					})
				end
			}
		}))
	end)
	arg0_1:bind(var0_0.OPEN_CRYPTOLALIA, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.CRYPTOLALIA, {
			groupId = arg1_4
		})
	end)
	arg0_1:bind(var0_0.ON_SWITCH_RANDOM_FLAG_SHIP_BTN, function(arg0_5, arg1_5)
		arg0_1:sendNotification(GAME.RANDOM_FLAG_SHIP, {
			isOn = arg1_5
		})
	end)
	arg0_1:bind(var0_0.GO_SCENE, function(arg0_6, arg1_6, arg2_6)
		arg0_1:sendNotification(GAME.GO_SCENE, arg1_6, arg2_6)
	end)
	arg0_1:bind(var0_0.CHANGE_RANDOM_SETTING, function(arg0_7, arg1_7)
		arg0_1:sendNotification(GAME.CHANGE_RANDOM_SHIP_AND_SKIN_SETTING, arg1_7)
	end)
	arg0_1:bind(var0_0.CHANGE_SKIN, function(arg0_8, arg1_8)
		arg0_1:addSubLayers(Context.New({
			mediator = SwichSkinMediator,
			viewComponent = SwichSkinLayer,
			data = {
				shipVO = arg1_8
			}
		}))
	end)
	arg0_1:bind(var0_0.CHANGE_PAINTS, function(arg0_9, arg1_9, arg2_9)
		arg0_1:sendNotification(GAME.CHANGE_PLAYER_ICON, {
			characterId = arg1_9,
			callback = arg2_9
		})
	end)
	arg0_1:bind(var0_0.ON_CHANGE_PLAYER_NAME, function(arg0_10, arg1_10)
		arg0_1:sendNotification(GAME.CHANGE_PLAYER_NAME, {
			name = arg1_10
		})
	end)
	arg0_1:bind(var0_0.ON_ATTIRE, function()
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.ATTIRE)
	end)
	arg0_1:bind(var0_0.CHANGE_MANIFESTO, function(arg0_12, arg1_12)
		arg0_1:sendNotification(GAME.CHANGE_PLAYER_MANIFESTO, {
			manifesto = arg1_12
		})
	end)
	arg0_1:bind(var0_0.CHANGE_PAINT, function(arg0_13, arg1_13)
		local var0_13 = {}

		arg0_1.contextData.showSelectCharacters = true

		local var1_13 = getProxy(PlayerProxy):getRawData()
		local var2_13 = {}

		for iter0_13, iter1_13 in ipairs(var1_13.characters) do
			if not arg1_13 or iter1_13 ~= arg1_13.id then
				table.insert(var0_13, iter1_13)
			end

			table.insert(var2_13, iter1_13)
		end

		local var3_13, var4_13 = PlayerVitaeShipsPage.GetSlotMaxCnt()
		local var5_13 = {
			callbackQuit = true,
			selectedMax = var4_13,
			hideTagFlags = ShipStatus.TAG_HIDE_ADMIRAL,
			selectedIds = var0_13,
			ignoredIds = pg.ShipFlagMgr.GetInstance():FilterShips({
				isActivityNpc = true
			}),
			onSelected = function(arg0_14, arg1_14)
				local var0_14 = arg0_1:ReSortShipIds(var2_13, arg0_14)

				arg0_1.contextData.showSelectCharacters = false

				arg0_1:sendNotification(GAME.CHANGE_PLAYER_ICON, {
					characterId = var0_14,
					callback = arg1_14
				})
			end
		}

		arg0_1:addSubLayers(Context.New({
			viewComponent = PlayerVitaeDockyardScene,
			mediator = DockyardMediator,
			data = var5_13
		}))
	end)
end

function var0_0.ReSortShipIds(arg0_15, arg1_15, arg2_15)
	local var0_15 = {}
	local var1_15 = math.max(#arg1_15, #arg2_15)

	for iter0_15, iter1_15 in ipairs(arg1_15) do
		if table.contains(arg2_15, iter1_15) then
			var0_15[iter0_15] = iter1_15

			table.removebyvalue(arg2_15, iter1_15)
		end
	end

	for iter2_15 = 1, var1_15 do
		if not var0_15[iter2_15] and #arg2_15 > 0 then
			var0_15[iter2_15] = table.remove(arg2_15, 1)
		end
	end

	local var2_15 = {}

	for iter3_15, iter4_15 in pairs(var0_15) do
		table.insert(var2_15, iter4_15)
	end

	return var2_15
end

function var0_0.listNotificationInterests(arg0_16)
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

function var0_0.handleNotification(arg0_17, arg1_17)
	local var0_17 = arg1_17:getName()
	local var1_17 = arg1_17:getBody()

	if var0_17 == GAME.CHANGE_PLAYER_NAME_DONE then
		arg0_17.viewComponent:OnPlayerNameChange()
	elseif var0_17 == SetShipSkinCommand.SKIN_UPDATED then
		arg0_17.viewComponent:OnShipSkinChanged(var1_17.ship)
	elseif var0_17 == GAME.UPDATE_SKINCONFIG then
		arg0_17.viewComponent:ReloadPanting(var1_17.skinId)
	elseif var0_17 == GAME.CHANGE_PLAYER_ICON_DONE then
		arg0_17.viewComponent:RefreshShips()
	elseif var0_17 == PaintingGroupConst.NotifyPaintingDownloadFinish then
		arg0_17.viewComponent:updateSwitchSkinBtnTag()

		if arg0_17.viewComponent.shipsPage and arg0_17.viewComponent.shipsPage:GetLoaded() then
			arg0_17.viewComponent.shipsPage:UpdateCardPaintingTag()
		end
	elseif var0_17 == GAME.CHANGE_EDUCATE_DONE then
		arg0_17.viewComponent:UpdatePainting(true)

		if arg0_17.viewComponent.shipsPage and arg0_17.viewComponent.shipsPage:GetLoaded() then
			arg0_17.viewComponent.shipsPage:UpdateEducateChar()
		end
	elseif var0_17 == GAME.CLEAR_EDUCATE_TIP and arg0_17.viewComponent.shipsPage and arg0_17.viewComponent.shipsPage:GetLoaded() then
		arg0_17.viewComponent.shipsPage:UpdateEducateCharTrTip()
	end
end

return var0_0
