local var0_0 = class("WorldMediaCollectionFilePreviewLayer", import("view.base.BaseUI"))

function var0_0.__index(arg0_1, arg1_1)
	local var0_1 = rawget(var0_0, arg1_1) or var0_0.super[arg1_1]

	var0_1 = var0_1 or WorldMediaCollectionFileDetailLayer[arg1_1]

	return var0_1
end

function var0_0.getUIName(arg0_2)
	return "WorldMediaCollectionFilePreviewUI"
end

function var0_0.init(arg0_3)
	arg0_3.canvasGroup = arg0_3._tf:GetComponent(typeof(CanvasGroup))

	arg0_3:InitDocument()

	arg0_3.tipTF = arg0_3._tf:Find("Tip")

	setText(arg0_3.tipTF, i18n("world_file_tip"))

	arg0_3.animBar = arg0_3._tf:Find("Bar")

	setActive(arg0_3.animBar, false)
	setActive(arg0_3.document, false)
	setActive(arg0_3.tipTF, false)

	arg0_3.loader = AutoLoader.New()

	setText(arg0_3.animBar:Find("Text"), i18n("world_collection_back"))
end

function var0_0.didEnter(arg0_4)
	pg.UIMgr.GetInstance():BlurPanel(arg0_4._tf)

	local var0_4 = WorldCollectionProxy.GetCollectionTemplate(arg0_4.contextData.collectionId)

	arg0_4:SetDocument(var0_4)
	setActive(arg0_4.animBar, true)

	local var1_4 = arg0_4.animBar:Find("Anim/Frame/Mask"):GetComponent(typeof(LayoutElement))
	local var2_4 = arg0_4.animBar:Find("Anim/Frame/Mask/Name")
	local var3_4 = var2_4:GetComponent(typeof(Text))

	RemoveComponent(var2_4, typeof(ScrollText))

	local var4_4 = var1_4.preferredWidth

	var2_4.pivot = Vector2(0, 0.5)
	var2_4.anchorMin = Vector2(0, 0.5)
	var2_4.anchorMax = Vector2(0, 0.5)
	var2_4.anchoredPosition = Vector2.zero
	var3_4.text = tostring(var0_4.name or "")
	var1_4.preferredWidth = math.min(var3_4.preferredWidth, var4_4)

	local function var5_4()
		onButton(arg0_4, arg0_4._tf, function()
			arg0_4:closeView()
		end)
	end

	local function var6_4()
		if var3_4.preferredWidth > var4_4 then
			var2_4.pivot = Vector2(0.5, 0.5)
			var2_4.anchorMin = Vector2(0.5, 0.5)
			var2_4.anchorMax = Vector2(0.5, 0.5)

			setScrollText(var2_4, var0_4.name or "")
		end
	end

	local var7_4 = arg0_4.animBar:GetComponent(typeof(DftAniEvent))

	removeOnButton(arg0_4._tf)

	if var7_4 then
		var7_4:SetTriggerEvent(var6_4)
		var7_4:SetEndEvent(var5_4)
	else
		var6_4()
		var5_4()
	end

	onButton(arg0_4, arg0_4.animBar:Find("Button"), function()
		setActive(arg0_4.animBar, false)
		setActive(arg0_4.document, true)
		setActive(arg0_4.tipTF, true)
		var5_4()
	end, SFX_PANEL)

	local var8_4 = WorldCollectionProxy.GetCollectionGroup(var0_4.id)
	local var9_4 = WorldCollectionProxy.GetCollectionFileGroupTemplate(var8_4)

	setImageSprite(arg0_4.animBar:Find("Anim/Icon"), LoadSprite("ui/WorldMediaCollectionFilePreviewUI_atlas", var9_4.type))
end

function var0_0.willExit(arg0_9)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_9._tf)
	arg0_9.loader:Clear()

	local var0_9 = arg0_9.contextData.callback

	if var0_9 then
		var0_9()
	end

	var0_0.super.willExit(arg0_9)
end

return var0_0
