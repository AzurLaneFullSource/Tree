local var0_0 = class("DelayedDataProcesseor")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1.delayedDataDic = {}
	arg0_1.preTimeStampDic = {}
	arg0_1.delayedTime = arg1_1
	arg0_1.intervalTime = arg2_1
	arg0_1.func = arg3_1
end

function var0_0.Add(arg0_2, arg1_2, arg2_2)
	local var0_2

	if arg0_2.preTimeStampDic[arg1_2] then
		var0_2 = arg0_2.preTimeStampDic[arg1_2] + arg0_2.intervalTime
	else
		arg0_2.delayedDataDic[arg1_2] = {}
		var0_2 = pg.TimeMgr.GetInstance():GetServerTimeMs() + arg0_2.delayedTime
	end

	table.insert(arg0_2.delayedDataDic[arg1_2], {
		data = arg2_2,
		timeStamp = var0_2
	})

	arg0_2.preTimeStampDic[arg1_2] = var0_2
end

function var0_0.Update(arg0_3)
	local var0_3 = pg.TimeMgr.GetInstance():GetServerTimeMs()

	for iter0_3, iter1_3 in pairs(arg0_3.delayedDataDic) do
		if #iter1_3 > 0 and var0_3 >= iter1_3[1].timeStamp then
			arg0_3.func(iter1_3[1].data)
			table.remove(iter1_3, 1)
		end
	end
end

function var0_0.Dispose(arg0_4)
	return
end

return var0_0
