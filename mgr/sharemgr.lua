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

function var1_0.Share(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4)
	arg0_4.noBlur = arg4_4

	if PLATFORM_CODE == PLATFORM_CHT and not CheckPermissionGranted(ANDROID_WRITE_EXTERNAL_PERMISSION) then
		var0_0.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n1("指揮官，碧藍航線需要存儲權限才能分享是否打開？"),
			onYes = function()
				ApplyPermission({
					ANDROID_WRITE_EXTERNAL_PERMISSION
				})
			end
		})

		return
	end

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

	local var4_4 = GameObject.Find(var1_4.camera):GetComponent(typeof(Camera)).transform:GetChild(0)

	SetParent(var2_4, var4_4, false)
	var2_4:SetAsLastSibling()
	arg0_4:ShotAndSave(arg1_4)
	SetParent(var2_4, arg0_4.tr, false)

	local var5_4 = arg0_4:ShowSharePanel(arg1_4, arg2_4, arg3_4, arg4_4)

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

	if not var5_4 then
		arg0_4:Dispose()
	end
end

function var1_0.ShotAndSave(arg0_12, arg1_12)
	local var0_12 = var0_0.share_template[arg1_12]

	assert(var0_12, "share_template not exist: " .. arg1_12)

	local var1_12 = LuaHelper.GetCHPackageType()
	local var2_12 = GameObject.Find(var0_12.camera):GetComponent(typeof(Camera))
	local var3_12 = ScreenShooter.New(Screen.width, Screen.height, TextureFormat.ARGB32)

	if (PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US) and var0_0.SdkMgr.GetInstance():GetIsPlatform() then
		local var4_12 = arg0_12:TakeTexture(arg1_12, var3_12, var2_12)
		local var5_12 = Tex2DExtension.EncodeToJPG(var4_12)

		arg0_12:SaveImageWithBytes(var5_12)

		return true
	elseif PLATFORM_CODE == PLATFORM_CHT then
		if arg0_12:TakePhoto(arg1_12, var3_12, var2_12) then
			return true
		end
	elseif PLATFORM_CODE == PLATFORM_CH and var1_12 == PACKAGE_TYPE_BILI then
		if arg0_12:TakePhoto(arg1_12, var3_12, var2_12) then
			return true
		end
	elseif arg0_12:TakePhoto(arg1_12, var3_12, var2_12) then
		return true
	elseif PLATFORM_CODE == PLATFORM_CHT then
		var0_0.TipsMgr.GetInstance():ShowTips("截圖失敗")
	else
		var0_0.TipsMgr.GetInstance():ShowTips("截图失败")
	end
end

function var1_0.ShowSharePanel(arg0_13, arg1_13, arg2_13, arg3_13, arg4_13)
	arg0_13.noBlur = arg4_13

	local var0_13 = var0_0.share_template[arg1_13]

	assert(var0_13, "share_template not exist: " .. arg1_13)

	local var1_13 = LuaHelper.GetCHPackageType()

	if (PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US) and var0_0.SdkMgr.GetInstance():GetIsPlatform() then
		local var2_13 = System.IO.File.ReadAllBytes(arg0_13.screenshotPath)
		local var3_13 = UnityEngine.Texture2D.New(Screen.width, Screen.height, TextureFormat.ARGB32, false)

		Tex2DExtension.LoadImage(var3_13, var2_13)
		var0_0.SdkMgr.GetInstance():GameShare(var0_13.description, var3_13)
		var0_0.UIMgr.GetInstance():LoadingOn()
		onDelayTick(function()
			var0_0.UIMgr.GetInstance():LoadingOff()
		end, 2)
	elseif PLATFORM_CODE == PLATFORM_CHT then
		var0_0.SdkMgr.GetInstance():ShareImg(arg0_13.screenshotPath, function()
			return
		end)
	elseif PLATFORM_CODE == PLATFORM_CH and var1_13 == PACKAGE_TYPE_BILI then
		var0_0.SdkMgr.GetInstance():GameShare(var0_13.description, arg0_13.screenshotPath)
	else
		arg0_13:ShowOwnUI(arg1_13, arg2_13, arg3_13, arg4_13)

		return true
	end
end

function var1_0.TakeTexture(arg0_16, arg1_16, arg2_16, arg3_16)
	if arg1_16 == var1_0.TypeValentineQte then
		local var0_16 = System.Collections.Generic.List_UnityEngine_Camera()
		local var1_16 = GameObject.Find("UICamera"):GetComponent(typeof(Camera))
		local var2_16 = GameObject.Find("OverlayCamera"):GetComponent(typeof(Camera))

		var0_16:Add(var1_16)
		var0_16:Add(var2_16)

		local var3_16 = arg2_16:TakePhotoMultiCam(var0_16)

		return (arg2_16:EncodeToJPG(var3_16))
	else
		local var4_16 = arg2_16:TakePhoto(arg3_16)

		return (arg2_16:EncodeToJPG(var4_16))
	end
end

function var1_0.TakePhoto(arg0_17, arg1_17, arg2_17, arg3_17)
	if arg1_17 == var1_0.TypeValentineQte then
		local var0_17 = System.Collections.Generic.List_UnityEngine_Camera()
		local var1_17 = GameObject.Find("UICamera"):GetComponent(typeof(Camera))
		local var2_17 = GameObject.Find("OverlayCamera"):GetComponent(typeof(Camera))

		var0_17:Add(var1_17)
		var0_17:Add(var2_17)

		return arg2_17:TakeMultiCam(var0_17, arg0_17.screenshotPath)
	else
		return arg2_17:Take(arg3_17, arg0_17.screenshotPath)
	end
end

function var1_0.ShowOwnUI(arg0_18, arg1_18, arg2_18, arg3_18, arg4_18)
	arg0_18.noBlur = arg4_18

	local var0_18 = var0_0.share_template[arg1_18]

	assert(var0_18, "share_template not exist: " .. arg1_18)
	arg0_18.go:SetActive(true)
	setActive(arg0_18.deckTF, false)

	arg2_18 = arg2_18 or var1_0.PANEL_TYPE_BLACK

	if arg2_18 == var1_0.PANEL_TYPE_BLACK then
		arg0_18.panel = arg0_18.panelBlack
	elseif arg2_18 == var1_0.PANEL_TYPE_PINK then
		arg0_18.panel = arg0_18.panelPink
	end

	setActive(arg0_18.panelBlack, arg2_18 == var1_0.PANEL_TYPE_BLACK)
	setActive(arg0_18.panelPink, arg2_18 == var1_0.PANEL_TYPE_PINK)

	if not arg4_18 then
		var0_0.UIMgr.GetInstance():BlurPanel(arg0_18.panel, true, arg3_18)
	end

	local function var1_18()
		arg0_18:Dispose()
	end

	onButton(arg0_18, arg0_18.panel:Find("main/top/btnBack"), var1_18)
	onButton(arg0_18, arg0_18.panel:Find("main/buttons/weibo"), function()
		var1_18()
	end)
	onButton(arg0_18, arg0_18.panel:Find("main/buttons/weixin"), function()
		var1_18()
	end)

	if PLATFORM_CODE == PLATFORM_KR then
		onButton(arg0_18, arg0_18.panel:Find("main/buttons/facebook"), function()
			var0_0.SdkMgr.GetInstance():ShareImg(arg0_18.screenshotPath, function(arg0_23, arg1_23)
				if arg0_23 and arg1_23 == 0 then
					var0_0.TipsMgr.GetInstance():ShowTips(i18n("share_success"))
				end
			end)
			var1_18()
		end)
	end
end

function var1_0.Dispose(arg0_24)
	arg0_24.go:SetActive(false)

	if arg0_24.panel and not arg0_24.noBlur then
		var0_0.UIMgr.GetInstance():UnblurPanel(arg0_24.panel, arg0_24.tr)
	end

	PoolMgr.GetInstance():ReturnUI("ShareUI", arg0_24.go)
	var0_0.DelegateInfo.Dispose(arg0_24)

	arg0_24.go = nil
	arg0_24.tr = nil
	arg0_24.panel = nil
end

function var1_0.SaveImageWithBytes(arg0_25, arg1_25)
	BackYardThemeTempalteUtil.CheckSaveDirectory()

	local var0_25 = arg0_25.screenshotPath

	System.IO.File.WriteAllBytes(var0_25, arg1_25)
end
