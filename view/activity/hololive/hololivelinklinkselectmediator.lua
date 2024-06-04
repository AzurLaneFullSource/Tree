local var0 = class("HoloLiveLinkLinkSelectMediator", import("view.base.ContextMediator"))

var0.HUB_ID = 3

function var0.register(arg0)
	arg0:BindEvent()
	arg0:requestDataFromServer()
end

function var0.requestDataFromServer(arg0)
	pg.ConnectionMgr.GetInstance():Send(26101, {
		type = MiniGameRequestCommand.REQUEST_HUB_DATA
	}, 26102, function(arg0)
		local var0 = getProxy(MiniGameProxy)

		for iter0, iter1 in ipairs(arg0.hubs) do
			if iter1.id == var0.HUB_ID then
				var0:UpdataHubData(iter1)
			end
		end
	end)
end

function var0.BindEvent(arg0)
	return
end

function var0.listNotificationInterests(arg0)
	return {
		MiniGameProxy.ON_HUB_DATA_UPDATE,
		GAME.SEND_MINI_GAME_OP_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == MiniGameProxy.ON_HUB_DATA_UPDATE then
		if var1.id == HoloLiveLinkLinkSelectScene.HOLOLIVE_LINKGAME_HUB_ID then
			arg0.viewComponent:updateData()
			arg0.viewComponent:updateUI()
		end
	elseif var0 == GAME.SEND_MINI_GAME_OP_DONE and var1.cmd == MiniGameOPCommand.CMD_ULTIMATE then
		local var2 = {
			function(arg0)
				local var0 = var1.awards

				if #var0 > 0 then
					arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var0, arg0)
				else
					arg0()
				end
			end,
			function(arg0)
				arg0.viewComponent:updateData()
				arg0.viewComponent:updateUI()
			end
		}

		seriesAsync(var2)
	end
end

return var0
