local var0 = class("GameMediator", pm.Mediator)

function var0.listNotificationInterests(arg0)
	return {
		GAME.GO_SCENE,
		GAME.GO_MINI_GAME,
		GAME.LOAD_SCENE_DONE,
		GAME.SEND_CMD_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()
	local var2

	if var0 == GAME.GO_SCENE then
		local var3 = arg1:getType()
		local var4 = Context.New()

		var4:extendData(var3)
		SCENE.SetSceneInfo(var4, var1)
		print("load scene: " .. var1)
		arg0:sendNotification(GAME.LOAD_SCENE, {
			context = var4
		})
	elseif var0 == GAME.GO_MINI_GAME then
		local var5 = Context.New()
		local var6 = var1

		var5:extendData({
			miniGameId = var6
		})

		local var7 = pg.mini_game[var6]

		var5.mediator = _G[var7.mediator_name]
		var5.viewComponent = _G[var7.view_name]
		var5.scene = var7.view_name

		print("load minigame: " .. var7.view_name)

		local var8 = {
			context = var5
		}
		local var9 = arg1:getType()

		table.merge(var8, var9)
		arg0:sendNotification(GAME.LOAD_SCENE, var8)
	elseif var0 == GAME.LOAD_SCENE_DONE then
		print("scene loaded: ", var1)

		if var1 == SCENE.LOGIN then
			pg.UIMgr.GetInstance():displayLoadingBG(false)
			pg.UIMgr.GetInstance():LoadingOff()
		end
	elseif var0 == GAME.SEND_CMD_DONE then
		-- block empty
	end
end

return var0
