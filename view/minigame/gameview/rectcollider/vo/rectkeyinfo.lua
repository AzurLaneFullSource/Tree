local var0_0 = class("RectKeyInfo")

function var0_0.Ctor(arg0_1)
	arg0_1._inPutKeyDic = {}
end

function var0_0.setKeyPress(arg0_2, arg1_2, arg2_2)
	arg0_2:getKeyData(arg1_2).status = arg2_2

	arg0_2:setKeyData(arg1_2, arg2_2)

	if arg0_2._triggerCallback then
		arg0_2._triggerCallback(arg1_2, arg2_2)
	end
end

function var0_0.setTriggerCallback(arg0_3, arg1_3)
	arg0_3._triggerCallback = arg1_3
end

function var0_0.setKeyData(arg0_4, arg1_4, arg2_4)
	for iter0_4 = 1, #arg0_4._inPutKeyDic do
		local var0_4 = arg0_4._inPutKeyDic[iter0_4]

		if var0_4.code == arg1_4 then
			var0_4.status = arg2_4
		end
	end
end

function var0_0.getKeyData(arg0_5, arg1_5)
	if not arg1_5 then
		return
	end

	local var0_5

	for iter0_5 = 1, #arg0_5._inPutKeyDic do
		local var1_5 = arg0_5._inPutKeyDic[iter0_5]

		if var1_5.code == arg1_5 then
			var0_5 = var1_5
		end
	end

	if not var0_5 then
		var0_5 = {
			status = false,
			code = arg1_5
		}

		table.insert(arg0_5._inPutKeyDic, var0_5)
	end

	return var0_5
end

function var0_0.getKeyCode(arg0_6, arg1_6)
	if not arg1_6 then
		return nil
	end

	local var0_6

	for iter0_6 = 1, #arg0_6._inPutKeyDic do
		local var1_6 = arg0_6._inPutKeyDic[iter0_6]

		if var1_6.code == arg1_6 then
			var0_6 = var1_6
		end
	end

	if not var0_6 then
		var0_6 = {
			status = false,
			code = arg1_6
		}

		table.insert(arg0_6._inPutKeyDic, var0_6)
	end

	return var0_6.status
end

return var0_0
