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
var0_0.ON_GET_LOVE_LETTER_MAIL = "PlayerVitaeMediator.ON_GET_LOVE_LETTER_MAIL"

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
	arg0_1:bind(var0_0.ON_GET_LOVE_LETTER_MAIL, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.ACCEPT_LOVE_LETTER_MAIL, {
			activity_id = arg1_4
		})
	end)
	arg0_1:bind(var0_0.OPEN_CRYPTOLALIA, function(arg0_5, arg1_5)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.CRYPTOLALIA, {
			groupId = arg1_5
		})
	end)
	arg0_1:bind(var0_0.ON_SWITCH_RANDOM_FLAG_SHIP_BTN, function(arg0_6, arg1_6)
		arg0_1:sendNotification(GAME.RANDOM_FLAG_SHIP, {
			isOn = arg1_6
		})
	end)
	arg0_1:bind(var0_0.GO_SCENE, function(arg0_7, arg1_7, arg2_7)
		arg0_1:sendNotification(GAME.GO_SCENE, arg1_7, arg2_7)
	end)
	arg0_1:bind(var0_0.CHANGE_RANDOM_SETTING, function(arg0_8, arg1_8)
		arg0_1:sendNotification(GAME.CHANGE_RANDOM_SHIP_AND_SKIN_SETTING, arg1_8)
	end)
	arg0_1:bind(var0_0.CHANGE_SKIN, function(arg0_9, arg1_9)
		arg0_1:addSubLayers(Context.New({
			mediator = SwitchSkinMediator,
			viewComponent = SwitchSkinLayer,
			data = {
				shipVO = arg1_9
			}
		}))
	end)
	arg0_1:bind(var0_0.CHANGE_PAINTS, function(arg0_10, arg1_10, arg2_10)
		arg0_1:sendNotification(GAME.CHANGE_PLAYER_ICON, {
			after = arg1_10,
			callback = arg2_10
		})
	end)
	arg0_1:bind(var0_0.ON_CHANGE_PLAYER_NAME, function(arg0_11, arg1_11)
		arg0_1:sendNotification(GAME.CHANGE_PLAYER_NAME, {
			name = arg1_11
		})
	end)
	arg0_1:bind(var0_0.ON_ATTIRE, function()
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.ATTIRE)
	end)
	arg0_1:bind(var0_0.CHANGE_MANIFESTO, function(arg0_13, arg1_13)
		arg0_1:sendNotification(GAME.CHANGE_PLAYER_MANIFESTO, {
			manifesto = arg1_13
		})
	end)
	arg0_1:bind(var0_0.CHANGE_PAINT, function(arg0_14, arg1_14)
		local var0_14 = {}
		local var1_14 = getProxy(PlayerProxy):getRawData()
		local var2_14 = var1_14:GetShipPhantomMarks()

		if arg1_14 then
			table.removebyvalue(var2_14, arg1_14:GetShipPhantomMark())
		end

		arg0_1.contextData.showSelectCharacters = true

		local var3_14, var4_14 = PlayerVitaeShipsPage.GetSlotMaxCnt()
		local var5_14 = {
			callbackQuit = true,
			selectedMax = var4_14,
			hideTagFlags = ShipStatus.TAG_HIDE_ADMIRAL,
			selectedIds = var0_14,
			selectedMarks = var2_14,
			ignoredIds = pg.ShipFlagMgr.GetInstance():FilterShips({
				isActivityNpc = true
			}),
			onSelected = function(arg0_15, arg1_15)
				local var0_15 = arg0_1:ReSortShipIds(var1_14:GetShipPhantomMarks(), arg0_15)

				arg0_1.contextData.showSelectCharacters = false

				arg0_1:sendNotification(GAME.CHANGE_PLAYER_ICON, {
					after = var0_15,
					callback = arg1_15
				})
			end
		}

		arg0_1:addSubLayers(Context.New({
			viewComponent = PlayerVitaeDockyardScene,
			mediator = DockyardMediator,
			data = var5_14
		}))
	end)
end

function var0_0.ReSortShipIds(arg0_16, arg1_16, arg2_16)
	local var0_16 = {}

	for iter0_16, iter1_16 in ipairs({
		{
			arg1_16,
			-1
		},
		{
			arg2_16,
			1
		}
	}) do
		local var1_16, var2_16 = unpack(iter1_16)

		for iter2_16, iter3_16 in ipairs(var1_16) do
			var0_16[iter3_16] = defaultValue(var0_16[iter3_16], 0) + var2_16
		end
	end

	local var3_16 = {}
	local var4_16 = 1
	local var5_16 = 1

	while #var3_16 < #arg2_16 do
		while var4_16 <= #arg1_16 and var0_16[arg1_16[var4_16]] == 0 do
			table.insert(var3_16, arg1_16[var4_16])

			var4_16 = var4_16 + 1
		end

		var4_16 = var4_16 + 1

		while var5_16 <= #arg2_16 and var0_16[arg2_16[var5_16]] == 0 do
			var5_16 = var5_16 + 1
		end

		if arg2_16[var5_16] then
			table.insert(var3_16, arg2_16[var5_16])

			var5_16 = var5_16 + 1
		end
	end

	return var3_16
end

function var0_0.listNotificationInterests(arg0_17)
	return {
		GAME.CHANGE_PLAYER_NAME_DONE,
		SetShipSkinCommand.SKIN_UPDATED,
		GAME.UPDATE_SKINCONFIG,
		GAME.CHANGE_PLAYER_ICON_DONE,
		PaintingGroupConst.NotifyPaintingDownloadFinish,
		GAME.CHANGE_EDUCATE_DONE,
		GAME.CLEAR_EDUCATE_TIP,
		GAME.CHANGE_SKIN_UPDATE,
		GAME.ACCEPT_LOVE_LETTER_MAIL_DONE
	}
end

function var0_0.handleNotification(arg0_18, arg1_18)
	local var0_18 = arg1_18:getName()
	local var1_18 = arg1_18:getBody()

	if var0_18 == GAME.CHANGE_PLAYER_NAME_DONE then
		arg0_18.viewComponent:OnPlayerNameChange()
	elseif var0_18 == SetShipSkinCommand.SKIN_UPDATED then
		arg0_18.viewComponent:OnShipSkinChanged(var1_18.ship:GetShipPhantomMark())
	elseif var0_18 == GAME.UPDATE_SKINCONFIG then
		arg0_18.viewComponent:ReloadPanting(var1_18.skinId)
	elseif var0_18 == GAME.CHANGE_PLAYER_ICON_DONE then
		arg0_18.viewComponent:RefreshShips()
	elseif var0_18 == PaintingGroupConst.NotifyPaintingDownloadFinish then
		arg0_18.viewComponent:updateSwitchSkinBtnTag()

		if arg0_18.viewComponent.shipsPage and arg0_18.viewComponent.shipsPage:GetLoaded() then
			arg0_18.viewComponent.shipsPage:UpdateCardPaintingTag()
		end
	elseif var0_18 == GAME.CHANGE_EDUCATE_DONE then
		arg0_18.viewComponent:UpdatePainting(true)

		if arg0_18.viewComponent.shipsPage and arg0_18.viewComponent.shipsPage:GetLoaded() then
			arg0_18.viewComponent.shipsPage:UpdateEducateChar()
		end
	elseif var0_18 == GAME.CLEAR_EDUCATE_TIP then
		if arg0_18.viewComponent.shipsPage and arg0_18.viewComponent.shipsPage:GetLoaded() then
			arg0_18.viewComponent.shipsPage:UpdateEducateCharTrTip()
		end
	elseif var0_18 == GAME.CHANGE_SKIN_UPDATE then
		arg0_18.viewComponent:OnShipSkinChanged(var1_18)
		arg0_18.viewComponent:RefreshShips()
		arg0_18.viewComponent:UpdatePainting(true)
	elseif var0_18 == GAME.ACCEPT_LOVE_LETTER_MAIL_DONE and arg0_18.viewComponent.shipsPage and arg0_18.viewComponent.shipsPage:GetLoaded() then
		arg0_18.viewComponent.shipsPage:UpdateGetMailBtn()
	end
end

return var0_0
