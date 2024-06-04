local var0 = class("LevelStageAtelierMaterialToast", import("view.base.BaseSubPanel"))

function var0.getUIName(arg0)
	return "LevelStageAtelierMaterialToast"
end

function var0.OnInit(arg0)
	return
end

function var0.OnLoaded(arg0)
	return
end

local var1 = 26
local var2 = 47
local var3 = 196

function var0.Play(arg0, arg1)
	local var0 = arg0.contextData.settings

	setText(arg0._tf:Find("Title"), var0.title)

	local var1 = arg0._tf:Find("Desc")
	local var2 = GetComponent(var1, typeof(Text))
	local var3 = WorldMediaCollectionFileDetailLayer.getTextPreferredHeight(var2, var1.rect.width, var0.desc)
	local var4 = 2

	while var3 > var1 + var2 * (var4 - 1) do
		var4 = var4 + 1
	end

	CustomIndexLayer.Clone2Full(arg0._tf:Find("Lines"), var4 + 1)
	setSizeDelta(arg0._tf, {
		x = arg0._tf.sizeDelta.x,
		y = var3 + math.max(var4 - 2, 0) * var2
	})
	setText(var1, var0.desc)

	if var0.icon then
		local var5 = var0.iconScale or 1

		LoadImageSpriteAtlasAsync("ui/ryzaicon_atlas", var0.icon, arg0._tf:Find("Image"))
		setLocalScale(arg0._tf:Find("Image"), {
			x = var5,
			y = var5
		})
	end

	if var0.voice then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var0.voice)
	end

	arg0._go.transform:SetParent(pg.UIMgr.GetInstance().OverlayToast, false)
	GetComponent(arg0._tf, typeof(DftAniEvent)):SetEndEvent(function()
		arg0:Destroy()
		existCall(arg1)
	end)
end

function var0.OnDestroy(arg0)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf)
	LeanTween.cancel(arg0._go)
end

return var0
