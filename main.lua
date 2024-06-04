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

function OnApplicationPause(arg0)
	originalPrint("OnApplicationPause: " .. tostring(arg0))

	if not pg.m02 then
		return
	end

	if arg0 then
		pg.m02:sendNotification(GAME.PAUSE_BATTLE)
		pg.PushNotificationMgr.GetInstance():PushAll()
	else
		pg.SdkMgr.GetInstance():BindCPU()
	end

	pg.SdkMgr.GetInstance():OnAppPauseForSDK(arg0)
	pg.m02:sendNotification(GAME.ON_APPLICATION_PAUSE, arg0)
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

	local var0 = ys.Battle.BattleState.GetInstance()

	if var0 and var0:GetState() == var0.BATTLE_STATE_FIGHT and not var0:IsPause() then
		pg.m02:sendNotification(GAME.PAUSE_BATTLE)

		return
	end

	local var1 = pg.UIMgr.GetInstance()

	if not var1._loadPanel or var1:LoadingRetainCount() ~= 0 then
		return
	end

	if pg.SceneAnimMgr.GetInstance():IsPlaying() then
		return
	end

	local var2 = pg.MsgboxMgr.GetInstance()
	local var3 = var2 and var2:getMsgBoxOb()
	local var4 = pg.NewStoryMgr.GetInstance()

	if var4 and var4:IsRunning() then
		if var3 and var3.activeSelf then
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
			triggerButton(var2._closeBtn)
		end

		return
	end

	local var5 = pg.m02

	if not var5 then
		return
	end

	local var6 = var5:retrieveProxy(ContextProxy.__cname)

	if not var6 then
		return
	end

	local var7 = var6:getCurrentContext()

	if not var7 then
		return
	end

	local var8 = pg.ShareMgr.GetInstance()

	if var8.go and isActive(var8.go) then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
		triggerButton(var8.panel:Find("main/top/btnBack"))

		return
	end

	local var9 = var7:retriveLastChild()
	local var10 = var5:retrieveMediator(var9.mediator.__cname)

	if not var10 or not var10.viewComponent then
		return
	end

	local var11 = var10.viewComponent
	local var12 = var11._tf.parent
	local var13 = var11._tf:GetSiblingIndex()
	local var14 = -1
	local var15

	if var3 and var3.activeSelf then
		var15 = var3.transform.parent
		var14 = var3.transform:GetSiblingIndex()
	end

	if pg.playerResUI:checkBackPressed() then
		return
	end

	if var12 == var15 and var14 < var13 then
		var11:onBackPressed()

		return
	end

	if var3 and var3.activeSelf then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
		triggerButton(var2._closeBtn)

		return
	end

	local var16 = nowWorld()

	if var16 and var16.staminaMgr:IsShowing() then
		var16.staminaMgr:Hide()

		return
	end

	var11:onBackPressed()
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

local function var0(arg0)
	parallelAsync({
		function(arg0)
			pg.LayerWeightMgr.GetInstance():Init(arg0)
		end,
		function(arg0)
			pg.UIMgr.GetInstance():Init(arg0)
		end,
		function(arg0)
			pg.CriMgr.GetInstance():Init(arg0)
		end
	}, arg0)
end

local function var1(arg0)
	parallelAsync({
		function(arg0)
			pg.FontMgr.GetInstance():Init(arg0)
		end,
		function(arg0)
			pg.ShaderMgr.GetInstance():Init(arg0)
		end,
		function(arg0)
			pg.PoolMgr.GetInstance():Init(arg0)
		end,
		function(arg0)
			pg.TipsMgr.GetInstance():Init(arg0)
		end,
		function(arg0)
			pg.MsgboxMgr.GetInstance():Init(arg0)
		end,
		function(arg0)
			pg.SystemOpenMgr.GetInstance():Init(arg0)
		end,
		function(arg0)
			pg.SystemGuideMgr.GetInstance():Init(arg0)
		end,
		function(arg0)
			pg.NewGuideMgr.GetInstance():Init(arg0)
		end,
		function(arg0)
			pg.SeriesGuideMgr.GetInstance():Init(arg0)
		end,
		function(arg0)
			pg.ToastMgr.GetInstance():Init(arg0)
		end,
		function(arg0)
			pg.WorldToastMgr.GetInstance():Init(arg0)
		end,
		function(arg0)
			pg.SecondaryPWDMgr.GetInstance():Init(arg0)
		end,
		function(arg0)
			pg.ShipFlagMgr.GetInstance():Init(arg0)
		end,
		function(arg0)
			pg.NewStoryMgr.GetInstance():Init(arg0)
		end,
		function(arg0)
			pg.RedDotMgr.GetInstance():Init(arg0)
		end,
		function(arg0)
			pg.UserAgreementMgr.GetInstance():Init(arg0)
		end,
		function(arg0)
			pg.BrightnessMgr.GetInstance():Init(arg0)
		end,
		function(arg0)
			pg.ConfigTablePreloadMgr.GetInstance():Init(arg0)
		end,
		function(arg0)
			pg.CameraFixMgr.GetInstance():Init(arg0)
		end,
		function(arg0)
			pg.BgmMgr.GetInstance():Init(arg0)
		end,
		function(arg0)
			pg.FileDownloadMgr.GetInstance():Init(arg0)
		end,
		function(arg0)
			pg.RepairResMgr.GetInstance():Init(arg0)
		end,
		function(arg0)
			pg.NodeCanvasMgr.GetInstance():Init(arg0)
		end,
		function(arg0)
			pg.SceneAnimMgr.GetInstance():Init(arg0)
		end,
		function(arg0)
			pg.PerformMgr.GetInstance():Init(arg0)
		end
	}, arg0)
end

local var2 = os.clock()

seriesAsync({
	var0,
	var1
}, function(arg0)
	pg.SdkMgr.GetInstance():QueryWithProduct()
	print("loading cost: " .. os.clock() - var2)
	VersionMgr.Inst:DestroyUI()

	local var0 = GameObject.Find("OverlayCamera/Overlay/UIMain/ServerChoosePanel")

	if not IsNil(var0) then
		Object.Destroy(var0)
	end

	Screen.sleepTimeout = SleepTimeout.SystemSetting

	pg.UIMgr.GetInstance():displayLoadingBG(true)
	pg.UIMgr.GetInstance():LoadingOn()

	if arg0 then
		pg.UIMgr.GetInstance():Loading(arg0)
		error(arg0)

		return
	end

	pg.SdkMgr.GetInstance():BindCPU()

	pg.m02 = pm.Facade.getInstance("m02")

	pg.m02:registerCommand(GAME.STARTUP, StartupCommand)
	pg.m02:sendNotification(GAME.STARTUP)

	pg.playerResUI = PlayerResUI.New()

	pg.SdkMgr.GetInstance():GoSDkLoginScene()
end)
