local var0_0 = class("TrophyGalleryMediator", import("..base.ContextMediator"))

var0_0.ON_TROPHY_CLAIM = "TrophyGalleryMediator:ON_TROPHY_CLAIM"
var0_0.ON_GET_ALL_LOVE_LETTER_REWARD = "TrophyGalleryMediator.ON_GET_ALL_LOVE_LETTER_REWARD"
var0_0.OPEN_DISPLAY_WINDOW = "TrophyGalleryMediator.OPEN_DISPLAY_WINDOW"
var0_0.OPEN_REALIZE_GIFT_LAYER = "TrophyGalleryMediator.OPEN_REALIZE_GIFT_LAYER"

function var0_0.register(arg0_1)
	local var0_1 = getProxy(CollectionProxy)

	arg0_1:bind(var0_0.ON_TROPHY_CLAIM, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.TROPHY_CLAIM, {
			trophyID = arg1_2
		})
	end)
	arg0_1:bind(var0_0.ON_GET_ALL_LOVE_LETTER_REWARD, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.GET_LOVE_LETTER_REWARD, {
			list = arg1_3
		})
	end)
	arg0_1:bind(var0_0.OPEN_DISPLAY_WINDOW, function(arg0_4, arg1_4)
		arg0_1:addSubLayers(Context.New({
			mediator = LoveLetterGiftLevelDisplayMediator,
			viewComponent = LoveLetterGiftLevelDisplayLayer,
			data = {
				groupId = arg1_4
			}
		}))
	end)
	arg0_1:bind(var0_0.OPEN_REALIZE_GIFT_LAYER, function(arg0_5)
		arg0_1:addSubLayers(Context.New({
			mediator = LoveLetterGiftCollectMediator,
			viewComponent = LoveLetterGiftCollectLayer
		}))
	end)

	local var1_1 = var0_1:getTrophyGroup()
	local var2_1 = var0_1:getTrophys()

	arg0_1.viewComponent:setTrophyGroups(var1_1)
	arg0_1.viewComponent:setTrophyList(var2_1)
end

function var0_0.initNotificationHandleDic(arg0_6)
	arg0_6.handleDic = {
		[GAME.TROPHY_CLAIM_DONE] = function(arg0_7, arg1_7)
			local var0_7 = arg1_7:getBody().trophyID

			if pg.medal_template[var0_7].hide == Trophy.ALWAYS_HIDE then
				return
			end

			local var1_7 = math.floor(var0_7 / 10)
			local var2_7 = getProxy(CollectionProxy)
			local var3_7 = var2_7:getTrophyGroup()
			local var4_7 = var2_7:getTrophys()

			arg0_7.viewComponent:setTrophyGroups(var3_7)
			arg0_7.viewComponent:setTrophyList(var4_7)
			arg0_7.viewComponent:PlayTrophyClaim(var1_7)
		end,
		[GAME.GET_LOVE_LETTER_REWARD_DONE] = function(arg0_8, arg1_8)
			local var0_8 = arg1_8:getBody()
			local var1_8 = {}

			if #var0_8.awards > 0 then
				table.insert(var1_8, function(arg0_9)
					arg0_8.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_8.awards, arg0_9)
				end)
			end

			seriesAsync(var1_8, function()
				arg0_8.viewComponent:updateLoveLetterPage()
				pg.EasyRedDotMgr.GetInstance():TriggerMarks("love_letter_level_reward")
			end)
		end,
		[GAME.LOVE_LETTER_LEVEL_UP_DONE] = function(arg0_11, arg1_11)
			arg0_11.viewComponent:updateLoveLetterPage()
			pg.EasyRedDotMgr.GetInstance():TriggerMarks("love_letter_level_up")
		end,
		[GAME.REALIZE_LOVE_LETTER_GIFT_DONE] = function(arg0_12, arg1_12)
			arg0_12.viewComponent:updateLoveLetterPage()
		end
	}
end

return var0_0
