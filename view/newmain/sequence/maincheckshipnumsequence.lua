local var0_0 = class("MainCheckShipNumSequence")

function var0_0.Execute(arg0_1, arg1_1)
	local function var0_1(arg0_2)
		if arg0_1:Check(arg0_2) then
			arg1_1()
		end
	end

	pg.m02:sendNotification(GAME.GET_SHIP_CNT, {
		callback = var0_1
	})
end

function var0_0.Check(arg0_3, arg1_3)
	local var0_3 = getProxy(BayProxy):getRawShipCount()
	local var1_3 = arg1_3 <= var0_3

	if not var1_3 then
		originalPrint(arg1_3, var0_3)
		arg0_3:ShowTip()
	end

	return var1_3
end

function var0_0.ShowTip(arg0_4)
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

return var0_0
