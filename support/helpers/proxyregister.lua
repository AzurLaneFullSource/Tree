local var0_0 = class("ProxyRegister")

var0_0.SecondCall = "sec"
var0_0.MinuteCall = "min"
var0_0.HourCall = "hour"
var0_0.DayCall = "day"

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.data = {}
	arg0_1.callDic = {
		[var0_0.SecondCall] = {},
		[var0_0.MinuteCall] = {},
		[var0_0.HourCall] = {},
		[var0_0.DayCall] = {}
	}
	arg0_1.dateMark = pg.TimeMgr.GetInstance():CurrentSTimeDesc("*t", true)

	for iter0_1, iter1_1 in ipairs(arg1_1) do
		arg0_1:AddProxy(unpack(iter1_1))
	end

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

function var0_0.RgisterProxy(arg0_4, arg1_4)
	for iter0_4, iter1_4 in ipairs(arg0_4.data) do
		arg1_4:registerProxy(iter1_4)
	end

	arg0_4.timer:Start()
end

function var0_0.RemoveProxy(arg0_5, arg1_5)
	for iter0_5, iter1_5 in ipairs(arg0_5.data) do
		arg1_5:removeProxy(iter1_5.__cname)
	end

	arg0_5.timer:Stop()
end

function var0_0.Dispatcher(arg0_6)
	local var0_6 = {}
	local var1_6 = pg.TimeMgr.GetInstance():CurrentSTimeDesc("*t", true)

	for iter0_6, iter1_6 in ipairs({
		var0_0.SecondCall,
		var0_0.MinuteCall,
		var0_0.HourCall,
		var0_0.DayCall
	}) do
		if iter1_6 == var0_0.DayCall then
			if arg0_6.dateMark[iter1_6] ~= var1_6[iter1_6] then
				if arg0_6.dayProto or arg0_6.dayCount and arg0_6.dayCount <= 0 then
					var0_6[iter1_6] = var1_6[iter1_6]
					arg0_6.dateMark[iter1_6] = var1_6[iter1_6]
				elseif arg0_6.dayCount then
					arg0_6.dayCount = arg0_6.dayCount - 1
				else
					arg0_6.dayCount = 30
				end
			else
				arg0_6.dayProto = nil
				arg0_6.dayCount = nil
			end
		elseif arg0_6.dateMark[iter1_6] ~= var1_6[iter1_6] then
			var0_6[iter1_6] = var1_6[iter1_6]
			arg0_6.dateMark[iter1_6] = var1_6[iter1_6]
		end
	end

	for iter2_6, iter3_6 in pairs(var0_6) do
		for iter4_6, iter5_6 in ipairs(arg0_6.callDic[iter2_6]) do
			iter5_6(iter3_6)
		end
	end
end

return var0_0
