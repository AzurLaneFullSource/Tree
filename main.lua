ys = {}
pg = {}
cs = {}
pg._weak = setmetatable({}, {
	__mode = "k"
})
PLATFORM_CH = 1
PLATFORM_JP = 2
PLATFORM_KR = 3
PLATFORM_US = 4
PLATFORM_CHT = 5
PLATFORM_CODE = PLATFORM_US
IsUnityEditor = UnityEngine.Application.isEditor

require("Include")
require("tolua.reflection")
tolua.loadassembly("Assembly-CSharp")
tolua.loadassembly("UnityEngine.UI")
math.randomseed(os.time())

CSharpVersion = NetConst.GatewayState

originalPrint("C# Ver... " .. CSharpVersion)

PLATFORM = LuaHelper.GetPlatformInt()
SDK_EXIT_CODE = 99

if not IsUnityEditor then
	function assert()
		return
	end
end

QualitySettings.vSyncCount = 0

UnityEngine.Physics.IgnoreLayerCollision(21, LayerMask.NameToLayer("Default"))
tolua.loadassembly("com.blhx.builtin-pipeline.runtime")
Dorm3dRoomTemplateScene.InitDefautQuality()
Dorm3dRoomTemplateScene.SettingQuality()
ReflectionHelp.RefSetField(typeof("ResourceMgr"), "_asyncMax", ResourceMgr.Inst, 30)

tf(GameObject.Find("EventSystem")):GetComponent(typeof(EventSystem)).sendNavigationEvents = false

if IsUnityEditor then
	function luaIdeDebugFunc()
		breakInfoFun = require("LuaDebugjit")("localhost", 7003)
		time = Timer.New(breakInfoFun, 0.5, -1, 1)

		time:Start()
		print("luaIdeDebugFunc")
	end
end

if PLATFORM_CODE == PLATFORM_CHT and PLATFORM == 8 then
	pg.SdkMgr.GetInstance():InitSDK()
end

pg.TimeMgr.GetInstance():Init()
pg.TimeMgr.GetInstance():_SetServerTime_(VersionMgr.Inst.timestamp, VersionMgr.Inst.monday0oclockTimestamp, VersionMgr.Inst.realStartUpTimeWhenSetServerTime)
pg.PushNotificationMgr.GetInstance():Init()

function OnApplicationPause(arg0_3)
	originalPrint("OnApplicationPause: " .. tostring(arg0_3))

	if not pg.m02 then
		return
	end

	if arg0_3 then
		pg.m02:sendNotification(GAME.PAUSE_BATTLE)
		pg.PushNotificationMgr.GetInstance():PushAll()
	else
		pg.SdkMgr.GetInstance():BindCPU()
	end

	pg.SdkMgr.GetInstance():OnAppPauseForSDK(arg0_3)
	pg.m02:sendNotification(GAME.ON_APPLICATION_PAUSE, arg0_3)
end

function OnApplicationExit()
	originalPrint("OnApplicationExit")

	if pg.FileDownloadMgr.GetInstance():IsRunning() then
		return
	end

	if pg.NewStoryMgr.GetInstance():IsRunning() then
		pg.NewStoryMgr.GetInstance():ForEscPress()

		return
	end

	if pg.NewGuideMgr.GetInstance():IsBusy() then
		return
	end

	if pg.PerformMgr.GetInstance():IsRunning() then
		return
	end

	local var0_4 = ys.Battle.BattleState.GetInstance()

	if var0_4 and var0_4:GetState() == var0_4.BATTLE_STATE_FIGHT and not var0_4:IsPause() then
		pg.m02:sendNotification(GAME.PAUSE_BATTLE)

		return
	end

	local var1_4 = pg.UIMgr.GetInstance()

	if not var1_4._loadPanel or var1_4:LoadingRetainCount() ~= 0 then
		return
	end

	if pg.SceneAnimMgr.GetInstance():IsPlaying() then
		return
	end

	local var2_4 = pg.MsgboxMgr.GetInstance()
	local var3_4 = var2_4 and var2_4:getMsgBoxOb()
	local var4_4 = pg.NewStoryMgr.GetInstance()

	if var4_4 and var4_4:IsRunning() then
		if var3_4 and var3_4.activeSelf then
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
			triggerButton(var2_4._closeBtn)
		end

		return
	end

	local var5_4 = pg.m02

	if not var5_4 then
		return
	end

	local var6_4 = var5_4:retrieveProxy(ContextProxy.__cname)

	if not var6_4 then
		return
	end

	local var7_4 = var6_4:getCurrentContext()

	if not var7_4 then
		return
	end

	local var8_4 = pg.ShareMgr.GetInstance()

	if var8_4.go and isActive(var8_4.go) then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
		triggerButton(var8_4.panel:Find("main/top/btnBack"))

		return
	end

	local var9_4 = var7_4:retriveLastChild()
	local var10_4 = var5_4:retrieveMediator(var9_4.mediator.__cname)

	if not var10_4 or not var10_4.viewComponent then
		return
	end

	local var11_4 = var10_4.viewComponent
	local var12_4 = var11_4._tf.parent
	local var13_4 = var11_4._tf:GetSiblingIndex()
	local var14_4 = -1
	local var15_4

	if var3_4 and var3_4.activeSelf then
		var15_4 = var3_4.transform.parent
		var14_4 = var3_4.transform:GetSiblingIndex()
	end

	if pg.playerResUI:checkBackPressed() then
		return
	end

	if var12_4 == var15_4 and var14_4 < var13_4 then
		var11_4:onBackPressed()

		return
	end

	if var3_4 and var3_4.activeSelf then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
		triggerButton(var2_4._closeBtn)

		return
	end

	local var16_4 = checkExist(pg.NewStyleMsgboxMgr.GetInstance(), {
		"_tf"
	})

	if var16_4 and isActive(var16_4) then
		pg.NewStyleMsgboxMgr.GetInstance():Hide()

		return
	end

	local var17_4 = nowWorld()

	if var17_4 and var17_4.staminaMgr:IsShowing() then
		var17_4.staminaMgr:Hide()

		return
	end

	var11_4:onBackPressed()
end

function OnReceiveMemoryWarning()
	return
end

function PressBack()
	if not IsNil(pg.MsgboxMgr.GetInstance()._go) then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("confirm_app_exit"),
			onYes = function()
				Application.Quit()
			end
		})
	end
end

local function var0_0(arg0_8)
	parallelAsync({
		function(arg0_9)
			pg.LayerWeightMgr.GetInstance():Init(arg0_9)
		end,
		function(arg0_10)
			pg.UIMgr.GetInstance():Init(arg0_10)
		end,
		function(arg0_11)
			pg.CriMgr.GetInstance():Init(arg0_11)
		end
	}, arg0_8)
end

local function var1_0(arg0_12)
	parallelAsync({
		function(arg0_13)
			pg.FontMgr.GetInstance():Init(arg0_13)
		end,
		function(arg0_14)
			pg.ShaderMgr.GetInstance():Init(arg0_14)
		end,
		function(arg0_15)
			pg.PoolMgr.GetInstance():Init(arg0_15)
		end,
		function(arg0_16)
			pg.TipsMgr.GetInstance():Init(arg0_16)
		end,
		function(arg0_17)
			pg.MsgboxMgr.GetInstance():Init(arg0_17)
		end,
		function(arg0_18)
			pg.NewStyleMsgboxMgr.GetInstance():Init(arg0_18)
		end,
		function(arg0_19)
			pg.SystemOpenMgr.GetInstance():Init(arg0_19)
		end,
		function(arg0_20)
			pg.SystemGuideMgr.GetInstance():Init(arg0_20)
		end,
		function(arg0_21)
			pg.NewGuideMgr.GetInstance():Init(arg0_21)
		end,
		function(arg0_22)
			pg.SeriesGuideMgr.GetInstance():Init(arg0_22)
		end,
		function(arg0_23)
			pg.ToastMgr.GetInstance():Init(arg0_23)
		end,
		function(arg0_24)
			pg.WorldToastMgr.GetInstance():Init(arg0_24)
		end,
		function(arg0_25)
			pg.SecondaryPWDMgr.GetInstance():Init(arg0_25)
		end,
		function(arg0_26)
			pg.ShipFlagMgr.GetInstance():Init(arg0_26)
		end,
		function(arg0_27)
			pg.NewStoryMgr.GetInstance():Init(arg0_27)
		end,
		function(arg0_28)
			pg.RedDotMgr.GetInstance():Init(arg0_28)
		end,
		function(arg0_29)
			pg.UserAgreementMgr.GetInstance():Init(arg0_29)
		end,
		function(arg0_30)
			pg.BrightnessMgr.GetInstance():Init(arg0_30)
		end,
		function(arg0_31)
			pg.ConfigTablePreloadMgr.GetInstance():Init(arg0_31)
		end,
		function(arg0_32)
			pg.CameraFixMgr.GetInstance():Init(arg0_32)
		end,
		function(arg0_33)
			pg.BgmMgr.GetInstance():Init(arg0_33)
		end,
		function(arg0_34)
			pg.FileDownloadMgr.GetInstance():Init(arg0_34)
		end,
		function(arg0_35)
			pg.RepairResMgr.GetInstance():Init(arg0_35)
		end,
		function(arg0_36)
			pg.NodeCanvasMgr.GetInstance():Init(arg0_36)
		end,
		function(arg0_37)
			pg.SceneAnimMgr.GetInstance():Init(arg0_37)
		end,
		function(arg0_38)
			pg.PerformMgr.GetInstance():Init(arg0_38)
		end,
		function(arg0_39)
			pg.ClickEffectMgr.GetInstance():Init(arg0_39)
		end,
		function(arg0_40)
			pg.CameraRTMgr.GetInstance():Init(arg0_40)
		end
	}, arg0_12)
end

local var2_0 = os.clock()

seriesAsync({
	var0_0,
	var1_0
}, function(arg0_41)
	pg.SdkMgr.GetInstance():QueryWithProduct()
	print("loading cost: " .. os.clock() - var2_0)
	VersionMgr.Inst:DestroyUI()

	local var0_41 = GameObject.Find("OverlayCamera/Overlay/UIMain/ServerChoosePanel")

	if not IsNil(var0_41) then
		Object.Destroy(var0_41)
	end

	Screen.sleepTimeout = SleepTimeout.SystemSetting

	pg.UIMgr.GetInstance():displayLoadingBG(true)

	if arg0_41 then
		pg.UIMgr.GetInstance():Loading(arg0_41)
		error(arg0_41)

		return
	end

	pg.SdkMgr.GetInstance():BindCPU()

	pg.m02 = pm.Facade.getInstance("m02")

	pg.m02:registerCommand(GAME.STARTUP, StartupCommand)
	pg.m02:sendNotification(GAME.STARTUP)

	pg.playerResUI = PlayerResUI.New()

	pg.SdkMgr.GetInstance():GoSDkLoginScene()
	pg.UIMgr.GetInstance():AddDebugButton("Device Info", function()
		originalPrint("+++++++++++graphicsDeviceVendorID:" .. SystemInfo.graphicsDeviceVendorID)
		DevicePerformanceUtil.GetDevicePerformanceLevel()
		originalPrint("CPU核心:" .. SystemInfo.processorCount)
		originalPrint("显存:" .. SystemInfo.graphicsMemorySize)
		originalPrint("内存:" .. SystemInfo.systemMemorySize)
		originalPrint("主频:" .. SystemInfo.processorFrequency)
		originalPrint("+++++++++++")
	end)
end)
