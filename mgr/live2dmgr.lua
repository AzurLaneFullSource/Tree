pg = pg or {}
pg.Live2DMgr = singletonClass("Live2DMgr")

local var0_0 = pg.Live2DMgr

function var0_0.Ctor(arg0_1)
	arg0_1.loadingDic = {}
	arg0_1.nameList = {}
end

function var0_0.GetLive2DModelAsync(arg0_2, arg1_2, arg2_2)
	table.insert(arg0_2.nameList, arg1_2)

	local var0_2 = #arg0_2.nameList

	arg0_2.loadingDic[arg1_2] = var0_2

	PoolMgr.GetInstance():GetLive2D(arg1_2, true, function(arg0_3)
		if arg0_2.loadingDic[arg1_2] ~= var0_2 then
			warning("l2d loaded dispose return  " .. arg1_2)
			PoolMgr.GetInstance():ReturnLive2D(arg1_2, arg0_3)
		end

		arg0_2.loadingDic[arg1_2] = nil

		existCall(arg2_2, arg0_3)
	end)
end

function var0_0.ReturnLive2DModel(arg0_4, arg1_4, arg2_4)
	PoolMgr.GetInstance():ReturnLive2D(arg1_4, arg2_4)
end

function var0_0.StopLoadingLive2d(arg0_5, arg1_5)
	local var0_5 = arg0_5.nameList[arg1_5]

	if arg0_5.loadingDic[var0_5] == arg1_5 then
		arg0_5.loadingDic[var0_5] = nil
	end
end
