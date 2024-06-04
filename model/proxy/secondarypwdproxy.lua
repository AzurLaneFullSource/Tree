local var0 = class("SecondaryPWDProxy", import(".NetProxy"))

function var0.register(arg0)
	arg0.data = arg0.data or {}

	local var0 = arg0.data

	var0.state = 0
	var0.fail_count = 0
	var0.fail_cd = nil
	var0.notice = nil
	var0.system_list = {}
end

function var0.SetData(arg0, arg1)
	arg0.data = arg0.data or {}

	local var0 = arg0.data

	var0.state = arg1.state
	var0.fail_count = arg1.fail_count
	var0.fail_cd = arg1.fail_cd
	var0.notice = arg1.notice
	var0.system_list = {}

	for iter0 = 1, #pg.SecondaryPWDMgr.LIMITED_OPERATION do
		table.insert(var0.system_list, arg1.system_list[iter0])
	end
end

function var0.OnFirstSet(arg0, arg1)
	arg0.data = arg0.data or {}

	local var0 = arg0.data

	var0.state = 1
	var0.system_list = Clone(arg1.settings)
	var0.fail_count = 0
	var0.fail_cd = nil
	var0.notice = Clone(arg1.tip)
end

function var0.OnSettingsChange(arg0, arg1)
	arg0.data = arg0.data or {}

	local var0 = arg0.data

	var0.state = #arg1.settings == 0 and 0 or 2
	var0.system_list = Clone(arg1.settings)
	var0.fail_cd = nil
	var0.fail_count = 0
end

function var0.GetPermissionState(arg0)
	if arg0.data.state == 0 then
		return true
	end

	local var0 = arg0.data.fail_cd
	local var1 = pg.TimeMgr.GetInstance():GetServerTime()

	if var0 and var1 < var0 then
		return false, var0 - var1
	end

	return true
end

return var0
