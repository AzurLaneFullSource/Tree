local var0_0 = class("IslandSaveThemeMsgboxWindow", import(".IslandCommonMsgboxWindow"))

function var0_0.getUIName(arg0_1)
	return "IslandCommonMsgBoxForSaveTheme"
end

function var0_0.OnLoaded(arg0_2)
	var0_0.super.OnLoaded(arg0_2)

	arg0_2.icon = arg0_2:findTF("icon")
	arg0_2.iconRaw = arg0_2:findTF("icon_raw"):GetComponent(typeof(RawImage))
	arg0_2.inputTr = arg0_2:findTF("input")
end

function var0_0.OnInit(arg0_3)
	var0_0.super.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		local var0_4 = getInputText(arg0_3.inputTr)

		if not var0_4 or var0_4 == "" then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_input_theme_name"))

			return
		end

		if arg0_3.onYes then
			arg0_3.onYes(var0_4)
		end

		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.OnShow(arg0_5)
	setInputText(arg0_5.inputTr, i18n("island_custom_theme_name", arg0_5.settings.id))

	arg0_5.settings.content = i18n("island_custom_theme_name_tip")

	var0_0.super.OnShow(arg0_5)
	arg0_5:FlushIcon()
end

function var0_0.FlushIcon(arg0_6)
	arg0_6:LoadRawTex(arg0_6.settings.id)
end

function var0_0.LoadRawTex(arg0_7, arg1_7)
	local var0_7 = AgoraCalc.BuildScreenShootSavePath(arg1_7)

	if not PathMgr.FileExists(var0_7) then
		return
	end

	local var1_7 = System.IO.File.ReadAllBytes(var0_7)
	local var2_7 = UnityEngine.Texture2D.New(426, 320)

	Tex2DExtension.LoadImage(var2_7, var1_7)

	arg0_7.iconRaw.texture = var2_7

	setActive(arg0_7.iconRaw, true)
	setActive(arg0_7.icon, false)
end

function var0_0.OnHide(arg0_8)
	var0_0.super.OnHide(arg0_8)

	if not IsNil(arg0_8.iconRaw.texture) then
		Object.Destroy(arg0_8.iconRaw.texture)

		arg0_8.iconRaw.texture = nil
	end
end

return var0_0
