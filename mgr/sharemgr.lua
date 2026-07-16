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
var1_0.AuctionGame = 20
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
	arg0_4:ShotAndSave(arg1_4, arg5_4, var4_4, function()
		SetParent(var2_4, arg0_4.tr, false)

		local var0_9 = arg0_4:ShowSharePanel(arg1_4, arg2_4, arg3_4, arg4_4)

		_.each(arg0_4.cacheComps, function(arg0_10)
			arg0_10:SetActive(true)
		end)

		arg0_4.cacheComps = {}

		_.each(arg0_4.cacheShowComps, function(arg0_11)
			arg0_11:SetActive(false)
		end)

		arg0_4.cacheShowComps = {}

		_.each(arg0_4.cacheMoveComps, function(arg0_12)
			setAnchoredPosition(arg0_12[1], {
				x = arg0_12[2],
				y = arg0_12[3]
			})
		end)

		arg0_4.cacheMoveComps = {}

		if not var0_9 then
			arg0_4:Dispose()
		end
	end)
end

function var1_0.ShotAndSave(arg0_13, arg1_13, arg2_13, arg3_13, arg4_13)
	local var0_13 = var0_0.share_template[arg1_13]

	assert(var0_13, "share_template not exist: " .. arg1_13)

	local var1_13 = GameObject.Find(var0_13.camera):GetComponent(typeof(Camera))
	local var2_13 = {}

	table.insert(var2_13, function(arg0_14)
		var0_0.UIMgr.GetInstance():LoadingOn(false)
		BLHX.Rendering.HotUpdate.ScreenShooterPass.TakePhoto(var1_13, arg0_14)
	end)
	table.insert(var2_13, function(arg0_15, arg1_15)
		var0_0.UIMgr.GetInstance():LoadingOff()

		local function var0_15(arg0_16, arg1_16)
			local var0_16 = arg1_16.x / arg3_13.sizeDelta.x * Screen.width
			local var1_16 = arg1_16.y / arg3_13.sizeDelta.y * Screen.height
			local var2_16 = (Screen.width - var0_16) / 2
			local var3_16 = (Screen.height - var1_16) / 2
			local var4_16 = arg0_16:GetPixels(var2_16, var3_16, var0_16, var1_16)
			local var5_16 = UnityEngine.Texture2D.New(var0_16, var1_16)

			var5_16:SetPixels(var4_16)
			var5_16:Apply()

			return var5_16
		end

		if arg2_13 then
			arg1_15 = var0_15(arg1_15, arg2_13)
		end

		local var1_15 = Tex2DExtension.EncodeToJPG(arg1_15)

		arg0_13:SaveImageWithBytes(var1_15)
		arg0_15()
	end)
	seriesAsync(var2_13, arg4_13)
end

function var1_0.ShowSharePanel(arg0_17, arg1_17, arg2_17, arg3_17, arg4_17)
	arg0_17.noBlur = arg4_17

	local var0_17 = var0_0.share_template[arg1_17]

	assert(var0_17, "share_template not exist: " .. arg1_17)

	local var1_17 = LuaHelper.GetCHPackageType()

	if (PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US) and var0_0.SdkMgr.GetInstance():GetIsPlatform() then
		local var2_17 = System.IO.File.ReadAllBytes(arg0_17.screenshotPath)
		local var3_17 = UnityEngine.Texture2D.New(Screen.width, Screen.height, TextureFormat.ARGB32, false)

		Tex2DExtension.LoadImage(var3_17, var2_17)
		var0_0.SdkMgr.GetInstance():GameShare(var0_17.description, var3_17)
		var0_0.UIMgr.GetInstance():LoadingOn()
		onDelayTick(function()
			var0_0.UIMgr.GetInstance():LoadingOff()
		end, 2)
	elseif PLATFORM_CODE == PLATFORM_CHT then
		var0_0.SdkMgr.GetInstance():ShareImg(arg0_17.screenshotPath, function()
			return
		end)
	elseif PLATFORM_CODE == PLATFORM_CH and var1_17 == PACKAGE_TYPE_BILI then
		var0_0.SdkMgr.GetInstance():GameShare(var0_17.description, arg0_17.screenshotPath)
	else
		arg0_17:ShowOwnUI(arg1_17, arg2_17, arg3_17, arg4_17)

		return true
	end
end

function var1_0.TakeTexture(arg0_20, arg1_20, arg2_20, arg3_20)
	if arg1_20 == var1_0.TypeValentineQte then
		local var0_20 = System.Collections.Generic.List_UnityEngine_Camera()
		local var1_20 = GameObject.Find("UICamera"):GetComponent(typeof(Camera))
		local var2_20 = GameObject.Find("OverlayCamera"):GetComponent(typeof(Camera))

		var0_20:Add(var1_20)
		var0_20:Add(var2_20)

		local var3_20 = arg2_20:TakePhotoMultiCam(var0_20)

		return (arg2_20:EncodeToJPG(var3_20))
	else
		local var4_20 = arg2_20:TakePhoto(arg3_20)

		return (arg2_20:EncodeToJPG(var4_20))
	end
end

function var1_0.TakePhoto(arg0_21, arg1_21, arg2_21, arg3_21)
	if arg1_21 == var1_0.TypeValentineQte then
		local var0_21 = System.Collections.Generic.List_UnityEngine_Camera()
		local var1_21 = GameObject.Find("UICamera"):GetComponent(typeof(Camera))
		local var2_21 = GameObject.Find("OverlayCamera"):GetComponent(typeof(Camera))

		var0_21:Add(var1_21)
		var0_21:Add(var2_21)

		return arg2_21:TakeMultiCam(var0_21, arg0_21.screenshotPath)
	else
		return arg2_21:Take(arg3_21, arg0_21.screenshotPath)
	end
end

function var1_0.ShowOwnUI(arg0_22, arg1_22, arg2_22, arg3_22, arg4_22)
	arg0_22.noBlur = arg4_22

	local var0_22 = var0_0.share_template[arg1_22]

	assert(var0_22, "share_template not exist: " .. arg1_22)
	arg0_22.go:SetActive(true)
	setActive(arg0_22.deckTF, false)

	arg2_22 = arg2_22 or var1_0.PANEL_TYPE_BLACK

	if arg2_22 == var1_0.PANEL_TYPE_BLACK then
		arg0_22.panel = arg0_22.panelBlack
	elseif arg2_22 == var1_0.PANEL_TYPE_PINK then
		arg0_22.panel = arg0_22.panelPink
	end

	setActive(arg0_22.panelBlack, arg2_22 == var1_0.PANEL_TYPE_BLACK)
	setActive(arg0_22.panelPink, arg2_22 == var1_0.PANEL_TYPE_PINK)

	if not arg4_22 then
		var0_0.UIMgr.GetInstance():BlurPanel(arg0_22.panel, setmetatable({
			staticBlur = true
		}, {
			__index = arg3_22
		}))
	end

	local function var1_22()
		arg0_22:Dispose()
	end

	onButton(arg0_22, arg0_22.panel:Find("main/top/btnBack"), var1_22)
	onButton(arg0_22, arg0_22.panel:Find("main/buttons/weibo"), function()
		var1_22()
	end)
	onButton(arg0_22, arg0_22.panel:Find("main/buttons/weixin"), function()
		var1_22()
	end)

	if PLATFORM_CODE == PLATFORM_KR then
		onButton(arg0_22, arg0_22.panel:Find("main/buttons/facebook"), function()
			var0_0.SdkMgr.GetInstance():ShareImg(arg0_22.screenshotPath)
			var1_22()
		end)
	end
end

function var1_0.Dispose(arg0_27)
	arg0_27.go:SetActive(false)

	if arg0_27.panel and not arg0_27.noBlur then
		var0_0.UIMgr.GetInstance():UnOverlayPanel(arg0_27.panel, arg0_27.tr)
	end

	PoolMgr.GetInstance():ReturnUI("ShareUI", arg0_27.go)
	var0_0.DelegateInfo.Dispose(arg0_27)

	arg0_27.go = nil
	arg0_27.tr = nil
	arg0_27.panel = nil
end

function var1_0.SaveImageWithBytes(arg0_28, arg1_28)
	BackYardThemeTempalteUtil.CheckSaveDirectory()

	local var0_28 = arg0_28.screenshotPath

	System.IO.File.WriteAllBytes(var0_28, arg1_28)
end
