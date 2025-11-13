pg = pg or {}
pg.EasyRedDotMgr = singletonClass("EasyRedDotMgr")

local var0_0 = pg.EasyRedDotMgr

function var0_0.Init(arg0_1, arg1_1)
	arg0_1.registerDic = {}
	arg0_1.markDic = {}

	if arg1_1 then
		arg1_1()
	end
end

function var0_0.RegisterRedDot(arg0_2, arg1_2, arg2_2, arg3_2)
	if arg0_2.registerDic[arg1_2] then
		arg0_2:UnRegisterRedDot(arg1_2)
	end

	arg0_2.registerDic[arg1_2] = {
		arg2_2,
		arg3_2
	}

	for iter0_2, iter1_2 in ipairs(arg2_2) do
		arg0_2.markDic[iter1_2] = arg0_2.markDic[iter1_2] or {}
		arg0_2.markDic[iter1_2][arg1_2] = true
	end

	arg3_2(arg1_2)
end

function var0_0.UnRegisterRedDot(arg0_3, arg1_3)
	if not arg0_3.registerDic[arg1_3] then
		return
	end

	local var0_3, var1_3 = unpack(arg0_3.registerDic[arg1_3])

	for iter0_3, iter1_3 in ipairs(var0_3) do
		arg0_3.markDic[iter1_3][arg1_3] = nil
	end

	arg0_3.registerDic[arg1_3] = nil
end

function var0_0.TriggerMarks(arg0_4, ...)
	local var0_4 = {}

	for iter0_4, iter1_4 in ipairs({
		...
	}) do
		for iter2_4, iter3_4 in pairs(arg0_4.markDic[iter1_4]) do
			if IsNil(iter2_4) then
				var0_4[iter2_4] = false
			elseif iter3_4 then
				var0_4[iter2_4] = true
			end
		end
	end

	for iter4_4, iter5_4 in pairs(var0_4) do
		if iter5_4 then
			arg0_4.registerDic[iter4_4][2](iter4_4)
		else
			warning(iter4_4)
			arg0_4:UnRegisterRedDot(iter4_4)
		end
	end
end
