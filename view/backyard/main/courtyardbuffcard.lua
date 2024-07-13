local var0_0 = class("CourtYardBuffCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.timeTxt = arg0_1._tf:Find("Text"):GetComponent(typeof(Text))
	arg0_1.icon = arg0_1._tf:GetComponent(typeof(Image))
end

function var0_0.Flush(arg0_2, arg1_2)
	arg0_2.buff = arg1_2
	arg0_2.icon.sprite = LoadSprite(arg1_2:getConfig("icon") .. "_backyard") or LoadSprite(arg1_2:getConfig("icon"))

	arg0_2:RemoveTimer()

	arg0_2.using = true

	if arg1_2:isActivate() then
		arg0_2:StartTimer(arg1_2)
	end
end

function var0_0.StartTimer(arg0_3, arg1_3)
	setActive(arg0_3._tf, true)

	arg0_3.timer = Timer.New(function()
		local var0_4 = arg1_3:getLeftTime()

		if var0_4 > 0 then
			local var1_4 = pg.TimeMgr.GetInstance():DescCDTime(var0_4)
			local var2_4 = var0_4 <= 600 and setColorStr(var1_4, COLOR_RED) or setColorStr(var1_4, "#FFFFFFFF")

			arg0_3.timeTxt.text = var2_4
		else
			arg0_3:RemoveTimer()
		end
	end, 1, -1)

	arg0_3.timer:Start()
	arg0_3.timer.func()
end

function var0_0.RemoveTimer(arg0_5)
	arg0_5.using = false

	setActive(arg0_5._tf, false)

	if arg0_5.timer then
		arg0_5.timer:Stop()

		arg0_5.timer = nil
	end
end

function var0_0.IsUsing(arg0_6)
	return arg0_6.using
end

function var0_0.Dispose(arg0_7)
	arg0_7:RemoveTimer()
end

return var0_0
