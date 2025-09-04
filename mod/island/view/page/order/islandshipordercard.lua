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

	setText(arg1_1:Find("loading_award/state/Text"), i18n("island_order_get_label"))
	setText(arg1_1:Find("normal_award/state/Text"), i18n("island_order_get_label"))
	setText(arg0_1.getBtn:Find("Text"), i18n("island_order_get_label"))

	arg0_1.animator = arg1_1:GetComponent(typeof(Animation))
	arg0_1.aniDft = arg1_1:GetComponent(typeof(DftAniEvent))
end

function var0_0.Flush(arg0_2, arg1_2, arg2_2)
	arg0_2.slot = arg1_2

	arg0_2:FlushMain(arg1_2, arg2_2)
	arg0_2:UpdateTimer(arg1_2)
end

function var0_0.FlushMain(arg0_3, arg1_3, arg2_3)
	arg0_3:SwitchMode(arg1_3, arg2_3)
	arg0_3:UpdateRequest(arg1_3)
	arg0_3:UpdateAward(arg1_3)
	arg0_3:UpdateLockTip(arg1_3)
	arg0_3:UpdateTitle(arg1_3)
end

function var0_0.PlayAniamtion(arg0_4, arg1_4, arg2_4, arg3_4)
	local function var0_4()
		arg0_4.aniDft:SetEndEvent(function()
			arg0_4.aniDft:SetEndEvent(nil)

			if arg3_4 then
				arg3_4()
			end
		end)
	end

	if arg1_4 == IslandShipOrder.OP_TYPE_UNLOCK then
		var0_4()
		arg0_4.animator:Play("anim_island_shiporder_unlock")
	elseif arg1_4 == IslandShipOrder.OP_TYPE_LOADUP and arg2_4 then
		var0_4()
		arg0_4.animator:Play("anim_island_shiporder_intransit")
	elseif arg1_4 == IslandShipOrder.OP_TYPE_GET_AWARD then
		var0_4()
		arg0_4.animator:Play("anim_island_shiporder_next")
	else
		arg3_4()
	end
end

function var0_0.PlayFinishAnimation(arg0_7, arg1_7, arg2_7)
	if arg1_7 then
		local var0_7 = Clone(arg0_7.slot)

		var0_7.endTime = pg.TimeMgr.GetInstance():GetServerTime() + 10

		arg0_7:FlushMain(var0_7, arg0_7.mode)
	end

	arg0_7.aniDft:SetEndEvent(nil)
	arg0_7.aniDft:SetEndEvent(function()
		arg0_7.aniDft:SetEndEvent(nil)

		if arg1_7 then
			arg0_7:FlushMain(arg0_7.slot, arg0_7.mode)
		end

		if arg2_7 then
			arg2_7()
		end
	end)
	arg0_7.animator:Play("anim_island_shiporder_complete")
end

function var0_0.SwitchMode(arg0_9, arg1_9, arg2_9)
	arg0_9.mode = arg2_9

	arg0_9:UpdateStyle(arg1_9, arg2_9)
end

function var0_0.UpdateTimer(arg0_10, arg1_10)
	arg0_10:RemoveTimer()

	if arg1_10:IsSubmited() and not arg1_10:IsFinished() then
		arg0_10:AddTimer(arg1_10)
	elseif arg1_10:IsFinished() then
		arg0_10:PlayFinishAnimation(true)
	end
end

function var0_0.RemoveTimer(arg0_11)
	if arg0_11.timer then
		arg0_11.timer:Stop()

		arg0_11.timer = nil
	end
end

function var0_0.AddTimer(arg0_12, arg1_12)
	local var0_12 = arg1_12:GetEndTime()

	arg0_12.timer = Timer.New(function(arg0_13, arg1_13, arg2_13)
		local var0_13 = pg.TimeMgr.GetInstance():GetServerTime()
		local var1_13 = var0_12 - var0_13

		arg0_12.timeTxt.text = pg.TimeMgr.GetInstance():DescCDTime(var1_13)

		if var1_13 <= 0 then
			arg0_12:RemoveTimer()
			arg0_12:PlayFinishAnimation(function()
				arg0_12:Flush(arg1_12, arg0_12.mode)
			end)
		end
	end, 1, -1)

	arg0_12.timer.func()
	arg0_12.timer:Start()
end

function var0_0.UpdateTitle(arg0_15, arg1_15)
	if arg1_15:IsWaiting() then
		local var0_15 = arg1_15:GetNeedTime()

		arg0_15.titleTxt.text = i18n("island_order_ship_worktime", pg.TimeMgr.GetInstance():DescCDTime(var0_15))
	elseif arg1_15:IsSubmited() and not arg1_15:IsFinished() then
		arg0_15.titleTxt.text = i18n("island_order_ship_working")
	elseif arg1_15:IsFinished() then
		arg0_15.titleTxt.text = i18n("island_order_ship_end_work")
	end
end

function var0_0.UpdateLockTip(arg0_16, arg1_16)
	local var0_16 = arg1_16:GetUnlockLevel()
	local var1_16 = arg1_16:GetUnlockGold()

	arg0_16.levelLockTxt.text = i18n("island_order_ship_unlock_tip")
	arg0_16.resLockTxt.text = "X" .. var1_16.count .. i18n("island_order_ship_unlock_tip_2")

	local var2_16 = pg.island_item_data_template[var1_16.id].icon

	GetImageSpriteFromAtlasAsync("island/" .. var2_16, "", arg0_16.resImg)
end

function var0_0.UpdateAward(arg0_17, arg1_17)
	local var0_17 = arg1_17:GetOrder():GetAwardList()

	arg0_17.uiAwardList:make(function(arg0_18, arg1_18, arg2_18)
		if arg0_18 == UIItemList.EventUpdate then
			local var0_18 = var0_17[arg1_18 + 1]

			updateCustomDrop(arg2_18, Drop.New(var0_18))
		end
	end)
	arg0_17.uiAwardList:align(#var0_17)
end

function var0_0.UpdateRequest(arg0_19, arg1_19)
	local var0_19 = arg1_19:GetOrder():GetConsumeList()

	arg0_19.uiRequestList:make(function(arg0_20, arg1_20, arg2_20)
		if arg0_20 == UIItemList.EventUpdate then
			local var0_20 = var0_19[arg1_20 + 1]
			local var1_20 = Drop.New(var0_20)
			local var2_20 = var1_20.icon or var1_20:getConfig("icon")

			GetImageSpriteFromAtlasAsync("island/" .. var2_20, "", arg2_20:Find("icon"))

			local var3_20 = var1_20.state == 1
			local var4_20 = var1_20:getOwnedCount()

			setText(arg2_20:Find("cnt"), setColorStr(var4_20 .. "/" .. var1_20.count, (var4_20 >= var1_20.count or var3_20) and "#39beff" or "#f36c6e"))
			setActive(arg2_20:Find("finish"), var3_20)
			setActive(arg2_20:Find("loaded"), var3_20)
			setActive(arg2_20:Find("loaded_1"), false)
			setActive(arg2_20:Find("enough"), not var3_20 and var4_20 >= var1_20.count)
		end
	end)
	arg0_19.uiRequestList:align(#var0_19)
end

function var0_0.UpdateStyle(arg0_21, arg1_21, arg2_21)
	local var0_21 = arg1_21:IsLock()
	local var1_21 = arg1_21:IsWaiting()
	local var2_21 = arg1_21:IsFinished()
	local var3_21 = arg1_21:IsSubmited() and not var2_21
	local var4_21 = arg1_21:CanUnlock()
	local var5_21 = arg2_21 == IslandShipOrderPage.MODE_REQUEST_VIEW
	local var6_21 = arg2_21 == IslandShipOrderPage.MODE_AWARD_VIEW

	setActive(arg0_21.loadingTr, var3_21)
	setActive(arg0_21.loadingRequest, var3_21 and var5_21)
	setActive(arg0_21.loadingAward, var3_21 and var6_21)
	setActive(arg0_21.finishTr, var2_21)
	setActive(arg0_21.request, not var0_21 and var5_21 and not var2_21)
	setActive(arg0_21.award, not var0_21 and var6_21 or var2_21)
	setActive(arg0_21.lockTr, var0_21)
	setActive(arg0_21.normalTr, var1_21 and var6_21)
	setActive(arg0_21.levelLockTr, var0_21 and not var4_21)
	setActive(arg0_21.resLockTr, var0_21 and var4_21)
	setActive(arg0_21.titleTr, not var0_21)

	arg0_21.requestCG.alpha = var3_21 and 0.6 or 1
	arg0_21.titleTr.sizeDelta = var1_21 and Vector2(360, 39) or Vector2(155, 39)

	arg0_21:UpdateBgColor(arg1_21)
	arg0_21:UpdateTitleColor(arg1_21)
end

function var0_0.UpdateBgColor(arg0_22, arg1_22)
	if arg1_22:IsSubmited() and not arg1_22:IsFinished() then
		setActive(arg0_22.bgTr, false)

		return
	end

	setActive(arg0_22.bgTr, true)

	arg0_22.bgImg.color = arg1_22:IsFinished() and var1_0 or var3_0
end

function var0_0.UpdateTitleColor(arg0_23, arg1_23)
	if arg1_23:IsFinished() then
		arg0_23.titleLineImg.color = var1_0
	elseif arg1_23:IsSubmited() and not arg1_23:IsFinished() then
		arg0_23.titleLineImg.color = var4_0
	elseif arg1_23:IsWaiting() then
		arg0_23.titleLineImg.color = var2_0
	end

	arg0_23.titleTxt.color = arg1_23:IsWaiting() and var2_0 or var5_0
end

function var0_0.Dispose(arg0_24)
	arg0_24:RemoveTimer()
	arg0_24.aniDft:SetEndEvent(nil)
end

return var0_0
