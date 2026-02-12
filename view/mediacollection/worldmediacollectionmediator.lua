local var0_0 = class("WorldMediaCollectionMediator", ContextMediator)

var0_0.BEGIN_STAGE = "WorldMediaCollectionMediator BEGIN_STAGE"
var0_0.ON_ADD_SUBLAYER = "WorldMediaCollectionMediator.ON_ADD_SUBLAYER"
var0_0.OPEN_LOVE_LETTER_DISPLAY = "WorldMediaCollectionMediator.OPEN_LOVE_LETTER_DISPLAY"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.BEGIN_STAGE, function(arg0_2, arg1_2)
		arg0_1.contextData.revertBgm = pg.CriMgr.GetInstance().bgmNow

		arg0_1:sendNotification(GAME.BEGIN_STAGE, arg1_2)
	end)
	arg0_1:bind(var0_0.ON_ADD_SUBLAYER, function(arg0_3, arg1_3)
		arg0_1:addSubLayers(arg1_3)
	end)
	arg0_1:bind(var0_0.OPEN_LOVE_LETTER_DISPLAY, function(arg0_4, arg1_4)
		arg0_1:addSubLayers(Context.New({
			mediator = LoveLetterDisplayMediator,
			viewComponent = LoveLetterDisplayLayer,
			data = setmetatable({
				groupId = arg1_4
			}, {
				__index = getProxy(LoveLetterProxy):GetGroupData(arg1_4):GetLetterDataFromId()
			})
		}))
	end)
end

function var0_0.listNotificationInterests(arg0_5)
	return {
		PlayerProxy.UPDATED,
		GAME.BEGIN_STAGE_DONE,
		GAME.UNLOCK_LOVE_LETTER_DONE
	}
end

function var0_0.handleNotification(arg0_6, arg1_6)
	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()

	if var0_6 == PlayerProxy.UPDATED then
		arg0_6.viewComponent:UpdateView()
	elseif var0_6 == GAME.BEGIN_STAGE_DONE then
		arg0_6:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1_6)
	elseif var0_6 == GAME.UNLOCK_LOVE_LETTER_DONE then
		pg.EasyRedDotMgr.GetInstance():TriggerMarks("love_letter_unlock_letter")
	end
end

return var0_0
