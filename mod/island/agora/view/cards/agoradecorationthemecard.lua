local var0_0 = class("AgoraDecorationThemeCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.tr = arg1_1.transform
	arg0_1.mainTr = arg0_1.tr:Find("main")
	arg0_1.addTr = arg0_1.tr:Find("empty")
	arg0_1.icon = arg0_1.tr:Find("main/mask/icon"):GetComponent(typeof(Image))
	arg0_1.iconRaw = arg0_1.tr:Find("main/mask/icon_raw"):GetComponent(typeof(RawImage))
	arg0_1.idTr = findTF(arg0_1.tr, "main/id")
	arg0_1.idTxt = findTF(arg0_1.tr, "main/id/Text"):GetComponent(typeof(Text))
	arg0_1.nameTxt = findTF(arg0_1.tr, "main/name"):GetComponent(typeof(Text))
	arg0_1.mark = findTF(arg0_1.tr, "main/mark")

	setText(arg0_1.addTr:Find("Text"), i18n("island_agora_save_theme"))
end

function var0_0.Update(arg0_2, arg1_2, arg2_2)
	arg0_2.theme = arg1_2

	local var0_2 = arg1_2.id == -1

	if not var0_2 then
		arg0_2:UpdateMain(arg1_2, arg2_2)
	end

	setActive(arg0_2.mainTr, not var0_2)
	setActive(arg0_2.addTr, var0_2)
	setActive(arg0_2.idTr, not var0_2 and isa(arg1_2, AgoraTheme))
end

function var0_0.LoadRawTex(arg0_3, arg1_3)
	local var0_3 = AgoraCalc.BuildScreenShootSavePath(arg1_3)

	if not PathMgr.FileExists(var0_3) then
		arg0_3:LoadImage(0)

		return
	end

	local var1_3 = System.IO.File.ReadAllBytes(var0_3)
	local var2_3 = UnityEngine.Texture2D.New(426, 320)

	Tex2DExtension.LoadImage(var2_3, var1_3)

	arg0_3.iconRaw.texture = var2_3

	setActive(arg0_3.iconRaw, true)
	setActive(arg0_3.icon, false)
end

function var0_0.LoadImage(arg0_4, arg1_4)
	LoadSpriteAsync("island/IslandThemeIcon/" .. arg1_4, function(arg0_5)
		arg0_4.icon.sprite = arg0_5

		arg0_4.icon:SetNativeSize()
	end)
	setActive(arg0_4.iconRaw, false)
	setActive(arg0_4.icon, true)
end

function var0_0.UpdateMain(arg0_6, arg1_6, arg2_6)
	arg0_6.idTxt.text = arg1_6.id
	arg0_6.nameTxt.text = shortenString(arg1_6.name, 5)

	setActive(arg0_6.mark, arg1_6.id == arg2_6)

	if isa(arg1_6, AgoraTheme) then
		arg0_6:LoadRawTex(arg1_6.id)
	else
		arg0_6:LoadImage(arg1_6.id)
	end
end

function var0_0.Dispose(arg0_7)
	if not IsNil(arg0_7.iconRaw.texture) then
		Object.Destroy(arg0_7.iconRaw.texture)

		arg0_7.iconRaw.texture = nil
	end
end

return var0_0
