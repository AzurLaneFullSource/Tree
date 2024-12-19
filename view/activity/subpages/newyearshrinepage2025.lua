local var0_0 = class("NewYearShrinePage2025", import(".NewYearShrinePage"))

var0_0.GO_MINI_GAME_ID = 71

function var0_0.OnFirstFlush(arg0_1)
	var0_0.super.OnFirstFlush(arg0_1)
	onButton(arg0_1, arg0_1.goBtn, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, var0_0.GO_MINI_GAME_ID, {})
	end, SFX_PANEL)
end

return var0_0
