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
var0_0.OPEN_SKIN_SELECT_LAYER = "Dorm3dRoomMediator.OPEN_SKIN_SELECT_LAYER"
var0_0.OPEN_SETTING_LAYER = "Dorm3dRoomMediator.OPEN_SETTING_LAYER"
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
var0_0.ENTER_DANCE = "Dorm3dRoomMediator.ENTER_DANCE"
var0_0.ON_DROP_CLIENT = "Dorm3dRoomMediator.ON_DROP_CLIENT"
var0_0.UPDATE_FAVOR_DISPLAY = "Dorm3dRoomMediator.UPDATE_FAVOR_DISPLAY"
var0_0.ADD_EXTRA_SYSTEM_FURNITURE_SLIDE = "Dorm3dRoomMediator.ADD_EXTRA_SYSTEM_FURNITURE_SLIDE"
var0_0.REFRESH_FURNITURE_AND_SLOTS_DONE = "Dorm3dRoomMediator.REFRESH_FURNITURE_AND_SLOTS_DONE"

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
	arg0_1:bind(var0_0.OPEN_SKIN_SELECT_LAYER, function(arg0_21, arg1_21, arg2_21, arg3_21, arg4_21, arg5_21)
		arg0_1:addSubLayers(Context.New({
			viewComponent = Dorm3dSkinSelectLayer,
			mediator = Dorm3dSkinSelectMediator,
			data = {
				groupId = arg1_21,
				ladyEnv = arg2_21,
				onSwitchSkin = arg3_21
			},
			onRemoved = arg5_21 and arg4_21 or function()
				arg0_1.viewComponent:SetAllBlackbloardValue("inLockLayer", false)
				arg0_1.viewComponent:TempHideUI(false, arg4_21)
			end
		}), nil, not arg5_21 and function()
			arg0_1.viewComponent:SetAllBlackbloardValue("inLockLayer", true)
			arg0_1.viewComponent:TempHideUI(true)
		end)
	end)
	arg0_1:bind(var0_0.OPEN_ACCOMPANY_WINDOW, function(arg0_24, arg1_24, arg2_24)
		arg0_1:addSubLayers(Context.New({
			viewComponent = Dorm3dAccompanyLayer,
			mediator = Dorm3dAccompanyMediator,
			data = arg1_24,
			onRemoved = function()
				arg0_1.viewComponent:SetAllBlackbloardValue("inLockLayer", false)
				arg0_1.viewComponent:TempHideUI(false, arg2_24)
			end
		}), nil, function()
			arg0_1.viewComponent:SetAllBlackbloardValue("inLockLayer", true)
			arg0_1.viewComponent:TempHideUI(true)
		end)
	end)
	arg0_1:bind(var0_0.OPEN_MINIGAME_WINDOW, function(arg0_27, arg1_27, arg2_27)
		local var0_27 = switch(arg1_27.minigameId, {
			[67] = function()
				return EatFoodLayer
			end,
			[70] = function()
				return NengDaiScheduleGameView
			end,
			[75] = function()
				return RPSGameLayer
			end
		}, function()
			assert(false, "without dorm minigame config in id:" .. arg1_27.minigameId)
		end)

		arg0_1:addSubLayers(Context.New({
			viewComponent = var0_27,
			mediator = Dorm3dMiniGameMediator,
			data = arg1_27,
			onRemoved = arg2_27
		}))
	end)
	arg0_1:bind(var0_0.ADD_EXTRA_SYSTEM_FURNITURE_SLIDE, function(arg0_32, arg1_32)
		arg0_1:addSubLayers(Context.New({
			viewComponent = FurnitureSlideExtraLayer,
			mediator = FurnitureSlideExtraMediator,
			data = arg1_32
		}))
	end)
	arg0_1:bind(var0_0.REFRESH_FURNITURE_AND_SLOTS_DONE, function(arg0_33)
		arg0_1:sendNotification(var0_0.REFRESH_FURNITURE_AND_SLOTS_DONE)
	end)
	arg0_1:bind(var0_0.DO_TALK, function(arg0_34, arg1_34, arg2_34)
		arg0_1:sendNotification(GAME.APARTMENT_DO_TALK, {
			talkId = arg1_34,
			callback = arg2_34
		})
	end)
	arg0_1:bind(var0_0.COLLECTION_ITEM, function(arg0_35, arg1_35)
		arg0_1:sendNotification(GAME.APARTMENT_COLLECTION_ITEM, arg1_35)
	end)
	arg0_1:bind(var0_0.Camera_Pinch_Value_Change, function(arg0_36, arg1_36)
		arg0_1:sendNotification(Dorm3dPhotoMediator.Camera_Pinch_Value_Change, {
			value = arg1_36
		})
	end)
	arg0_1:bind(Dorm3dPhotoMediator.CAMERA_LIFT_CHANGED, function(arg0_37, arg1_37)
		arg0_1:sendNotification(Dorm3dPhotoMediator.CAMERA_LIFT_CHANGED, {
			value = arg1_37
		})
	end)
	arg0_1:bind(Dorm3dPhotoMediator.CAMERA_STICK_MOVE, function(arg0_38, arg1_38)
		arg0_1:sendNotification(Dorm3dPhotoMediator.CAMERA_STICK_MOVE, arg1_38)
	end)
	arg0_1:bind(var0_0.ENTER_VOLLEYBALL, function(arg0_39, arg1_39)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.DORM3D_VOLLEYBALL, {
			groupId = arg1_39
		})
	end)
	arg0_1:bind(var0_0.ENTER_DANCE, function(arg0_40, arg1_40)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.DORM3D_DANCE, {
			groupId = arg1_40
		})
	end)
	arg0_1:bind(var0_0.ON_DROP_CLIENT, function(arg0_41, arg1_41)
		pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_DROP_CLIENT, arg1_41)
	end)
	arg0_1:bind(var0_0.OPEN_SETTING_LAYER, function(arg0_42)
		arg0_1:addSubLayers(Context.New({
			viewComponent = Dorm3dSettingScene,
			mediator = NewSettingsMediator
		}))
	end)
	arg0_1.viewComponent:SetRoom(getProxy(ApartmentProxy):getRoom(arg0_1.contextData.roomId))

	if arg0_1.viewComponent.room:isPersonalRoom() then
		local var0_1 = getProxy(ApartmentProxy):getApartment(arg0_1.contextData.groupIds[1])

		arg0_1.viewComponent:SetApartment(var0_1)
	end

	Dorm3dFurniture.RecordLastTimelimitShopFurniture()
end

function var0_0.initNotificationHandleDic(arg0_43)
	arg0_43.handleDic = {
		[GAME.APARTMENT_TRIGGER_FAVOR_DONE] = function(arg0_44, arg1_44)
			local var0_44 = arg1_44:getBody()

			arg0_44.viewComponent:PopFavorTrigger(var0_44)
		end,
		[GAME.APARTMENT_LEVEL_UP_DONE] = function(arg0_45, arg1_45)
			local var0_45 = arg1_45:getBody()

			seriesAsync({
				function(arg0_46)
					arg0_45.viewComponent:SetAllBlackbloardValue("inLockLayer", true)
					arg0_45.viewComponent:PopFavorLevelUp(var0_45.apartment, var0_45.award, arg0_46)
				end
			}, function()
				arg0_45.viewComponent:SetAllBlackbloardValue("inLockLayer", false)
				arg0_45.viewComponent:CheckQueue()
				arg0_45:sendNotification(var0_0.ON_LEVEL_UP_FINISH)
			end)
		end,
		[STORY_EVENT.TEST] = function(arg0_48, arg1_48)
			local var0_48 = arg1_48:getBody()

			arg0_48.viewComponent:TalkingEventHandle(var0_48)
		end,
		[ApartmentProxy.UPDATE_APARTMENT] = function(arg0_49, arg1_49)
			local var0_49 = arg1_49:getBody()
			local var1_49 = arg0_49.viewComponent.apartment

			if var1_49 and var1_49:GetConfigID() == var0_49:GetConfigID() then
				arg0_49.viewComponent:SetApartment(var0_49)
			end
		end,
		[var0_0.OTHER_DO_TALK] = function(arg0_50, arg1_50)
			local var0_50 = arg1_50:getBody()

			arg0_50.viewComponent.inReplayTalk = true

			arg0_50.viewComponent:DoTalk(var0_50.talkId, function()
				arg0_50.viewComponent.inReplayTalk = false

				existCall(var0_50.callback)
			end)
		end,
		[var0_0.OTHER_POP_UNLOCK] = function(arg0_52, arg1_52)
			local var0_52 = arg1_52:getBody()

			arg0_52.viewComponent:AddUnlockDisplay(var0_52)
		end,
		[GAME.APARTMENT_DO_TALK_DONE] = function(arg0_53, arg1_53)
			arg0_53.viewComponent:UpdateBtnState()
		end,
		[GAME.APARTMENT_COLLECTION_ITEM_DONE] = function(arg0_54, arg1_54)
			local var0_54 = arg1_54:getBody()

			arg0_54:addSubLayers(Context.New({
				viewComponent = Dorm3dCollectAwardLayer,
				mediator = Dorm3dCollectAwardMediator,
				data = {
					itemId = var0_54.itemId,
					isNew = var0_54.isNew
				}
			}))
			arg0_54.viewComponent:UpdateBtnState()
		end,
		[var0_0.CHAMGE_TIME_RELOAD_SCENE] = function(arg0_55, arg1_55)
			local var0_55 = arg1_55:getBody()

			arg0_55.contextData.timeIndex = var0_55.timeIndex

			arg0_55.viewComponent:SwitchDayNight(arg0_55.contextData.timeIndex)
			onNextTick(function()
				arg0_55.viewComponent:RefreshSlots()
			end)
			arg0_55.viewComponent:UpdateContactState()
		end,
		[GAME.APARTMENT_GIVE_GIFT_DONE] = function(arg0_57, arg1_57)
			local var0_57 = arg1_57:getBody()

			arg0_57.viewComponent:PlayHeartFX(var0_57.groupId)
			arg0_57.viewComponent:UpdateBtnState()
			getProxy(Dorm3dChatProxy):TriggerEvent({
				{
					value = 1,
					event_type = arg0_57.contextData.timeIndex == 1 and 113 or 118,
					ship_id = var0_57.groupId
				}
			})
		end,
		[var0_0.GUIDE_CLICK_LADY] = function(arg0_58, arg1_58)
			warning("this.GUIDE_CLICK_LADY")
			arg0_58.viewComponent:EnterWatchMode()
		end,
		[var0_0.GUIDE_CHECK_GUIDE] = function(arg0_59, arg1_59)
			arg0_59.viewComponent:CheckGuide()
		end,
		[var0_0.GUIDE_CHECK_LEVEL_UP] = function(arg0_60, arg1_60)
			arg0_60.viewComponent:CheckLevelUp()
		end,
		[ApartmentProxy.UPDATE_ROOM] = function(arg0_61, arg1_61)
			local var0_61 = arg1_61:getBody()

			if var0_61:GetConfigID() == arg0_61.viewComponent.room:GetConfigID() then
				arg0_61.viewComponent:SetRoom(var0_61)
			end
		end,
		[Dorm3dInviteMediator.ON_DORM] = function(arg0_62, arg1_62)
			local var0_62 = arg1_62:getBody()

			arg0_62:sendNotification(GAME.CHANGE_SCENE, SCENE.DORM3D_ROOM, var0_62)
		end,
		[Dorm3dMiniGameMediator.OPERATION] = function(arg0_63, arg1_63)
			local var0_63 = arg1_63:getBody()

			arg0_63.viewComponent:HandleGameNotification(Dorm3dMiniGameMediator.OPERATION, var0_63)
		end,
		[ApartmentProxy.ZERO_HOUR_REFRESH] = function(arg0_64, arg1_64)
			local var0_64 = arg1_64:getBody()

			arg0_64.viewComponent:UpdateFavorDisplay()
		end,
		[var0_0.UPDATE_FAVOR_DISPLAY] = function(arg0_65, arg1_65)
			arg0_65.viewComponent:UpdateFavorDisplay()
		end,
		[ApartmentProxy.UPDATE_ROOM_INVITE_LIST] = function(arg0_66, arg1_66)
			local var0_66 = arg1_66:getBody()

			arg0_66.viewComponent:LoadCharacterAdditionally(var0_66.addIds, var0_66.callback)
		end
	}
end

function var0_0.remove(arg0_67)
	return
end

return var0_0
