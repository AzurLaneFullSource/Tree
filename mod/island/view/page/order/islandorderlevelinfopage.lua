local var0_0 = class("IslandOrderLevelInfoPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandOrderLevelInfoUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.levelTxt = arg0_2:findTF("frame/animroot/level"):GetComponent(typeof(Text))
	arg0_2.expTr = arg0_2:findTF("frame/animroot/slider")
	arg0_2.expTxt = arg0_2:findTF("frame/animroot/exp"):GetComponent(typeof(Text))
	arg0_2.cntTxt = arg0_2:findTF("frame/bg/Image/cnt"):GetComponent(typeof(Text))
	arg0_2.uiItemList = UIItemList.New(arg0_2:findTF("frame/animroot/rect/content"), arg0_2:findTF("frame/animroot/rect/content/tpl"))
	arg0_2.animator = arg0_2._tf:GetComponent(typeof(Animation))
	arg0_2.aniDft = arg0_2._tf:GetComponent(typeof(DftAniEvent))
	arg0_2.canvasGroup = GetOrAddComponent(arg0_2._tf, typeof(CanvasGroup))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:PlayExitAnimation(function()
			arg0_3:Hide()
		end)
	end, SFX_PANEL)
end

function var0_0.PlayExitAnimation(arg0_6, arg1_6)
	arg0_6.canvasGroup.blocksRaycasts = false

	arg0_6.aniDft:SetEndEvent(function()
		arg0_6.canvasGroup.blocksRaycasts = true

		if arg1_6 then
			arg1_6()
		end
	end)
	arg0_6.animator:Play("anim_island_shiporder_LVinfo_out")
end

function var0_0.AddListeners(arg0_8)
	arg0_8:AddListener(IslandOrderAgency.ORDER_FINISH_UPDATE, arg0_8.OnReset)
end

function var0_0.RemoveListener(arg0_9)
	arg0_9:RemoveListener(IslandOrderAgency.ORDER_FINISH_UPDATE, arg0_9.OnReset)
end

function var0_0.OnReset(arg0_10)
	arg0_10:Flush()
end

function var0_0.Show(arg0_11)
	var0_0.super.Show(arg0_11)
	arg0_11:Flush()
end

function var0_0.Flush(arg0_12)
	local var0_12 = getProxy(IslandProxy):GetIsland():GetOrderAgency()

	arg0_12:FlushLevelInfo(var0_12)
	arg0_12:FlushList(var0_12)
	arg0_12:FlushCnt(var0_12)
end

function var0_0.FlushCnt(arg0_13, arg1_13)
	arg0_13.cntTxt.text = i18n("island_order_leftcnt_dispaly", arg1_13:GetLeftUrgentCnt())
end

function var0_0.FlushLevelInfo(arg0_14, arg1_14)
	arg0_14.levelTxt.text = "Lv." .. arg1_14:GetLevel()

	if arg1_14:IsMaxLevel() then
		setSlider(arg0_14.expTr, 0, 1, 1)

		arg0_14.expTxt.text = "MAX"
	else
		local var0_14 = arg1_14:GetExp()
		local var1_14 = math.max(1, arg1_14:GetNextTargetExp())

		setSlider(arg0_14.expTr, 0, 1, var0_14 / var1_14)

		arg0_14.expTxt.text = "<size=60><color=#ffaf1b>" .. var0_14 .. "</color></size><color=#979797>/" .. var1_14 .. "</color>"
	end
end

function var0_0.FlushList(arg0_15, arg1_15)
	local var0_15 = pg.island_order_favor.all
	local var1_15 = 1

	arg0_15.uiItemList:make(function(arg0_16, arg1_16, arg2_16)
		if arg0_16 == UIItemList.EventUpdate then
			local var0_16 = var0_15[arg1_16 + 1]

			arg0_15:UpdateCard(arg1_15, arg2_16, var0_16)

			if arg1_15:IsGotAward(var0_16) then
				var1_15 = arg1_16 + 1
			end
		end
	end)
	arg0_15.uiItemList:align(#var0_15)
	scrollTo(arg0_15.uiItemList.container.parent, 0, 1)
	arg0_15:ScrollTo(var1_15, var0_15)
end

function var0_0.ScrollTo(arg0_17, arg1_17, arg2_17)
	onNextTick(function()
		local var0_18 = math.min(arg1_17, #arg2_17 * 0.5 - 1)
		local var1_18 = arg0_17.uiItemList.container:GetChild(0)
		local var2_18 = arg0_17.uiItemList.container:GetChild(var0_18)
		local var3_18 = math.abs(var2_18.localPosition.x - var1_18.localPosition.x)
		local var4_18 = arg0_17.uiItemList.container.localPosition

		arg0_17.uiItemList.container.localPosition = Vector3(var4_18.x - var3_18, var4_18.y, 0)
	end)
end

function var0_0.UpdateCard(arg0_19, arg1_19, arg2_19, arg3_19)
	arg0_19:UpdateAwards(arg2_19, arg3_19)

	local var0_19 = arg1_19:IsGotAward(arg3_19)
	local var1_19 = arg1_19:CanGetAward(arg3_19)
	local var2_19 = var1_19 or var0_19

	setActive(arg2_19:Find("got"), var0_19)
	setActive(arg2_19:Find("finish"), var2_19)

	local var3_19 = arg3_19 < 10 and "0" .. arg3_19 or arg3_19

	setText(arg2_19:Find("num"), setColorStr(var3_19, var2_19 and "#FFFFFF" or "#979797"))
	onButton(arg0_19, arg2_19, function()
		if var1_19 and not var0_19 then
			arg0_19:emit(IslandMediator.ON_GET_ORDER_EXP_AWARD, arg3_19)
		end
	end, SFX_PANEL)
end

function var0_0.UpdateAwards(arg0_21, arg1_21, arg2_21)
	local var0_21 = pg.island_order_favor[arg2_21].award_display
	local var1_21 = UIItemList.New(arg1_21:Find("awards"), arg1_21:Find("awards/IslandItemTpl"))

	var1_21:make(function(arg0_22, arg1_22, arg2_22)
		if arg0_22 == UIItemList.EventUpdate then
			local var0_22 = var0_21[arg1_22 + 1]
			local var1_22 = Drop.Create(var0_22)

			updateCustomDrop(arg2_22, var1_22)
		end
	end)
	var1_21:align(math.min(2, #var0_21))
end

function var0_0.OnDestroy(arg0_23)
	return
end

return var0_0
