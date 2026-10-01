local var0_0 = class("MainPrevPeriodCrusingChargeTipSequence")

var0_0.TIP = true

function var0_0.Execute(arg0_1, arg1_1)
	if not PrevPeriodCrusingActivity.StaticExistPrevPeriodCrusingActivity() then
		arg1_1()

		return
	end

	if not var0_0.TIP then
		arg1_1()

		return
	end

	arg0_1.callback = arg1_1

	arg0_1:ShowMsgBox()
end

function var0_0.ShowMsgBox(arg0_2)
	arg0_2.mediator = MainPrevPeriodCrusingChargeTipMeidator.New(arg0_2)

	local var0_2 = PrevPeriodCrusingChargeTipPage.New(pg.UIMgr.GetInstance().OverlayMain)

	var0_2:ExecuteAction("Show", function()
		arg0_2:OnClose()
	end)

	arg0_2.chargeTipPage = var0_2
	var0_0.TIP = false
end

function var0_0.OnClose(arg0_4)
	if arg0_4.callback then
		arg0_4.callback()
	end

	arg0_4.callback = nil

	if arg0_4.mediator then
		arg0_4.mediator:Dispose()

		arg0_4.mediator = nil
	end
end

function var0_0.OnChargeSuccess(arg0_5, arg1_5)
	local var0_5 = Goods.Create({
		shop_id = arg1_5.shopId
	}, Goods.TYPE_CHARGE)

	if not var0_5:isPassItem() then
		return
	end

	seriesAsync({
		function(arg0_6)
			arg0_5.chargeTipPage:OnChargeScene(var0_5, arg0_6)
		end,
		function(arg0_7)
			MainFetchPrevPeriodCrusingSequence.New():Execute(arg0_7)
		end
	}, function()
		if arg0_5.chargeTipPage and arg0_5.chargeTipPage:GetLoaded() then
			arg0_5.chargeTipPage:Destroy()

			arg0_5.chargeTipPage = nil
		end
	end)
end

function var0_0.GetCurrentCrusingAct(arg0_9)
	local var0_9 = getProxy(ActivityProxy):getAliveActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)

	if var0_9 and not var0_9:isEnd() then
		return var0_9
	end

	return nil
end

return var0_0
