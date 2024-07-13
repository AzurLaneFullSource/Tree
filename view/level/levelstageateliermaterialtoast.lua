local var0_0 = class("LevelStageAtelierMaterialToast", import("view.base.BaseSubPanel"))

function var0_0.getUIName(arg0_1)
	return "LevelStageAtelierMaterialToast"
end

function var0_0.OnInit(arg0_2)
	return
end

function var0_0.OnLoaded(arg0_3)
	return
end

local var1_0 = 26
local var2_0 = 47
local var3_0 = 196

function var0_0.Play(arg0_4, arg1_4)
	local var0_4 = arg0_4.contextData.settings

	setText(arg0_4._tf:Find("Title"), var0_4.title)

	local var1_4 = arg0_4._tf:Find("Desc")
	local var2_4 = GetComponent(var1_4, typeof(Text))
	local var3_4 = WorldMediaCollectionFileDetailLayer.getTextPreferredHeight(var2_4, var1_4.rect.width, var0_4.desc)
	local var4_4 = 2

	while var3_4 > var1_0 + var2_0 * (var4_4 - 1) do
		var4_4 = var4_4 + 1
	end

	CustomIndexLayer.Clone2Full(arg0_4._tf:Find("Lines"), var4_4 + 1)
	setSizeDelta(arg0_4._tf, {
		x = arg0_4._tf.sizeDelta.x,
		y = var3_0 + math.max(var4_4 - 2, 0) * var2_0
	})
	setText(var1_4, var0_4.desc)

	if var0_4.icon then
		local var5_4 = var0_4.iconScale or 1

		LoadImageSpriteAtlasAsync("ui/ryzaicon_atlas", var0_4.icon, arg0_4._tf:Find("Image"))
		setLocalScale(arg0_4._tf:Find("Image"), {
			x = var5_4,
			y = var5_4
		})
	end

	if var0_4.voice then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var0_4.voice)
	end

	arg0_4._go.transform:SetParent(pg.UIMgr.GetInstance().OverlayToast, false)
	GetComponent(arg0_4._tf, typeof(DftAniEvent)):SetEndEvent(function()
		arg0_4:Destroy()
		existCall(arg1_4)
	end)
end

function var0_0.OnDestroy(arg0_6)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_6._tf)
	LeanTween.cancel(arg0_6._go)
end

return var0_0
