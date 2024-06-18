local var0_0 = class("SnackResultView", import("...base.BaseSubView"))

var0_0.EXTable = {
	[0] = 0,
	1,
	2,
	5
}

function var0_0.getUIName(arg0_1)
	return "SnackResult"
end

function var0_0.OnInit(arg0_2)
	arg0_2:initUI()
	arg0_2:updateView()
	arg0_2:Show()
	pg.UIMgr.GetInstance():BlurPanel(arg0_2._tf)
end

function var0_0.OnDestroy(arg0_3)
	arg0_3.lockBackPress = false

	pg.UIMgr.GetInstance():UnblurPanel(arg0_3._tf)
end

function var0_0.initUI(arg0_4)
	local var0_4 = arg0_4:findTF("Content")

	arg0_4.timeText = arg0_4:findTF("Tip/Time/TimeText", var0_4)
	arg0_4.scoreText = arg0_4:findTF("Tip/Score/ScoreText", var0_4)
	arg0_4.snackTpl = arg0_4:findTF("SnackTpl", var0_4)
	arg0_4.orderListContainer = arg0_4:findTF("Order/OrderList", var0_4)
	arg0_4.orderList = UIItemList.New(arg0_4.orderListContainer, arg0_4.snackTpl)
	arg0_4.selectedListContainer = arg0_4:findTF("Select/SelectList", var0_4)
	arg0_4.selectedList = UIItemList.New(arg0_4.selectedListContainer, arg0_4.snackTpl)
	arg0_4.submitBtn = arg0_4:findTF("Buttons/SubmitBtn", var0_4)
	arg0_4.continueBtn = arg0_4:findTF("Buttons/ContinueBtn", var0_4)

	onButton(arg0_4, arg0_4.submitBtn, function()
		local var0_5 = arg0_4:calculateLevel()

		arg0_4.contextData.onSubmit(var0_5)
		arg0_4:Destroy()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.continueBtn, function()
		arg0_4.contextData.onContinue()
		arg0_4:Destroy()
	end)
end

function var0_0.updateView(arg0_7)
	local var0_7 = arg0_7:calculateEXValue()

	if arg0_7.contextData.countTime > 0 then
		setText(arg0_7.timeText, arg0_7.contextData.countTime .. "s   + " .. setColorStr(var0_7 .. "s", "#3068E6FF"))
	else
		setText(arg0_7.timeText, arg0_7.contextData.countTime .. "s")
	end

	setText(arg0_7.scoreText, arg0_7.contextData.score .. "   + " .. setColorStr(var0_7, "#3068E6FF"))
	arg0_7.orderList:make(function(arg0_8, arg1_8, arg2_8)
		if arg0_8 == UIItemList.EventUpdate then
			local var0_8 = arg0_7.contextData.orderIDList[arg1_8 + 1]
			local var1_8 = arg0_7:findTF("SnackImg", arg2_8)

			setImageSprite(var1_8, GetSpriteFromAtlas("ui/snackui_atlas", "snack_" .. var0_8))
		end
	end)
	arg0_7.orderList:align(#arg0_7.contextData.orderIDList)
	arg0_7.selectedList:make(function(arg0_9, arg1_9, arg2_9)
		if arg0_9 == UIItemList.EventUpdate then
			local var0_9 = arg0_7.contextData.selectedIDList[arg1_9 + 1]
			local var1_9 = arg0_7:findTF("SnackImg", arg2_9)

			setImageSprite(var1_9, GetSpriteFromAtlas("ui/snackui_atlas", "snack_" .. var0_9))

			local var2_9 = arg0_7.contextData.orderIDList[arg1_9 + 1]
			local var3_9 = arg0_7:findTF("ErrorImg", arg2_9)
			local var4_9 = arg0_7:findTF("CorrectImg", arg2_9)

			setActive(var4_9, var0_9 == var2_9)
			setActive(var3_9, var0_9 ~= var2_9)
		end
	end)
	arg0_7.selectedList:align(#arg0_7.contextData.selectedIDList)

	if arg0_7.contextData.countTime == 0 then
		setActive(arg0_7.continueBtn, false)
	end

	arg0_7.contextData.countTime = arg0_7.contextData.countTime + var0_7
	arg0_7.contextData.score = arg0_7.contextData.score + var0_7
end

function var0_0.calculateEXValue(arg0_10)
	local var0_10 = 0

	for iter0_10, iter1_10 in ipairs(arg0_10.contextData.selectedIDList) do
		if arg0_10.contextData.orderIDList[iter0_10] == iter1_10 then
			var0_10 = var0_10 + 1
		end
	end

	return arg0_10.contextData.correctNumToEXValue[var0_10]
end

function var0_0.calculateLevel(arg0_11)
	if arg0_11.contextData.score >= arg0_11.contextData.scoreLevel[4] then
		return 1
	elseif arg0_11.contextData.score >= arg0_11.contextData.scoreLevel[3] then
		return 2
	elseif arg0_11.contextData.score >= arg0_11.contextData.scoreLevel[2] then
		return 3
	elseif arg0_11.contextData.score >= arg0_11.contextData.scoreLevel[1] then
		return 4
	end
end

return var0_0
