local var0_0 = class("ProxyRegister")

var0_0.SecondCall = "sec"
var0_0.MinuteCall = "min"
var0_0.HourCall = "hour"
var0_0.DayCall = "day"

function var0_0.Ctor(arg0_1)
	arg0_1.data = {}
	arg0_1.callDic = {
		[var0_0.SecondCall] = {},
		[var0_0.MinuteCall] = {},
		[var0_0.HourCall] = {},
		[var0_0.DayCall] = {}
	}
	arg0_1.timer = CoTimer.New(function()
		arg0_1:Dispatcher()
	end, 1, -1)
end

function var0_0.AddProxy(arg0_3, arg1_3, arg2_3, ...)
	if not arg2_3 then
		return
	end

	local var0_3 = arg1_3.New(...)

	table.insert(arg0_3.data, var0_3)

	for iter0_3, iter1_3 in pairs(var0_3:timeCall()) do
		table.insert(arg0_3.callDic[iter0_3], iter1_3)
	end
end

function var0_0.RgisterProxy(arg0_4, arg1_4, arg2_4)
	for iter0_4, iter1_4 in ipairs(arg2_4) do
		arg0_4:AddProxy(unpack(iter1_4))
	end

	for iter2_4, iter3_4 in ipairs(arg0_4.data) do
		arg1_4:registerProxy(iter3_4)
	end
end

function var0_0.RemoveProxy(arg0_5, arg1_5)
	for iter0_5, iter1_5 in ipairs(arg0_5.data) do
		arg1_5:removeProxy(iter1_5.__cname)
	end
end

function var0_0.Start(arg0_6)
	arg0_6.dateMark = pg.TimeMgr.GetInstance():CurrentSTimeDesc("*t", true)

	arg0_6.timer:Start()
end

function var0_0.Stop(arg0_7)
	arg0_7.timer:Stop()
end

function var0_0.Dispatcher(arg0_8)
	local var0_8 = {}
	local var1_8 = pg.TimeMgr.GetInstance():CurrentSTimeDesc("*t", true)

	for iter0_8, iter1_8 in ipairs({
		var0_0.SecondCall,
		var0_0.MinuteCall,
		var0_0.HourCall,
		var0_0.DayCall
	}) do
		if iter1_8 == var0_0.DayCall then
			if arg0_8.dateMark[iter1_8] ~= var1_8[iter1_8] then
				if arg0_8.dayProto or arg0_8.dayCount and arg0_8.dayCount <= 0 then
					var0_8[iter1_8] = var1_8[iter1_8]
					arg0_8.dateMark[iter1_8] = var1_8[iter1_8]
				elseif arg0_8.dayCount then
					arg0_8.dayCount = arg0_8.dayCount - 1
				else
					arg0_8.dayCount = 30
				end
			else
				arg0_8.dayProto = nil
				arg0_8.dayCount = nil
			end
		elseif arg0_8.dateMark[iter1_8] ~= var1_8[iter1_8] then
			var0_8[iter1_8] = var1_8[iter1_8]
			arg0_8.dateMark[iter1_8] = var1_8[iter1_8]
		end
	end

	for iter2_8, iter3_8 in pairs(var0_8) do
		for iter4_8, iter5_8 in ipairs(arg0_8.callDic[iter2_8]) do
			iter5_8(iter3_8, var1_8)
		end
	end
end

return var0_0
