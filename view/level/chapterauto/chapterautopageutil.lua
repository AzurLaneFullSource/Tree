local var0_0 = class("ChapterAutoPageUtil", import("Support.Utils.PageUtil"))

function var0_0.Ctor(arg0_1, ...)
	var0_0.super.Ctor(arg0_1, ...)
	pressPersistTrigger(arg0_1._leftBtn, 0.5, function()
		local var0_2 = arg0_1._curNum - arg0_1._addNum

		var0_2 = var0_2 < 0 and arg0_1._curNum or var0_2

		arg0_1:setCurNum(var0_2)
	end, nil, true, true, 0.1, SFX_PANEL)
	pressPersistTrigger(arg0_1._rightBtn, 0.5, function()
		local var0_3 = arg0_1._curNum + arg0_1._addNum

		for iter0_3, iter1_3 in ipairs(arg0_1._tipCntList) do
			if iter1_3 < var0_3 then
				pg.TipsMgr.GetInstance():ShowTips(arg0_1._tipList[iter0_3])

				break
			end
		end

		if arg0_1._maxNum < 0 then
			arg0_1:setCurNum(var0_3)
		else
			var0_3 = var0_3 > arg0_1._maxNum and arg0_1._maxNum or var0_3

			arg0_1:setCurNum(var0_3)
		end
	end, nil, true, true, 0.1, SFX_PANEL)
	onInputEndEdit(arg0_1, arg0_1._numTxt, function(arg0_4)
		local var0_4 = arg0_1._curNum

		if not arg0_4 or arg0_4 == "" or not tonumber(arg0_4) then
			local var1_4 = arg0_1._curNum
		end

		local var2_4 = tonumber(arg0_4)
		local var3_4 = math.clamp(var2_4, 0, arg0_1._maxNum)

		arg0_1:setCurNum(var3_4)
	end)
end

function var0_0.SetTipInfo(arg0_5, arg1_5, arg2_5)
	arg0_5._tipCntList = arg1_5
	arg0_5._tipList = arg2_5
end

function var0_0.setMaxNum(arg0_6, arg1_6)
	arg0_6._maxNum = arg1_6

	setActive(arg0_6._maxBtn, true)
end

function var0_0.setCurNum(arg0_7, arg1_7)
	arg0_7._curNum = arg1_7

	setInputText(arg0_7._numTxt, arg0_7._curNum)

	if arg0_7._numUpdate ~= nil then
		arg0_7._numUpdate(arg0_7._curNum)
	end
end

return var0_0
