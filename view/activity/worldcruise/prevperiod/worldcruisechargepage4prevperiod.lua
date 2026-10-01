local var0_0 = class("WorldCruiseChargePage4PrevPeriod", import("..pages.WorldCruiseChargePage"))

function var0_0.getUIName(arg0_1)
	return "WorldCruiseChargePage4PrevPeriod"
end

function var0_0.GetPassId(arg0_2)
	local var0_2 = getProxy(ActivityProxy):getAliveActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)

	if var0_2 and not var0_2:isEnd() then
		local var1_2 = var0_2:GetPreviousPeriodAct()

		assert(var1_2, "prev period crusing activity is nil")

		for iter0_2, iter1_2 in ipairs(pg.pay_data_display.all) do
			local var2_2 = pg.pay_data_display[iter1_2]

			if var2_2.sub_display and type(var2_2.sub_display) == "table" and var2_2.sub_display[1] == var1_2.id then
				return iter1_2
			end
		end
	end

	return nil
end

return var0_0
