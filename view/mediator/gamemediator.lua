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
		local var6_2
		local var7_2

		if type(var1_2) == "number" then
			var6_2 = var1_2
			var7_2 = {
				miniGameId = var6_2
			}
		else
			var6_2 = var1_2.id
			var7_2 = var1_2
			var7_2.miniGameId = var6_2
		end

		var5_2:extendData(var7_2)

		local var8_2 = pg.mini_game[var6_2]

		var5_2.mediator = _G[var8_2.mediator_name]
		var5_2.viewComponent = _G[var8_2.view_name]
		var5_2.scene = var8_2.view_name

		print("load minigame: " .. var8_2.view_name)

		local var9_2 = {
			context = var5_2
		}
		local var10_2 = arg1_2:getType()

		table.merge(var9_2, var10_2)
		arg0_2:sendNotification(GAME.LOAD_SCENE, var9_2)
	elseif var0_2 == GAME.LOAD_SCENE_DONE then
		print("scene loaded: ", var1_2)

		if var1_2 == SCENE.LOGIN then
			pg.UIMgr.GetInstance():displayLoadingBG(false)
		end
	elseif var0_2 == GAME.SEND_CMD_DONE then
		-- block empty
	end
end

return var0_0
