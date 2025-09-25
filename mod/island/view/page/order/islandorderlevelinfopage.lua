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
	arg0_2.canvasGroup = GetOrAddComponent(arg0_2._tf, typeof(CanvasGroup))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.AddListeners(arg0_5)
	arg0_5:AddListener(IslandOrderAgency.ORDER_FINISH_UPDATE, arg0_5.OnReset)
end

function var0_0.RemoveListeners(arg0_6)
	arg0_6:RemoveListener(IslandOrderAgency.ORDER_FINISH_UPDATE, arg0_6.OnReset)
end

function var0_0.OnReset(arg0_7)
	arg0_7:Flush()
end

function var0_0.Show(arg0_8)
	var0_0.super.Show(arg0_8)
	arg0_8:Flush()
end

function var0_0.Flush(arg0_9)
	local var0_9 = getProxy(IslandProxy):GetIsland():GetOrderAgency()

	arg0_9:FlushCnt(var0_9)
	arg0_9:FlushLevelInfo(var0_9)
	arg0_9:FlushList(var0_9)
end

function var0_0.FlushCnt(arg0_10, arg1_10)
	arg0_10.cntTxt.text = i18n("island_order_leftcnt_dispaly", arg1_10:GetLeftUrgentCnt())
end

function var0_0.FlushLevelInfo(arg0_11, arg1_11)
	arg0_11.levelTxt.text = "Lv." .. arg1_11:GetLevel()

	if arg1_11:IsMaxLevel() then
		setSlider(arg0_11.expTr, 0, 1, 1)

		arg0_11.expTxt.text = "MAX"
	else
		local var0_11 = arg1_11:GetExp()
		local var1_11 = math.max(1, arg1_11:GetNextTargetExp())

		setSlider(arg0_11.expTr, 0, 1, var0_11 / var1_11)

		arg0_11.expTxt.text = "<size=60><color=#ffaf1b>" .. var0_11 .. "</color></size><color=#979797>/" .. var1_11 .. "</color>"
	end
end

function var0_0.FlushList(arg0_12, arg1_12)
	local var0_12 = pg.island_order_favor.all
	local var1_12 = 1

	arg0_12.uiItemList:make(function(arg0_13, arg1_13, arg2_13)
		if arg0_13 == UIItemList.EventUpdate then
			local var0_13 = var0_12[arg1_13 + 1]

			arg0_12:UpdateCard(arg1_12, arg2_13, var0_13)

			if arg1_12:IsGotAward(var0_13) then
				var1_12 = arg1_13 + 1
			end
		end
	end)
	arg0_12.uiItemList:align(#var0_12)
	scrollTo(arg0_12.uiItemList.container.parent, 0, 1)
	arg0_12:ScrollTo(var1_12, var0_12)
end

function var0_0.ScrollTo(arg0_14, arg1_14, arg2_14)
	onNextTick(function()
		local var0_15 = math.min(arg1_14, #arg2_14 * 0.5 - 1)
		local var1_15 = arg0_14.uiItemList.container:GetChild(0)
		local var2_15 = arg0_14.uiItemList.container:GetChild(var0_15)
		local var3_15 = math.abs(var2_15.localPosition.x - var1_15.localPosition.x)
		local var4_15 = arg0_14.uiItemList.container.localPosition

		arg0_14.uiItemList.container.localPosition = Vector3(var4_15.x - var3_15, var4_15.y, 0)
	end)
end

function var0_0.UpdateCard(arg0_16, arg1_16, arg2_16, arg3_16)
	arg0_16:UpdateAwards(arg2_16, arg3_16)

	local var0_16 = arg1_16:IsGotAward(arg3_16)
	local var1_16 = arg1_16:CanGetAward(arg3_16)
	local var2_16 = var1_16 or var0_16

	setActive(arg2_16:Find("got"), var0_16)
	setActive(arg2_16:Find("finish"), var2_16)

	local var3_16 = arg3_16 < 10 and "0" .. arg3_16 or arg3_16

	setText(arg2_16:Find("num"), setColorStr(var3_16, var2_16 and "#FFFFFF" or "#979797"))
	onButton(arg0_16, arg2_16, function()
		if var1_16 and not var0_16 then
			arg0_16:emit(IslandMediator.ON_GET_ORDER_EXP_AWARD, arg3_16)
		end
	end, SFX_PANEL)
end

function var0_0.UpdateAwards(arg0_18, arg1_18, arg2_18)
	local var0_18 = pg.island_order_favor[arg2_18].award_display
	local var1_18 = UIItemList.New(arg1_18:Find("awards"), arg1_18:Find("awards/IslandItemTpl"))

	var1_18:make(function(arg0_19, arg1_19, arg2_19)
		if arg0_19 == UIItemList.EventUpdate then
			local var0_19 = var0_18[arg1_19 + 1]
			local var1_19 = Drop.Create(var0_19)

			updateCustomDrop(arg2_19, var1_19)
		end
	end)
	var1_18:align(math.min(2, #var0_18))
end

function var0_0.OnDestroy(arg0_20)
	return
end

return var0_0
