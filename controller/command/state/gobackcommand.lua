local var0_0 = class("GoBackCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = arg1_1:getType() or 1
	local var2_1 = getProxy(ContextProxy)
	local var3_1 = var2_1:popContext()
	local var4_1
	local var5_1

	while var1_1 > 0 do
		if var2_1:getContextCount() == 0 then
			break
		else
			var4_1 = var2_1:popContext()

			if var4_1.skipBack then
				var4_1 = nil
			else
				var1_1 = var1_1 - 1
			end
		end
	end

	if var4_1 then
		var5_1 = var4_1.scene
	else
		var4_1 = Context.New()
		var5_1 = SCENE.MAINUI
	end

	var4_1:extendData(var0_1)
	SCENE.SetSceneInfo(var4_1, var5_1)
	arg0_1:sendNotification(GAME.LOAD_SCENE, {
		isBack = true,
		prevContext = var3_1,
		context = var4_1
	})
end

return var0_0
