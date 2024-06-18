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
		arg0_1.panelBlack = arg0_1.tr:Find("panel")
		arg0_1.panelPink = arg0_1.tr:Find("panel_pink")
		arg0_1.deckTF = arg0_1.tr:Find("deck")

		setActive(arg0_1.panelBlack, false)
		setActive(arg0_1.panelPink, false)

		arg0_1.logo = arg0_1.tr:Find("deck/logo")

		GetComponent(arg0_1.logo, "Image"):SetNativeSize()
	end)

	arg0_1.screenshot = Application.persistentDataPath .. "/screen_scratch/last_picture_for_share.jpg"
	arg0_1.cacheComps = {}
	arg0_1.cacheShowComps = {}
	arg0_1.cacheMoveComps = {}
end

function var1_0.Share(arg0_3, arg1_3, arg2_3, arg3_3)
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

	local var0_3 = LuaHelper.GetCHPackageType()

	if not IsUnityEditor and PLATFORM_CODE == PLATFORM_CH and var0_3 ~= PACKAGE_TYPE_BILI then
		var0_0.TipsMgr.GetInstance():ShowTips("指挥官，当前平台不支持分享功能哦")

		return
	end

	if IsNil(arg0_3.go) then
		arg0_3:Init()
	end

	arg2_3 = arg2_3 or var1_0.PANEL_TYPE_BLACK

	if arg2_3 == var1_0.PANEL_TYPE_BLACK then
		arg0_3.panel = arg0_3.panelBlack
	elseif arg2_3 == var1_0.PANEL_TYPE_PINK then
		arg0_3.panel = arg0_3.panelPink
	end

	setActive(arg0_3.panelBlack, arg2_3 == var1_0.PANEL_TYPE_BLACK)
	setActive(arg0_3.panelPink, arg2_3 == var1_0.PANEL_TYPE_PINK)

	local var1_3 = var0_0.share_template[arg1_3]

	assert(var1_3, "share_template not exist: " .. arg1_3)

	local var2_3 = getProxy(PlayerProxy):getRawData()
	local var3_3 = getProxy(UserProxy):getRawData()
	local var4_3 = getProxy(ServerProxy):getRawData()[var3_3 and var3_3.server or 0]
	local var5_3 = var2_3 and var2_3.name or ""
	local var6_3 = var4_3 and var4_3.name or ""
	local var7_3 = arg0_3.deckTF
	local var8_3 = arg0_3.ANCHORS_TYPE[var1_3.deck] or {
		0.5,
		0.5,
		0.5,
		0.5
	}

	var7_3.anchorMin = Vector2(var8_3[1], var8_3[2])
	var7_3.anchorMax = Vector2(var8_3[3], var8_3[4])

	setText(var7_3:Find("name/value"), var5_3)
	setText(var7_3:Find("server/value"), var6_3)
	setText(var7_3:Find("lv/value"), var2_3.level)

	if PLATFORM_CODE == PLATFORM_CHT or PLATFORM_CODE == PLATFORM_CH then
		setActive(var7_3:Find("code_bg"), true)
	else
		setActive(var7_3:Find("code_bg"), false)
	end

	local var9_3 = GameObject.Find(var1_3.camera):GetComponent(typeof(Camera))
	local var10_3 = var9_3.transform:GetChild(0)

	var7_3.anchoredPosition3D = Vector3(var1_3.qrcode_location[1], var1_3.qrcode_location[2], -100)
	var7_3.anchoredPosition = Vector2(var1_3.qrcode_location[1], var1_3.qrcode_location[2])

	_.each(var1_3.hidden_comps, function(arg0_5)
		local var0_5 = GameObject.Find(arg0_5)

		if not IsNil(var0_5) and var0_5.activeSelf then
			table.insert(arg0_3.cacheComps, var0_5)
			var0_5:SetActive(false)
		end
	end)
	_.each(var1_3.show_comps, function(arg0_6)
		local var0_6 = GameObject.Find(arg0_6)

		if not IsNil(var0_6) and not var0_6.activeSelf then
			table.insert(arg0_3.cacheShowComps, var0_6)
			var0_6:SetActive(true)
		end
	end)
	_.each(var1_3.move_comps, function(arg0_7)
		local var0_7 = GameObject.Find(arg0_7.path)

		if not IsNil(var0_7) then
			local var1_7 = var0_7.transform.anchoredPosition.x
			local var2_7 = var0_7.transform.anchoredPosition.y
			local var3_7 = arg0_7.x
			local var4_7 = arg0_7.y

			table.insert(arg0_3.cacheMoveComps, {
				var0_7,
				var1_7,
				var2_7
			})
			setAnchoredPosition(var0_7, {
				x = var3_7,
				y = var4_7
			})
		end
	end)
	SetParent(var7_3, var10_3, false)
	var7_3:SetAsLastSibling()

	local var11_3 = ScreenShooter.New(Screen.width, Screen.height, TextureFormat.ARGB32)

	if (PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US) and var0_0.SdkMgr.GetInstance():GetIsPlatform() then
		local var12_3 = arg0_3:TakeTexture(arg1_3, var11_3, var9_3)

		var0_0.SdkMgr.GetInstance():GameShare(var1_3.description, var12_3)
		var0_0.UIMgr.GetInstance():LoadingOn()
		onDelayTick(function()
			var0_0.UIMgr.GetInstance():LoadingOff()
		end, 2)
	elseif PLATFORM_CODE == PLATFORM_CHT then
		arg0_3:TakePhoto(arg1_3, var11_3, var9_3)
		var0_0.SdkMgr.GetInstance():ShareImg(arg0_3.screenshot, function()
			return
		end)
	elseif PLATFORM_CODE == PLATFORM_CH and var0_3 == PACKAGE_TYPE_BILI then
		if arg0_3:TakePhoto(arg1_3, var11_3, var9_3) then
			var0_0.SdkMgr.GetInstance():GameShare(var1_3.description, arg0_3.screenshot)
		end
	elseif arg0_3:TakePhoto(arg1_3, var11_3, var9_3) then
		print("截图位置: " .. arg0_3.screenshot)
		arg0_3:Show(var1_3, arg3_3)
	elseif PLATFORM_CODE == PLATFORM_CHT then
		var0_0.TipsMgr.GetInstance():ShowTips("截圖失敗")
	else
		var0_0.TipsMgr.GetInstance():ShowTips("截图失败")
	end

	SetParent(var7_3, arg0_3.tr, false)
	_.each(arg0_3.cacheComps, function(arg0_10)
		arg0_10:SetActive(true)
	end)

	arg0_3.cacheComps = {}

	_.each(arg0_3.cacheShowComps, function(arg0_11)
		arg0_11:SetActive(false)
	end)

	arg0_3.cacheShowComps = {}

	_.each(arg0_3.cacheMoveComps, function(arg0_12)
		setAnchoredPosition(arg0_12[1], {
			x = arg0_12[2],
			y = arg0_12[3]
		})
	end)

	arg0_3.cacheMoveComps = {}
end

function var1_0.TakeTexture(arg0_13, arg1_13, arg2_13, arg3_13)
	if arg1_13 == var1_0.TypeValentineQte then
		local var0_13 = System.Collections.Generic.List_UnityEngine_Camera()
		local var1_13 = GameObject.Find("UICamera"):GetComponent(typeof(Camera))
		local var2_13 = GameObject.Find("OverlayCamera"):GetComponent(typeof(Camera))

		var0_13:Add(var1_13)
		var0_13:Add(var2_13)

		local var3_13 = arg2_13:TakePhotoMultiCam(var0_13)

		return (arg2_13:EncodeToJPG(var3_13))
	else
		local var4_13 = arg2_13:TakePhoto(arg3_13)

		return (arg2_13:EncodeToJPG(var4_13))
	end
end

function var1_0.TakePhoto(arg0_14, arg1_14, arg2_14, arg3_14)
	if arg1_14 == var1_0.TypeValentineQte then
		local var0_14 = System.Collections.Generic.List_UnityEngine_Camera()
		local var1_14 = GameObject.Find("UICamera"):GetComponent(typeof(Camera))
		local var2_14 = GameObject.Find("OverlayCamera"):GetComponent(typeof(Camera))

		var0_14:Add(var1_14)
		var0_14:Add(var2_14)

		return arg2_14:TakeMultiCam(var0_14, arg0_14.screenshot)
	else
		return arg2_14:Take(arg3_14, arg0_14.screenshot)
	end
end

function var1_0.Show(arg0_15, arg1_15, arg2_15)
	arg0_15.go:SetActive(true)
	var0_0.UIMgr.GetInstance():BlurPanel(arg0_15.panel, true, arg2_15)
	var0_0.DelegateInfo.New(arg0_15)

	local function var0_15()
		arg0_15.go:SetActive(false)
		var0_0.UIMgr.GetInstance():UnblurPanel(arg0_15.panel, arg0_15.tr)
		PoolMgr.GetInstance():ReturnUI("ShareUI", arg0_15.go)
		var0_0.DelegateInfo.Dispose(arg0_15)

		arg0_15.go = nil
		arg0_15.tr = nil
		arg0_15.panel = nil
	end

	onButton(arg0_15, arg0_15.panel:Find("main/top/btnBack"), var0_15)
	onButton(arg0_15, arg0_15.panel:Find("main/buttons/weibo"), function()
		var0_15()
	end)
	onButton(arg0_15, arg0_15.panel:Find("main/buttons/weixin"), function()
		var0_15()
	end)

	if PLATFORM_CODE == PLATFORM_KR then
		onButton(arg0_15, arg0_15.panel:Find("main/buttons/facebook"), function()
			var0_0.SdkMgr.GetInstance():ShareImg(arg0_15.screenshot, function(arg0_20, arg1_20)
				if arg0_20 and arg1_20 == 0 then
					var0_0.TipsMgr.GetInstance():ShowTips(i18n("share_success"))
				end
			end)
			var0_15()
		end)
	end
end
