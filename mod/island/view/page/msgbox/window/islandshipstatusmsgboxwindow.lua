local var0_0 = class("IslandShipStatusMsgboxWindow", import(".IslandCommonMsgboxWindow"))

function var0_0.getUIName(arg0_1)
	return "IslandShipStatusMsgboxUI"
end

function var0_0.OnLoaded(arg0_2)
	var0_0.super.OnLoaded(arg0_2)

	arg0_2.buffDesc = arg0_2:findTF("Text"):GetComponent(typeof(Text))
end

function var0_0.OnShow(arg0_3)
	var0_0.super.OnShow(arg0_3)
	arg0_3:FlushBuff()
end

function var0_0.FlushBuff(arg0_4)
	local var0_4 = arg0_4.settings.buff

	if not var0_4 then
		return
	end

	arg0_4.buffDesc.text = ""

	arg0_4:AddTimer(var0_4)
end

function var0_0.AddTimer(arg0_5, arg1_5)
	arg0_5:RemoveTimer()

	local var0_5 = arg1_5:GetEndTime()

	if var0_5 <= 0 then
		return
	end

	arg0_5.timer = Timer.New(function()
		local var0_6 = pg.TimeMgr.GetInstance():GetServerTime()
		local var1_6 = var0_5 - var0_6

		if var1_6 <= 0 then
			arg0_5:RemoveTimer()

			arg0_5.buffDesc.text = ""
		else
			local var2_6 = pg.TimeMgr.GetInstance():DescCDTime(var1_6)

			arg0_5.buffDesc.text = arg1_5:GetName() .. ":" .. var2_6
		end
	end, 1, -1)

	arg0_5.timer:Start()
	arg0_5.timer.func()
end

function var0_0.RemoveTimer(arg0_7)
	if arg0_7.timer then
		arg0_7.timer:Stop()

		arg0_7.timer = nil
	end
end

function var0_0.OnHide(arg0_8)
	var0_0.super.OnHide(arg0_8)
	arg0_8:RemoveTimer()
end

return var0_0
