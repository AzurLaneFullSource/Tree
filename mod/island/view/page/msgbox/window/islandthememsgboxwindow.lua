local var0_0 = class("IslandThemeMsgboxWindow", import(".IslandCommonMsgboxWindow"))

function var0_0.getUIName(arg0_1)
	return "IslandCommonMsgBoxForTheme"
end

function var0_0.OnLoaded(arg0_2)
	var0_0.super.OnLoaded(arg0_2)

	arg0_2.iconRaw = arg0_2:findTF("icon_raw"):GetComponent(typeof(RawImage))
	arg0_2.icon = arg0_2:findTF("icon"):GetComponent(typeof(Image))
	arg0_2.delBtn = arg0_2:findTF("delete")

	setText(arg0_2.delBtn:Find("Text"), i18n("island_btn_label_del"))
	setText(arg0_2:findTF("confirm/Text"), i18n("island_word_place"))
end

function var0_0.OnInit(arg0_3)
	var0_0.super.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.delBtn, function()
		if arg0_3.settings.onDel then
			arg0_3.settings.onDel()
		end

		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.OnShow(arg0_5)
	arg0_5.settings.content = arg0_5.settings.theme.name

	var0_0.super.OnShow(arg0_5)
	arg0_5:FlushIcon()
end

function var0_0.OnHide(arg0_6)
	var0_0.super.OnHide(arg0_6)

	if not IsNil(arg0_6.iconRaw.texture) then
		Object.Destroy(arg0_6.iconRaw.texture)

		arg0_6.iconRaw.texture = nil
	end
end

function var0_0.FlushBtn(arg0_7, arg1_7)
	return
end

function var0_0.FlushIcon(arg0_8)
	local var0_8 = arg0_8.settings.theme

	if isa(var0_8, AgoraTheme) then
		arg0_8:LoadRawTex(var0_8.id)
	else
		arg0_8:LoadImage(var0_8.id)
	end
end

function var0_0.LoadRawTex(arg0_9, arg1_9)
	local var0_9 = AgoraCalc.BuildScreenShootSavePath(arg1_9)

	if not PathMgr.FileExists(var0_9) then
		arg0_9:LoadImage(0)

		return
	end

	local var1_9 = System.IO.File.ReadAllBytes(var0_9)
	local var2_9 = UnityEngine.Texture2D.New(426, 320)

	Tex2DExtension.LoadImage(var2_9, var1_9)

	arg0_9.iconRaw.texture = var2_9

	setActive(arg0_9.iconRaw, true)
	setActive(arg0_9.icon, false)
end

function var0_0.LoadImage(arg0_10, arg1_10)
	LoadSpriteAsync("island/IslandThemeIcon/" .. arg1_10, function(arg0_11)
		arg0_10.icon.sprite = arg0_11

		arg0_10.icon:SetNativeSize()
	end)
	setActive(arg0_10.iconRaw, false)
	setActive(arg0_10.icon, true)
end

return var0_0
