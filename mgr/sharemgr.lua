pg = pg or {}

local var0_0 = pg

var0_0.ShareMgr = singletonClass("ShareMgr")

local var1_0 = var0_0.ShareMgr

var1_0.TypeAdmira = 1
var1_0.TypeShipProfile = 2
var1_0.TypeNewShip = 3
var1_0.TypeBackyard = 4
var1_0.TypeNewSkin = 5
var1_0.TypeSummary = 6
var1_0.TypePhoto = 7
var1_0.TypeReflux = 8
var1_0.TypeCommander = 9
var1_0.TypeColoring = 10
var1_0.TypeChallenge = 11
var1_0.TypeInstagram = 12
var1_0.TypePizzahut = 13
var1_0.TypeSecondSummary = 14
var1_0.TypePoraisMedals = 15
var1_0.TypeIcecream = 16
var1_0.TypeValentineQte = 17
var1_0.TypeBossRushEX = 18
var1_0.TypeTWCelebrationShare = 5000
var1_0.TypeCardTower = 17
var1_0.TypeDorm3dPhoto = 19
var1_0.PANEL_TYPE_BLACK = 1
var1_0.PANEL_TYPE_PINK = 2
var1_0.ANCHORS_TYPE = {
	{
		0,
		0,
		0,
		0
	},
	{
		1,
		0,
		1,
		0
	},
	{
		0,
		1,
		0,
		1
	},
	{
		1,
		1,
		1,
		1
	},
	{
		0.5,
		0.5,
		0.5,
		0.5
	}
}

function var1_0.Init(arg0_1)
	PoolMgr.GetInstance():GetUI("ShareUI", false, function(arg0_2)
		arg0_1.go = arg0_2

		arg0_1.go:SetActive(false)

		arg0_1.tr = arg0_2.transform

		local var0_2 = var0_0.UIMgr.GetInstance().OverlayMain

		setParent(arg0_1.tr, var0_2.transform, false)

		arg0_1.panelBlack = arg0_1.tr:Find("panel")
		arg0_1.panelPink = arg0_1.tr:Find("panel_pink")
		arg0_1.deckTF = arg0_1.tr:Find("deck")

		setActive(arg0_1.panelBlack, false)
		setActive(arg0_1.panelPink, false)

		arg0_1.logo = arg0_1.tr:Find("deck/logo")

		GetComponent(arg0_1.logo, "Image"):SetNativeSize()
		var0_0.DelegateInfo.New(arg0_1)
	end)

	arg0_1.screenshotPath = Application.persistentDataPath .. "/screen_scratch/last_picture_for_share.jpg"
	arg0_1.cacheComps = {}
	arg0_1.cacheShowComps = {}
	arg0_1.cacheMoveComps = {}
end

function var1_0.UpdateDeck(arg0_3, arg1_3)
	local var0_3 = getProxy(PlayerProxy):getRawData()
	local var1_3 = getProxy(UserProxy):getRawData()
	local var2_3 = getProxy(ServerProxy):getRawData()[var1_3 and var1_3.server or 0]
	local var3_3 = var0_3 and var0_3.name or ""
	local var4_3 = var2_3 and var2_3.name or ""

	setText(arg1_3:Find("name/value"), var3_3)
	setText(arg1_3:Find("server/value"), var4_3)
	setText(arg1_3:Find("lv/value"), var0_3.level)

	if PLATFORM_CODE == PLATFORM_CHT or PLATFORM_CODE == PLATFORM_CH then
		setActive(arg1_3:Find("code_bg"), true)
	else
		setActive(arg1_3:Find("code_bg"), false)
	end
end

function var1_0.Share(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4, arg5_4, arg6_4)
	arg0_4.noBlur = arg4_4

	local var0_4 = LuaHelper.GetCHPackageType()

	if not IsUnityEditor and PLATFORM_CODE == PLATFORM_CH and var0_4 ~= PACKAGE_TYPE_BILI then
		var0_0.TipsMgr.GetInstance():ShowTips("指挥官，当前平台不支持分享功能哦")

		return
	end

	arg0_4:Init()

	local var1_4 = var0_0.share_template[arg1_4]

	assert(var1_4, "share_template not exist: " .. arg1_4)

	local var2_4 = arg0_4.deckTF
	local var3_4 = arg0_4.ANCHORS_TYPE[var1_4.deck] or {
		0.5,
		0.5,
		0.5,
		0.5
	}

	var2_4.anchorMin = Vector2(var3_4[1], var3_4[2])
	var2_4.anchorMax = Vector2(var3_4[3], var3_4[4])
	var2_4.anchoredPosition3D = Vector3(var1_4.qrcode_location[1], var1_4.qrcode_location[2], -100)
	var2_4.anchoredPosition = Vector2(var1_4.qrcode_location[1], var1_4.qrcode_location[2])

	local var4_4 = GameObject.Find(var1_4.camera):GetComponent(typeof(Camera)).transform:GetChild(0)

	if arg5_4 then
		local var5_4 = (var4_4.sizeDelta.x - arg5_4.x) / 2
		local var6_4 = (var4_4.sizeDelta.y - arg5_4.y) / 2

		;(function()
			if arg6_4 then
				var5_4 = var5_4 + arg6_4[1]
				var6_4 = var6_4 + arg6_4[2]
			end
		end)()

		var2_4.anchoredPosition3D = Vector3(var1_4.qrcode_location[1] - var5_4, var1_4.qrcode_location[2] + var6_4, -100)
		var2_4.anchoredPosition = Vector2(var1_4.qrcode_location[1] - var5_4, var1_4.qrcode_location[2] + var6_4)
	end

	arg0_4:UpdateDeck(var2_4)
	_.each(var1_4.hidden_comps, function(arg0_6)
		local var0_6 = GameObject.Find(arg0_6)

		if not IsNil(var0_6) and var0_6.activeSelf then
			table.insert(arg0_4.cacheComps, var0_6)
			var0_6:SetActive(false)
		end
	end)
	_.each(var1_4.show_comps, function(arg0_7)
		local var0_7 = GameObject.Find(arg0_7)

		if not IsNil(var0_7) and not var0_7.activeSelf then
			table.insert(arg0_4.cacheShowComps, var0_7)
			var0_7:SetActive(true)
		end
	end)
	_.each(var1_4.move_comps, function(arg0_8)
		local var0_8 = GameObject.Find(arg0_8.path)

		if not IsNil(var0_8) then
			local var1_8 = var0_8.transform.anchoredPosition.x
			local var2_8 = var0_8.transform.anchoredPosition.y
			local var3_8 = arg0_8.x
			local var4_8 = arg0_8.y

			table.insert(arg0_4.cacheMoveComps, {
				var0_8,
				var1_8,
				var2_8
			})
			setAnchoredPosition(var0_8, {
				x = var3_8,
				y = var4_8
			})
		end
	end)
	SetParent(var2_4, var4_4, false)
	var2_4:SetAsLastSibling()
	arg0_4:ShotAndSave(arg1_4, arg5_4, var4_4)
	SetParent(var2_4, arg0_4.tr, false)

	local var7_4 = arg0_4:ShowSharePanel(arg1_4, arg2_4, arg3_4, arg4_4)

	_.each(arg0_4.cacheComps, function(arg0_9)
		arg0_9:SetActive(true)
	end)

	arg0_4.cacheComps = {}

	_.each(arg0_4.cacheShowComps, function(arg0_10)
		arg0_10:SetActive(false)
	end)

	arg0_4.cacheShowComps = {}

	_.each(arg0_4.cacheMoveComps, function(arg0_11)
		setAnchoredPosition(arg0_11[1], {
			x = arg0_11[2],
			y = arg0_11[3]
		})
	end)

	arg0_4.cacheMoveComps = {}

	if not var7_4 then
		arg0_4:Dispose()
	end
end

function var1_0.ShotAndSave(arg0_12, arg1_12, arg2_12, arg3_12)
	local var0_12 = var0_0.share_template[arg1_12]

	assert(var0_12, "share_template not exist: " .. arg1_12)

	local var1_12 = LuaHelper.GetCHPackageType()
	local var2_12 = GameObject.Find(var0_12.camera):GetComponent(typeof(Camera))
	local var3_12 = ScreenShooter.New(Screen.width, Screen.height, TextureFormat.ARGB32)
	local var4_12 = arg0_12:TakeTexture(arg1_12, var3_12, var2_12)

	local function var5_12(arg0_13, arg1_13)
		local var0_13 = arg1_13.x / arg3_12.sizeDelta.x * Screen.width
		local var1_13 = arg1_13.y / arg3_12.sizeDelta.y * Screen.height
		local var2_13 = (Screen.width - var0_13) / 2
		local var3_13 = (Screen.height - var1_13) / 2
		local var4_13 = arg0_13:GetPixels(var2_13, var3_13, var0_13, var1_13)
		local var5_13 = UnityEngine.Texture2D.New(var0_13, var1_13)

		var5_13:SetPixels(var4_13)
		var5_13:Apply()

		return var5_13
	end

	if arg2_12 then
		var4_12 = var5_12(var4_12, arg2_12)
	end

	local var6_12 = Tex2DExtension.EncodeToJPG(var4_12)

	arg0_12:SaveImageWithBytes(var6_12)

	return true
end

function var1_0.ShowSharePanel(arg0_14, arg1_14, arg2_14, arg3_14, arg4_14)
	arg0_14.noBlur = arg4_14

	local var0_14 = var0_0.share_template[arg1_14]

	assert(var0_14, "share_template not exist: " .. arg1_14)

	local var1_14 = LuaHelper.GetCHPackageType()

	if (PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US) and var0_0.SdkMgr.GetInstance():GetIsPlatform() then
		local var2_14 = System.IO.File.ReadAllBytes(arg0_14.screenshotPath)
		local var3_14 = UnityEngine.Texture2D.New(Screen.width, Screen.height, TextureFormat.ARGB32, false)

		Tex2DExtension.LoadImage(var3_14, var2_14)
		var0_0.SdkMgr.GetInstance():GameShare(var0_14.description, var3_14)
		var0_0.UIMgr.GetInstance():LoadingOn()
		onDelayTick(function()
			var0_0.UIMgr.GetInstance():LoadingOff()
		end, 2)
	elseif PLATFORM_CODE == PLATFORM_CHT then
		var0_0.SdkMgr.GetInstance():ShareImg(arg0_14.screenshotPath, function()
			return
		end)
	elseif PLATFORM_CODE == PLATFORM_CH and var1_14 == PACKAGE_TYPE_BILI then
		var0_0.SdkMgr.GetInstance():GameShare(var0_14.description, arg0_14.screenshotPath)
	else
		arg0_14:ShowOwnUI(arg1_14, arg2_14, arg3_14, arg4_14)

		return true
	end
end

function var1_0.TakeTexture(arg0_17, arg1_17, arg2_17, arg3_17)
	if arg1_17 == var1_0.TypeValentineQte then
		local var0_17 = System.Collections.Generic.List_UnityEngine_Camera()
		local var1_17 = GameObject.Find("UICamera"):GetComponent(typeof(Camera))
		local var2_17 = GameObject.Find("OverlayCamera"):GetComponent(typeof(Camera))

		var0_17:Add(var1_17)
		var0_17:Add(var2_17)

		local var3_17 = arg2_17:TakePhotoMultiCam(var0_17)

		return (arg2_17:EncodeToJPG(var3_17))
	else
		local var4_17 = arg2_17:TakePhoto(arg3_17)

		return (arg2_17:EncodeToJPG(var4_17))
	end
end

function var1_0.TakePhoto(arg0_18, arg1_18, arg2_18, arg3_18)
	if arg1_18 == var1_0.TypeValentineQte then
		local var0_18 = System.Collections.Generic.List_UnityEngine_Camera()
		local var1_18 = GameObject.Find("UICamera"):GetComponent(typeof(Camera))
		local var2_18 = GameObject.Find("OverlayCamera"):GetComponent(typeof(Camera))

		var0_18:Add(var1_18)
		var0_18:Add(var2_18)

		return arg2_18:TakeMultiCam(var0_18, arg0_18.screenshotPath)
	else
		return arg2_18:Take(arg3_18, arg0_18.screenshotPath)
	end
end

function var1_0.ShowOwnUI(arg0_19, arg1_19, arg2_19, arg3_19, arg4_19)
	arg0_19.noBlur = arg4_19

	local var0_19 = var0_0.share_template[arg1_19]

	assert(var0_19, "share_template not exist: " .. arg1_19)
	arg0_19.go:SetActive(true)
	setActive(arg0_19.deckTF, false)

	arg2_19 = arg2_19 or var1_0.PANEL_TYPE_BLACK

	if arg2_19 == var1_0.PANEL_TYPE_BLACK then
		arg0_19.panel = arg0_19.panelBlack
	elseif arg2_19 == var1_0.PANEL_TYPE_PINK then
		arg0_19.panel = arg0_19.panelPink
	end

	setActive(arg0_19.panelBlack, arg2_19 == var1_0.PANEL_TYPE_BLACK)
	setActive(arg0_19.panelPink, arg2_19 == var1_0.PANEL_TYPE_PINK)

	if not arg4_19 then
		var0_0.UIMgr.GetInstance():BlurPanel(arg0_19.panel, true, arg3_19)
	end

	local function var1_19()
		arg0_19:Dispose()
	end

	onButton(arg0_19, arg0_19.panel:Find("main/top/btnBack"), var1_19)
	onButton(arg0_19, arg0_19.panel:Find("main/buttons/weibo"), function()
		var1_19()
	end)
	onButton(arg0_19, arg0_19.panel:Find("main/buttons/weixin"), function()
		var1_19()
	end)

	if PLATFORM_CODE == PLATFORM_KR then
		onButton(arg0_19, arg0_19.panel:Find("main/buttons/facebook"), function()
			var0_0.SdkMgr.GetInstance():ShareImg(arg0_19.screenshotPath, function(arg0_24, arg1_24)
				if arg0_24 and arg1_24 == 0 then
					var0_0.TipsMgr.GetInstance():ShowTips(i18n("share_success"))
				end
			end)
			var1_19()
		end)
	end
end

function var1_0.Dispose(arg0_25)
	arg0_25.go:SetActive(false)

	if arg0_25.panel and not arg0_25.noBlur then
		var0_0.UIMgr.GetInstance():UnblurPanel(arg0_25.panel, arg0_25.tr)
	end

	PoolMgr.GetInstance():ReturnUI("ShareUI", arg0_25.go)
	var0_0.DelegateInfo.Dispose(arg0_25)

	arg0_25.go = nil
	arg0_25.tr = nil
	arg0_25.panel = nil
end

function var1_0.SaveImageWithBytes(arg0_26, arg1_26)
	BackYardThemeTempalteUtil.CheckSaveDirectory()

	local var0_26 = arg0_26.screenshotPath

	System.IO.File.WriteAllBytes(var0_26, arg1_26)
end
