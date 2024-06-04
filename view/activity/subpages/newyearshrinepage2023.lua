local var0 = class("NewYearShrinePage2023", import(".NewYearShrinePage"))

var0.GO_MINI_GAME_ID = 45
var0.GO_BACKHILL_SCENE = SCENE.NEWYEAR_BACKHILL_2023

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)
	onButton(arg0, arg0.goBtn, function()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, var0.GO_MINI_GAME_ID, {
			callback = function()
				local var0 = Context.New()

				SCENE.SetSceneInfo(var0, var0.GO_BACKHILL_SCENE)
				getProxy(ContextProxy):PushContext2Prev(var0)
			end
		})
	end, SFX_PANEL)
end

return var0
