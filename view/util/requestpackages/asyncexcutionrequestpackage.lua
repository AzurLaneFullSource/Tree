local var0 = class("AsyncExcutionRequestPackage", import(".RequestPackage"))

function var0.__call(arg0, ...)
	if arg0.stopped then
		return
	end

	if not arg0.funcs or #arg0.funcs == 0 then
		return
	end

	arg0:Excute(...)
end

function var0.Resume(arg0)
	arg0.suspended = nil

	if arg0.ready then
		if arg0.resume then
			local var0 = arg0.resume

			arg0.resume = nil

			arg0:Excute(unpack(var0.params, var0.paramLength))
		else
			arg0:Excute()
		end
	end
end

function var0.Suspend(arg0)
	arg0.suspended = true
end

function var0.Ctor(arg0, arg1)
	arg0.ready = true
	arg0.funcs = arg1
	arg0.suspended = nil
	arg0.resume = nil
end

function var0.Insert(arg0, arg1)
	table.insert(arg0.funcs, arg1)
end

function var0.Excute(arg0, ...)
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
			arg0.resume = {
				params = {
					...
				},
				paramLength = select("#", ...)
			}
			arg0.ready = true

			return
		end

		arg0.ready = nil

		table.remove(arg0.funcs, 1)(var1, ...)
	end

	var1(...)
end

return var0
