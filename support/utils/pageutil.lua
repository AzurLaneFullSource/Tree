local var0_0 = class("PageUtil")

PageUtil = var0_0

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1._leftBtn = arg1_1
	arg0_1._rightBtn = arg2_1
	arg0_1._maxBtn = arg3_1
	arg0_1._numTxt = arg4_1

	pressPersistTrigger(arg0_1._leftBtn, 0.5, function()
		local var0_2 = arg0_1._curNum - arg0_1._addNum

		var0_2 = var0_2 <= 0 and arg0_1._curNum or var0_2

		arg0_1:setCurNum(var0_2)
	end, nil, true, true, 0.1, SFX_PANEL)
	pressPersistTrigger(arg0_1._rightBtn, 0.5, function()
		local var0_3 = arg0_1._curNum + arg0_1._addNum

		if arg0_1._maxNum < 0 then
			arg0_1:setCurNum(var0_3)
		else
			var0_3 = var0_3 > arg0_1._maxNum and arg0_1._maxNum or var0_3

			arg0_1:setCurNum(var0_3)
		end
	end, nil, true, true, 0.1, SFX_PANEL)
	onButton(arg0_1, arg0_1._maxBtn, function()
		if arg0_1._maxNum < 0 then
			-- block empty
		else
			arg0_1:setCurNum(arg0_1._maxNum)
		end
	end)
	arg0_1:setAddNum(1)
	arg0_1:setDefaultNum(1)
	arg0_1:setMaxNum(-1)
end

function var0_0.setAddNum(arg0_5, arg1_5)
	arg0_5._addNum = arg1_5
end

function var0_0.setDefaultNum(arg0_6, arg1_6)
	arg0_6._defaultNum = arg1_6

	arg0_6:setCurNum(arg0_6._defaultNum)
end

function var0_0.setMaxNum(arg0_7, arg1_7)
	arg0_7._maxNum = arg1_7

	setActive(arg0_7._maxBtn, arg0_7._maxNum > 0)
end

function var0_0.setCurNum(arg0_8, arg1_8)
	arg0_8._curNum = arg1_8

	setText(arg0_8._numTxt, arg0_8._curNum)

	if arg0_8._numUpdate ~= nil then
		arg0_8._numUpdate(arg0_8._curNum)
	end
end

function var0_0.setNumUpdate(arg0_9, arg1_9)
	arg0_9._numUpdate = arg1_9
end

function var0_0.getCurNum(arg0_10)
	return arg0_10._curNum
end

function var0_0.Dispose(arg0_11)
	pg.DelegateInfo.Dispose(arg0_11)
end

return var0_0
