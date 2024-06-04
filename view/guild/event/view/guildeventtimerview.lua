local var0 = class("GuildEventTimerView")

function var0.Flush(arg0, arg1, arg2)
	arg0.text = arg1

	arg0:RemoveEndEventTimer()

	local var0 = arg2:GetLeftTime()

	if var0 < 86400 then
		arg0.timer = Timer.New(function()
			local var0 = arg2:GetLeftTime()

			arg0:UpdateText("<size=31><color=#FF3838>" .. pg.TimeMgr.GetInstance():DescCDTime(var0) .. "</color></size>")

			if var0 <= 0 then
				arg0:OnOver()
			end
		end, 1, -1)

		arg0.timer.func()
	else
		local var1, var2, var3, var4 = pg.TimeMgr.GetInstance():parseTimeFrom(var0)

		assert(var1 > 0)

		if var2 <= 0 and (var3 > 0 or var4 > 0) then
			var2 = var2 + 1
		end

		local var5 = string.format("%s" .. i18n("word_date") .. "%s" .. i18n("word_hour"), var1, var2)

		if var1 < 7 then
			var5 = "<size=31><color=#FF3838>" .. var5 .. "</color></size>"
		end

		arg0:UpdateText(var5)

		local var6 = var3 * 60 + var4

		if var6 <= 0 then
			var6 = 3600
		end

		local var7 = math.min(var0 - 86400, var6)

		arg0.timer = Timer.New(function()
			arg0:Flush(arg1, arg2)
		end, var7 + 2, 1)
	end

	arg0.timer:Start()
end

function var0.UpdateText(arg0, arg1)
	arg0.text.text = arg1
end

function var0.RemoveEndEventTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.OnOver(arg0)
	arg0:RemoveEndEventTimer()
	pg.m02:sendNotification(GAME.GUILD_GET_ACTIVATION_EVENT, {
		force = true
	})
end

function var0.Dispose(arg0)
	arg0:RemoveEndEventTimer()
end

return var0
