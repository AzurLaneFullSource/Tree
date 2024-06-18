local var0_0 = class("ResourcePage", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "ResourcePage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.titleTxt = arg0_2:findTF("frame/title/text"):GetComponent(typeof(Text))
	arg0_2.iconImg = arg0_2:findTF("frame/title/icon"):GetComponent(typeof(Image))
	arg0_2.closeBtn = arg0_2:findTF("frame/btnBack")
	arg0_2.descTxt = arg0_2:findTF("frame/content/describe/class"):GetComponent(typeof(Text))
	arg0_2.levelTxt = arg0_2:findTF("frame/title/icon/current"):GetComponent(typeof(Text))
	arg0_2.currentLevelTxt = arg0_2:findTF("frame/content/info/level/curr"):GetComponent(typeof(Text))
	arg0_2.nextLevelTxt = arg0_2:findTF("frame/content/info/level/next"):GetComponent(typeof(Text))
	arg0_2.costTxt = arg0_2:findTF("frame/content/upgrade_btn/cost"):GetComponent(typeof(Text))
	arg0_2.spendTimeTxt = arg0_2:findTF("frame/upgrade_duration/Text"):GetComponent(typeof(Text))
	arg0_2.upgradeBtn = arg0_2:findTF("frame/content/upgrade_btn")
	arg0_2.upgradingBtn = arg0_2:findTF("frame/content/upgrading_block")
	arg0_2.attrUIlist = UIItemList.New(arg0_2:findTF("frame/content/info/conent"), arg0_2:findTF("frame/content/info/conent/tpl"))

	setText(arg0_2.upgradeBtn:Find("Image"), i18n("word_levelup"))
	setText(arg0_2.upgradingBtn:Find("Image"), i18n("class_label_upgrading"))
	setText(arg0_2:findTF("frame/content/upgrade_btn/costback/label"), i18n("text_consume"))
	setText(arg0_2:findTF("frame/upgrade_duration/Image/Text"), i18n("class_label_upgradetime"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.upgradeBtn, function()
		if arg0_3:CheckUpgrade() then
			arg0_3:OnUpgrade()
		end
	end, SFX_PANEL)
	arg0_3.attrUIlist:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventUpdate then
			arg0_3:UpdateResourceFieldAttr(arg0_3.attrs[arg1_7 + 1], arg2_7)
		end
	end)
end

function var0_0.Flush(arg0_8, arg1_8)
	arg0_8:Update(arg1_8)
	arg0_8:Show()
end

function var0_0.Update(arg0_9, arg1_9)
	arg0_9.resourceField = arg1_9

	arg0_9:Refresh()
end

function var0_0.CheckUpgrade(arg0_10)
	if not arg0_10.resourceField:CanUpgrade() then
		if arg0_10.resourceField:IsMaxLevel() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("class_res_maxlevel_tip"))
		elseif not arg0_10.resourceField:IsReachLevel() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_limit_level", arg0_10.resourceField:GetTargetLevel()))
		elseif not arg0_10.resourceField:IsReachRes() then
			local var0_10 = arg0_10.resourceField:GetTargetRes()
			local var1_10 = getProxy(PlayerProxy):getRawData().gold

			GoShoppingMsgBox(i18n("switch_to_shop_tip_2", i18n("word_gold")), ChargeScene.TYPE_ITEM, {
				{
					59001,
					var0_10 - var1_10,
					var0_10
				}
			})
		end

		return false
	end

	return true
end

function var0_0.OnUpgrade(arg0_11)
	local var0_11 = arg0_11.resourceField:GetUpgradeType()

	arg0_11:emit(NavalAcademyMediator.UPGRADE_FIELD, var0_11)
end

function var0_0.Refresh(arg0_12)
	local var0_12 = arg0_12.resourceField
	local var1_12 = var0_12:GetKeyWord()

	arg0_12.iconImg.sprite = GetSpriteFromAtlas("ui/ResourceFieldUI_atlas", var1_12)
	arg0_12.titleTxt.text = var0_12:GetName()

	local var2_12 = arg0_12.resourceField

	arg0_12.descTxt.text = var2_12:GetDesc()

	local var3_12 = "Lv." .. var2_12:GetLevel()

	arg0_12.levelTxt.text = var3_12

	local var4_12 = var2_12:IsMaxLevel()
	local var5_12 = var4_12 and "Lv.Max" or "Lv." .. var2_12:GetLevel() + 1

	arg0_12.currentLevelTxt.text = var3_12
	arg0_12.nextLevelTxt.text = var5_12

	local var6_12 = var4_12 and "-" or var2_12:GetCost().count
	local var7_12 = var2_12:IsReachRes() and COLOR_WHITE or COLOR_RED

	arg0_12.costTxt.text = "<color=" .. var7_12 .. ">" .. var6_12 .. "</color>"

	arg0_12:FlushState()
end

function var0_0.FlushState(arg0_13)
	local var0_13 = arg0_13.resourceField
	local var1_13 = var0_13:IsMaxLevel()
	local var2_13 = var0_13:IsStarting()

	setActive(arg0_13.upgradeBtn, not var2_13)
	setActive(arg0_13.upgradingBtn, var2_13)
	setGray(arg0_13.upgradeBtn, var1_13, true)
	arg0_13:RemoveTimer()

	if var2_13 then
		arg0_13:AddTimer()
	else
		local var3_13 = var1_13 and "-" or pg.TimeMgr.GetInstance():DescCDTime(var0_13:GetSpendTime())

		arg0_13.spendTimeTxt.text = var3_13
	end

	arg0_13:UpdateResourceFieldAttrs()
end

function var0_0.UpdateResourceFieldAttrs(arg0_14)
	arg0_14.attrs = arg0_14.resourceField:GetEffectAttrs()

	arg0_14.attrUIlist:align(#arg0_14.attrs)
end

function var0_0.UpdateResourceFieldAttr(arg0_15, arg1_15, arg2_15)
	setText(arg2_15:Find("label"), arg1_15:GetName())
	setText(arg2_15:Find("advance"), "[+" .. arg1_15:GetAdditionDesc() .. "]")

	local var0_15 = arg1_15:GetValue()
	local var1_15 = arg1_15:GetNextValue()
	local var2_15 = arg1_15:GetMaxValue()

	setFillAmount(arg2_15:Find("curr"), var0_15 / var2_15)
	setFillAmount(arg2_15:Find("prev"), var1_15 / var2_15)
	LeanTween.cancel(go(arg2_15:Find("prev")))
	blinkAni(arg2_15:Find("prev"), 0.8, -1, 0.3):setFrom(1)
	setText(arg2_15:Find("current"), arg1_15:GetProgressDesc())
end

function var0_0.AddTimer(arg0_16)
	local var0_16 = arg0_16.resourceField:GetUpgradeTimeStamp()

	if var0_16 > pg.TimeMgr.GetInstance():GetServerTime() then
		arg0_16.timer = Timer.New(function()
			local var0_17 = var0_16 - pg.TimeMgr.GetInstance():GetServerTime()

			if var0_17 <= 0 then
				arg0_16:RemoveTimer()
			end

			arg0_16.spendTimeTxt.text = pg.TimeMgr.GetInstance():DescCDTime(var0_17)
		end, 1, -1)

		arg0_16.timer:Start()
		arg0_16.timer.func()
	end
end

function var0_0.RemoveTimer(arg0_18)
	if arg0_18.timer then
		arg0_18.timer:Stop()

		arg0_18.timer = nil
	end
end

function var0_0.Show(arg0_19)
	if not arg0_19.isOpen then
		var0_0.super.Show(arg0_19)
		pg.UIMgr.GetInstance():BlurPanel(arg0_19._tf)

		arg0_19.isOpen = true
	end
end

function var0_0.Hide(arg0_20)
	if arg0_20.isOpen then
		arg0_20.isOpen = false

		var0_0.super.Hide(arg0_20)
		pg.UIMgr.GetInstance():UnblurPanel(arg0_20._tf, arg0_20._parentTf)
	end
end

function var0_0.OnDestroy(arg0_21)
	arg0_21:Hide()
	arg0_21:RemoveTimer()
end

return var0_0
