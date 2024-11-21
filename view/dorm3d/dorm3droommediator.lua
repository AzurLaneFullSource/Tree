local var0_0 = class("Dorm3dRoomMediator", import("view.base.ContextMediator"))

var0_0.TRIGGER_FAVOR = "Dorm3dRoomMediator.TRIGGER_FAVOR"
var0_0.FAVOR_LEVEL_UP = "Dorm3dRoomMediator.FAVOR_LEVEL_UP"
var0_0.TALKING_EVENT_FINISH = "Dorm3dRoomMediator.TALKING_EVENT_FINISH"
var0_0.DO_TALK = "Dorm3dRoomMediator.DO_TALK"
var0_0.COLLECTION_ITEM = "Dorm3dRoomMediator.COLLECTION_ITEM"
var0_0.OPEN_FURNITURE_SELECT = "Dorm3dRoomMediator.OPEN_FURNITURE_SELECT"
var0_0.OPEN_LEVEL_LAYER = "Dorm3dRoomMediator.OPEN_LEVEL_LAYER"
var0_0.OPEN_GIFT_LAYER = "Dorm3dRoomMediator.OPEN_GIFT_LAYER"
var0_0.OPEN_CAMERA_LAYER = "Dorm3dRoomMediator.OPEN_CAMERA_LAYER"
var0_0.OPEN_DROP_LAYER = "Dorm3dRoomMediator.OPEN_DROP_LAYER"
var0_0.OPEN_COLLECTION_LAYER = "Dorm3dRoomMediator.OPEN_COLLECTION_LAYER"
var0_0.OPEN_INVITE_WINDOW = "Dorm3dRoomMediator.OPEN_INVITE_WINDOW"
var0_0.OPEN_ACCOMPANY_WINDOW = "Dorm3dRoomMediator.OPEN_ACCOMPANY_WINDOW"
var0_0.OPEN_MINIGAME_WINDOW = "Dorm3dRoomMediator.OPEN_MINIGAME_WINDOW"
var0_0.ON_LEVEL_UP_FINISH = "Dorm3dRoomMediator.ON_LEVEL_UP_FINISH"
var0_0.ON_CLICK_FURNITURE_SLOT = "Dorm3dRoomMediator.ON_CLICK_FURNITURE_SLOT"
var0_0.OTHER_DO_TALK = "Dorm3dRoomMediator.OTHER_DO_TALK"
var0_0.OTHER_POP_UNLOCK = "Dorm3dRoomMediator.OTHER_POP_UNLOCK"
var0_0.CHAMGE_TIME_RELOAD_SCENE = "Dorm3dRoomMediator.CHAMGE_TIME_RELOAD_SCENE"
var0_0.GUIDE_CLICK_LADY = "Dorm3dRoomMediator.GUIDE_CLICK_LADY"
var0_0.GUIDE_CHECK_GUIDE = "Dorm3dRoomMediator.GUIDE_CHECK_GUIDE"
var0_0.GUIDE_CHECK_LEVEL_UP = "Dorm3dRoomMediator.GUIDE_CHECK_LEVEL_UP"
var0_0.Camera_Pinch_Value_Change = "Dorm3dRoomMediator.Camera_Pinch_Value_Change"
var0_0.ENTER_VOLLEYBALL = "Dorm3dRoomMediator.ENTER_VOLLEYBALL"
var0_0.ON_DROP_CLIENT = "Dorm3dRoomMediator.ON_DROP_CLIENT"
var0_0.UPDATE_FAVOR_DISPLAY = "Dorm3dRoomMediator.UPDATE_FAVOR_DISPLAY"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.TRIGGER_FAVOR, function(arg0_2, arg1_2, arg2_2)
		arg0_1:sendNotification(GAME.APARTMENT_TRIGGER_FAVOR, {
			groupId = arg1_2,
			triggerId = arg2_2
		})
	end)
	arg0_1:bind(var0_0.FAVOR_LEVEL_UP, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.APARTMENT_LEVEL_UP, {
			groupId = arg1_3
		})
	end)
	arg0_1:bind(var0_0.TALKING_EVENT_FINISH, function(arg0_4, arg1_4, arg2_4)
		arg0_1:sendNotification(arg1_4, arg2_4)
	end)
	arg0_1:bind(var0_0.OPEN_FURNITURE_SELECT, function(arg0_5, arg1_5, arg2_5)
		arg0_1:addSubLayers(Context.New({
			mediator = Dorm3dFurnitureSelectMediator,
			viewComponent = Dorm3dFurnitureSelectLayer,
			data = arg1_5,
			onRemoved = function()
				arg0_1.viewComponent:TempHideUI(false, arg2_5)
			end
		}), nil, function()
			arg0_1.viewComponent:TempHideUI(true)
		end)
	end)
	arg0_1:bind(var0_0.ON_CLICK_FURNITURE_SLOT, function(arg0_8, arg1_8)
		arg0_1:sendNotification(arg0_8, arg1_8)
	end)
	arg0_1:bind(var0_0.OPEN_LEVEL_LAYER, function(arg0_9, arg1_9, arg2_9)
		arg0_1:addSubLayers(Context.New({
			viewComponent = Dorm3dLevelLayer,
			mediator = Dorm3dLevelMediator,
			data = arg1_9,
			onRemoved = function()
				arg0_1.viewComponent:SetAllBlackbloardValue("inLockLayer", false)
				arg0_1.viewComponent:TempHideUI(false, arg2_9)
			end
		}), nil, function()
			arg0_1.viewComponent:SetAllBlackbloardValue("inLockLayer", true)
			arg0_1.viewComponent:TempHideUI(true)
		end)
	end)
	arg0_1:bind(var0_0.OPEN_GIFT_LAYER, function(arg0_12, arg1_12, arg2_12)
		arg0_1:addSubLayers(Context.New({
			viewComponent = Dorm3dGiftLayer,
			mediator = Dorm3dGiftMediator,
			data = arg1_12,
			onRemoved = function()
				arg0_1.viewComponent:SetAllBlackbloardValue("inLockLayer", false)
				arg0_1.viewComponent:TempHideUI(false, arg2_12)
			end
		}), nil, function()
			arg0_1.viewComponent:SetAllBlackbloardValue("inLockLayer", true)
			arg0_1.viewComponent:TempHideUI(true)
		end)
	end)
	arg0_1:bind(var0_0.OPEN_CAMERA_LAYER, function(arg0_15, arg1_15, arg2_15, arg3_15)
		arg0_1:addSubLayers(Context.New({
			viewComponent = Dorm3dPhotoLayer,
			mediator = Dorm3dPhotoMediator,
			data = {
				groupId = arg2_15,
				view = arg1_15
			}
		}))
	end)
	arg0_1:bind(var0_0.OPEN_DROP_LAYER, function(arg0_16, arg1_16, arg2_16)
		arg0_1:addSubLayers(Context.New({
			viewComponent = Dorm3dAwardInfoLayer,
			mediator = Dorm3dAwardInfoMediator,
			data = {
				items = arg1_16
			},
			onRemoved = arg2_16
		}))
	end)
	arg0_1:bind(var0_0.OPEN_COLLECTION_LAYER, function(arg0_17, arg1_17)
		arg0_1:addSubLayers(Context.New({
			viewComponent = Dorm3dCollectionLayer,
			mediator = Dorm3dCollectionMediator,
			data = {
				roomId = arg1_17
			}
		}))
	end)
	arg0_1:bind(var0_0.OPEN_INVITE_WINDOW, function(arg0_18, arg1_18, arg2_18, arg3_18)
		arg0_1:addSubLayers(Context.New({
			viewComponent = Dorm3dInviteLayer,
			mediator = Dorm3dInviteMediator,
			data = {
				roomId = arg1_18,
				groupIds = arg2_18
			},
			onRemoved = function()
				arg0_1.viewComponent:SetAllBlackbloardValue("inLockLayer", false)
				arg0_1.viewComponent:TempHideUI(false, arg3_18)
			end
		}), nil, function()
			arg0_1.viewComponent:SetAllBlackbloardValue("inLockLayer", true)
			arg0_1.viewComponent:TempHideUI(true)
		end)
	end)
	arg0_1:bind(var0_0.OPEN_ACCOMPANY_WINDOW, function(arg0_21, arg1_21, arg2_21)
		arg0_1:addSubLayers(Context.New({
			viewComponent = Dorm3dAccompanyLayer,
			mediator = Dorm3dAccompanyMediator,
			data = arg1_21,
			onRemoved = function()
				arg0_1.viewComponent:SetAllBlackbloardValue("inLockLayer", false)
				arg0_1.viewComponent:TempHideUI(false, arg2_21)
			end
		}), nil, function()
			arg0_1.viewComponent:SetAllBlackbloardValue("inLockLayer", true)
			arg0_1.viewComponent:TempHideUI(true)
		end)
	end)
	arg0_1:bind(var0_0.OPEN_MINIGAME_WINDOW, function(arg0_24, arg1_24, arg2_24)
		arg0_1:addSubLayers(Context.New({
			viewComponent = EatFoodLayer,
			mediator = EatFoodMediator,
			data = arg1_24,
			onRemoved = arg2_24
		}))
	end)
	arg0_1:bind(var0_0.DO_TALK, function(arg0_25, arg1_25, arg2_25)
		arg0_1:sendNotification(GAME.APARTMENT_DO_TALK, {
			talkId = arg1_25,
			callback = arg2_25
		})
	end)
	arg0_1:bind(var0_0.COLLECTION_ITEM, function(arg0_26, arg1_26)
		arg0_1:sendNotification(GAME.APARTMENT_COLLECTION_ITEM, arg1_26)
	end)
	arg0_1:bind(var0_0.Camera_Pinch_Value_Change, function(arg0_27, arg1_27)
		arg0_1:sendNotification(Dorm3dPhotoMediator.Camera_Pinch_Value_Change, {
			value = arg1_27
		})
	end)
	arg0_1:bind(Dorm3dPhotoMediator.CAMERA_LIFT_CHANGED, function(arg0_28, arg1_28)
		arg0_1:sendNotification(Dorm3dPhotoMediator.CAMERA_LIFT_CHANGED, {
			value = arg1_28
		})
	end)
	arg0_1:bind(Dorm3dPhotoMediator.CAMERA_STICK_MOVE, function(arg0_29, arg1_29)
		arg0_1:sendNotification(Dorm3dPhotoMediator.CAMERA_STICK_MOVE, arg1_29)
	end)
	arg0_1:bind(var0_0.ENTER_VOLLEYBALL, function(arg0_30)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.DORM3D_VOLLEYBALL)
	end)
	arg0_1:bind(var0_0.ON_DROP_CLIENT, function(arg0_31, arg1_31)
		pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_DROP_CLIENT, arg1_31)
	end)
	arg0_1.viewComponent:SetRoom(getProxy(ApartmentProxy):getRoom(arg0_1.contextData.roomId))

	if arg0_1.viewComponent.room:isPersonalRoom() then
		local var0_1 = getProxy(ApartmentProxy):getApartment(arg0_1.contextData.groupIds[1])

		arg0_1.viewComponent:SetApartment(var0_1)
	else
		PlayerPrefs.SetString(string.format("room%d_invite_list", arg0_1.contextData.roomId), table.concat(arg0_1.contextData.groupIds, "|"))
	end
end

function var0_0.initNotificationHandleDic(arg0_32)
	arg0_32.handleDic = {
		[GAME.APARTMENT_TRIGGER_FAVOR_DONE] = function(arg0_33, arg1_33)
			local var0_33 = arg1_33:getBody()

			arg0_33.viewComponent:PopFavorTrigger(var0_33)
		end,
		[GAME.APARTMENT_LEVEL_UP_DONE] = function(arg0_34, arg1_34)
			local var0_34 = arg1_34:getBody()

			seriesAsync({
				function(arg0_35)
					arg0_34.viewComponent:SetAllBlackbloardValue("inLockLayer", true)
					arg0_34.viewComponent:PopFavorLevelUp(var0_34.apartment, var0_34.award, arg0_35)
				end
			}, function()
				arg0_34.viewComponent:SetAllBlackbloardValue("inLockLayer", false)
				arg0_34.viewComponent:CheckQueue()
				arg0_34:sendNotification(var0_0.ON_LEVEL_UP_FINISH)
			end)
		end,
		[STORY_EVENT.TEST] = function(arg0_37, arg1_37)
			local var0_37 = arg1_37:getBody()

			arg0_37.viewComponent:TalkingEventHandle(var0_37)
		end,
		[ApartmentProxy.UPDATE_APARTMENT] = function(arg0_38, arg1_38)
			local var0_38 = arg1_38:getBody()
			local var1_38 = arg0_38.viewComponent.apartment

			if var1_38 and var1_38:GetConfigID() == var0_38:GetConfigID() then
				arg0_38.viewComponent:SetApartment(var0_38)
			end
		end,
		[var0_0.OTHER_DO_TALK] = function(arg0_39, arg1_39)
			local var0_39 = arg1_39:getBody()

			arg0_39.viewComponent.inReplayTalk = true

			arg0_39.viewComponent:DoTalk(var0_39.talkId, function()
				arg0_39.viewComponent.inReplayTalk = false

				existCall(var0_39.callback)
			end)
		end,
		[var0_0.OTHER_POP_UNLOCK] = function(arg0_41, arg1_41)
			local var0_41 = arg1_41:getBody()

			arg0_41.viewComponent:AddUnlockDisplay(var0_41)
		end,
		[GAME.APARTMENT_DO_TALK_DONE] = function(arg0_42, arg1_42)
			arg0_42.viewComponent:UpdateBtnState()
		end,
		[GAME.APARTMENT_COLLECTION_ITEM_DONE] = function(arg0_43, arg1_43)
			local var0_43 = arg1_43:getBody()

			arg0_43:addSubLayers(Context.New({
				viewComponent = Dorm3dCollectAwardLayer,
				mediator = Dorm3dCollectAwardMediator,
				data = {
					itemId = var0_43.itemId,
					isNew = var0_43.isNew
				}
			}))
			arg0_43.viewComponent:UpdateBtnState()
		end,
		[var0_0.CHAMGE_TIME_RELOAD_SCENE] = function(arg0_44, arg1_44)
			local var0_44 = arg1_44:getBody()

			arg0_44.contextData.timeIndex = var0_44.timeIndex

			arg0_44.viewComponent:SwitchDayNight(arg0_44.contextData.timeIndex)
			onNextTick(function()
				arg0_44.viewComponent:RefreshSlots()
			end)
			arg0_44.viewComponent:UpdateContactState()
		end,
		[GAME.APARTMENT_GIVE_GIFT_DONE] = function(arg0_46, arg1_46)
			local var0_46 = arg1_46:getBody()

			arg0_46.viewComponent:PlayHeartFX(var0_46.groupId)
			arg0_46.viewComponent:UpdateBtnState()
		end,
		[var0_0.GUIDE_CLICK_LADY] = function(arg0_47, arg1_47)
			warning("this.GUIDE_CLICK_LADY")
			arg0_47.viewComponent:EnterWatchMode()
		end,
		[var0_0.GUIDE_CHECK_GUIDE] = function(arg0_48, arg1_48)
			arg0_48.viewComponent:CheckGuide()
		end,
		[var0_0.GUIDE_CHECK_LEVEL_UP] = function(arg0_49, arg1_49)
			arg0_49.viewComponent:CheckLevelUp()
		end,
		[ApartmentProxy.UPDATE_ROOM] = function(arg0_50, arg1_50)
			local var0_50 = arg1_50:getBody()

			if var0_50:GetConfigID() == arg0_50.viewComponent.room:GetConfigID() then
				arg0_50.viewComponent:SetRoom(var0_50)
			end
		end,
		[Dorm3dInviteMediator.ON_DORM] = function(arg0_51, arg1_51)
			local var0_51 = arg1_51:getBody()

			arg0_51:sendNotification(GAME.CHANGE_SCENE, SCENE.DORM3D_ROOM, var0_51)
		end,
		[EatFoodMediator.HIT_AREA] = function(arg0_52, arg1_52)
			local var0_52 = arg1_52:getBody()

			arg0_52.viewComponent:HandleGameNotification(EatFoodMediator.HIT_AREA, var0_52)
		end,
		[EatFoodMediator.RESULT] = function(arg0_53, arg1_53)
			local var0_53 = arg1_53:getBody()

			arg0_53.viewComponent:HandleGameNotification(EatFoodMediator.RESULT, var0_53)
		end,
		[EatFoodMediator.LEAVE_GAME] = function(arg0_54, arg1_54)
			local var0_54 = arg1_54:getBody()

			arg0_54.viewComponent:HandleGameNotification(EatFoodMediator.LEAVE_GAME, var0_54)
		end,
		[ApartmentProxy.ZERO_HOUR_REFRESH] = function(arg0_55, arg1_55)
			local var0_55 = arg1_55:getBody()

			arg0_55.viewComponent:UpdateFavorDisplay()
		end,
		[var0_0.UPDATE_FAVOR_DISPLAY] = function(arg0_56, arg1_56)
			arg0_56.viewComponent:UpdateFavorDisplay()
		end
	}
end

function var0_0.remove(arg0_57)
	return
end

return var0_0
