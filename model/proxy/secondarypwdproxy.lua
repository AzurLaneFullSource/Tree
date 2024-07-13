local var0_0 = class("SecondaryPWDProxy", import(".NetProxy"))

function var0_0.register(arg0_1)
	arg0_1.data = arg0_1.data or {}

	local var0_1 = arg0_1.data

	var0_1.state = 0
	var0_1.fail_count = 0
	var0_1.fail_cd = nil
	var0_1.notice = nil
	var0_1.system_list = {}
end

function var0_0.SetData(arg0_2, arg1_2)
	arg0_2.data = arg0_2.data or {}

	local var0_2 = arg0_2.data

	var0_2.state = arg1_2.state
	var0_2.fail_count = arg1_2.fail_count
	var0_2.fail_cd = arg1_2.fail_cd
	var0_2.notice = arg1_2.notice
	var0_2.system_list = {}

	for iter0_2 = 1, #pg.SecondaryPWDMgr.LIMITED_OPERATION do
		table.insert(var0_2.system_list, arg1_2.system_list[iter0_2])
	end
end

function var0_0.OnFirstSet(arg0_3, arg1_3)
	arg0_3.data = arg0_3.data or {}

	local var0_3 = arg0_3.data

	var0_3.state = 1
	var0_3.system_list = Clone(arg1_3.settings)
	var0_3.fail_count = 0
	var0_3.fail_cd = nil
	var0_3.notice = Clone(arg1_3.tip)
end

function var0_0.OnSettingsChange(arg0_4, arg1_4)
	arg0_4.data = arg0_4.data or {}

	local var0_4 = arg0_4.data

	var0_4.state = #arg1_4.settings == 0 and 0 or 2
	var0_4.system_list = Clone(arg1_4.settings)
	var0_4.fail_cd = nil
	var0_4.fail_count = 0
end

function var0_0.GetPermissionState(arg0_5)
	if arg0_5.data.state == 0 then
		return true
	end

	local var0_5 = arg0_5.data.fail_cd
	local var1_5 = pg.TimeMgr.GetInstance():GetServerTime()

	if var0_5 and var1_5 < var0_5 then
		return false, var0_5 - var1_5
	end

	return true
end

return var0_0
