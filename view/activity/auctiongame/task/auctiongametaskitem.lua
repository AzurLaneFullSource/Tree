local var0_0 = class("AuctionGameTaskItem", import("view.base.BasePanel"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject

	var0_0.super.Ctor(arg0_1, arg0_1._go)

	arg0_1._parentClass = arg2_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	onButton(arg0_2, arg0_2.uiGoBtn, function()
		local var0_3 = arg0_2.taskVO:getConfig("scene")

		if var0_3 and #var0_3 > 0 and var0_3[2] and var0_3[2].unlockActivityID and var0_3[1] == "AUCTION_GAME_ENTRANCE" and getProxy(ContextProxy):getContextByMediator(AuctionGameEntranceMediator) then
			arg0_2:emit(BaseUI.ON_CLOSE)

			return
		end

		arg0_2:emit(AuctionGameTaskMediator.ON_TASK_GO, arg0_2.taskVO)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiGetBtn, function()
		arg0_2:emit(AuctionGameTaskMediator.ON_TASK_SUBMIT, arg0_2.taskVO)
	end, SFX_PANEL)

	arg0_2.rewardList = UIItemList.New(arg0_2.uiRewardList, arg0_2.uiRewardItem)

	arg0_2.rewardList:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventUpdate then
			local var0_5 = arg1_5 + 1
			local var1_5 = arg0_2.taskVO:getConfig("award_display")
			local var2_5 = Drop.Create(var1_5[var0_5])

			updateDrop(arg2_5, var2_5)
			onButton(arg0_2, arg2_5, function()
				arg0_2:emit(BaseUI.ON_DROP, var2_5)
			end, SFX_PANEL)
		end
	end)
end

function var0_0.didEnter(arg0_7)
	return
end

function var0_0.willExit(arg0_8)
	arg0_8:detach()
end

function var0_0.SetData(arg0_9, arg1_9)
	arg0_9.taskVO = arg1_9

	setText(arg0_9.uiDescText, arg1_9:getConfig("desc"))

	local var0_9 = arg1_9:getConfig("target_num")
	local var1_9 = arg1_9:getProgress()

	if arg1_9:getConfig("sub_type") == TASK_SUB_TYPE_REPEATABLE then
		var0_9 = 1
	end

	if var0_9 < var1_9 then
		var1_9 = var0_9
	end

	setText(arg0_9.uiProgressText, string.format("%s/%s", var1_9, var0_9))

	arg0_9.uiSlider.value = var1_9 / var0_9

	if arg1_9:isReceive() then
		setActive(arg0_9.uiGoBtn, false)
		setActive(arg0_9.uiGetBtn, false)
		setActive(arg0_9.uiGotBtn, true)
	else
		setActive(arg0_9.uiGotBtn, false)

		if arg1_9:isFinish() then
			setActive(arg0_9.uiGoBtn, false)
			setActive(arg0_9.uiGetBtn, true)
		else
			setActive(arg0_9.uiGoBtn, true)
			setActive(arg0_9.uiGetBtn, false)
		end
	end

	local var2_9 = arg1_9:getConfig("award_display")

	arg0_9.rewardList:align(#var2_9)

	local var3_9 = arg1_9:getConfig("type") == Task.TYPE_REPEATABLE

	setActive(arg0_9.uiRepeatableGo, var3_9)
end

return var0_0
