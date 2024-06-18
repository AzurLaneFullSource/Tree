local var0_0 = class("GameHallMediator", import("..base.ContextMediator"))

var0_0.OPEN_MINI_GAME = "open mini game"
var0_0.OPEN_GAME_SHOP = "open game shop "
var0_0.GET_WEEKLY_COIN = "get weekly coin"
var0_0.EXCHANGE_COIN = "exchange coin"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.OPEN_MINI_GAME, function(arg0_2, arg1_2, arg2_2)
		print("open minigame " .. arg1_2.game_id)
		pg.m02:sendNotification(GAME.GO_MINI_GAME, arg1_2.game_id)
	end)
	arg0_1:bind(var0_0.OPEN_GAME_SHOP, function(arg0_3, arg1_3, arg2_3)
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SHOP, {
			warp = NewShopsScene.TYPE_MINI_GAME
		})
	end)
	arg0_1:bind(var0_0.GET_WEEKLY_COIN, function(arg0_4, arg1_4, arg2_4)
		pg.m02:sendNotification(GAME.GAME_ROOM_WEEK_COIN)
	end)
	arg0_1:bind(var0_0.EXCHANGE_COIN, function(arg0_5, arg1_5, arg2_5)
		pg.m02:sendNotification(GAME.GAME_ROOM_EXCHANGE_COIN, arg1_5)
	end)
end

function var0_0.onUIAvalible(arg0_6)
	if getProxy(GameRoomProxy):getFirstEnter() then
		pg.m02:sendNotification(GAME.GAME_ROOM_FIRST_COIN)
	else
		pg.SystemGuideMgr.GetInstance():Play(arg0_6.viewComponent)
	end
end

function var0_0.listNotificationInterests(arg0_7)
	return {
		GAME.GAME_ROOM_AWARD_DONE,
		GAME.ROOM_FIRST_COIN_DONE,
		GAME.END_GUIDE
	}
end

function var0_0.handleNotification(arg0_8, arg1_8)
	local var0_8 = arg1_8:getName()
	local var1_8 = arg1_8:getBody()

	if var0_8 == GAME.GAME_ROOM_AWARD_DONE then
		arg0_8.viewComponent:emit(BaseUI.ON_AWARD, {
			items = var1_8
		})
		arg0_8.viewComponent:updateUI()
	elseif var0_8 == GAME.ROOM_FIRST_COIN_DONE then
		seriesAsync({
			function(arg0_9)
				arg0_8.viewComponent:emit(BaseUI.ON_AWARD, {
					items = var1_8,
					removeFunc = arg0_9
				})
			end,
			function(arg0_10)
				arg0_8.viewComponent:updateUI()
				pg.SystemGuideMgr.GetInstance():Play(arg0_8.viewComponent)
				arg0_10()
			end
		})
	elseif var0_8 == GAME.END_GUIDE then
		pg.SystemGuideMgr.GetInstance():Play(arg0_8.viewComponent)
	end
end

return var0_0
