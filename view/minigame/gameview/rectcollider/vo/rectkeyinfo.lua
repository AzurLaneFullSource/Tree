local var0 = class("RectKeyInfo")

function var0.Ctor(arg0)
	arg0._inPutKeyDic = {}
end

function var0.setKeyPress(arg0, arg1, arg2)
	arg0:getKeyData(arg1).status = arg2

	arg0:setKeyData(arg1, arg2)

	if arg0._triggerCallback then
		arg0._triggerCallback(arg1, arg2)
	end
end

function var0.setTriggerCallback(arg0, arg1)
	arg0._triggerCallback = arg1
end

function var0.setKeyData(arg0, arg1, arg2)
	for iter0 = 1, #arg0._inPutKeyDic do
		local var0 = arg0._inPutKeyDic[iter0]

		if var0.code == arg1 then
			var0.status = arg2
		end
	end
end

function var0.getKeyData(arg0, arg1)
	if not arg1 then
		return
	end

	local var0

	for iter0 = 1, #arg0._inPutKeyDic do
		local var1 = arg0._inPutKeyDic[iter0]

		if var1.code == arg1 then
			var0 = var1
		end
	end

	if not var0 then
		var0 = {
			status = false,
			code = arg1
		}

		table.insert(arg0._inPutKeyDic, var0)
	end

	return var0
end

function var0.getKeyCode(arg0, arg1)
	if not arg1 then
		return nil
	end

	local var0

	for iter0 = 1, #arg0._inPutKeyDic do
		local var1 = arg0._inPutKeyDic[iter0]

		if var1.code == arg1 then
			var0 = var1
		end
	end

	if not var0 then
		var0 = {
			status = false,
			code = arg1
		}

		table.insert(arg0._inPutKeyDic, var0)
	end

	return var0.status
end

return var0
