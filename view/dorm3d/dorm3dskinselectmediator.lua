local var0_0 = class("Dorm3dSkinSelectMediator", import("view.base.ContextMediator"))

var0_0.CHANGE_SKIN = "Dorm3dSkinSelectMediator:CHANGE_SKIN"
var0_0.SWITCH_SKIN = "Dorm3dSkinSelectMediator:SWITCH_SKIN"
var0_0.OPEN_SHOP_WINDOW = "Dorm3dSkinSelectMediator:OPEN_SHOP_WINDOW"
var0_0.PLAY_ANIM = "Dorm3dSkinSelectMediator:PLAY_ANIM"
var0_0.OPEN_ROOM_UNLOCK_WINDOW = "Dorm3dSkinSelectMediator:OPEN_ROOM_UNLOCK_WINDOW"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.CHANGE_SKIN, function(arg0_2, arg1_2, arg2_2, arg3_2)
		arg0_1:sendNotification(GAME.APARTMENT_CHANGE_SKIN, {
			groupId = arg1_2,
			skinId = arg2_2
		})
		arg0_1:sendNotification(GAME.APARTMENT_SKIN_PART_HIDDEN, {
			groupId = arg1_2,
			skinId = arg2_2,
			partList = arg3_2
		})
	end)
	arg0_1:bind(var0_0.OPEN_ROOM_UNLOCK_WINDOW, function(arg0_3, arg1_3, arg2_3)
		arg0_1:addSubLayers(Context.New({
			viewComponent = Dorm3dRoomUnlockWindow,
			mediator = Dorm3dRoomUnlockWindowMediator,
			data = {
				roomId = arg1_3,
				groupId = arg2_3
			},
			onRemoved = function()
				arg0_1.viewComponent:FlushSkinList()
			end
		}))
	end)
	arg0_1:bind(var0_0.OPEN_SHOP_WINDOW, function(arg0_5, arg1_5)
		arg0_1:addSubLayers(Context.New({
			viewComponent = Dorm3dShoppingConfirmWindow,
			mediator = Dorm3dShoppingConfirmWindowMediator,
			data = arg1_5
		}))
	end)
	arg0_1:bind(GAME.SHOPPING, function(arg0_6, arg1_6)
		arg0_1:sendNotification(GAME.SHOPPING, arg1_6)
	end)
	arg0_1.viewComponent:SetApartment(getProxy(ApartmentProxy):getApartment(arg0_1.contextData.groupId))
end

function var0_0.initNotificationHandleDic(arg0_7)
	local function var0_7(arg0_8)
		arg0_7.viewComponent:FlushSkinList()

		local var0_8 = pg.shop_template[arg0_8].effect_args[1]
		local var1_8 = ShipGroup.getDefaultShipNameByGroupID(arg0_7.contextData.groupId)
		local var2_8 = pg.dorm3d_resource[var0_8].name

		pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_MSGBOX, {
			title = i18n("title_info"),
			contentText = i18n("dorm3d_skin_equip", var1_8, var2_8),
			onConfirm = function()
				arg0_7.viewComponent:ConfirmCurrentSkin()
			end,
			onClose = function()
				arg0_7.viewComponent:CancelCurrentSkin()
			end
		})
	end

	arg0_7.handleDic = {
		[GAME.SHOPPING_DONE] = function(arg0_11, arg1_11)
			local var0_11 = arg1_11:getBody()

			var0_7(var0_11.id)
		end,
		[GAME.APARTMENT_ROOM_INVITE_UNLOCK_DONE] = function(arg0_12, arg1_12)
			local var0_12 = arg1_12:getBody()
			local var1_12 = getProxy(ApartmentProxy):getRoom(var0_12.roomId):getConfig("invite_cost")
			local var2_12 = Apartment.getGroupConfig(var0_12.groupId, var1_12)

			var0_7(var2_12)
		end,
		[ApartmentProxy.UPDATE_APARTMENT] = function(arg0_13, arg1_13)
			arg0_13.viewComponent:SetApartment(getProxy(ApartmentProxy):getApartment(arg0_13.contextData.groupId))
			arg0_13.viewComponent:FlushSkinList()
		end
	}
end

function var0_0.remove(arg0_14)
	return
end

return var0_0
