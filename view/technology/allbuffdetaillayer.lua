local var0_0 = class("AllBuffDetailLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "TechnologyTreeAllBuffUI"
end

function var0_0.init(arg0_2)
	arg0_2:initData()
	arg0_2:findUI()
end

function var0_0.didEnter(arg0_3)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf, false, {
		weight = arg0_3:getWeightFromData()
	})
	arg0_3:addListener()
	arg0_3:updateDetail()
end

function var0_0.willExit(arg0_4)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_4._tf)
end

function var0_0.initData(arg0_5)
	arg0_5.technologyNationProxy = getProxy(TechnologyNationProxy)
	arg0_5.tecList = arg0_5.technologyNationProxy:GetTecList()
	arg0_5.typeAttrTable, arg0_5.typeOrder, arg0_5.typeAttrOrderTable = arg0_5.technologyNationProxy:getTecBuff()
	arg0_5.typeOrder = ShipType.FilterOverQuZhuType(arg0_5.typeOrder)
end

function var0_0.findUI(arg0_6)
	arg0_6.backBtn = arg0_6:findTF("BG")
	arg0_6.scrollView = arg0_6:findTF("Scroll View")
	arg0_6.viewport = arg0_6:findTF("Viewport", arg0_6.scrollView)
	arg0_6.typeContainer = arg0_6:findTF("Content", arg0_6.viewport)
	arg0_6.typeItemTpl = arg0_6:findTF("TypeItemTpl")
	arg0_6.buffItemTpl = arg0_6:findTF("BuffItemTpl")
	arg0_6.scrollViewGroupCom = GetComponent(arg0_6.scrollView, "VerticalLayoutGroup")
	arg0_6.scrollViewFitterCom = GetComponent(arg0_6.scrollView, "ContentSizeFitter")
	arg0_6.viewportGroupCom = GetComponent(arg0_6.viewport, "VerticalLayoutGroup")
	arg0_6.viewportFitterCom = GetComponent(arg0_6.viewport, "ContentSizeFitter")
	arg0_6.setValueBtn = arg0_6:findTF("Scroll View/bg/SetValueBtn")
end

function var0_0.onBackPressed(arg0_7)
	triggerButton(arg0_7.backBtn)
end

function var0_0.addListener(arg0_8)
	onButton(arg0_8, arg0_8.backBtn, function()
		arg0_8:emit(var0_0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0_8, arg0_8.setValueBtn, function()
		if getProxy(ChapterProxy):getActiveChapter(true) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("attrset_disable"))
		else
			arg0_8:emit(AllBuffDetailMediator.OPEN_SET_VALUE_LAYER)
		end
	end, SFX_PANEL)
end

function var0_0.updateDetail(arg0_11)
	local var0_11 = UIItemList.New(arg0_11.typeContainer, arg0_11.typeItemTpl)

	var0_11:make(function(arg0_12, arg1_12, arg2_12)
		if arg0_12 == UIItemList.EventUpdate then
			local var0_12 = arg0_11:findTF("TypeTitle/TypeImg", arg2_12)
			local var1_12 = arg0_11:findTF("TypeTitle/TypeTextImg", arg2_12)
			local var2_12 = arg0_11:findTF("Container", arg2_12)
			local var3_12 = arg0_11.typeOrder[arg1_12 + 1]

			setImageSprite(var1_12, GetSpriteFromAtlas("ShipType", "ch_title_" .. var3_12))
			setImageSprite(var0_12, GetSpriteFromAtlas("ShipType", "buffitem_tec_" .. var3_12), true)
			Canvas.ForceUpdateCanvases()
			arg0_11:updateBuffList(var2_12, var3_12)
		end
	end)
	var0_11:align(#arg0_11.typeOrder)
	Canvas.ForceUpdateCanvases()

	if arg0_11.scrollView.rect.height >= 850 then
		arg0_11.viewportGroupCom.enabled = false
		arg0_11.viewportFitterCom.enabled = false
		arg0_11.scrollViewFitterCom.enabled = false
		arg0_11.scrollView.sizeDelta = Vector2.New(0, 850)
		GetComponent(arg0_11.scrollView, "ScrollRect").enabled = true
	end

	setActive(arg0_11.scrollView, false)
	setActive(arg0_11.scrollView, true)
end

function var0_0.updateBuffList(arg0_13, arg1_13, arg2_13)
	local var0_13 = UIItemList.New(arg1_13, arg0_13.buffItemTpl)
	local var1_13 = arg0_13.typeAttrTable[arg2_13]
	local var2_13 = arg0_13.typeAttrOrderTable[arg2_13]

	var0_13:make(function(arg0_14, arg1_14, arg2_14)
		if arg0_14 == UIItemList.EventUpdate then
			local var0_14 = arg0_13:findTF("AttrText", arg2_14)
			local var1_14 = arg0_13:findTF("ValueText", arg2_14)
			local var2_14 = var2_13[arg1_14 + 1]
			local var3_14 = var1_13[var2_14]
			local var4_14 = arg0_13.technologyNationProxy:getSetableAttrAdditionValueByTypeAttr(arg2_13, var2_14)

			setText(var0_14, AttributeType.Type2Name(pg.attribute_info_by_type[var2_14].name))

			local var5_14

			if var4_14 == var3_14 then
				var5_14 = "#00FF32FF"
			elseif var4_14 == 0 then
				var5_14 = "#CA5B5BFF"
			elseif var4_14 < var3_14 then
				var5_14 = "#A5BBD6FF"
			end

			setText(var1_14, setColorStr("+" .. var4_14, var5_14))
		end
	end)
	var0_13:align(#var2_13)
end

return var0_0
