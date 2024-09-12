local var0_0 = class("ChargeBattleUISellLayer", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "ChargeBattleUISellLayer"
end

function var0_0.init(arg0_2)
	arg0_2:InitData()
	arg0_2:InitUI()
	arg0_2:updateGiftWindow()
	arg0_2:InitBattleShow()
end

function var0_0.didEnter(arg0_3)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf)
end

function var0_0.willExit(arg0_4)
	arg0_4:ClearPreviewer()
	pg.UIMgr.GetInstance():UnblurPanel(arg0_4._tf)
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
	arg0_6.bg = arg0_6:findTF("BG")
	arg0_6.titleText = arg0_6:findTF("mainPanel/topBar/left/titleText")
	arg0_6.tipText = arg0_6:findTF("mainPanel/topBar/left/tipText")
	arg0_6.middleText = arg0_6:findTF("mainPanel/topBar/middle/Text")
	arg0_6.closeBtn = arg0_6:findTF("mainPanel/topBar/right")
	arg0_6.startShowBtn = arg0_6:findTF("mainPanel/main/showWindow")
	arg0_6.normalWindow = arg0_6:findTF("mainPanel/main/normalWindow")
	arg0_6.specialWindow = arg0_6:findTF("mainPanel/main/specialWindow")
	arg0_6.normalText = arg0_6:findTF("title", arg0_6.normalWindow)
	arg0_6.specialText = arg0_6:findTF("title", arg0_6.specialWindow)
	arg0_6.buyNormalBtn = arg0_6:findTF("buyNormalButton", arg0_6.normalWindow)
	arg0_6.buySpecialBtn = arg0_6:findTF("buySpecialButton", arg0_6.specialWindow)

	local var0_6 = GetComponent(arg0_6._tf, "ItemList").prefabItem[0]
	local var1_6 = Instantiate(var0_6)

	arg0_6.itemTpl = arg0_6:findTF("itemTpl")

	local var2_6 = arg0_6:findTF("Container", arg0_6.itemTpl)

	setParent(var1_6, var2_6, false)

	arg0_6.normalList = UIItemList.New(arg0_6:findTF("list", arg0_6.normalWindow), arg0_6.itemTpl)
	arg0_6.specialList = UIItemList.New(arg0_6:findTF("list", arg0_6.specialWindow), arg0_6.itemTpl)

	setText(arg0_6.titleText, "")
	setText(arg0_6.tipText, i18n("ui_pack_tip1"))
	setText(arg0_6.normalText, i18n("ui_pack_tip2"))
	setText(arg0_6.specialText, i18n("ui_pack_tip3"))

	arg0_6.preview = arg0_6:findTF("mainPanel/main/preview")
	arg0_6.sea = arg0_6:findTF("sea", arg0_6.preview)
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
end

function var0_0.updateGiftWindow(arg0_9)
	onButton(arg0_9, arg0_9.buyNormalBtn, function()
		pg.m02:sendNotification(GAME.CHARGE_OPERATION, {
			shopId = arg0_9.normalGoodVO.id
		})
		arg0_9:ClearPreviewer()
		arg0_9:closeView()
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.buySpecialBtn, function()
		pg.m02:sendNotification(GAME.CHARGE_OPERATION, {
			shopId = arg0_9.specailGoodVO.id
		})
		arg0_9:ClearPreviewer()
		arg0_9:closeView()
	end, SFX_PANEL)

	local var0_9 = {}

	for iter0_9, iter1_9 in ipairs(arg0_9.normalGoodVO:GetExtraServiceItem()) do
		table.insert(var0_9, iter1_9)

		if not arg0_9.battleSkinId then
			arg0_9.battleSkinId = iter1_9.id
		end
	end

	arg0_9.normalList:make(function(arg0_12, arg1_12, arg2_12)
		if arg0_12 == UIItemList.EventUpdate then
			local var0_12 = arg0_9:findTF("Container", arg2_12):GetChild(0)
			local var1_12 = arg0_9:findTF("TextMask/Text", arg2_12)
			local var2_12 = var0_9[arg1_12 + 1]

			updateDrop(var0_12, var2_12)
			onButton(arg0_9, var0_12, function()
				arg0_9:emit(BaseUI.ON_DROP, var2_12)
			end, SFX_PANEL)
			setScrollText(var1_12, var2_12:getName())

			if arg0_9.titleText:GetComponent(typeof(Text)).text == "" then
				setText(arg0_9.titleText, var2_12:getName())
			end
		end
	end)
	arg0_9.normalList:align(#var0_9)

	var0_9 = {}

	for iter2_9, iter3_9 in ipairs(arg0_9.specailGoodVO:GetExtraServiceItem()) do
		table.insert(var0_9, iter3_9)
	end

	arg0_9.specialList:make(function(arg0_14, arg1_14, arg2_14)
		if arg0_14 == UIItemList.EventUpdate then
			local var0_14 = arg0_9:findTF("Container", arg2_14):GetChild(0)
			local var1_14 = arg0_9:findTF("TextMask/Text", arg2_14)
			local var2_14 = var0_9[arg1_14 + 1]

			updateDrop(var0_14, var2_14)
			onButton(arg0_9, var0_14, function()
				arg0_9:emit(BaseUI.ON_DROP, var2_14)
			end, SFX_PANEL)
			setScrollText(var1_14, var2_14:getName())
		end
	end)
	arg0_9.specialList:align(#var0_9)
end

function var0_0.InitBattleShow(arg0_16)
	local var0_16 = Ship.New({
		id = 100001,
		configId = 100001,
		skin_id = 100000
	})
	local var1_16 = Ship.New({
		id = 100011,
		configId = 100011,
		skin_id = 100010
	})
	local var2_16 = pg.item_data_battleui[arg0_16.battleSkinId].key

	onButton(arg0_16, arg0_16.startShowBtn, function()
		local var0_17 = "CombatUI" .. var2_16
		local var1_17 = "CombatHPBar" .. var2_16
		local var2_17
		local var3_17
		local var4_17

		seriesAsync({
			function(arg0_18)
				PoolMgr.GetInstance():GetUI(var1_17, true, function(arg0_19)
					var3_17 = arg0_19

					arg0_18()
				end)
			end,
			function(arg0_20)
				PoolMgr.GetInstance():GetUI(var1_17, true, function(arg0_21)
					var4_17 = arg0_21

					arg0_20()
				end)
			end,
			function(arg0_22)
				PoolMgr.GetInstance():GetUI(var0_17, true, function(arg0_23)
					var2_17 = arg0_23

					arg0_22()
				end)
			end
		}, function()
			local var0_24 = pg.UIMgr.GetInstance().UIMain

			var2_17.transform:SetParent(arg0_16.preview, false)
			var3_17.transform:SetParent(arg0_16.preview, false)
			var4_17.transform:SetParent(arg0_16.preview, false)
			setActive(arg0_16.preview, true)

			local var1_24 = arg0_16.sea.rect.width
			local var2_24 = arg0_16.sea.rect.height

			var2_17.transform.localScale = Vector3(var1_24 / 1920, var2_24 / 1080, 1)
			arg0_16.previewer = CombatUIPreviewer.New(arg0_16.rawImage)

			arg0_16.previewer:setDisplayWeapon({
				100
			})
			arg0_16.previewer:setCombatUI(var2_17, var3_17, var4_17, var2_16)
			arg0_16.previewer:load(40000, var0_16, var1_16, {}, function()
				return
			end)
		end)
	end, SFX_PANEL)
	triggerButton(arg0_16.startShowBtn)
end

function var0_0.ClearPreviewer(arg0_26)
	if arg0_26.previewer then
		setActive(arg0_26.preview, false)
		arg0_26.previewer:clear()

		arg0_26.previewer = nil
	end
end

function var0_0.onBackPressed(arg0_27)
	arg0_27:ClearPreviewer()
	arg0_27:emit(var0_0.ON_BACK_PRESSED)
end

return var0_0
