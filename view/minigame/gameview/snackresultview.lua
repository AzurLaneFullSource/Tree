local var0 = class("SnackResultView", import("...base.BaseSubView"))

var0.EXTable = {
	[0] = 0,
	1,
	2,
	5
}

function var0.getUIName(arg0)
	return "SnackResult"
end

function var0.OnInit(arg0)
	arg0:initUI()
	arg0:updateView()
	arg0:Show()
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
end

function var0.OnDestroy(arg0)
	arg0.lockBackPress = false

	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

function var0.initUI(arg0)
	local var0 = arg0:findTF("Content")

	arg0.timeText = arg0:findTF("Tip/Time/TimeText", var0)
	arg0.scoreText = arg0:findTF("Tip/Score/ScoreText", var0)
	arg0.snackTpl = arg0:findTF("SnackTpl", var0)
	arg0.orderListContainer = arg0:findTF("Order/OrderList", var0)
	arg0.orderList = UIItemList.New(arg0.orderListContainer, arg0.snackTpl)
	arg0.selectedListContainer = arg0:findTF("Select/SelectList", var0)
	arg0.selectedList = UIItemList.New(arg0.selectedListContainer, arg0.snackTpl)
	arg0.submitBtn = arg0:findTF("Buttons/SubmitBtn", var0)
	arg0.continueBtn = arg0:findTF("Buttons/ContinueBtn", var0)

	onButton(arg0, arg0.submitBtn, function()
		local var0 = arg0:calculateLevel()

		arg0.contextData.onSubmit(var0)
		arg0:Destroy()
	end, SFX_PANEL)
	onButton(arg0, arg0.continueBtn, function()
		arg0.contextData.onContinue()
		arg0:Destroy()
	end)
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

			setImageSprite(var1, GetSpriteFromAtlas("ui/snackui_atlas", "snack_" .. var0))
		end
	end)
	arg0.orderList:align(#arg0.contextData.orderIDList)
	arg0.selectedList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0.contextData.selectedIDList[arg1 + 1]
			local var1 = arg0:findTF("SnackImg", arg2)

			setImageSprite(var1, GetSpriteFromAtlas("ui/snackui_atlas", "snack_" .. var0))

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

function var0.calculateEXValue(arg0)
	local var0 = 0

	for iter0, iter1 in ipairs(arg0.contextData.selectedIDList) do
		if arg0.contextData.orderIDList[iter0] == iter1 then
			var0 = var0 + 1
		end
	end

	return arg0.contextData.correctNumToEXValue[var0]
end

function var0.calculateLevel(arg0)
	if arg0.contextData.score >= arg0.contextData.scoreLevel[4] then
		return 1
	elseif arg0.contextData.score >= arg0.contextData.scoreLevel[3] then
		return 2
	elseif arg0.contextData.score >= arg0.contextData.scoreLevel[2] then
		return 3
	elseif arg0.contextData.score >= arg0.contextData.scoreLevel[1] then
		return 4
	end
end

return var0
