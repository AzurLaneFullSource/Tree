local var0_0 = class("IslandShipOrderCard")
local var1_0 = Color.New(0.223529411764706, 0.745098039215686, 1, 1)
local var2_0 = Color.New(0.827450980392157, 0.827450980392157, 0.827450980392157, 1)
local var3_0 = Color.New(0.858823529411765, 0.858823529411765, 0.858823529411765, 1)
local var4_0 = Color.New(1, 0.682352941176471, 0.133333333333333, 1)
local var5_0 = Color.New(1, 1, 1, 1)

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._tf = arg1_1
	arg0_1.bgTr = arg1_1:Find("bg")
	arg0_1.bgImg = arg1_1:Find("bg"):GetComponent(typeof(Image))
	arg0_1.request = arg1_1:Find("request")
	arg0_1.requestCG = GetOrAddComponent(arg0_1.request, typeof(CanvasGroup))
	arg0_1.uiRequestList = UIItemList.New(arg1_1:Find("request"), arg1_1:Find("request/tpl"))
	arg0_1.titleTr = arg1_1:Find("title")
	arg0_1.titleLineImg = arg1_1:Find("title/line"):GetComponent(typeof(Image))
	arg0_1.titleTxt = arg1_1:Find("title/Text"):GetComponent(typeof(Text))
	arg0_1.loadingTr = arg1_1:Find("state_loading")
	arg0_1.loadingRequest = arg1_1:Find("loading_request")
	arg0_1.loadingAward = arg1_1:Find("loading_award")
	arg0_1.finishTr = arg1_1:Find("state_finish")
	arg0_1.award = arg1_1:Find("award")
	arg0_1.uiAwardList = UIItemList.New(arg1_1:Find("award"), arg1_1:Find("award/tpl"))
	arg0_1.lockTr = arg1_1:Find("state_lock")
	arg0_1.normalTr = arg1_1:Find("normal_award")
	arg0_1.levelLockTr = arg1_1:Find("state_lock/level")
	arg0_1.levelLockTxt = arg0_1.levelLockTr:Find("Text"):GetComponent(typeof(Text))
	arg0_1.resLockTr = arg1_1:Find("state_lock/gold")
	arg0_1.resLockTxt = arg0_1.resLockTr:Find("content/Text"):GetComponent(typeof(Text))
	arg0_1.timeTxt = arg1_1:Find("loading_request/time/content/Text"):GetComponent(typeof(Text))
	arg0_1.getBtn = arg1_1:Find("state_finish/get")
	arg0_1.signTr = arg1_1:Find("sign")
	arg0_1.resImg = arg1_1:Find("state_lock/gold/content/icon")

	setText(arg1_1:Find("loading_award/state/Text"), i18n1("运输中"))
	setText(arg1_1:Find("normal_award/state/Text"), i18n1("等待运输"))
	setText(arg0_1.getBtn:Find("Text"), i18n1("领取奖励"))
end

function var0_0.Flush(arg0_2, arg1_2, arg2_2, arg3_2)
	arg0_2.slot = arg1_2

	arg0_2:SwitchMode(arg1_2, arg2_2)
	arg0_2:UpdateRequest(arg1_2)
	arg0_2:UpdateAward(arg1_2)
	arg0_2:UpdateLockTip(arg1_2)
	arg0_2:UpdateTitle(arg1_2)
	arg0_2:UpdateTimer(arg1_2)
end

function var0_0.PlaySignAnim(arg0_3, arg1_3)
	arg0_3:RemoveSignTimer()
	setActive(arg0_3.signTr, true)

	arg0_3.signTimer = Timer.New(function()
		arg0_3:RemoveSignTimer()
		setActive(arg0_3.signTr, false)
		arg1_3()
	end, 2, 1)

	arg0_3.signTimer:Start()
end

function var0_0.RemoveSignTimer(arg0_5)
	if arg0_5.signTimer then
		arg0_5.signTimer:Stop()

		arg0_5.signTimer = nil
	end
end

function var0_0.SwitchMode(arg0_6, arg1_6, arg2_6)
	arg0_6.mode = arg2_6

	arg0_6:UpdateStyle(arg1_6, arg2_6)
end

function var0_0.UpdateTimer(arg0_7, arg1_7)
	arg0_7:RemoveTimer()

	if arg1_7:IsSubmited() and not arg1_7:IsFinished() then
		arg0_7:AddTimer(arg1_7)
	end
end

function var0_0.RemoveTimer(arg0_8)
	if arg0_8.timer then
		arg0_8.timer:Stop()

		arg0_8.timer = nil
	end
end

function var0_0.AddTimer(arg0_9, arg1_9)
	local var0_9 = arg1_9:GetEndTime()

	arg0_9.timer = Timer.New(function(arg0_10, arg1_10, arg2_10)
		local var0_10 = pg.TimeMgr.GetInstance():GetServerTime()
		local var1_10 = var0_9 - var0_10

		arg0_9.timeTxt.text = pg.TimeMgr.GetInstance():DescCDTime(var1_10)

		if var1_10 <= 0 then
			arg0_9:RemoveTimer()
			arg0_9:Flush(arg1_9, arg0_9.mode)
		end
	end, 1, -1)

	arg0_9.timer.func()
	arg0_9.timer:Start()
end

function var0_0.UpdateTitle(arg0_11, arg1_11)
	if arg1_11:IsWaiting() then
		local var0_11 = arg1_11:GetNeedTime()

		arg0_11.titleTxt.text = i18n1("运输时间     " .. pg.TimeMgr.GetInstance():DescCDTime(var0_11))
	elseif arg1_11:IsSubmited() and not arg1_11:IsFinished() then
		arg0_11.titleTxt.text = i18n1("运输中...")
	elseif arg1_11:IsFinished() then
		arg0_11.titleTxt.text = i18n1("已完成...")
	end
end

function var0_0.UpdateLockTip(arg0_12, arg1_12)
	local var0_12 = arg1_12:GetUnlockLevel()
	local var1_12 = arg1_12:GetUnlockGold()

	arg0_12.levelLockTxt.text = i18n1(string.format("下艘运输船舶将在%d级解锁", var0_12))
	arg0_12.resLockTxt.text = i18n1("X" .. var1_12.count .. "解锁")

	local var2_12 = pg.island_item_data_template[var1_12.id].icon

	GetImageSpriteFromAtlasAsync(var2_12, "", arg0_12.resImg)
end

function var0_0.UpdateAward(arg0_13, arg1_13)
	local var0_13 = arg1_13:GetOrder():GetAwardList()

	arg0_13.uiAwardList:make(function(arg0_14, arg1_14, arg2_14)
		if arg0_14 == UIItemList.EventUpdate then
			local var0_14 = var0_13[arg1_14 + 1]

			updateDrop(arg2_14, Drop.New(var0_14))
		end
	end)
	arg0_13.uiAwardList:align(#var0_13)
end

function var0_0.UpdateRequest(arg0_15, arg1_15)
	local var0_15 = arg1_15:GetOrder():GetConsumeList()

	arg0_15.uiRequestList:make(function(arg0_16, arg1_16, arg2_16)
		if arg0_16 == UIItemList.EventUpdate then
			local var0_16 = var0_15[arg1_16 + 1]
			local var1_16 = Drop.New(var0_16)
			local var2_16 = var1_16.icon or var1_16:getConfig("icon")

			GetImageSpriteFromAtlasAsync(var2_16, "", arg2_16:Find("icon"))

			local var3_16 = var1_16.state == 1

			setText(arg2_16:Find("cnt"), setColorStr("x" .. var1_16.count, (var1_16:getOwnedCount() >= var1_16.count or var3_16) and "#393a3c" or "#f36c6e"))
			setActive(arg2_16:Find("loaded"), var3_16)
			setActive(arg2_16:Find("loaded_1"), false)
		end
	end)
	arg0_15.uiRequestList:align(#var0_15)
end

function var0_0.UpdateStyle(arg0_17, arg1_17, arg2_17)
	local var0_17 = arg1_17:IsLock()
	local var1_17 = arg1_17:IsWaiting()
	local var2_17 = arg1_17:IsFinished()
	local var3_17 = arg1_17:IsSubmited() and not var2_17
	local var4_17 = arg1_17:CanUnlock()
	local var5_17 = arg2_17 == IslandShipOrderPage.MODE_REQUEST_VIEW
	local var6_17 = arg2_17 == IslandShipOrderPage.MODE_AWARD_VIEW

	setActive(arg0_17.loadingTr, var3_17)
	setActive(arg0_17.loadingRequest, var3_17 and var5_17)
	setActive(arg0_17.loadingAward, var3_17 and var6_17)
	setActive(arg0_17.finishTr, var2_17)
	setActive(arg0_17.request, not var0_17 and var5_17 and not var2_17)
	setActive(arg0_17.award, not var0_17 and var6_17 or var2_17)
	setActive(arg0_17.lockTr, var0_17)
	setActive(arg0_17.normalTr, var1_17 and var6_17)
	setActive(arg0_17.levelLockTr, var0_17 and not var4_17)
	setActive(arg0_17.resLockTr, var0_17 and var4_17)
	setActive(arg0_17.titleTr, not var0_17)

	arg0_17.requestCG.alpha = var3_17 and 0.6 or 1
	arg0_17.titleTr.sizeDelta = var1_17 and Vector2(280, 39) or Vector2(155, 39)

	arg0_17:UpdateBgColor(arg1_17)
	arg0_17:UpdateTitleColor(arg1_17)
end

function var0_0.UpdateBgColor(arg0_18, arg1_18)
	if arg1_18:IsSubmited() and not arg1_18:IsFinished() then
		setActive(arg0_18.bgTr, false)

		return
	end

	setActive(arg0_18.bgTr, true)

	arg0_18.bgImg.color = arg1_18:IsFinished() and var1_0 or var3_0
end

function var0_0.UpdateTitleColor(arg0_19, arg1_19)
	if arg1_19:IsFinished() then
		arg0_19.titleLineImg.color = var1_0
	elseif arg1_19:IsSubmited() and not arg1_19:IsFinished() then
		arg0_19.titleLineImg.color = var4_0
	elseif arg1_19:IsWaiting() then
		arg0_19.titleLineImg.color = var2_0
	end

	arg0_19.titleTxt.color = arg1_19:IsWaiting() and var2_0 or var5_0
end

function var0_0.Dispose(arg0_20)
	arg0_20:RemoveTimer()
	arg0_20:RemoveSignTimer()
end

return var0_0
