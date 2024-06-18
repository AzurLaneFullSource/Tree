local var0_0 = class("AsyncExcutionRequestLitePackage", import(".RequestPackage"))

var0_0.STATUS = {
	SUSPEND = 2,
	READY = 1,
	RUNNING = 3
}

function var0_0.__call(arg0_1, ...)
	if arg0_1.stopped then
		return
	end

	if not arg0_1.funcs or #arg0_1.funcs == 0 then
		return
	end

	arg0_1:Excute()
end

function var0_0.Resume(arg0_2)
	arg0_2.targetStatus = var0_0.STATUS.READY

	if arg0_2.status == var0_0.STATUS.SUSPEND then
		arg0_2:Excute()
	end
end

function var0_0.Suspend(arg0_3)
	arg0_3.targetStatus = var0_0.STATUS.SUSPEND
end

function var0_0.Ctor(arg0_4, arg1_4)
	arg0_4.funcs = arg1_4 or {}
	arg0_4.status = var0_0.STATUS.READY
	arg0_4.targetStatus = var0_0.STATUS.READY
end

function var0_0.Insert(arg0_5, arg1_5)
	table.insert(arg0_5.funcs, arg1_5)
end

function var0_0.Excute(arg0_6)
	assert(arg0_6.ready)

	if not arg0_6.ready then
		return
	end

	local var0_6

	local function var1_6(...)
		if arg0_6.stopped then
			return
		end

		if arg0_6.suspended or not arg0_6.funcs or not (#arg0_6.funcs > 0) then
			arg0_6.ready = true

			return
		end

		arg0_6.ready = nil

		table.remove(arg0_6.funcs, 1)(var1_6, ...)
	end

	var1_6()
end

return var0_0
