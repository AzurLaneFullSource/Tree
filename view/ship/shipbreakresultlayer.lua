local var0_0 = class("ShipBreakResultLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "ShipBreakResultUI"
end

function var0_0.init(arg0_2)
	arg0_2.frame = arg0_2:findTF("frame")
	arg0_2.attrPanel = arg0_2:findTF("right_panel/top/attrs")
	arg0_2.rarePanel = arg0_2:findTF("right_panel/top/rare")
	arg0_2.paintContain = arg0_2:findTF("paint")
	arg0_2.qCharaContain = arg0_2:findTF("right_panel/top/q_chara")
	arg0_2._chat = arg0_2:findTF("chat", arg0_2.paintContain)

	pg.UIMgr.GetInstance():BlurPanel(arg0_2._tf, false, {
		weight = LayerWeightConst.TOP_LAYER
	})

	arg0_2._shake = arg0_2:findTF("shake_panel")
	arg0_2._bg = arg0_2:findTF("bg", arg0_2._shake)
	arg0_2._paintingShadowTF = arg0_2:findTF("shadow")
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:emit(var0_0.ON_CLOSE)
	end, SFX_CANCEL)
end

local var1_0 = {
	"durability",
	"cannon",
	"torpedo",
	"antiaircraft",
	"air"
}

function var0_0.updateStatistics(arg0_5)
	local var0_5 = arg0_5.contextData.newShip
	local var1_5 = arg0_5.contextData.oldShip
	local var2_5 = intProperties(var0_5:getShipProperties())
	local var3_5 = intProperties(var1_5:getShipProperties())
	local var4_5 = arg0_5.attrPanel

	for iter0_5, iter1_5 in ipairs(var1_0) do
		local var5_5 = var4_5:GetChild(iter0_5 - 1)

		setText(var5_5:Find("name"), AttributeType.Type2Name(iter1_5))
		setText(var5_5:Find("value"), var3_5[iter1_5])
		setText(var5_5:Find("value1"), var2_5[iter1_5])

		local var6_5 = var5_5:Find("addition")
		local var7_5 = var2_5[iter1_5] - var3_5[iter1_5]

		if var7_5 == 0 then
			setActive(var6_5, false)
		else
			setText(var6_5, "+" .. var7_5)
		end
	end

	local var8_5 = var4_5:GetChild(5)
	local var9_5 = var1_5:getBattleTotalExpend()
	local var10_5 = var0_5:getBattleTotalExpend()

	setText(var8_5:Find("name"), AttributeType.Type2Name(AttributeType.Expend))
	setText(var8_5:Find("value"), var9_5)
	setText(var8_5:Find("value1"), var10_5)

	local var11_5 = var8_5:Find("addition")
	local var12_5 = math.abs(var10_5 - var9_5)

	if var12_5 == 0 then
		setActive(var11_5, false)
	else
		setText(var11_5, "+" .. var12_5)
	end

	local var13_5 = var0_5:getStar()
	local var14_5 = var1_5:getStar()
	local var15_5 = arg0_5.rarePanel:Find("stars_from")
	local var16_5 = arg0_5.rarePanel:Find("stars_to")

	for iter2_5 = 1, var14_5 do
		setActive(var15_5:GetChild(iter2_5 - 1), true)
	end

	for iter3_5 = 1, var13_5 do
		setActive(var16_5:GetChild(iter3_5 - 1), true)
	end

	setPaintingPrefabAsync(arg0_5.paintContain, var0_5:getPainting(), "chuanwu")
	setPaintingPrefabAsync(arg0_5._paintingShadowTF, var0_5:getPainting(), "chuanwu", function()
		local var0_6 = findTF(arg0_5._paintingShadowTF, "fitter"):GetChild(0)

		var0_6:GetComponent("Image").color = Color.New(0, 0, 0)

		local var1_6 = findTF(var0_6, "layers")

		if not IsNil(var1_6) then
			local var2_6 = var1_6:GetComponentsInChildren(typeof(Image))

			for iter0_6 = 1, var2_6.Length do
				var2_6[iter0_6 - 1].color = Color.New(0, 0, 0)
			end
		end

		local var3_6 = findTF(var0_6, "face")

		if not IsNil(var3_6) then
			var3_6:GetComponent("Image").color = Color.New(0, 0, 0)
		end
	end)

	local var17_5 = var0_5:getPrefab()

	pg.UIMgr.GetInstance():LoadingOn()
	PoolMgr.GetInstance():GetSpineChar(var17_5, true, function(arg0_7)
		pg.UIMgr.GetInstance():LoadingOff()

		arg0_5.shipPrefab = var17_5
		arg0_5.shipModel = arg0_7
		tf(arg0_7).localScale = Vector3(1, 1, 1)

		arg0_7:GetComponent("SpineAnimUI"):SetAction("stand", 0)
		setParent(arg0_7, arg0_5.qCharaContain)
	end)
	GetSpriteFromAtlasAsync("newshipbg/bg_" .. var0_5:rarity2bgPrintForGet(), "", function(arg0_8)
		setImageSprite(arg0_5._tf, arg0_8, false)
	end)

	local var18_5 = var0_5:getCVIntimacy()
	local var19_5, var20_5, var21_5 = ShipWordHelper.GetWordAndCV(var0_5.skinId, ShipWordHelper.WORD_TYPE_UPGRADE, nil, nil, var18_5)

	setWidgetText(arg0_5._chat, var21_5)

	local var22_5 = arg0_5:findTF("Text", arg0_5._chat):GetComponent(typeof(Text))

	var22_5.alignment = #var22_5.text > CHAT_POP_STR_LEN and TextAnchor.MiddleLeft or TextAnchor.MiddleCenter
	arg0_5._chat.transform.localScale = Vector3(0, 0, 1)
	arg0_5.delayTId = LeanTween.delayedCall(0.6, System.Action(function()
		SetActive(arg0_5._chat, true)
		LeanTween.scale(rtf(arg0_5._chat), Vector3.New(1, 1, 1), 0.3):setEase(LeanTweenType.easeOutBack)
		arg0_5:voice(var20_5)
	end)).id

	local var23_5 = var0_5
	local var24_5 = var23_5:isBluePrintShip()
	local var25_5 = var23_5:isMetaShip()

	GetSpriteFromAtlasAsync("newshipbg/bg_" .. var23_5:rarity2bgPrintForGet(), "", function(arg0_10)
		setImageSprite(arg0_5._bg, arg0_10)
	end)

	if var24_5 then
		if arg0_5.metaBg then
			setActive(arg0_5.metaBg, false)
		end

		if arg0_5.designBg and arg0_5.designName ~= "raritydesign" .. var23_5:getRarity() then
			PoolMgr.GetInstance():ReturnUI(arg0_5.designName, arg0_5.designBg)

			arg0_5.designBg = nil
		end

		if not arg0_5.designBg then
			PoolMgr.GetInstance():GetUI("raritydesign" .. var23_5:getRarity(), true, function(arg0_11)
				arg0_5.designBg = arg0_11
				arg0_5.designName = "raritydesign" .. var23_5:getRarity()

				arg0_11.transform:SetParent(arg0_5._shake, false)

				arg0_11.transform.localPosition = Vector3(1, 1, 1)
				arg0_11.transform.localScale = Vector3(1, 1, 1)

				arg0_11.transform:SetSiblingIndex(1)
				setActive(arg0_11, true)
			end)
		else
			setActive(arg0_5.designBg, true)
		end
	elseif var25_5 then
		if arg0_5.designBg then
			setActive(arg0_5.designBg, false)
		end

		if arg0_5.metaBg and arg0_5.metaName ~= "raritymeta" .. var23_5:getRarity() then
			PoolMgr.GetInstance():ReturnUI(arg0_5.metaName, arg0_5.metaBg)

			arg0_5.metaBg = nil
		end

		if not arg0_5.metaBg then
			PoolMgr.GetInstance():GetUI("raritymeta" .. var23_5:getRarity(), true, function(arg0_12)
				arg0_5.metaBg = arg0_12
				arg0_5.metaName = "raritymeta" .. var23_5:getRarity()

				arg0_12.transform:SetParent(arg0_5._shake, false)

				arg0_12.transform.localPosition = Vector3(1, 1, 1)
				arg0_12.transform.localScale = Vector3(1, 1, 1)

				arg0_12.transform:SetSiblingIndex(1)
				setActive(arg0_12, true)
			end)
		else
			setActive(arg0_5.metaBg, true)
		end
	else
		if arg0_5.designBg then
			setActive(arg0_5.designBg, false)
		end

		if arg0_5.metaBg then
			setActive(arg0_5.metaBg, false)
		end
	end

	PoolMgr.GetInstance():GetUI("tupo_" .. var23_5:getRarity(), true, function(arg0_13)
		arg0_13.transform:SetParent(arg0_5._tf, false)

		arg0_13.transform.localPosition = Vector3(1, 1, 1)
		arg0_13.transform.localScale = Vector3(1, 1, 1)

		arg0_13.transform:SetSiblingIndex(4)
		setActive(arg0_13, true)
	end)
	PoolMgr.GetInstance():GetUI(var23_5:isMetaShip() and "tupo_meta" or "tupo", true, function(arg0_14)
		arg0_14.transform:SetParent(arg0_5._tf, false)

		arg0_14.transform.localPosition = Vector3(1, 1, 1)
		arg0_14.transform.localScale = Vector3(1, 1, 1)

		arg0_14.transform:SetAsLastSibling()
		setActive(arg0_14, true)
	end)
end

function var0_0.voice(arg0_15, arg1_15)
	if not arg1_15 then
		return
	end

	arg0_15:stopVoice()
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(arg1_15)

	arg0_15._currentVoice = arg1_15
end

function var0_0.stopVoice(arg0_16)
	if arg0_16._currentVoice then
		pg.CriMgr.GetInstance():UnloadSoundEffect_V3(arg0_16._currentVoice)
	end

	arg0_16._currentVoice = nil
end

function var0_0.recycleSpineChar(arg0_17)
	if arg0_17.shipPrefab and arg0_17.shipModel then
		PoolMgr.GetInstance():ReturnSpineChar(arg0_17.shipPrefab, arg0_17.shipModel)

		arg0_17.shipPrefab = nil
		arg0_17.shipModel = nil
	end
end

function var0_0.willExit(arg0_18)
	if arg0_18.delayTId then
		LeanTween.cancel(arg0_18.delayTId)
	end

	arg0_18:recycleSpineChar()

	if arg0_18.designBg then
		PoolMgr.GetInstance():ReturnUI(arg0_18.designName, arg0_18.designBg)
	end

	if arg0_18.metaBg then
		PoolMgr.GetInstance():ReturnUI(arg0_18.metaName, arg0_18.metaBg)
	end

	arg0_18:stopVoice()

	if arg0_18.loadedCVBankName then
		pg.CriMgr.UnloadCVBank(arg0_18.loadedCVBankName)

		arg0_18.loadedCVBankName = nil
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0_18._tf, pg.UIMgr.GetInstance().UIMain)
end

return var0_0
