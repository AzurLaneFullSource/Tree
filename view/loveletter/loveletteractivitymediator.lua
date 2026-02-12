local var0_0 = class("LoveLetterActivityMediator", import("view.base.ContextMediator"))

var0_0.ON_SELECT_GROUP = "LoveLetterActivityMediator.ON_SELECT_GROUP"
var0_0.ON_REALIZE_GIFT = "LoveLetterActivityMediator.ON_REALIZE_GIFT"
var0_0.ON_GO_COLLECTION = "LoveLetterActivityMediator.ON_GO_COLLECTION"
var0_0.ON_GO_TROPHY = "LoveLetterActivityMediator.ON_GO_TROPHY"
var0_0.ON_DAILY_LOGIN_REWARD = "LoveLetterActivityMediator.ON_DAILY_LOGIN_REWARD"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_SELECT_GROUP, function(arg0_2, arg1_2)
		arg0_1:addSubLayers(Context.New({
			mediator = LoveLetterSelectCharMediator,
			viewComponent = LoveLetterSelectCharLayer,
			data = {
				actId = arg1_2
			}
		}))
	end)
	arg0_1:bind(var0_0.ON_REALIZE_GIFT, function(arg0_3)
		arg0_1:addSubLayers(Context.New({
			mediator = LoveLetterGiftCollectMediator,
			viewComponent = LoveLetterGiftCollectLayer
		}))
	end)
	arg0_1:bind(var0_0.ON_DAILY_LOGIN_REWARD, function(arg0_4, arg1_4)
		arg0_1.contextData.submitTaskId = arg1_4

		arg0_1:sendNotification(GAME.SUBMIT_TASK, arg1_4, nil)
	end)
	arg0_1:bind(var0_0.ON_GO_COLLECTION, function(arg0_5)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.WORLD_COLLECTION, {
			page = WorldMediaCollectionScene.PAGE_ALBUM,
			albumType = WorldMediaCollectionAlbumGroupLayer.ALBUM_TYPE_LOVE_LETTER
		})
	end)
	arg0_1:bind(var0_0.ON_GO_TROPHY, function(arg0_6)
		arg0_1:addSubLayers(Context.New({
			mediator = TrophyGalleryMediator,
			viewComponent = TrophyGalleryLayer,
			data = {
				index = 3
			}
		}))
	end)

	local var0_1 = getProxy(ActivityProxy)
	local var1_1 = var0_1:getActivityByType(ActivityConst.ACTIVITY_TYPE_LOVE_LETTER_UP)

	arg0_1.viewComponent:SetActivity(var1_1)
	arg0_1.viewComponent:SetDailyActivity(var0_1:getActivityById(var1_1:GetConfigClientSetting("sub_act_id")))
end

function var0_0.initNotificationHandleDic(arg0_7)
	arg0_7.handleDic = {
		[ActivityProxy.ACTIVITY_UPDATED] = function(arg0_8, arg1_8)
			local var0_8 = arg1_8:getBody()

			if arg0_8.viewComponent.activity and arg0_8.viewComponent.activity.id == var0_8.id then
				arg0_8.viewComponent:SetActivity(var0_8)
				arg0_8.viewComponent:UpdatePainting()
				arg0_8.viewComponent:UpdateSlider()
				arg0_8.viewComponent:UpdateLoveLetterMedal()
			end
		end,
		[GAME.REALIZE_LOVE_LETTER_GIFT_DONE] = function(arg0_9, arg1_9)
			arg0_9.viewComponent:UpdateSlider()
			arg0_9.viewComponent:UpdateLoveLetterMedal()
		end,
		[GAME.LOVE_LETTER_LEVEL_UP_DONE] = GAME.REALIZE_LOVE_LETTER_GIFT_DONE,
		[LoveLetterProxy.UPDATE_LOVE_LETTER] = function(arg0_10, arg1_10)
			arg0_10.viewComponent:UpdateSlider()
		end,
		[GAME.SUBMIT_TASK_AWARD_DOWN] = function(arg0_11, arg1_11)
			local var0_11 = arg1_11:getBody()

			if arg0_11.contextData.submitTaskId ~= arg1_11:getType()[1] then
				return
			end

			arg0_11.contextData.submitTaskId = nil

			arg0_11.viewComponent:HideDailyPanel()
			arg0_11.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_11.awards, function()
				arg0_11.viewComponent:UpdateSlider()
				arg0_11.viewComponent:SetDailyActivity(getProxy(ActivityProxy):getActivityById(arg0_11.viewComponent.dailyActivity.id))
			end)
		end
	}
end

return var0_0
