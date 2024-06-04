local var0 = class("Shrine2022SelectShipView", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "Shrine2022SelectShipUI"
end

function var0.OnInit(arg0)
	arg0:initData()
	arg0:initUI()
	arg0:updateCardList()
	arg0:Show()
	arg0:playEnterAni(true)
end

function var0.OnDestroy(arg0)
	arg0:cleanManagedTween()
end

function var0.initData(arg0)
	arg0.cardPosList = {
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
	arg0.confirmPosList = {
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
	arg0.onCloseFunc = arg0.contextData.onClose
	arg0.onSelectFunc = arg0.contextData.onSelect
	arg0.onConfirmFunc = arg0.contextData.onConfirm
	arg0.shipGameID = arg0.contextData.shipGameID
	arg0.shipGameData = getProxy(MiniGameProxy):GetMiniGameData(arg0.shipGameID)
	arg0.selectingCardIndex = arg0.contextData.selectingCardIndex
	arg0.curSelectIndex = nil
end

function var0.initUI(arg0)
	arg0.bg = arg0:findTF("BG")
	arg0.cardTpl = arg0:findTF("CardTpl")
	arg0.backBtn = arg0:findTF("Adapt/BackBtn")
	arg0.helpBtn = arg0:findTF("Adapt/HelpBtn")
	arg0.panelTF = arg0:findTF("Adapt/Panel")
	arg0.tipTF = arg0:findTF("Adapt/Tip")
	arg0.cardContainer = arg0:findTF("CardContainer", arg0.panelTF)
	arg0.cardUIItemList = UIItemList.New(arg0.cardContainer, arg0.cardTpl)
	arg0.confirmBtn = arg0:findTF("ConfirmBtn")

	onButton(arg0, arg0.bg, function()
		arg0:closeSelf()
	end, SFX_PANEL)
	onButton(arg0, arg0.backBtn, function()
		arg0:closeSelf()
	end, SFX_PANEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.Pray_activity_tips1.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.confirmBtn, function()
		if arg0.onConfirmFunc then
			arg0.onConfirmFunc(arg0.curSelectIndex)
		end

		arg0:closeSelf()
	end, SFX_PANEL)
	arg0.cardUIItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1 + 1
			local var1 = "cardselect_" .. var0
			local var2 = "Shrine2022/" .. var1

			setImageSprite(arg2, LoadSprite(var2, var1), true)

			local var3 = arg0:findTF("Name", arg2)
			local var4 = "cardselectname_" .. var0
			local var5 = "Shrine2022/" .. var4

			setImageSprite(var3, LoadSprite(var5, var4), true)
			setLocalPosition(arg2, arg0.cardPosList[var0])

			local var6 = arg0:findTF("Selected", arg2)
			local var7 = arg0:isSelected(var0)

			setActive(var6, var7)
			setActive(var3, not var7)

			GetComponent(arg2, "Toggle").enabled = not var7

			if not var7 then
				onToggle(arg0, arg2, function(arg0)
					if arg0 then
						arg0.curSelectIndex = var0

						if arg0.onSelectFunc then
							arg0.onSelectFunc(var0)
						end
					end

					arg0:updateConfirmBtn(arg0)
				end, SFX_PANEL)
			end
		end
	end)
end

function var0.closeSelf(arg0)
	if arg0.isPlaying then
		return
	end

	if arg0.onCloseFunc then
		arg0.onCloseFunc()
	end

	arg0:playEnterAni(false, function()
		arg0:Destroy()
	end)
end

function var0.updateConfirmBtn(arg0, arg1)
	local var0 = arg0.confirmPosList[arg0.selectingCardIndex]

	setLocalPosition(arg0.confirmBtn, var0)
	setActive(arg0.confirmBtn, arg1)
end

function var0.updateCardList(arg0)
	local var0 = 7

	arg0.cardUIItemList:align(var0)
end

function var0.playEnterAni(arg0, arg1, arg2)
	local var0 = arg1 and -1000 or 0
	local var1 = arg1 and 0 or -1000
	local var2 = 0.3
	local var3 = {
		x = var0,
		y = rtf(arg0.panelTF).anchoredPosition.y
	}

	arg0.isPlaying = true

	arg0:managedTween(LeanTween.value, nil, go(arg0.panelTF), var0, var1, var2):setOnUpdate(System.Action_float(function(arg0)
		var3.x = arg0

		setAnchoredPosition(arg0.panelTF, var3)
	end)):setOnComplete(System.Action(function()
		arg0.isPlaying = false

		if arg2 then
			arg2()
		end
	end))

	local var4 = arg1 and -100 or 38
	local var5 = arg1 and 38 or -100
	local var6 = {
		x = rtf(arg0.tipTF).anchoredPosition.x,
		y = var4
	}

	arg0:managedTween(LeanTween.value, nil, go(arg0.tipTF), var4, var5, var2):setOnUpdate(System.Action_float(function(arg0)
		var6.y = arg0

		setAnchoredPosition(arg0.tipTF, var6)
	end))
end

function var0.isSelected(arg0, arg1)
	local var0 = arg0.shipGameData:GetRuntimeData("kvpElements")[1]

	for iter0, iter1 in ipairs(var0) do
		if iter1.value == arg1 then
			return true
		end
	end

	return false
end

return var0
