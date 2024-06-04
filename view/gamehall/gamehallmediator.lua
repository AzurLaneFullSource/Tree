local var0 = class("GameHallMediator", import("..base.ContextMediator"))

var0.OPEN_MINI_GAME = "open mini game"
var0.OPEN_GAME_SHOP = "open game shop "
var0.GET_WEEKLY_COIN = "get weekly coin"
var0.EXCHANGE_COIN = "exchange coin"

function var0.register(arg0)
	arg0:bind(var0.OPEN_MINI_GAME, function(arg0, arg1, arg2)
		print("open minigame " .. arg1.game_id)
		pg.m02:sendNotification(GAME.GO_MINI_GAME, arg1.game_id)
	end)
	arg0:bind(var0.OPEN_GAME_SHOP, function(arg0, arg1, arg2)
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SHOP, {
			warp = NewShopsScene.TYPE_MINI_GAME
		})
	end)
	arg0:bind(var0.GET_WEEKLY_COIN, function(arg0, arg1, arg2)
		pg.m02:sendNotification(GAME.GAME_ROOM_WEEK_COIN)
	end)
	arg0:bind(var0.EXCHANGE_COIN, function(arg0, arg1, arg2)
		pg.m02:sendNotification(GAME.GAME_ROOM_EXCHANGE_COIN, arg1)
	end)
end

function var0.onUIAvalible(arg0)
	if getProxy(GameRoomProxy):getFirstEnter() then
		pg.m02:sendNotification(GAME.GAME_ROOM_FIRST_COIN)
	else
		pg.SystemGuideMgr.GetInstance():Play(arg0.viewComponent)
	end
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.GAME_ROOM_AWARD_DONE,
		GAME.ROOM_FIRST_COIN_DONE,
		GAME.END_GUIDE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.GAME_ROOM_AWARD_DONE then
		arg0.viewComponent:emit(BaseUI.ON_AWARD, {
			items = var1
		})
		arg0.viewComponent:updateUI()
	elseif var0 == GAME.ROOM_FIRST_COIN_DONE then
		seriesAsync({
			function(arg0)
				arg0.viewComponent:emit(BaseUI.ON_AWARD, {
					items = var1,
					removeFunc = arg0
				})
			end,
			function(arg0)
				arg0.viewComponent:updateUI()
				pg.SystemGuideMgr.GetInstance():Play(arg0.viewComponent)
				arg0()
			end
		})
	elseif var0 == GAME.END_GUIDE then
		pg.SystemGuideMgr.GetInstance():Play(arg0.viewComponent)
	end
end

return var0
