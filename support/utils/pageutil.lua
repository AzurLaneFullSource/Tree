local var0 = class("PageUtil")

PageUtil = var0

function var0.Ctor(arg0, arg1, arg2, arg3, arg4)
	pg.DelegateInfo.New(arg0)

	arg0._leftBtn = arg1
	arg0._rightBtn = arg2
	arg0._maxBtn = arg3
	arg0._numTxt = arg4

	pressPersistTrigger(arg0._leftBtn, 0.5, function()
		local var0 = arg0._curNum - arg0._addNum

		var0 = var0 <= 0 and arg0._curNum or var0

		arg0:setCurNum(var0)
	end, nil, true, true, 0.1, SFX_PANEL)
	pressPersistTrigger(arg0._rightBtn, 0.5, function()
		local var0 = arg0._curNum + arg0._addNum

		if arg0._maxNum < 0 then
			arg0:setCurNum(var0)
		else
			var0 = var0 > arg0._maxNum and arg0._maxNum or var0

			arg0:setCurNum(var0)
		end
	end, nil, true, true, 0.1, SFX_PANEL)
	onButton(arg0, arg0._maxBtn, function()
		if arg0._maxNum < 0 then
			-- block empty
		else
			arg0:setCurNum(arg0._maxNum)
		end
	end)
	arg0:setAddNum(1)
	arg0:setDefaultNum(1)
	arg0:setMaxNum(-1)
end

function var0.setAddNum(arg0, arg1)
	arg0._addNum = arg1
end

function var0.setDefaultNum(arg0, arg1)
	arg0._defaultNum = arg1

	arg0:setCurNum(arg0._defaultNum)
end

function var0.setMaxNum(arg0, arg1)
	arg0._maxNum = arg1

	setActive(arg0._maxBtn, arg0._maxNum > 0)
end

function var0.setCurNum(arg0, arg1)
	arg0._curNum = arg1

	setText(arg0._numTxt, arg0._curNum)

	if arg0._numUpdate ~= nil then
		arg0._numUpdate(arg0._curNum)
	end
end

function var0.setNumUpdate(arg0, arg1)
	arg0._numUpdate = arg1
end

function var0.getCurNum(arg0)
	return arg0._curNum
end

function var0.Dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)
end

return var0
