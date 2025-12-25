local var0_0 = class("Shrine2022SelectShipView", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "Shrine2022SelectShipUI"
end

function var0_0.OnInit(arg0_2)
	arg0_2:initData()
	arg0_2:initUI()
	arg0_2:updateCardList()
	arg0_2:Show()
	arg0_2:playEnterAni(true)
end

function var0_0.OnDestroy(arg0_3)
	arg0_3:cleanManagedTween()
end

function var0_0.setUIData(arg0_4)
	arg0_4.shipCardSpriteList = {}

	for iter0_4 = 1, 7 do
		local var0_4 = "cardselect_" .. iter0_4
		local var1_4 = "Shrine2022/" .. var0_4
		local var2_4 = LoadSprite(var1_4, var0_4)

		table.insert(arg0_4.shipCardSpriteList, var2_4)
	end

	arg0_4.shipNameSpriteList = {}

	for iter1_4 = 1, 7 do
		local var3_4 = "cardselectname_" .. iter1_4
		local var4_4 = "Shrine2022/" .. var3_4
		local var5_4 = LoadSprite(var4_4, var3_4)

		table.insert(arg0_4.shipNameSpriteList, var5_4)
	end
end

function var0_0.updateShipCardUI(arg0_5, arg1_5, arg2_5)
	setImageSprite(arg1_5, arg0_5.shipCardSpriteList[arg2_5], true)

	local var0_5 = arg1_5:Find("Name")

	setImageSprite(var0_5, arg0_5.shipNameSpriteList[arg2_5], true)
	setLocalPosition(arg1_5, arg0_5.cardPosList[arg2_5])

	local var1_5 = arg1_5:Find("Selected")
	local var2_5 = arg0_5:isSelected(arg2_5)

	setActive(var1_5, var2_5)
	setActive(var0_5, not var2_5)

	GetComponent(arg1_5, "Toggle").enabled = not var2_5
end

function var0_0.initData(arg0_6)
	arg0_6.cardPosList = {
		{
			x = -80,
			y = 240
		},
		{
			x = -80,
			y = 40
		},
		{
			x = -80,
			y = -162
		},
		{
			x = -80,
			y = -363
		},
		{
			x = 94,
			y = 195
		},
		{
			x = 94,
			y = -7
		},
		{
			x = 94,
			y = -210
		}
	}
	arg0_6.confirmPosList = {
		{
			x = -452,
			y = -34
		},
		{
			x = -160,
			y = -34
		},
		{
			x = 140,
			y = -34
		},
		{
			x = 440,
			y = -34
		},
		{
			x = -304,
			y = -400
		},
		{
			x = -6,
			y = -400
		},
		{
			x = 297,
			y = -400
		}
	}
	arg0_6.onCloseFunc = arg0_6.contextData.onClose
	arg0_6.onSelectFunc = arg0_6.contextData.onSelect
	arg0_6.onConfirmFunc = arg0_6.contextData.onConfirm
	arg0_6.shipGameID = arg0_6.contextData.shipGameID
	arg0_6.shipGameData = getProxy(MiniGameProxy):GetMiniGameData(arg0_6.shipGameID)
	arg0_6.selectingCardIndex = arg0_6.contextData.selectingCardIndex
	arg0_6.curSelectIndex = nil
end

function var0_0.initUI(arg0_7)
	arg0_7:setUIData()

	arg0_7.bg = arg0_7._tf:Find("BG")
	arg0_7.cardTpl = arg0_7._tf:Find("CardTpl")
	arg0_7.backBtn = arg0_7._tf:Find("Adapt/BackBtn")
	arg0_7.helpBtn = arg0_7._tf:Find("Adapt/HelpBtn")
	arg0_7.panelTF = arg0_7._tf:Find("Adapt/Panel")
	arg0_7.tipTF = arg0_7._tf:Find("Adapt/Tip")
	arg0_7.cardContainer = arg0_7.panelTF:Find("CardContainer")
	arg0_7.cardUIItemList = UIItemList.New(arg0_7.cardContainer, arg0_7.cardTpl)
	arg0_7.confirmBtn = arg0_7._tf:Find("ConfirmBtn")

	onButton(arg0_7, arg0_7.bg, function()
		arg0_7:closeSelf()
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.backBtn, function()
		arg0_7:closeSelf()
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.Pray_activity_tips1.tip
		})
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.confirmBtn, function()
		setActive(arg0_7.confirmBtn, false)
		arg0_7:confirmSelf()
	end, SFX_PANEL)
	arg0_7.cardUIItemList:make(function(arg0_12, arg1_12, arg2_12)
		if arg0_12 == UIItemList.EventUpdate then
			local var0_12 = arg1_12 + 1

			arg0_7:updateShipCardUI(arg2_12, var0_12)

			if not isSelected then
				onToggle(arg0_7, arg2_12, function(arg0_13)
					if arg0_13 then
						arg0_7.curSelectIndex = var0_12

						if arg0_7.onSelectFunc then
							arg0_7.onSelectFunc(var0_12)
						end
					end

					arg0_7:updateConfirmBtn(arg0_13)
				end, SFX_PANEL)
			end
		end
	end)
end

function var0_0.closeSelf(arg0_14)
	if arg0_14.isPlaying then
		return
	end

	arg0_14:playEnterAni(false, function()
		if arg0_14.onCloseFunc then
			arg0_14.onCloseFunc()
		end

		arg0_14:Destroy()
	end)
end

function var0_0.confirmSelf(arg0_16)
	if arg0_16.isPlaying then
		return
	end

	if arg0_16.onCloseFunc then
		arg0_16.onCloseFunc()
	end

	arg0_16:playEnterAni(false, function()
		if arg0_16.onConfirmFunc then
			arg0_16.onConfirmFunc(arg0_16.curSelectIndex)
		end

		arg0_16:Destroy()
	end)
end

function var0_0.updateConfirmBtn(arg0_18, arg1_18)
	local var0_18 = arg0_18.confirmPosList[arg0_18.selectingCardIndex]

	setLocalPosition(arg0_18.confirmBtn, var0_18)
	setActive(arg0_18.confirmBtn, arg1_18)
end

function var0_0.updateCardList(arg0_19)
	local var0_19 = 7

	arg0_19.cardUIItemList:align(var0_19)
end

function var0_0.playEnterAni(arg0_20, arg1_20, arg2_20)
	local var0_20 = arg1_20 and -1000 or 0
	local var1_20 = arg1_20 and 0 or -1000
	local var2_20 = 0.3
	local var3_20 = {
		x = var0_20,
		y = rtf(arg0_20.panelTF).anchoredPosition.y
	}

	arg0_20.isPlaying = true

	arg0_20:managedTween(LeanTween.value, nil, go(arg0_20.panelTF), var0_20, var1_20, var2_20):setOnUpdate(System.Action_float(function(arg0_21)
		var3_20.x = arg0_21

		setAnchoredPosition(arg0_20.panelTF, var3_20)
	end)):setOnComplete(System.Action(function()
		arg0_20.isPlaying = false

		if arg2_20 then
			arg2_20()
		end
	end))

	local var4_20 = arg1_20 and -100 or 38
	local var5_20 = arg1_20 and 38 or -100
	local var6_20 = {
		x = rtf(arg0_20.tipTF).anchoredPosition.x,
		y = var4_20
	}

	arg0_20:managedTween(LeanTween.value, nil, go(arg0_20.tipTF), var4_20, var5_20, var2_20):setOnUpdate(System.Action_float(function(arg0_23)
		var6_20.y = arg0_23

		setAnchoredPosition(arg0_20.tipTF, var6_20)
	end))
end

function var0_0.isSelected(arg0_24, arg1_24)
	local var0_24 = arg0_24.shipGameData:GetRuntimeData("kvpElements")[1]

	for iter0_24, iter1_24 in ipairs(var0_24) do
		if iter1_24.value == arg1_24 then
			return true
		end
	end

	return false
end

return var0_0
