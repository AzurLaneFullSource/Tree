local var0_0 = class("ActivityRemasterUtil")

function var0_0.AdapterCoreScene(arg0_1, arg1_1, arg2_1, arg3_1)
	if isa(arg0_1, BaseActivityPage) then
		local var0_1 = CoreActivityPage.New(arg1_1, arg2_1, arg3_1)

		setmetatable(arg0_1, {
			__index = function(arg0_2, arg1_2)
				local var0_2 = rawget(arg0_2, "class")

				return var0_2[arg1_2] and var0_2[arg1_2] or var0_1[arg1_2]
			end
		})
	end
end

function var0_0.UpdateTime(arg0_3)
	local var0_3 = pg.TimeMgr.GetInstance()
	local var1_3, var2_3 = getProxy(ActivityRemasterProxy):InActTime()

	if var2_3 > 0 then
		local var3_3 = pg.activity_re_timer[var2_3]
		local var4_3 = var3_3.timer[2][1][1]
		local var5_3 = var3_3.timer[2][1][2]
		local var6_3 = var3_3.timer[2][1][3]
		local var7_3 = var3_3.timer[3][1][1]
		local var8_3 = var3_3.timer[3][1][2]
		local var9_3 = var3_3.timer[3][1][3]
		local var10_3 = string.format("%s.%s-%s.%s", var5_3, var6_3, var8_3, var9_3)

		setText(arg0_3.time.transform:Find("Text"), var10_3)
		setText(arg0_3.time.transform:Find("label"), i18n("act_remaster_tip_2", ""))

		local var11_3 = arg0_3.time.transform:Find("Text_1")

		if not IsNil(var11_3) then
			setText(var11_3, var10_3)
		end
	end

	local var12_3 = arg0_3.time.transform:Find("label_1")

	if not IsNil(var12_3) then
		setText(var12_3, i18n("act_remaster_tip_2", ""))
	end

	local var13_3 = arg0_3.time.transform:Find("extend_time")

	if not IsNil(var13_3) and arg0_3.activity then
		local var14_3 = arg0_3.activity.stopTime
		local var15_3 = var0_3:STimeDescS(var14_3, "*t")
		local var16_3 = ""

		if var15_3.hour == 0 then
			var16_3 = string.format("%04d.%02d.%02d %02d:%02d:%02d", var15_3.year, var15_3.month, var15_3.day - 1, 23, 59, 59)
		else
			var16_3 = string.format("%04d.%02d.%02d %02d:%02d:%02d", var15_3.year, var15_3.month, var15_3.day, var15_3.hour, var15_3.min, var15_3.sec)
		end

		setText(var13_3, i18n("act_remaster_extend_time", var16_3))
	end
end

return var0_0
