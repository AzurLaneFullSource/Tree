local var0_0 = class("GameMediator", pm.Mediator)

function var0_0.listNotificationInterests(arg0_1)
	return {
		GAME.GO_SCENE,
		GAME.GO_MINI_GAME,
		GAME.LOAD_SCENE_DONE,
		GAME.SEND_CMD_DONE
	}
end

function var0_0.handleNotification(arg0_2, arg1_2)
	local var0_2 = arg1_2:getName()
	local var1_2 = arg1_2:getBody()
	local var2_2

	if var0_2 == GAME.GO_SCENE then
		local var3_2 = arg1_2:getType()
		local var4_2 = Context.New()

		var4_2:extendData(var3_2)
		SCENE.SetSceneInfo(var4_2, var1_2)
		print("load scene: " .. var1_2)
		arg0_2:sendNotification(GAME.LOAD_SCENE, {
			context = var4_2
		})
	elseif var0_2 == GAME.GO_MINI_GAME then
		local var5_2 = Context.New()
		local var6_2 = var1_2

		var5_2:extendData({
			miniGameId = var6_2
		})

		local var7_2 = pg.mini_game[var6_2]

		var5_2.mediator = _G[var7_2.mediator_name]
		var5_2.viewComponent = _G[var7_2.view_name]
		var5_2.scene = var7_2.view_name

		print("load minigame: " .. var7_2.view_name)

		local var8_2 = {
			context = var5_2
		}
		local var9_2 = arg1_2:getType()

		table.merge(var8_2, var9_2)
		arg0_2:sendNotification(GAME.LOAD_SCENE, var8_2)
	elseif var0_2 == GAME.LOAD_SCENE_DONE then
		print("scene loaded: ", var1_2)

		if var1_2 == SCENE.LOGIN then
			pg.UIMgr.GetInstance():displayLoadingBG(false)
			pg.UIMgr.GetInstance():LoadingOff()
		end
	elseif var0_2 == GAME.SEND_CMD_DONE then
		-- block empty
	end
end

return var0_0
