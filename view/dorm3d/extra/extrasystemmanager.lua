local var0_0 = class("ExtraSystemManager")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.event = arg1_1
	arg0_1.scene = arg2_1
	arg0_1.systems = {}
	arg0_1.systemOrder = {}
end

function var0_0.Register(arg0_2, arg1_2, ...)
	local var0_2 = arg1_2.__cname or tostring(arg1_2)

	warning("Trying to register Extra System:", var0_2)

	if arg0_2.systems[var0_2] then
		warning("System " .. var0_2 .. " already registered")

		return arg0_2.systems[var0_2]
	end

	if arg1_2.IsOpen then
		local var1_2 = arg0_2.scene.room

		if not arg1_2.IsOpen(var1_2, ...) then
			return nil
		end
	end

	local var2_2 = arg1_2.New(arg0_2.event, arg0_2.scene, ...)

	arg0_2.systems[var0_2] = var2_2

	warning("Register Extra System:", var0_2)
	table.insert(arg0_2.systemOrder, var0_2)
	var2_2:Init()

	return var2_2
end

function var0_0.Get(arg0_3, arg1_3)
	local var0_3

	if type(arg1_3) == "string" then
		var0_3 = arg1_3
	else
		var0_3 = arg1_3.__cname or tostring(arg1_3)
	end

	return arg0_3.systems[var0_3]
end

function var0_0.Remove(arg0_4, arg1_4)
	warning("Trying to remove Extra System:", arg1_4)

	local var0_4

	if type(arg1_4) == "string" then
		var0_4 = arg1_4
	else
		var0_4 = arg1_4.__cname or tostring(arg1_4)
	end

	local var1_4 = arg0_4.systems[var0_4]

	if not var1_4 then
		return
	end

	var1_4:Dispose()

	arg0_4.systems[var0_4] = nil

	table.removebyvalue(arg0_4.systemOrder, var0_4)
	warning("Remove Extra System:", var0_4)
end

function var0_0.Update(arg0_5, arg1_5)
	for iter0_5, iter1_5 in ipairs(arg0_5.systemOrder) do
		local var0_5 = arg0_5.systems[iter1_5]

		if var0_5 then
			var0_5:Update(arg1_5)
		end
	end
end

function var0_0.LateUpdate(arg0_6, arg1_6)
	for iter0_6, iter1_6 in ipairs(arg0_6.systemOrder) do
		local var0_6 = arg0_6.systems[iter1_6]

		if var0_6 then
			var0_6:LateUpdate(arg1_6)
		end
	end
end

function var0_0.BroadcastNotification(arg0_7, arg1_7, arg2_7)
	for iter0_7, iter1_7 in ipairs(arg0_7.systemOrder) do
		local var0_7 = arg0_7.systems[iter1_7]

		if var0_7 then
			local var1_7 = var0_7.GetInterests()

			if table.contains(var1_7, arg1_7) then
				var0_7:HandleNotification(arg1_7, arg2_7)
			end
		end
	end
end

function var0_0.GetAllInterests(arg0_8)
	local var0_8 = {}

	for iter0_8, iter1_8 in ipairs(arg0_8.systemOrder) do
		local var1_8 = arg0_8.systems[iter1_8]

		if var1_8 then
			local var2_8 = var1_8.GetInterests()

			for iter2_8, iter3_8 in ipairs(var2_8) do
				if not table.contains(var0_8, iter3_8) then
					table.insert(var0_8, iter3_8)
				end
			end
		end
	end

	return var0_8
end

function var0_0.Dispose(arg0_9)
	for iter0_9 = #arg0_9.systemOrder, 1, -1 do
		local var0_9 = arg0_9.systemOrder[iter0_9]
		local var1_9 = arg0_9.systems[var0_9]

		if var1_9 then
			var1_9:Dispose()
		end
	end

	arg0_9.systems = {}
	arg0_9.systemOrder = {}
	arg0_9.event = nil
	arg0_9.scene = nil
end

return var0_0
