local var0 = class("AsyncExcutionRequestLitePackage", import(".RequestPackage"))

var0.STATUS = {
	SUSPEND = 2,
	READY = 1,
	RUNNING = 3
}

function var0.__call(arg0, ...)
	if arg0.stopped then
		return
	end

	if not arg0.funcs or #arg0.funcs == 0 then
		return
	end

	arg0:Excute()
end

function var0.Resume(arg0)
	arg0.targetStatus = var0.STATUS.READY

	if arg0.status == var0.STATUS.SUSPEND then
		arg0:Excute()
	end
end

function var0.Suspend(arg0)
	arg0.targetStatus = var0.STATUS.SUSPEND
end

function var0.Ctor(arg0, arg1)
	arg0.funcs = arg1 or {}
	arg0.status = var0.STATUS.READY
	arg0.targetStatus = var0.STATUS.READY
end

function var0.Insert(arg0, arg1)
	table.insert(arg0.funcs, arg1)
end

function var0.Excute(arg0)
	assert(arg0.ready)

	if not arg0.ready then
		return
	end

	local var0

	local function var1(...)
		if arg0.stopped then
			return
		end

		if arg0.suspended or not arg0.funcs or not (#arg0.funcs > 0) then
			arg0.ready = true

			return
		end

		arg0.ready = nil

		table.remove(arg0.funcs, 1)(var1, ...)
	end

	var1()
end

return var0
