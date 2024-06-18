local var0_0 = class("HoloLiveLinkLinkSelectMediator", import("view.base.ContextMediator"))

var0_0.HUB_ID = 3

function var0_0.register(arg0_1)
	arg0_1:BindEvent()
	arg0_1:requestDataFromServer()
end

function var0_0.requestDataFromServer(arg0_2)
	pg.ConnectionMgr.GetInstance():Send(26101, {
		type = MiniGameRequestCommand.REQUEST_HUB_DATA
	}, 26102, function(arg0_3)
		local var0_3 = getProxy(MiniGameProxy)

		for iter0_3, iter1_3 in ipairs(arg0_3.hubs) do
			if iter1_3.id == var0_0.HUB_ID then
				var0_3:UpdataHubData(iter1_3)
			end
		end
	end)
end

function var0_0.BindEvent(arg0_4)
	return
end

function var0_0.listNotificationInterests(arg0_5)
	return {
		MiniGameProxy.ON_HUB_DATA_UPDATE,
		GAME.SEND_MINI_GAME_OP_DONE
	}
end

function var0_0.handleNotification(arg0_6, arg1_6)
	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()

	if var0_6 == MiniGameProxy.ON_HUB_DATA_UPDATE then
		if var1_6.id == HoloLiveLinkLinkSelectScene.HOLOLIVE_LINKGAME_HUB_ID then
			arg0_6.viewComponent:updateData()
			arg0_6.viewComponent:updateUI()
		end
	elseif var0_6 == GAME.SEND_MINI_GAME_OP_DONE and var1_6.cmd == MiniGameOPCommand.CMD_ULTIMATE then
		local var2_6 = {
			function(arg0_7)
				local var0_7 = var1_6.awards

				if #var0_7 > 0 then
					arg0_6.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_7, arg0_7)
				else
					arg0_7()
				end
			end,
			function(arg0_8)
				arg0_6.viewComponent:updateData()
				arg0_6.viewComponent:updateUI()
			end
		}

		seriesAsync(var2_6)
	end
end

return var0_0
