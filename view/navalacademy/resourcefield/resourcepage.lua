local var0 = class("ResourcePage", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "ResourcePage"
end

function var0.OnLoaded(arg0)
	arg0.titleTxt = arg0:findTF("frame/title/text"):GetComponent(typeof(Text))
	arg0.iconImg = arg0:findTF("frame/title/icon"):GetComponent(typeof(Image))
	arg0.closeBtn = arg0:findTF("frame/btnBack")
	arg0.descTxt = arg0:findTF("frame/content/describe/class"):GetComponent(typeof(Text))
	arg0.levelTxt = arg0:findTF("frame/title/icon/current"):GetComponent(typeof(Text))
	arg0.currentLevelTxt = arg0:findTF("frame/content/info/level/curr"):GetComponent(typeof(Text))
	arg0.nextLevelTxt = arg0:findTF("frame/content/info/level/next"):GetComponent(typeof(Text))
	arg0.costTxt = arg0:findTF("frame/content/upgrade_btn/cost"):GetComponent(typeof(Text))
	arg0.spendTimeTxt = arg0:findTF("frame/upgrade_duration/Text"):GetComponent(typeof(Text))
	arg0.upgradeBtn = arg0:findTF("frame/content/upgrade_btn")
	arg0.upgradingBtn = arg0:findTF("frame/content/upgrading_block")
	arg0.attrUIlist = UIItemList.New(arg0:findTF("frame/content/info/conent"), arg0:findTF("frame/content/info/conent/tpl"))

	setText(arg0.upgradeBtn:Find("Image"), i18n("word_levelup"))
	setText(arg0.upgradingBtn:Find("Image"), i18n("class_label_upgrading"))
	setText(arg0:findTF("frame/content/upgrade_btn/costback/label"), i18n("text_consume"))
	setText(arg0:findTF("frame/upgrade_duration/Image/Text"), i18n("class_label_upgradetime"))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.closeBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.upgradeBtn, function()
		if arg0:CheckUpgrade() then
			arg0:OnUpgrade()
		end
	end, SFX_PANEL)
	arg0.attrUIlist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:UpdateResourceFieldAttr(arg0.attrs[arg1 + 1], arg2)
		end
	end)
end

function var0.Flush(arg0, arg1)
	arg0:Update(arg1)
	arg0:Show()
end

function var0.Update(arg0, arg1)
	arg0.resourceField = arg1

	arg0:Refresh()
end

function var0.CheckUpgrade(arg0)
	if not arg0.resourceField:CanUpgrade() then
		if arg0.resourceField:IsMaxLevel() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("class_res_maxlevel_tip"))
		elseif not arg0.resourceField:IsReachLevel() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_limit_level", arg0.resourceField:GetTargetLevel()))
		elseif not arg0.resourceField:IsReachRes() then
			local var0 = arg0.resourceField:GetTargetRes()
			local var1 = getProxy(PlayerProxy):getRawData().gold

			GoShoppingMsgBox(i18n("switch_to_shop_tip_2", i18n("word_gold")), ChargeScene.TYPE_ITEM, {
				{
					59001,
					var0 - var1,
					var0
				}
			})
		end

		return false
	end

	return true
end

function var0.OnUpgrade(arg0)
	local var0 = arg0.resourceField:GetUpgradeType()

	arg0:emit(NavalAcademyMediator.UPGRADE_FIELD, var0)
end

function var0.Refresh(arg0)
	local var0 = arg0.resourceField
	local var1 = var0:GetKeyWord()

	arg0.iconImg.sprite = GetSpriteFromAtlas("ui/ResourceFieldUI_atlas", var1)
	arg0.titleTxt.text = var0:GetName()

	local var2 = arg0.resourceField

	arg0.descTxt.text = var2:GetDesc()

	local var3 = "Lv." .. var2:GetLevel()

	arg0.levelTxt.text = var3

	local var4 = var2:IsMaxLevel()
	local var5 = var4 and "Lv.Max" or "Lv." .. var2:GetLevel() + 1

	arg0.currentLevelTxt.text = var3
	arg0.nextLevelTxt.text = var5

	local var6 = var4 and "-" or var2:GetCost().count
	local var7 = var2:IsReachRes() and COLOR_WHITE or COLOR_RED

	arg0.costTxt.text = "<color=" .. var7 .. ">" .. var6 .. "</color>"

	arg0:FlushState()
end

function var0.FlushState(arg0)
	local var0 = arg0.resourceField
	local var1 = var0:IsMaxLevel()
	local var2 = var0:IsStarting()

	setActive(arg0.upgradeBtn, not var2)
	setActive(arg0.upgradingBtn, var2)
	setGray(arg0.upgradeBtn, var1, true)
	arg0:RemoveTimer()

	if var2 then
		arg0:AddTimer()
	else
		local var3 = var1 and "-" or pg.TimeMgr.GetInstance():DescCDTime(var0:GetSpendTime())

		arg0.spendTimeTxt.text = var3
	end

	arg0:UpdateResourceFieldAttrs()
end

function var0.UpdateResourceFieldAttrs(arg0)
	arg0.attrs = arg0.resourceField:GetEffectAttrs()

	arg0.attrUIlist:align(#arg0.attrs)
end

function var0.UpdateResourceFieldAttr(arg0, arg1, arg2)
	setText(arg2:Find("label"), arg1:GetName())
	setText(arg2:Find("advance"), "[+" .. arg1:GetAdditionDesc() .. "]")

	local var0 = arg1:GetValue()
	local var1 = arg1:GetNextValue()
	local var2 = arg1:GetMaxValue()

	setFillAmount(arg2:Find("curr"), var0 / var2)
	setFillAmount(arg2:Find("prev"), var1 / var2)
	LeanTween.cancel(go(arg2:Find("prev")))
	blinkAni(arg2:Find("prev"), 0.8, -1, 0.3):setFrom(1)
	setText(arg2:Find("current"), arg1:GetProgressDesc())
end

function var0.AddTimer(arg0)
	local var0 = arg0.resourceField:GetUpgradeTimeStamp()

	if var0 > pg.TimeMgr.GetInstance():GetServerTime() then
		arg0.timer = Timer.New(function()
			local var0 = var0 - pg.TimeMgr.GetInstance():GetServerTime()

			if var0 <= 0 then
				arg0:RemoveTimer()
			end

			arg0.spendTimeTxt.text = pg.TimeMgr.GetInstance():DescCDTime(var0)
		end, 1, -1)

		arg0.timer:Start()
		arg0.timer.func()
	end
end

function var0.RemoveTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.Show(arg0)
	if not arg0.isOpen then
		var0.super.Show(arg0)
		pg.UIMgr.GetInstance():BlurPanel(arg0._tf)

		arg0.isOpen = true
	end
end

function var0.Hide(arg0)
	if arg0.isOpen then
		arg0.isOpen = false

		var0.super.Hide(arg0)
		pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
	end
end

function var0.OnDestroy(arg0)
	arg0:Hide()
	arg0:RemoveTimer()
end

return var0
