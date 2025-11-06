local var0_0 = class("IslandShipOrderCard")
local var1_0 = Color.New(0.223529411764706, 0.745098039215686, 1, 1)
local var2_0 = Color.New(0.827450980392157, 0.827450980392157, 0.827450980392157, 1)
local var3_0 = Color.New(0.858823529411765, 0.858823529411765, 0.858823529411765, 1)
local var4_0 = Color.New(1, 0.682352941176471, 0.133333333333333, 1)
local var5_0 = Color.New(1, 1, 1, 1)

var0_0.EVENT_CD_END = "IslandShipOrderCard.EVENT_CD_END"

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.parent = arg2_1
	arg0_1._tf = arg1_1
	arg0_1.bgTr = arg1_1:Find("bg")
	arg0_1.bgImg = arg1_1:Find("bg"):GetComponent(typeof(Image))
	arg0_1.request = arg1_1:Find("request")
	arg0_1.exchangeBtn = arg1_1:Find("refresh")
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
	arg0_1.emptyTr = arg1_1:Find("empty")
	arg0_1.finishCntTxt = arg1_1:Find("count"):GetComponent(typeof(Text))

	setText(arg1_1:Find("loading_award/state/Text"), i18n("island_order_get_label"))
	setText(arg1_1:Find("normal_award/state/Text"), i18n("island_order_get_label"))
	setText(arg0_1.getBtn:Find("Text"), i18n("island_order_get_label"))
	setText(arg1_1:Find("empty/Text"), i18n("island_order_ship_sel_delegate_label"))
	setText(arg0_1.exchangeBtn:Find("Text"), i18n("island_order_ship_btn_replace"))

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
	arg0_3:UpdateFinishCnt(arg1_3)
end

function var0_0.UpdateFinishCnt(arg0_4, arg1_4)
	local var0_4 = arg1_4:GetRealFinishCnt()
	local var1_4 = arg1_4:GetMaxFinishCnt()

	arg0_4.finishCntTxt.text = i18n("island_order_ship_finish_cnt", var1_4 - var0_4, var1_4)
end

function var0_0.PlayAniamtion(arg0_5, arg1_5, arg2_5, arg3_5)
	local function var0_5()
		arg0_5.aniDft:SetEndEvent(function()
			arg0_5.aniDft:SetEndEvent(nil)

			if arg3_5 then
				arg3_5()
			end
		end)
	end

	if arg1_5 == IslandShipOrder.OP_TYPE_UNLOCK then
		var0_5()
		arg0_5.animator:Play("anim_island_shiporder_unlock")
	elseif arg1_5 == IslandShipOrder.OP_TYPE_LOADUP and arg2_5 then
		var0_5()
		arg0_5.animator:Play("anim_island_shiporder_intransit")
	elseif arg1_5 == IslandShipOrder.OP_TYPE_GET_AWARD then
		var0_5()
		arg0_5.animator:Play("anim_island_shiporder_next")
	else
		arg3_5()
	end
end

function var0_0.PlayFinishAnimation(arg0_8, arg1_8, arg2_8)
	if arg1_8 then
		local var0_8 = Clone(arg0_8.slot)

		var0_8.endTime = pg.TimeMgr.GetInstance():GetServerTime() + 10

		arg0_8:FlushMain(var0_8, arg0_8.mode)
	end

	arg0_8.aniDft:SetEndEvent(nil)
	arg0_8.aniDft:SetEndEvent(function()
		arg0_8.aniDft:SetEndEvent(nil)

		if arg1_8 then
			arg0_8:FlushMain(arg0_8.slot, arg0_8.mode)
		end

		if arg2_8 then
			arg2_8()
		end
	end)
	arg0_8.animator:Play("anim_island_shiporder_complete")
end

function var0_0.SwitchMode(arg0_10, arg1_10, arg2_10)
	arg0_10.mode = arg2_10

	arg0_10:UpdateStyle(arg1_10, arg2_10)
end

function var0_0.UpdateTimer(arg0_11, arg1_11)
	arg0_11:RemoveTimer()

	if arg1_11:IsSubmited() and not arg1_11:IsFinished() then
		arg0_11:AddTimer(arg1_11)
	elseif arg1_11:IsFinished() then
		arg0_11:PlayFinishAnimation(true)
	end
end

function var0_0.RemoveTimer(arg0_12)
	if arg0_12.timer then
		arg0_12.timer:Stop()

		arg0_12.timer = nil
	end
end

function var0_0.AddTimer(arg0_13, arg1_13)
	local var0_13 = arg1_13:GetEndTime()

	arg0_13.timer = Timer.New(function(arg0_14, arg1_14, arg2_14)
		local var0_14 = pg.TimeMgr.GetInstance():GetServerTime()
		local var1_14 = var0_13 - var0_14

		arg0_13.timeTxt.text = pg.TimeMgr.GetInstance():DescCDTime(var1_14)

		if var1_14 <= 0 then
			arg0_13:RemoveTimer()
			arg0_13:PlayFinishAnimation(function()
				arg0_13:Flush(arg1_13, arg0_13.mode)
			end)
		end
	end, 1, -1)

	arg0_13.timer.func()
	arg0_13.timer:Start()
end

function var0_0.UpdateTitle(arg0_16, arg1_16)
	if arg1_16:IsWaiting() then
		local var0_16 = arg1_16:GetNeedTime()

		arg0_16.titleTxt.text = i18n("island_order_ship_worktime", pg.TimeMgr.GetInstance():DescCDTime(var0_16))
	elseif arg1_16:IsSubmited() and not arg1_16:IsFinished() then
		arg0_16.titleTxt.text = i18n("island_order_ship_working")
	elseif arg1_16:IsFinished() then
		arg0_16.titleTxt.text = i18n("island_order_ship_end_work")
	end
end

function var0_0.UpdateLockTip(arg0_17, arg1_17)
	local var0_17 = arg1_17:GetUnlockLevel()
	local var1_17 = arg1_17:GetUnlockGold()

	arg0_17.levelLockTxt.text = i18n("island_order_ship_unlock_tip")
	arg0_17.resLockTxt.text = "X" .. var1_17.count .. i18n("island_order_ship_unlock_tip_2")

	local var2_17 = pg.island_item_data_template[var1_17.id].icon

	GetImageSpriteFromAtlasAsync("island/" .. var2_17, "", arg0_17.resImg)
end

function var0_0.UpdateAward(arg0_18, arg1_18)
	local var0_18 = arg1_18:GetOrder():GetAwardList()

	arg0_18.uiAwardList:make(function(arg0_19, arg1_19, arg2_19)
		if arg0_19 == UIItemList.EventUpdate then
			local var0_19 = var0_18[arg1_19 + 1]
			local var1_19 = Drop.New(var0_19)

			updateCustomDrop(arg2_19, Drop.New(var0_19))
			onButton(arg0_18.parent, arg2_19, function()
				arg0_18.parent:ShowMsgBox({
					title = i18n("island_word_desc"),
					type = IslandMsgBox.TYPE_COMMON_DROP_DESCRIBE,
					dropData = var1_19
				})
			end)
		end
	end)
	arg0_18.uiAwardList:align(#var0_18)
end

function var0_0.UpdateRequest(arg0_21, arg1_21)
	local var0_21 = arg1_21:GetOrder():GetConsumeList()

	arg0_21.uiRequestList:make(function(arg0_22, arg1_22, arg2_22)
		if arg0_22 == UIItemList.EventUpdate then
			local var0_22 = var0_21[arg1_22 + 1]
			local var1_22 = Drop.New(var0_22)
			local var2_22 = var1_22.icon or var1_22:getConfig("icon")

			GetImageSpriteFromAtlasAsync("island/" .. var2_22, "", arg2_22:Find("icon"))

			local var3_22 = var1_22.state == 1
			local var4_22 = var1_22:getOwnedCount()

			setText(arg2_22:Find("cnt"), setColorStr(var4_22 .. "/" .. var1_22.count, (var4_22 >= var1_22.count or var3_22) and "#39beff" or "#f36c6e"))
			setActive(arg2_22:Find("finish"), var3_22)
			setActive(arg2_22:Find("loaded"), var3_22)
			setActive(arg2_22:Find("loaded_1"), false)
			setActive(arg2_22:Find("enough"), not var3_22 and var4_22 >= var1_22.count)
		end
	end)
	arg0_21.uiRequestList:align(#var0_21)
end

function var0_0.UpdateStyle(arg0_23, arg1_23, arg2_23)
	local var0_23 = arg1_23:IsLock()
	local var1_23 = arg1_23:IsWaiting()
	local var2_23 = arg1_23:IsFinished()
	local var3_23 = arg1_23:IsSubmited() and not var2_23
	local var4_23 = arg1_23:CanUnlock()
	local var5_23 = arg1_23:IsEmpty()
	local var6_23 = arg2_23 == IslandShipOrderPage.MODE_REQUEST_VIEW
	local var7_23 = arg2_23 == IslandShipOrderPage.MODE_AWARD_VIEW

	setActive(arg0_23.loadingTr, var3_23)
	setActive(arg0_23.loadingRequest, var3_23 and var6_23)
	setActive(arg0_23.loadingAward, var3_23 and var7_23)
	setActive(arg0_23.finishTr, var2_23 and not var5_23)
	setActive(arg0_23.request, not var0_23 and var6_23 and not var2_23 and not var5_23)
	setActive(arg0_23.award, (not var0_23 and var7_23 or var2_23) and not var5_23)
	setActive(arg0_23.lockTr, var0_23)
	setActive(arg0_23.normalTr, var1_23 and var7_23 and not var5_23)
	setActive(arg0_23.levelLockTr, var0_23 and not var4_23)
	setActive(arg0_23.resLockTr, var0_23 and var4_23)
	setActive(arg0_23.titleTr, not var0_23 and not var5_23)
	setActive(arg0_23.emptyTr, var5_23 and var1_23)
	setActive(arg0_23.exchangeBtn, not var5_23 and var1_23 and var6_23)
	setActive(arg0_23.finishCntTxt.gameObject, not var0_23)

	arg0_23.requestCG.alpha = var3_23 and 0.6 or 1
	arg0_23.titleTr.sizeDelta = var1_23 and Vector2(360, 39) or Vector2(240, 39)

	arg0_23:UpdateBgColor(arg1_23)
	arg0_23:UpdateTitleColor(arg1_23)
end

function var0_0.RemoveReloadingTimer(arg0_24)
	if arg0_24.reloadingTimer then
		arg0_24.reloadingTimer:Stop()

		arg0_24.reloadingTimer = nil
	end
end

function var0_0.UpdateBgColor(arg0_25, arg1_25)
	if arg1_25:IsSubmited() and not arg1_25:IsFinished() then
		setActive(arg0_25.bgTr, false)

		return
	end

	setActive(arg0_25.bgTr, true)

	arg0_25.bgImg.color = arg1_25:IsFinished() and var1_0 or var3_0
end

function var0_0.UpdateTitleColor(arg0_26, arg1_26)
	if arg1_26:IsFinished() then
		arg0_26.titleLineImg.color = var1_0
	elseif arg1_26:IsSubmited() and not arg1_26:IsFinished() then
		arg0_26.titleLineImg.color = var4_0
	elseif arg1_26:IsWaiting() then
		arg0_26.titleLineImg.color = var2_0
	end

	arg0_26.titleTxt.color = arg1_26:IsWaiting() and var2_0 or var5_0
end

function var0_0.Dispose(arg0_27)
	arg0_27:RemoveTimer()
	arg0_27:RemoveReloadingTimer()
	arg0_27.aniDft:SetEndEvent(nil)
end

return var0_0
