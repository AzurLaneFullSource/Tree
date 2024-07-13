local var0_0 = class("GuildEventTimerView")

function var0_0.Flush(arg0_1, arg1_1, arg2_1)
	arg0_1.text = arg1_1

	arg0_1:RemoveEndEventTimer()

	local var0_1 = arg2_1:GetLeftTime()

	if var0_1 < 86400 then
		arg0_1.timer = Timer.New(function()
			local var0_2 = arg2_1:GetLeftTime()

			arg0_1:UpdateText("<size=31><color=#FF3838>" .. pg.TimeMgr.GetInstance():DescCDTime(var0_2) .. "</color></size>")

			if var0_2 <= 0 then
				arg0_1:OnOver()
			end
		end, 1, -1)

		arg0_1.timer.func()
	else
		local var1_1, var2_1, var3_1, var4_1 = pg.TimeMgr.GetInstance():parseTimeFrom(var0_1)

		assert(var1_1 > 0)

		if var2_1 <= 0 and (var3_1 > 0 or var4_1 > 0) then
			var2_1 = var2_1 + 1
		end

		local var5_1 = string.format("%s" .. i18n("word_date") .. "%s" .. i18n("word_hour"), var1_1, var2_1)

		if var1_1 < 7 then
			var5_1 = "<size=31><color=#FF3838>" .. var5_1 .. "</color></size>"
		end

		arg0_1:UpdateText(var5_1)

		local var6_1 = var3_1 * 60 + var4_1

		if var6_1 <= 0 then
			var6_1 = 3600
		end

		local var7_1 = math.min(var0_1 - 86400, var6_1)

		arg0_1.timer = Timer.New(function()
			arg0_1:Flush(arg1_1, arg2_1)
		end, var7_1 + 2, 1)
	end

	arg0_1.timer:Start()
end

function var0_0.UpdateText(arg0_4, arg1_4)
	arg0_4.text.text = arg1_4
end

function var0_0.RemoveEndEventTimer(arg0_5)
	if arg0_5.timer then
		arg0_5.timer:Stop()

		arg0_5.timer = nil
	end
end

function var0_0.OnOver(arg0_6)
	arg0_6:RemoveEndEventTimer()
	pg.m02:sendNotification(GAME.GUILD_GET_ACTIVATION_EVENT, {
		force = true
	})
end

function var0_0.Dispose(arg0_7)
	arg0_7:RemoveEndEventTimer()
end

return var0_0
