pg = pg or {}

local var0 = pg

var0.ShareMgr = singletonClass("ShareMgr")

local var1 = var0.ShareMgr

var1.TypeAdmira = 1
var1.TypeShipProfile = 2
var1.TypeNewShip = 3
var1.TypeBackyard = 4
var1.TypeNewSkin = 5
var1.TypeSummary = 6
var1.TypePhoto = 7
var1.TypeReflux = 8
var1.TypeCommander = 9
var1.TypeColoring = 10
var1.TypeChallenge = 11
var1.TypeInstagram = 12
var1.TypePizzahut = 13
var1.TypeSecondSummary = 14
var1.TypePoraisMedals = 15
var1.TypeIcecream = 16
var1.TypeValentineQte = 17
var1.TypeBossRushEX = 18
var1.TypeTWCelebrationShare = 5000
var1.TypeCardTower = 17
var1.PANEL_TYPE_BLACK = 1
var1.PANEL_TYPE_PINK = 2
var1.ANCHORS_TYPE = {
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

function var1.Init(arg0)
	PoolMgr.GetInstance():GetUI("ShareUI", false, function(arg0)
		arg0.go = arg0

		arg0.go:SetActive(false)

		arg0.tr = arg0.transform
		arg0.panelBlack = arg0.tr:Find("panel")
		arg0.panelPink = arg0.tr:Find("panel_pink")
		arg0.deckTF = arg0.tr:Find("deck")

		setActive(arg0.panelBlack, false)
		setActive(arg0.panelPink, false)

		arg0.logo = arg0.tr:Find("deck/logo")

		GetComponent(arg0.logo, "Image"):SetNativeSize()
	end)

	arg0.screenshot = Application.persistentDataPath .. "/screen_scratch/last_picture_for_share.jpg"
	arg0.cacheComps = {}
	arg0.cacheShowComps = {}
	arg0.cacheMoveComps = {}
end

function var1.Share(arg0, arg1, arg2, arg3)
	if PLATFORM_CODE == PLATFORM_CHT and not CheckPermissionGranted(ANDROID_WRITE_EXTERNAL_PERMISSION) then
		var0.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n1("指揮官，碧藍航線需要存儲權限才能分享是否打開？"),
			onYes = function()
				ApplyPermission({
					ANDROID_WRITE_EXTERNAL_PERMISSION
				})
			end
		})

		return
	end

	local var0 = LuaHelper.GetCHPackageType()

	if not IsUnityEditor and PLATFORM_CODE == PLATFORM_CH and var0 ~= PACKAGE_TYPE_BILI then
		var0.TipsMgr.GetInstance():ShowTips("指挥官，当前平台不支持分享功能哦")

		return
	end

	if IsNil(arg0.go) then
		arg0:Init()
	end

	arg2 = arg2 or var1.PANEL_TYPE_BLACK

	if arg2 == var1.PANEL_TYPE_BLACK then
		arg0.panel = arg0.panelBlack
	elseif arg2 == var1.PANEL_TYPE_PINK then
		arg0.panel = arg0.panelPink
	end

	setActive(arg0.panelBlack, arg2 == var1.PANEL_TYPE_BLACK)
	setActive(arg0.panelPink, arg2 == var1.PANEL_TYPE_PINK)

	local var1 = var0.share_template[arg1]

	assert(var1, "share_template not exist: " .. arg1)

	local var2 = getProxy(PlayerProxy):getRawData()
	local var3 = getProxy(UserProxy):getRawData()
	local var4 = getProxy(ServerProxy):getRawData()[var3 and var3.server or 0]
	local var5 = var2 and var2.name or ""
	local var6 = var4 and var4.name or ""
	local var7 = arg0.deckTF
	local var8 = arg0.ANCHORS_TYPE[var1.deck] or {
		0.5,
		0.5,
		0.5,
		0.5
	}

	var7.anchorMin = Vector2(var8[1], var8[2])
	var7.anchorMax = Vector2(var8[3], var8[4])

	setText(var7:Find("name/value"), var5)
	setText(var7:Find("server/value"), var6)
	setText(var7:Find("lv/value"), var2.level)

	if PLATFORM_CODE == PLATFORM_CHT or PLATFORM_CODE == PLATFORM_CH then
		setActive(var7:Find("code_bg"), true)
	else
		setActive(var7:Find("code_bg"), false)
	end

	local var9 = GameObject.Find(var1.camera):GetComponent(typeof(Camera))
	local var10 = var9.transform:GetChild(0)

	var7.anchoredPosition3D = Vector3(var1.qrcode_location[1], var1.qrcode_location[2], -100)
	var7.anchoredPosition = Vector2(var1.qrcode_location[1], var1.qrcode_location[2])

	_.each(var1.hidden_comps, function(arg0)
		local var0 = GameObject.Find(arg0)

		if not IsNil(var0) and var0.activeSelf then
			table.insert(arg0.cacheComps, var0)
			var0:SetActive(false)
		end
	end)
	_.each(var1.show_comps, function(arg0)
		local var0 = GameObject.Find(arg0)

		if not IsNil(var0) and not var0.activeSelf then
			table.insert(arg0.cacheShowComps, var0)
			var0:SetActive(true)
		end
	end)
	_.each(var1.move_comps, function(arg0)
		local var0 = GameObject.Find(arg0.path)

		if not IsNil(var0) then
			local var1 = var0.transform.anchoredPosition.x
			local var2 = var0.transform.anchoredPosition.y
			local var3 = arg0.x
			local var4 = arg0.y

			table.insert(arg0.cacheMoveComps, {
				var0,
				var1,
				var2
			})
			setAnchoredPosition(var0, {
				x = var3,
				y = var4
			})
		end
	end)
	SetParent(var7, var10, false)
	var7:SetAsLastSibling()

	local var11 = ScreenShooter.New(Screen.width, Screen.height, TextureFormat.ARGB32)

	if (PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US) and var0.SdkMgr.GetInstance():GetIsPlatform() then
		local var12 = arg0:TakeTexture(arg1, var11, var9)

		var0.SdkMgr.GetInstance():GameShare(var1.description, var12)
		var0.UIMgr.GetInstance():LoadingOn()
		onDelayTick(function()
			var0.UIMgr.GetInstance():LoadingOff()
		end, 2)
	elseif PLATFORM_CODE == PLATFORM_CHT then
		arg0:TakePhoto(arg1, var11, var9)
		var0.SdkMgr.GetInstance():ShareImg(arg0.screenshot, function()
			return
		end)
	elseif PLATFORM_CODE == PLATFORM_CH and var0 == PACKAGE_TYPE_BILI then
		if arg0:TakePhoto(arg1, var11, var9) then
			var0.SdkMgr.GetInstance():GameShare(var1.description, arg0.screenshot)
		end
	elseif arg0:TakePhoto(arg1, var11, var9) then
		print("截图位置: " .. arg0.screenshot)
		arg0:Show(var1, arg3)
	elseif PLATFORM_CODE == PLATFORM_CHT then
		var0.TipsMgr.GetInstance():ShowTips("截圖失敗")
	else
		var0.TipsMgr.GetInstance():ShowTips("截图失败")
	end

	SetParent(var7, arg0.tr, false)
	_.each(arg0.cacheComps, function(arg0)
		arg0:SetActive(true)
	end)

	arg0.cacheComps = {}

	_.each(arg0.cacheShowComps, function(arg0)
		arg0:SetActive(false)
	end)

	arg0.cacheShowComps = {}

	_.each(arg0.cacheMoveComps, function(arg0)
		setAnchoredPosition(arg0[1], {
			x = arg0[2],
			y = arg0[3]
		})
	end)

	arg0.cacheMoveComps = {}
end

function var1.TakeTexture(arg0, arg1, arg2, arg3)
	if arg1 == var1.TypeValentineQte then
		local var0 = System.Collections.Generic.List_UnityEngine_Camera()
		local var1 = GameObject.Find("UICamera"):GetComponent(typeof(Camera))
		local var2 = GameObject.Find("OverlayCamera"):GetComponent(typeof(Camera))

		var0:Add(var1)
		var0:Add(var2)

		local var3 = arg2:TakePhotoMultiCam(var0)

		return (arg2:EncodeToJPG(var3))
	else
		local var4 = arg2:TakePhoto(arg3)

		return (arg2:EncodeToJPG(var4))
	end
end

function var1.TakePhoto(arg0, arg1, arg2, arg3)
	if arg1 == var1.TypeValentineQte then
		local var0 = System.Collections.Generic.List_UnityEngine_Camera()
		local var1 = GameObject.Find("UICamera"):GetComponent(typeof(Camera))
		local var2 = GameObject.Find("OverlayCamera"):GetComponent(typeof(Camera))

		var0:Add(var1)
		var0:Add(var2)

		return arg2:TakeMultiCam(var0, arg0.screenshot)
	else
		return arg2:Take(arg3, arg0.screenshot)
	end
end

function var1.Show(arg0, arg1, arg2)
	arg0.go:SetActive(true)
	var0.UIMgr.GetInstance():BlurPanel(arg0.panel, true, arg2)
	var0.DelegateInfo.New(arg0)

	local var0 = function()
		arg0.go:SetActive(false)
		var0.UIMgr.GetInstance():UnblurPanel(arg0.panel, arg0.tr)
		PoolMgr.GetInstance():ReturnUI("ShareUI", arg0.go)
		var0.DelegateInfo.Dispose(arg0)

		arg0.go = nil
		arg0.tr = nil
		arg0.panel = nil
	end

	onButton(arg0, arg0.panel:Find("main/top/btnBack"), var0)
	onButton(arg0, arg0.panel:Find("main/buttons/weibo"), function()
		var0()
	end)
	onButton(arg0, arg0.panel:Find("main/buttons/weixin"), function()
		var0()
	end)

	if PLATFORM_CODE == PLATFORM_KR then
		onButton(arg0, arg0.panel:Find("main/buttons/facebook"), function()
			var0.SdkMgr.GetInstance():ShareImg(arg0.screenshot, function(arg0, arg1)
				if arg0 and arg1 == 0 then
					var0.TipsMgr.GetInstance():ShowTips(i18n("share_success"))
				end
			end)
			var0()
		end)
	end
end
