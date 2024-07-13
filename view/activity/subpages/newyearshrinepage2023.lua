local var0_0 = class("NewYearShrinePage2023", import(".NewYearShrinePage"))

var0_0.GO_MINI_GAME_ID = 45
var0_0.GO_BACKHILL_SCENE = SCENE.NEWYEAR_BACKHILL_2023

function var0_0.OnFirstFlush(arg0_1)
	var0_0.super.OnFirstFlush(arg0_1)
	onButton(arg0_1, arg0_1.goBtn, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, var0_0.GO_MINI_GAME_ID, {
			callback = function()
				local var0_3 = Context.New()

				SCENE.SetSceneInfo(var0_3, var0_0.GO_BACKHILL_SCENE)
				getProxy(ContextProxy):PushContext2Prev(var0_3)
			end
		})
	end, SFX_PANEL)
end

return var0_0
