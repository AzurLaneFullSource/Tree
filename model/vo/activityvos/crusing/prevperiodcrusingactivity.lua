local var0_0 = class("PrevPeriodCrusingActivity", import(".CrusingActivity"))

function var0_0.StaticExistPrevPeriodCrusingActivity()
	local var0_1 = getProxy(ActivityProxy)

	if not var0_1 then
		return false
	end

	local var1_1 = var0_1:getActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)

	if var1_1 and not var1_1:isEnd() then
		local var2_1 = var1_1:GetPreviousPeriodAct()

		if var2_1 and var2_1:CanRecharge() then
			return true, var2_1.id
		end
	end

	return false
end

function var0_0.Ctor(arg0_2, arg1_2, arg2_2)
	arg0_2.crusingActivity = arg2_2
	arg0_2.id = arg1_2
	arg0_2.configId = arg0_2.id

	arg0_2:SynCrusingActivity(arg2_2)
end

function var0_0.CanRecharge(arg0_3)
	local var0_3 = pg.gameset.last_worldcruise_pay.key_value
	local var1_3 = arg0_3:GetCrusingInfo()

	return var1_3 and not var1_3.isPay and var0_3 <= var1_3.phase
end

function var0_0.SynCrusingActivity(arg0_4, arg1_4)
	arg1_4 = arg1_4 or arg0_4.crusingActivity
	arg0_4.stopTime = arg1_4.stopTime
	arg0_4.data1 = arg1_4.data3
	arg0_4.data2 = arg1_4.data4
	arg0_4.data3 = 0
	arg0_4.data4 = 0
	arg0_4.str_data1 = ""
	arg0_4.data1_list = {}

	for iter0_4, iter1_4 in ipairs(arg1_4.data3_list or {}) do
		table.insert(arg0_4.data1_list, iter1_4)
	end

	arg0_4.data2_list = {}

	for iter2_4, iter3_4 in ipairs(arg1_4.data4_list or {}) do
		table.insert(arg0_4.data2_list, iter3_4)
	end

	arg0_4.data3_list = {}
	arg0_4.data4_list = {}
	arg0_4.data1KeyValueList = {}
	arg0_4.buffList = {}
	arg0_4.clientData1 = 0
end

function var0_0.RevertSynCrusingActivity(arg0_5)
	local var0_5 = arg0_5.crusingActivity

	var0_5.data3 = arg0_5.data1
	var0_5.data4 = arg0_5.data2
	var0_5.data3_list = {}

	for iter0_5, iter1_5 in ipairs(arg0_5.data1_list or {}) do
		table.insert(var0_5.data3_list, iter1_5)
	end

	var0_5.data4_list = {}

	for iter2_5, iter3_5 in ipairs(arg0_5.data2_list or {}) do
		table.insert(var0_5.data4_list, iter3_5)
	end
end

return var0_0
