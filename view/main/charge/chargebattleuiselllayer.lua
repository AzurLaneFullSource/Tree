local var0_0 = class("ChargeBattleUISellLayer", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "ChargeBattleUISellLayer"
end

function var0_0.init(arg0_2)
	arg0_2.loader = AutoLoader.New()

	arg0_2:InitData()
	arg0_2:InitUI()
	arg0_2:updateGiftWindow()
	arg0_2:InitBattleShow()
end

function var0_0.didEnter(arg0_3)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf)
end

function var0_0.willExit(arg0_4)
	arg0_4.loader:Clear()
	UpdateBeat:RemoveListener(arg0_4.handle)
	arg0_4:ClearPreviewer()
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_4._tf)
end

function var0_0.InitData(arg0_5)
	arg0_5.showGoodVO = arg0_5.contextData.showGoodVO
	arg0_5.chargedList = arg0_5.contextData.chargedList
	arg0_5.goodVOList = arg0_5.showGoodVO:getSameLimitGroupTecGoods()
	arg0_5.normalGoodVO = nil
	arg0_5.specailGoodVO = nil

	for iter0_5, iter1_5 in ipairs(arg0_5.goodVOList) do
		if iter1_5:getConfig("limit_arg") == 1 then
			if not arg0_5.normalGoodVO then
				arg0_5.normalGoodVO = iter1_5
			else
				arg0_5.specailGoodVO = iter1_5
			end
		end
	end

	arg0_5.battleSkinId = nil
end

function var0_0.InitUI(arg0_6)
	arg0_6.bg = arg0_6._tf:Find("BG")
	arg0_6.titleText = arg0_6._tf:Find("mainPanel/topBar/left/nameMask/name")
	arg0_6.tipText = arg0_6._tf:Find("mainPanel/topBar/left/tipText")
	arg0_6.middleText = arg0_6._tf:Find("mainPanel/topBar/middle/Text")
	arg0_6.closeBtn = arg0_6._tf:Find("mainPanel/topBar/right")
	arg0_6.startShowBtn = arg0_6._tf:Find("mainPanel/main/showWindow")
	arg0_6.normalWindow = arg0_6._tf:Find("mainPanel/main/normalWindow")
	arg0_6.specialWindow = arg0_6._tf:Find("mainPanel/main/specialWindow")
	arg0_6.normalText = arg0_6.normalWindow:Find("title")
	arg0_6.specialText = arg0_6.specialWindow:Find("title")
	arg0_6.buyNormalBtn = arg0_6.normalWindow:Find("buyNormalButton")
	arg0_6.buySpecialBtn = arg0_6.specialWindow:Find("buySpecialButton")
	arg0_6.itemTpl = arg0_6._tf:Find("itemTpl")
	arg0_6.normalList = UIItemList.New(arg0_6.normalWindow:Find("list"), arg0_6.itemTpl)
	arg0_6.specialList = UIItemList.New(arg0_6.specialWindow:Find("list"), arg0_6.itemTpl)

	setScrollText(arg0_6.titleText, "")
	setText(arg0_6.tipText, i18n("ui_pack_tip1"))
	setText(arg0_6.normalText, i18n("ui_pack_tip2"))
	setText(arg0_6.specialText, i18n("ui_pack_tip3"))

	arg0_6.preview = arg0_6._tf:Find("mainPanel/main/preview")
	arg0_6.sea = arg0_6.preview:Find("sea")
	arg0_6.rawImage = arg0_6.sea:GetComponent("RawImage")

	setActive(arg0_6.preview, false)
	setActive(arg0_6.rawImage, false)
	onButton(arg0_6, arg0_6.closeBtn, function()
		arg0_6:ClearPreviewer()
		arg0_6:closeView()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.bg, function()
		arg0_6:ClearPreviewer()
		arg0_6:closeView()
	end, SFX_PANEL)

	arg0_6.tipsGo = arg0_6._tf:Find("mainPanel/topBar/left/tips")
	arg0_6.tipsText = arg0_6._tf:Find("mainPanel/topBar/left/tips/text")
	arg0_6.toggleList = UIItemList.New(arg0_6._tf:Find("mainPanel/topBar/left/elementList"), arg0_6._tf:Find("mainPanel/topBar/left/elementList/main_toggle"))
	arg0_6.handle = UpdateBeat:CreateListener(arg0_6.UpdateClick, arg0_6)

	UpdateBeat:AddListener(arg0_6.handle)
end

function var0_0.ShowTips(arg0_9, arg1_9)
	setActive(arg0_9.tipsGo, arg1_9)
end

function var0_0.UpdateClick(arg0_10)
	if UnityEngine.Input.GetMouseButtonDown(0) then
		arg0_10.toggleList:each(function(arg0_11, arg1_11)
			GetComponent(arg1_11, typeof(Toggle)).isOn = false
		end)
	end
end

function var0_0.updateGiftWindow(arg0_12)
	setText(arg0_12.buyNormalBtn:Find("Price/BuyText"), i18n("word_buy"))
	setText(arg0_12.buyNormalBtn:Find("Price/content/Text"), arg0_12.normalGoodVO:getConfig("money"))
	onButton(arg0_12, arg0_12.buyNormalBtn, function()
		pg.m02:sendNotification(GAME.CHARGE_OPERATION, {
			shopId = arg0_12.normalGoodVO.id
		})
		arg0_12:ClearPreviewer()
		arg0_12:closeView()
	end, SFX_PANEL)
	setText(arg0_12.buySpecialBtn:Find("Price/BuyText"), i18n("word_buy"))
	setText(arg0_12.buySpecialBtn:Find("Price/content/Text"), arg0_12.specailGoodVO:getConfig("money"))
	onButton(arg0_12, arg0_12.buySpecialBtn, function()
		pg.m02:sendNotification(GAME.CHARGE_OPERATION, {
			shopId = arg0_12.specailGoodVO.id
		})
		arg0_12:ClearPreviewer()
		arg0_12:closeView()
	end, SFX_PANEL)

	local var0_12 = {}

	for iter0_12, iter1_12 in ipairs(arg0_12.normalGoodVO:GetExtraServiceItem()) do
		table.insert(var0_12, iter1_12)

		if not arg0_12.battleSkinId then
			arg0_12.battleSkinId = iter1_12.id
		end
	end

	arg0_12.normalList:make(function(arg0_15, arg1_15, arg2_15)
		if arg0_15 == UIItemList.EventUpdate then
			local var0_15 = arg2_15:Find("Container"):GetChild(0)
			local var1_15 = arg2_15:Find("TextMask/Text")
			local var2_15 = var0_12[arg1_15 + 1]

			var2_15.notPlay = true

			updateDrop(var0_15, var2_15)
			onButton(arg0_12, var0_15, function()
				arg0_12:emit(BaseUI.ON_DROP, var2_15)
			end, SFX_PANEL)
			setScrollText(var1_15, var2_15:getName())

			if arg0_12.titleText:GetComponent(typeof(Text)).text == "" then
				setScrollText(arg0_12.titleText, var2_15:getName())
			end
		end
	end)
	arg0_12.normalList:align(#var0_12)

	var0_12 = {}

	for iter2_12, iter3_12 in ipairs(arg0_12.specailGoodVO:GetExtraServiceItem()) do
		table.insert(var0_12, iter3_12)
	end

	arg0_12.specialList:make(function(arg0_17, arg1_17, arg2_17)
		if arg0_17 == UIItemList.EventUpdate then
			local var0_17 = arg2_17:Find("Container"):GetChild(0)
			local var1_17 = arg2_17:Find("TextMask/Text")
			local var2_17 = var0_12[arg1_17 + 1]

			updateDrop(var0_17, var2_17)

			var2_17.notPlay = true

			onButton(arg0_12, var0_17, function()
				arg0_12:emit(BaseUI.ON_DROP, var2_17)
			end, SFX_PANEL)
			setScrollText(var1_17, var2_17:getName())
		end
	end)
	arg0_12.specialList:align(#var0_12)
	arg0_12:InitTitle(var0_12)
end

function var0_0.InitBattleShow(arg0_19)
	local var0_19 = Ship.New({
		id = 100001,
		configId = 100001,
		skin_id = 100000
	})
	local var1_19 = Ship.New({
		id = 100011,
		configId = 100011,
		skin_id = 100010
	})
	local var2_19 = pg.item_data_battleui[arg0_19.battleSkinId].key

	onButton(arg0_19, arg0_19.startShowBtn, function()
		local var0_20 = "CombatUI" .. var2_19
		local var1_20 = "CombatHPBar" .. var2_19
		local var2_20
		local var3_20
		local var4_20

		seriesAsync({
			function(arg0_21)
				PoolMgr.GetInstance():GetUI(var1_20, true, function(arg0_22)
					var3_20 = arg0_22

					arg0_21()
				end)
			end,
			function(arg0_23)
				PoolMgr.GetInstance():GetUI(var1_20, true, function(arg0_24)
					var4_20 = arg0_24

					arg0_23()
				end)
			end,
			function(arg0_25)
				PoolMgr.GetInstance():GetUI(var0_20, true, function(arg0_26)
					var2_20 = arg0_26

					arg0_25()
				end)
			end
		}, function()
			local var0_27 = pg.UIMgr.GetInstance().UIMain

			var2_20.transform:SetParent(arg0_19.preview, false)
			var3_20.transform:SetParent(arg0_19.preview, false)
			var4_20.transform:SetParent(arg0_19.preview, false)
			setActive(arg0_19.preview, true)

			local var1_27 = arg0_19.sea.rect.width
			local var2_27 = arg0_19.sea.rect.height

			var2_20.transform.localScale = Vector3(var1_27 / 1920, var2_27 / 1080, 1)
			arg0_19.previewer = CombatUIPreviewer.New(arg0_19.rawImage)

			arg0_19.previewer:setDisplayWeapon({
				100
			})
			arg0_19.previewer:setCombatUI(var2_20, var3_20, var4_20, var2_19)
			arg0_19.previewer:load(40000, var0_19, var1_19, {}, function()
				return
			end)
		end)
	end, SFX_PANEL)
	triggerButton(arg0_19.startShowBtn)
end

function var0_0.InitTitle(arg0_29, arg1_29)
	for iter0_29, iter1_29 in ipairs(arg1_29) do
		if iter1_29.type == DROP_TYPE_COMBAT_UI_STYLE then
			setScrollText(arg0_29.titleText, iter1_29:getName())

			local var0_29 = iter1_29.id
			local var1_29 = pg.item_data_battleui[var0_29]
			local var2_29 = var1_29.rare

			arg0_29.loader:GetSpriteQuiet("ui/combatskinrare", string.format("rare_%s", var2_29), arg0_29._tf:Find("mainPanel/topBar/left/rareImage"))
			arg0_29.toggleList:make(function(arg0_30, arg1_30, arg2_30)
				if arg0_30 == UIItemList.EventUpdate then
					local var0_30 = var1_29.rare_display[arg1_30 + 1]

					arg0_29.loader:GetSpriteQuiet("ui/combatskinrare", CombatSkinConst.TYPE_ICON_NAME[var0_30], findTF(arg2_30, "on"))
					arg0_29.loader:GetSpriteQuiet("ui/combatskinrare", string.format("%s_unselected", CombatSkinConst.TYPE_ICON_NAME[var0_30]), findTF(arg2_30, "off"))
					onToggle(arg0_29, arg2_30, function(arg0_31)
						setText(arg0_29.tipsText, i18n("battleui_display" .. var0_30))

						local var0_31 = arg0_29._tf:Find("mainPanel/topBar/left"):InverseTransformPoint(arg2_30.transform.position)

						setLocalPosition(arg0_29.tipsGo, var0_31 + Vector3(-20, 46, 0))
						arg0_29:ShowTips(arg0_31)
					end, SFX_CONFIRM)
				end
			end)
			arg0_29.toggleList:align(#var1_29.rare_display)
		end
	end
end

function var0_0.ClearPreviewer(arg0_32)
	if arg0_32.previewer then
		setActive(arg0_32.preview, false)
		arg0_32.previewer:clear()

		arg0_32.previewer = nil
	end
end

function var0_0.onBackPressed(arg0_33)
	arg0_33:ClearPreviewer()
	arg0_33:emit(var0_0.ON_BACK_PRESSED)
end

return var0_0
