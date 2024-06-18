local var0_0 = class("FireworkFactoryMediator", import(".MiniHubMediator"))

function var0_0.handleNotification(arg0_1, arg1_1)
	local var0_1 = arg1_1:getName()
	local var1_1 = arg1_1:getBody()

	if var0_1 == MiniGameProxy.ON_HUB_DATA_UPDATE then
		arg0_1.viewComponent:SetMGHubData(var1_1)
	elseif var0_1 == GAME.SEND_MINI_GAME_OP_DONE and var1_1.cmd == MiniGameOPCommand.CMD_COMPLETE then
		local var2_1 = var1_1.argList
		local var3_1 = var1_1.cmd
		local var4_1 = {
			function(arg0_2)
				local var0_2 = (getProxy(MiniGameProxy):GetMiniGameData(MiniGameDataCreator.ShrineGameID):GetRuntimeData("count") or 0) + 1

				arg0_1:sendNotification(GAME.MODIFY_MINI_GAME_DATA, {
					id = MiniGameDataCreator.ShrineGameID,
					map = {
						count = var0_2
					}
				})
				arg0_2()
			end,
			function(arg0_3)
				local var0_3 = var1_1.awards

				if #var0_3 > 0 then
					arg0_1.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_3, arg0_3)
				else
					arg0_3()
				end
			end,
			function(arg0_4)
				arg0_1.viewComponent:OnGetAwardDone(var1_1)
			end
		}

		seriesAsync(var4_1)
		arg0_1.viewComponent:OnSendMiniGameOPDone(var1_1)
	elseif var0_1 == GAME.MODIFY_MINI_GAME_DATA_DONE then
		arg0_1.viewComponent:OnModifyMiniGameDataDone(var1_1)
	else
		var0_0.super.handleNotification(arg0_1, arg1_1)
	end
end

return var0_0
