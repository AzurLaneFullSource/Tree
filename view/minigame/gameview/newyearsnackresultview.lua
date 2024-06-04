local var0 = class("NewYearSnackResultView", import(".SnackResultView"))

function var0.getUIName(arg0)
	return "NewYearSnackResult"
end

function var0.updateView(arg0)
	local var0 = arg0:calculateEXValue()

	if arg0.contextData.countTime > 0 then
		setText(arg0.timeText, arg0.contextData.countTime .. "s   + " .. setColorStr(var0 .. "s", "#3068E6FF"))
	else
		setText(arg0.timeText, arg0.contextData.countTime .. "s")
	end

	setText(arg0.scoreText, arg0.contextData.score .. "   + " .. setColorStr(var0, "#3068E6FF"))
	arg0.orderList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0.contextData.orderIDList[arg1 + 1]
			local var1 = arg0:findTF("SnackImg", arg2)

			setImageSprite(var1, GetSpriteFromAtlas("ui/minigameui/newyearsnackui_atlas", "snack_" .. var0))
		end
	end)
	arg0.orderList:align(#arg0.contextData.orderIDList)
	arg0.selectedList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0.contextData.selectedIDList[arg1 + 1]
			local var1 = arg0:findTF("SnackImg", arg2)

			setImageSprite(var1, GetSpriteFromAtlas("ui/minigameui/newyearsnackui_atlas", "snack_" .. var0))

			local var2 = arg0.contextData.orderIDList[arg1 + 1]
			local var3 = arg0:findTF("ErrorImg", arg2)
			local var4 = arg0:findTF("CorrectImg", arg2)

			setActive(var4, var0 == var2)
			setActive(var3, var0 ~= var2)
		end
	end)
	arg0.selectedList:align(#arg0.contextData.selectedIDList)

	if arg0.contextData.countTime == 0 then
		setActive(arg0.continueBtn, false)
	end

	arg0.contextData.countTime = arg0.contextData.countTime + var0
	arg0.contextData.score = arg0.contextData.score + var0
end

return var0
