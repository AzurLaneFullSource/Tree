local var0 = class("MainCheckShipNumSequence")

function var0.Execute(arg0, arg1)
	local function var0(arg0)
		if arg0:Check(arg0) then
			arg1()
		end
	end

	pg.m02:sendNotification(GAME.GET_SHIP_CNT, {
		callback = var0
	})
end

function var0.Check(arg0, arg1)
	local var0 = getProxy(BayProxy):getRawShipCount()
	local var1 = arg1 <= var0

	if not var1 then
		originalPrint(arg1, var0)
		arg0:ShowTip()
	end

	return var1
end

function var0.ShowTip(arg0)
	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		modal = true,
		hideNo = true,
		hideClose = true,
		content = i18n("dockyard_data_loss_detected"),
		onYes = function()
			pg.m02:sendNotification(GAME.LOGOUT, {
				code = 0
			})
		end
	})
end

return var0
