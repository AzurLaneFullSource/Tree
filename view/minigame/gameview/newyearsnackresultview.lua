local var0_0 = class("NewYearSnackResultView", import(".SnackResultView"))

function var0_0.getUIName(arg0_1)
	return "NewYearSnackResult"
end

function var0_0.updateView(arg0_2)
	local var0_2 = arg0_2:calculateEXValue()

	if arg0_2.contextData.countTime > 0 then
		setText(arg0_2.timeText, arg0_2.contextData.countTime .. "s   + " .. setColorStr(var0_2 .. "s", "#3068E6FF"))
	else
		setText(arg0_2.timeText, arg0_2.contextData.countTime .. "s")
	end

	setText(arg0_2.scoreText, arg0_2.contextData.score .. "   + " .. setColorStr(var0_2, "#3068E6FF"))
	arg0_2.orderList:make(function(arg0_3, arg1_3, arg2_3)
		if arg0_3 == UIItemList.EventUpdate then
			local var0_3 = arg0_2.contextData.orderIDList[arg1_3 + 1]
			local var1_3 = arg0_2:findTF("SnackImg", arg2_3)

			setImageSprite(var1_3, GetSpriteFromAtlas("ui/minigameui/newyearsnackui_atlas", "snack_" .. var0_3))
		end
	end)
	arg0_2.orderList:align(#arg0_2.contextData.orderIDList)
	arg0_2.selectedList:make(function(arg0_4, arg1_4, arg2_4)
		if arg0_4 == UIItemList.EventUpdate then
			local var0_4 = arg0_2.contextData.selectedIDList[arg1_4 + 1]
			local var1_4 = arg0_2:findTF("SnackImg", arg2_4)

			setImageSprite(var1_4, GetSpriteFromAtlas("ui/minigameui/newyearsnackui_atlas", "snack_" .. var0_4))

			local var2_4 = arg0_2.contextData.orderIDList[arg1_4 + 1]
			local var3_4 = arg0_2:findTF("ErrorImg", arg2_4)
			local var4_4 = arg0_2:findTF("CorrectImg", arg2_4)

			setActive(var4_4, var0_4 == var2_4)
			setActive(var3_4, var0_4 ~= var2_4)
		end
	end)
	arg0_2.selectedList:align(#arg0_2.contextData.selectedIDList)

	if arg0_2.contextData.countTime == 0 then
		setActive(arg0_2.continueBtn, false)
	end

	arg0_2.contextData.countTime = arg0_2.contextData.countTime + var0_2
	arg0_2.contextData.score = arg0_2.contextData.score + var0_2
end

return var0_0
