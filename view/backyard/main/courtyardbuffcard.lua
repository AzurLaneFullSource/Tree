local var0 = class("CourtYardBuffCard")

function var0.Ctor(arg0, arg1)
	arg0._go = arg1
	arg0._tf = arg1.transform
	arg0.timeTxt = arg0._tf:Find("Text"):GetComponent(typeof(Text))
	arg0.icon = arg0._tf:GetComponent(typeof(Image))
end

function var0.Flush(arg0, arg1)
	arg0.buff = arg1
	arg0.icon.sprite = LoadSprite(arg1:getConfig("icon") .. "_backyard") or LoadSprite(arg1:getConfig("icon"))

	arg0:RemoveTimer()

	arg0.using = true

	if arg1:isActivate() then
		arg0:StartTimer(arg1)
	end
end

function var0.StartTimer(arg0, arg1)
	setActive(arg0._tf, true)

	arg0.timer = Timer.New(function()
		local var0 = arg1:getLeftTime()

		if var0 > 0 then
			local var1 = pg.TimeMgr.GetInstance():DescCDTime(var0)
			local var2 = var0 <= 600 and setColorStr(var1, COLOR_RED) or setColorStr(var1, "#FFFFFFFF")

			arg0.timeTxt.text = var2
		else
			arg0:RemoveTimer()
		end
	end, 1, -1)

	arg0.timer:Start()
	arg0.timer.func()
end

function var0.RemoveTimer(arg0)
	arg0.using = false

	setActive(arg0._tf, false)

	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.IsUsing(arg0)
	return arg0.using
end

function var0.Dispose(arg0)
	arg0:RemoveTimer()
end

return var0
