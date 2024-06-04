local var0 = class("ShipBreakResultLayer", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "ShipBreakResultUI"
end

function var0.init(arg0)
	arg0.frame = arg0:findTF("frame")
	arg0.attrPanel = arg0:findTF("right_panel/top/attrs")
	arg0.rarePanel = arg0:findTF("right_panel/top/rare")
	arg0.paintContain = arg0:findTF("paint")
	arg0.qCharaContain = arg0:findTF("right_panel/top/q_chara")
	arg0._chat = arg0:findTF("chat", arg0.paintContain)

	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = LayerWeightConst.TOP_LAYER
	})

	arg0._shake = arg0:findTF("shake_panel")
	arg0._bg = arg0:findTF("bg", arg0._shake)
	arg0._paintingShadowTF = arg0:findTF("shadow")
end

function var0.didEnter(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:emit(var0.ON_CLOSE)
	end, SFX_CANCEL)
end

local var1 = {
	"durability",
	"cannon",
	"torpedo",
	"antiaircraft",
	"air"
}

function var0.updateStatistics(arg0)
	local var0 = arg0.contextData.newShip
	local var1 = arg0.contextData.oldShip
	local var2 = intProperties(var0:getShipProperties())
	local var3 = intProperties(var1:getShipProperties())
	local var4 = arg0.attrPanel

	for iter0, iter1 in ipairs(var1) do
		local var5 = var4:GetChild(iter0 - 1)

		setText(var5:Find("name"), AttributeType.Type2Name(iter1))
		setText(var5:Find("value"), var3[iter1])
		setText(var5:Find("value1"), var2[iter1])

		local var6 = var5:Find("addition")
		local var7 = var2[iter1] - var3[iter1]

		if var7 == 0 then
			setActive(var6, false)
		else
			setText(var6, "+" .. var7)
		end
	end

	local var8 = var4:GetChild(5)
	local var9 = var1:getBattleTotalExpend()
	local var10 = var0:getBattleTotalExpend()

	setText(var8:Find("name"), AttributeType.Type2Name(AttributeType.Expend))
	setText(var8:Find("value"), var9)
	setText(var8:Find("value1"), var10)

	local var11 = var8:Find("addition")
	local var12 = math.abs(var10 - var9)

	if var12 == 0 then
		setActive(var11, false)
	else
		setText(var11, "+" .. var12)
	end

	local var13 = var0:getStar()
	local var14 = var1:getStar()
	local var15 = arg0.rarePanel:Find("stars_from")
	local var16 = arg0.rarePanel:Find("stars_to")

	for iter2 = 1, var14 do
		setActive(var15:GetChild(iter2 - 1), true)
	end

	for iter3 = 1, var13 do
		setActive(var16:GetChild(iter3 - 1), true)
	end

	setPaintingPrefabAsync(arg0.paintContain, var0:getPainting(), "chuanwu")
	setPaintingPrefabAsync(arg0._paintingShadowTF, var0:getPainting(), "chuanwu", function()
		local var0 = findTF(arg0._paintingShadowTF, "fitter"):GetChild(0)

		var0:GetComponent("Image").color = Color.New(0, 0, 0)

		local var1 = findTF(var0, "layers")

		if not IsNil(var1) then
			local var2 = var1:GetComponentsInChildren(typeof(Image))

			for iter0 = 1, var2.Length do
				var2[iter0 - 1].color = Color.New(0, 0, 0)
			end
		end

		local var3 = findTF(var0, "face")

		if not IsNil(var3) then
			var3:GetComponent("Image").color = Color.New(0, 0, 0)
		end
	end)

	local var17 = var0:getPrefab()

	pg.UIMgr.GetInstance():LoadingOn()
	PoolMgr.GetInstance():GetSpineChar(var17, true, function(arg0)
		pg.UIMgr.GetInstance():LoadingOff()

		arg0.shipPrefab = var17
		arg0.shipModel = arg0
		tf(arg0).localScale = Vector3(1, 1, 1)

		arg0:GetComponent("SpineAnimUI"):SetAction("stand", 0)
		setParent(arg0, arg0.qCharaContain)
	end)
	GetSpriteFromAtlasAsync("newshipbg/bg_" .. var0:rarity2bgPrintForGet(), "", function(arg0)
		setImageSprite(arg0._tf, arg0, false)
	end)

	local var18 = var0:getCVIntimacy()
	local var19, var20, var21 = ShipWordHelper.GetWordAndCV(var0.skinId, ShipWordHelper.WORD_TYPE_UPGRADE, nil, nil, var18)

	setWidgetText(arg0._chat, var21)

	local var22 = arg0:findTF("Text", arg0._chat):GetComponent(typeof(Text))

	var22.alignment = #var22.text > CHAT_POP_STR_LEN and TextAnchor.MiddleLeft or TextAnchor.MiddleCenter
	arg0._chat.transform.localScale = Vector3(0, 0, 1)
	arg0.delayTId = LeanTween.delayedCall(0.6, System.Action(function()
		SetActive(arg0._chat, true)
		LeanTween.scale(rtf(arg0._chat), Vector3.New(1, 1, 1), 0.3):setEase(LeanTweenType.easeOutBack)
		arg0:voice(var20)
	end)).id

	local var23 = var0
	local var24 = var23:isBluePrintShip()
	local var25 = var23:isMetaShip()

	GetSpriteFromAtlasAsync("newshipbg/bg_" .. var23:rarity2bgPrintForGet(), "", function(arg0)
		setImageSprite(arg0._bg, arg0)
	end)

	if var24 then
		if arg0.metaBg then
			setActive(arg0.metaBg, false)
		end

		if arg0.designBg and arg0.designName ~= "raritydesign" .. var23:getRarity() then
			PoolMgr.GetInstance():ReturnUI(arg0.designName, arg0.designBg)

			arg0.designBg = nil
		end

		if not arg0.designBg then
			PoolMgr.GetInstance():GetUI("raritydesign" .. var23:getRarity(), true, function(arg0)
				arg0.designBg = arg0
				arg0.designName = "raritydesign" .. var23:getRarity()

				arg0.transform:SetParent(arg0._shake, false)

				arg0.transform.localPosition = Vector3(1, 1, 1)
				arg0.transform.localScale = Vector3(1, 1, 1)

				arg0.transform:SetSiblingIndex(1)
				setActive(arg0, true)
			end)
		else
			setActive(arg0.designBg, true)
		end
	elseif var25 then
		if arg0.designBg then
			setActive(arg0.designBg, false)
		end

		if arg0.metaBg and arg0.metaName ~= "raritymeta" .. var23:getRarity() then
			PoolMgr.GetInstance():ReturnUI(arg0.metaName, arg0.metaBg)

			arg0.metaBg = nil
		end

		if not arg0.metaBg then
			PoolMgr.GetInstance():GetUI("raritymeta" .. var23:getRarity(), true, function(arg0)
				arg0.metaBg = arg0
				arg0.metaName = "raritymeta" .. var23:getRarity()

				arg0.transform:SetParent(arg0._shake, false)

				arg0.transform.localPosition = Vector3(1, 1, 1)
				arg0.transform.localScale = Vector3(1, 1, 1)

				arg0.transform:SetSiblingIndex(1)
				setActive(arg0, true)
			end)
		else
			setActive(arg0.metaBg, true)
		end
	else
		if arg0.designBg then
			setActive(arg0.designBg, false)
		end

		if arg0.metaBg then
			setActive(arg0.metaBg, false)
		end
	end

	PoolMgr.GetInstance():GetUI("tupo_" .. var23:getRarity(), true, function(arg0)
		arg0.transform:SetParent(arg0._tf, false)

		arg0.transform.localPosition = Vector3(1, 1, 1)
		arg0.transform.localScale = Vector3(1, 1, 1)

		arg0.transform:SetSiblingIndex(4)
		setActive(arg0, true)
	end)
	PoolMgr.GetInstance():GetUI(var23:isMetaShip() and "tupo_meta" or "tupo", true, function(arg0)
		arg0.transform:SetParent(arg0._tf, false)

		arg0.transform.localPosition = Vector3(1, 1, 1)
		arg0.transform.localScale = Vector3(1, 1, 1)

		arg0.transform:SetAsLastSibling()
		setActive(arg0, true)
	end)
end

function var0.voice(arg0, arg1)
	if not arg1 then
		return
	end

	arg0:stopVoice()
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg1)

	arg0._currentVoice = arg1
end

function var0.stopVoice(arg0)
	if arg0._currentVoice then
		pg.CriMgr.GetInstance():UnloadSoundEffect_V3(arg0._currentVoice)
	end

	arg0._currentVoice = nil
end

function var0.recycleSpineChar(arg0)
	if arg0.shipPrefab and arg0.shipModel then
		PoolMgr.GetInstance():ReturnSpineChar(arg0.shipPrefab, arg0.shipModel)

		arg0.shipPrefab = nil
		arg0.shipModel = nil
	end
end

function var0.willExit(arg0)
	if arg0.delayTId then
		LeanTween.cancel(arg0.delayTId)
	end

	arg0:recycleSpineChar()

	if arg0.designBg then
		PoolMgr.GetInstance():ReturnUI(arg0.designName, arg0.designBg)
	end

	if arg0.metaBg then
		PoolMgr.GetInstance():ReturnUI(arg0.metaName, arg0.metaBg)
	end

	arg0:stopVoice()

	if arg0.loadedCVBankName then
		pg.CriMgr.UnloadCVBank(arg0.loadedCVBankName)

		arg0.loadedCVBankName = nil
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, pg.UIMgr.GetInstance().UIMain)
end

return var0
