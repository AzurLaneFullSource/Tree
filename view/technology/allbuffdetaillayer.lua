local var0 = class("AllBuffDetailLayer", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "TechnologyTreeAllBuffUI"
end

function var0.init(arg0)
	arg0:initData()
	arg0:findUI()
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = arg0:getWeightFromData()
	})
	arg0:addListener()
	arg0:updateDetail()
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

function var0.initData(arg0)
	arg0.technologyNationProxy = getProxy(TechnologyNationProxy)
	arg0.tecList = arg0.technologyNationProxy:GetTecList()
	arg0.typeAttrTable, arg0.typeOrder, arg0.typeAttrOrderTable = arg0.technologyNationProxy:getTecBuff()
	arg0.typeOrder = ShipType.FilterOverQuZhuType(arg0.typeOrder)
end

function var0.findUI(arg0)
	arg0.backBtn = arg0:findTF("BG")
	arg0.scrollView = arg0:findTF("Scroll View")
	arg0.viewport = arg0:findTF("Viewport", arg0.scrollView)
	arg0.typeContainer = arg0:findTF("Content", arg0.viewport)
	arg0.typeItemTpl = arg0:findTF("TypeItemTpl")
	arg0.buffItemTpl = arg0:findTF("BuffItemTpl")
	arg0.scrollViewGroupCom = GetComponent(arg0.scrollView, "VerticalLayoutGroup")
	arg0.scrollViewFitterCom = GetComponent(arg0.scrollView, "ContentSizeFitter")
	arg0.viewportGroupCom = GetComponent(arg0.viewport, "VerticalLayoutGroup")
	arg0.viewportFitterCom = GetComponent(arg0.viewport, "ContentSizeFitter")
	arg0.setValueBtn = arg0:findTF("Scroll View/bg/SetValueBtn")
end

function var0.onBackPressed(arg0)
	triggerButton(arg0.backBtn)
end

function var0.addListener(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:emit(var0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0, arg0.setValueBtn, function()
		if getProxy(ChapterProxy):getActiveChapter(true) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("attrset_disable"))
		else
			arg0:emit(AllBuffDetailMediator.OPEN_SET_VALUE_LAYER)
		end
	end, SFX_PANEL)
end

function var0.updateDetail(arg0)
	local var0 = UIItemList.New(arg0.typeContainer, arg0.typeItemTpl)

	var0:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0:findTF("TypeTitle/TypeImg", arg2)
			local var1 = arg0:findTF("TypeTitle/TypeTextImg", arg2)
			local var2 = arg0:findTF("Container", arg2)
			local var3 = arg0.typeOrder[arg1 + 1]

			setImageSprite(var1, GetSpriteFromAtlas("ShipType", "ch_title_" .. var3))
			setImageSprite(var0, GetSpriteFromAtlas("ShipType", "buffitem_tec_" .. var3), true)
			Canvas.ForceUpdateCanvases()
			arg0:updateBuffList(var2, var3)
		end
	end)
	var0:align(#arg0.typeOrder)
	Canvas.ForceUpdateCanvases()

	if arg0.scrollView.rect.height >= 850 then
		arg0.viewportGroupCom.enabled = false
		arg0.viewportFitterCom.enabled = false
		arg0.scrollViewFitterCom.enabled = false
		arg0.scrollView.sizeDelta = Vector2.New(0, 850)
		GetComponent(arg0.scrollView, "ScrollRect").enabled = true
	end

	setActive(arg0.scrollView, false)
	setActive(arg0.scrollView, true)
end

function var0.updateBuffList(arg0, arg1, arg2)
	local var0 = UIItemList.New(arg1, arg0.buffItemTpl)
	local var1 = arg0.typeAttrTable[arg2]
	local var2 = arg0.typeAttrOrderTable[arg2]

	var0:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0:findTF("AttrText", arg2)
			local var1 = arg0:findTF("ValueText", arg2)
			local var2 = var2[arg1 + 1]
			local var3 = var1[var2]
			local var4 = arg0.technologyNationProxy:getSetableAttrAdditionValueByTypeAttr(arg2, var2)

			setText(var0, AttributeType.Type2Name(pg.attribute_info_by_type[var2].name))

			local var5

			if var4 == var3 then
				var5 = "#00FF32FF"
			elseif var4 == 0 then
				var5 = "#CA5B5BFF"
			elseif var4 < var3 then
				var5 = "#A5BBD6FF"
			end

			setText(var1, setColorStr("+" .. var4, var5))
		end
	end)
	var0:align(#var2)
end

return var0
