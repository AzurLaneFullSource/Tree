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

function var0_0.initData(arg0_4)
	arg0_4.cardPosList = {
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
	arg0_4.confirmPosList = {
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
	arg0_4.onCloseFunc = arg0_4.contextData.onClose
	arg0_4.onSelectFunc = arg0_4.contextData.onSelect
	arg0_4.onConfirmFunc = arg0_4.contextData.onConfirm
	arg0_4.shipGameID = arg0_4.contextData.shipGameID
	arg0_4.shipGameData = getProxy(MiniGameProxy):GetMiniGameData(arg0_4.shipGameID)
	arg0_4.selectingCardIndex = arg0_4.contextData.selectingCardIndex
	arg0_4.curSelectIndex = nil
end

function var0_0.initUI(arg0_5)
	arg0_5.bg = arg0_5:findTF("BG")
	arg0_5.cardTpl = arg0_5:findTF("CardTpl")
	arg0_5.backBtn = arg0_5:findTF("Adapt/BackBtn")
	arg0_5.helpBtn = arg0_5:findTF("Adapt/HelpBtn")
	arg0_5.panelTF = arg0_5:findTF("Adapt/Panel")
	arg0_5.tipTF = arg0_5:findTF("Adapt/Tip")
	arg0_5.cardContainer = arg0_5:findTF("CardContainer", arg0_5.panelTF)
	arg0_5.cardUIItemList = UIItemList.New(arg0_5.cardContainer, arg0_5.cardTpl)
	arg0_5.confirmBtn = arg0_5:findTF("ConfirmBtn")

	onButton(arg0_5, arg0_5.bg, function()
		arg0_5:closeSelf()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.backBtn, function()
		arg0_5:closeSelf()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.Pray_activity_tips1.tip
		})
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.confirmBtn, function()
		if arg0_5.onConfirmFunc then
			arg0_5.onConfirmFunc(arg0_5.curSelectIndex)
		end

		arg0_5:closeSelf()
	end, SFX_PANEL)
	arg0_5.cardUIItemList:make(function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventUpdate then
			local var0_10 = arg1_10 + 1
			local var1_10 = "cardselect_" .. var0_10
			local var2_10 = "Shrine2022/" .. var1_10

			setImageSprite(arg2_10, LoadSprite(var2_10, var1_10), true)

			local var3_10 = arg0_5:findTF("Name", arg2_10)
			local var4_10 = "cardselectname_" .. var0_10
			local var5_10 = "Shrine2022/" .. var4_10

			setImageSprite(var3_10, LoadSprite(var5_10, var4_10), true)
			setLocalPosition(arg2_10, arg0_5.cardPosList[var0_10])

			local var6_10 = arg0_5:findTF("Selected", arg2_10)
			local var7_10 = arg0_5:isSelected(var0_10)

			setActive(var6_10, var7_10)
			setActive(var3_10, not var7_10)

			GetComponent(arg2_10, "Toggle").enabled = not var7_10

			if not var7_10 then
				onToggle(arg0_5, arg2_10, function(arg0_11)
					if arg0_11 then
						arg0_5.curSelectIndex = var0_10

						if arg0_5.onSelectFunc then
							arg0_5.onSelectFunc(var0_10)
						end
					end

					arg0_5:updateConfirmBtn(arg0_11)
				end, SFX_PANEL)
			end
		end
	end)
end

function var0_0.closeSelf(arg0_12)
	if arg0_12.isPlaying then
		return
	end

	if arg0_12.onCloseFunc then
		arg0_12.onCloseFunc()
	end

	arg0_12:playEnterAni(false, function()
		arg0_12:Destroy()
	end)
end

function var0_0.updateConfirmBtn(arg0_14, arg1_14)
	local var0_14 = arg0_14.confirmPosList[arg0_14.selectingCardIndex]

	setLocalPosition(arg0_14.confirmBtn, var0_14)
	setActive(arg0_14.confirmBtn, arg1_14)
end

function var0_0.updateCardList(arg0_15)
	local var0_15 = 7

	arg0_15.cardUIItemList:align(var0_15)
end

function var0_0.playEnterAni(arg0_16, arg1_16, arg2_16)
	local var0_16 = arg1_16 and -1000 or 0
	local var1_16 = arg1_16 and 0 or -1000
	local var2_16 = 0.3
	local var3_16 = {
		x = var0_16,
		y = rtf(arg0_16.panelTF).anchoredPosition.y
	}

	arg0_16.isPlaying = true

	arg0_16:managedTween(LeanTween.value, nil, go(arg0_16.panelTF), var0_16, var1_16, var2_16):setOnUpdate(System.Action_float(function(arg0_17)
		var3_16.x = arg0_17

		setAnchoredPosition(arg0_16.panelTF, var3_16)
	end)):setOnComplete(System.Action(function()
		arg0_16.isPlaying = false

		if arg2_16 then
			arg2_16()
		end
	end))

	local var4_16 = arg1_16 and -100 or 38
	local var5_16 = arg1_16 and 38 or -100
	local var6_16 = {
		x = rtf(arg0_16.tipTF).anchoredPosition.x,
		y = var4_16
	}

	arg0_16:managedTween(LeanTween.value, nil, go(arg0_16.tipTF), var4_16, var5_16, var2_16):setOnUpdate(System.Action_float(function(arg0_19)
		var6_16.y = arg0_19

		setAnchoredPosition(arg0_16.tipTF, var6_16)
	end))
end

function var0_0.isSelected(arg0_20, arg1_20)
	local var0_20 = arg0_20.shipGameData:GetRuntimeData("kvpElements")[1]

	for iter0_20, iter1_20 in ipairs(var0_20) do
		if iter1_20.value == arg1_20 then
			return true
		end
	end

	return false
end

return var0_0
