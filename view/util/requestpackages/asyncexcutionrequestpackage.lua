local var0_0 = class("AsyncExcutionRequestPackage", import(".RequestPackage"))

function var0_0.__call(arg0_1, ...)
	if arg0_1.stopped then
		return
	end

	if not arg0_1.funcs or #arg0_1.funcs == 0 then
		return
	end

	arg0_1:Excute(...)
end

function var0_0.Resume(arg0_2)
	arg0_2.suspended = nil

	if arg0_2.ready then
		if arg0_2.resume then
			local var0_2 = arg0_2.resume

			arg0_2.resume = nil

			arg0_2:Excute(unpack(var0_2.params, var0_2.paramLength))
		else
			arg0_2:Excute()
		end
	end
end

function var0_0.Suspend(arg0_3)
	arg0_3.suspended = true
end

function var0_0.Ctor(arg0_4, arg1_4)
	arg0_4.ready = true
	arg0_4.funcs = arg1_4
	arg0_4.suspended = nil
	arg0_4.resume = nil
end

function var0_0.Insert(arg0_5, arg1_5)
	table.insert(arg0_5.funcs, arg1_5)
end

function var0_0.Excute(arg0_6, ...)
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
			arg0_6.resume = {
				params = {
					...
				},
				paramLength = select("#", ...)
			}
			arg0_6.ready = true

			return
		end

		arg0_6.ready = nil

		table.remove(arg0_6.funcs, 1)(var1_6, ...)
	end

	var1_6(...)
end

return var0_0
