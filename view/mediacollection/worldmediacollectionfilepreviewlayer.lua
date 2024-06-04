local var0 = class("WorldMediaCollectionFilePreviewLayer", import("view.base.BaseUI"))

function var0.__index(arg0, arg1)
	local var0 = rawget(var0, arg1) or var0.super[arg1]

	var0 = var0 or WorldMediaCollectionFileDetailLayer[arg1]

	return var0
end

function var0.getUIName(arg0)
	return "WorldMediaCollectionFilePreviewUI"
end

function var0.init(arg0)
	arg0.canvasGroup = arg0._tf:GetComponent(typeof(CanvasGroup))

	arg0:InitDocument()

	arg0.tipTF = arg0._tf:Find("Tip")
	arg0.animBar = arg0._tf:Find("Bar")

	setActive(arg0.animBar, false)
	setActive(arg0.document, false)
	setActive(arg0.tipTF, false)

	arg0.loader = AutoLoader.New()

	setText(arg0.animBar:Find("Text"), i18n("world_collection_back"))
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)

	local var0 = WorldCollectionProxy.GetCollectionTemplate(arg0.contextData.collectionId)

	arg0:SetDocument(var0)
	setActive(arg0.animBar, true)

	local var1 = arg0.animBar:Find("Anim/Frame/Mask"):GetComponent(typeof(LayoutElement))
	local var2 = arg0.animBar:Find("Anim/Frame/Mask/Name")
	local var3 = var2:GetComponent(typeof(Text))

	RemoveComponent(var2, typeof(ScrollText))

	local var4 = var1.preferredWidth

	var2.pivot = Vector2(0, 0.5)
	var2.anchorMin = Vector2(0, 0.5)
	var2.anchorMax = Vector2(0, 0.5)
	var2.anchoredPosition = Vector2.zero
	var3.text = tostring(var0.name or "")
	var1.preferredWidth = math.min(var3.preferredWidth, var4)

	local function var5()
		onButton(arg0, arg0._tf, function()
			arg0:closeView()
		end)
	end

	local function var6()
		if var3.preferredWidth > var4 then
			var2.pivot = Vector2(0.5, 0.5)
			var2.anchorMin = Vector2(0.5, 0.5)
			var2.anchorMax = Vector2(0.5, 0.5)

			setScrollText(var2, var0.name or "")
		end
	end

	local var7 = arg0.animBar:GetComponent(typeof(DftAniEvent))

	removeOnButton(arg0._tf)

	if var7 then
		var7:SetTriggerEvent(var6)
		var7:SetEndEvent(var5)
	else
		var6()
		var5()
	end

	onButton(arg0, arg0.animBar:Find("Button"), function()
		setActive(arg0.animBar, false)
		setActive(arg0.document, true)
		setActive(arg0.tipTF, true)
		var5()
	end, SFX_PANEL)

	local var8 = WorldCollectionProxy.GetCollectionGroup(var0.id)
	local var9 = WorldCollectionProxy.GetCollectionFileGroupTemplate(var8)

	setImageSprite(arg0.animBar:Find("Anim/Icon"), LoadSprite("ui/WorldMediaCollectionFilePreviewUI_atlas", var9.type))
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
	arg0.loader:Clear()

	local var0 = arg0.contextData.callback

	if var0 then
		var0()
	end

	var0.super.willExit(arg0)
end

return var0
