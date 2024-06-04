local var0 = class("FireworkFactoryMediator", import(".MiniHubMediator"))

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == MiniGameProxy.ON_HUB_DATA_UPDATE then
		arg0.viewComponent:SetMGHubData(var1)
	elseif var0 == GAME.SEND_MINI_GAME_OP_DONE and var1.cmd == MiniGameOPCommand.CMD_COMPLETE then
		local var2 = var1.argList
		local var3 = var1.cmd
		local var4 = {
			function(arg0)
				local var0 = (getProxy(MiniGameProxy):GetMiniGameData(MiniGameDataCreator.ShrineGameID):GetRuntimeData("count") or 0) + 1

				arg0:sendNotification(GAME.MODIFY_MINI_GAME_DATA, {
					id = MiniGameDataCreator.ShrineGameID,
					map = {
						count = var0
					}
				})
				arg0()
			end,
			function(arg0)
				local var0 = var1.awards

				if #var0 > 0 then
					arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var0, arg0)
				else
					arg0()
				end
			end,
			function(arg0)
				arg0.viewComponent:OnGetAwardDone(var1)
			end
		}

		seriesAsync(var4)
		arg0.viewComponent:OnSendMiniGameOPDone(var1)
	elseif var0 == GAME.MODIFY_MINI_GAME_DATA_DONE then
		arg0.viewComponent:OnModifyMiniGameDataDone(var1)
	else
		var0.super.handleNotification(arg0, arg1)
	end
end

return var0
