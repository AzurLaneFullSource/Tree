local var0_0 = class("BaseUI", import("view.base.BaseEventLogic"))

var0_0.LOADED = "BaseUI:LOADED"
var0_0.DID_ENTER = "BaseUI:DID_ENTER"
var0_0.AVALIBLE = "BaseUI:AVALIBLE"
var0_0.DID_EXIT = "BaseUI:DID_EXIT"
var0_0.ON_BACK = "BaseUI:ON_BACK"
var0_0.ON_RETURN = "BaseUI:ON_RETURN"
var0_0.ON_HOME = "BaseUI:ON_HOME"
var0_0.ON_CLOSE = "BaseUI:ON_CLOSE"
var0_0.ON_DROP = "BaseUI.ON_DROP"
var0_0.ON_DROP_LIST = "BaseUI.ON_DROP_LIST"
var0_0.ON_DROP_LIST_OWN = "BaseUI.ON_DROP_LIST_OWN"
var0_0.ON_NEW_DROP = "BaseUI.ON_NEW_DROP"
var0_0.ON_NEW_STYLE_DROP = "BaseUI.ON_NEW_STYLE_DROP"
var0_0.ON_NEW_STYLE_ITEMS = "BaseUI.ON_NEW_STYLE_ITEMS"
var0_0.ON_ITEM = "BaseUI:ON_ITEM"
var0_0.ON_ITEM_EXTRA = "BaseUI.ON_ITEM_EXTRA"
var0_0.ON_SHIP = "BaseUI:ON_SHIP"
var0_0.ON_AWARD = "BaseUI:ON_AWARD"
var0_0.ON_ACHIEVE = "BaseUI:ON_ACHIEVE"
var0_0.ON_ACHIEVE_AUTO = "BaseUI:ON_ACHIEVE_AUTO"
var0_0.ON_WORLD_ACHIEVE = "BaseUI:ON_WORLD_ACHIEVE"
var0_0.ON_EQUIPMENT = "BaseUI:ON_EQUIPMENT"
var0_0.ON_SPWEAPON = "BaseUI:ON_SPWEAPON"
var0_0.ON_SHIP_EXP = "BaseUI.ON_SHIP_EXP"
var0_0.ON_BACK_PRESSED = "BaseUI:ON_BACK_PRESS"

function var0_0.Ctor(arg0_1)
	var0_0.super.Ctor(arg0_1)

	arg0_1._isLoaded = false
	arg0_1._go = nil
	arg0_1._tf = nil
	arg0_1._isCachedView = false
end

function var0_0.setContextData(arg0_2, arg1_2)
	arg0_2.contextData = arg1_2
end

function var0_0.getUIName(arg0_3)
	return nil
end

function var0_0.getGroupName(arg0_4)
	return arg0_4.contextData.groupName or arg0_4.__cname
end

function var0_0.getDefaultUI(arg0_5)
	return arg0_5._tf
end

function var0_0.preloadUIList(arg0_6)
	return {
		arg0_6:getUIName()
	}
end

function var0_0.needCache(arg0_7)
	return false
end

function var0_0.tempCache(arg0_8)
	return false
end

function var0_0.forceGC(arg0_9)
	return false
end

function var0_0.forceRatio(arg0_10)
	return nil
end

function var0_0.loadingQueue(arg0_11)
	return false
end

function var0_0.setLayerMgrRegister(arg0_12, arg1_12)
	if not arg0_12.contextData then
		return
	end

	local var0_12 = arg0_12:getGroupName()

	if arg1_12 then
		pg.LayerWeightMgr.GetInstance():RegisterGroupWeight(var0_12)
	else
		pg.LayerWeightMgr.GetInstance():RemoveGroupWeight(var0_12)
	end
end

function var0_0.preload(arg0_13, arg1_13)
	arg1_13()
end

function var0_0.loadUISync(arg0_14, arg1_14)
	local var0_14 = LoadAndInstantiateSync("UI", arg1_14, true, false)
	local var1_14 = pg.UIMgr.GetInstance().UIMain

	var0_14.transform:SetParent(var1_14.transform, false)

	return var0_14
end

function var0_0.GCWhenAwake(arg0_15)
	return tobool(arg0_15:loadingQueue())
end

function var0_0.load(arg0_16)
	arg0_16:setLayerMgrRegister(true)

	local var0_16
	local var1_16 = Time.realtimeSinceStartup
	local var2_16 = arg0_16:getUIName()

	seriesAsync({
		function(arg0_17)
			if arg0_16:GCWhenAwake() then
				gcAll(true)
			end

			arg0_16:preload(arg0_17)
		end,
		function(arg0_18)
			arg0_16:LoadUIFromPool(var2_16, function(arg0_19)
				print("Loaded " .. var2_16)

				var0_16 = arg0_19

				arg0_18()
			end)
		end
	}, function()
		originalPrint("load " .. var0_16.name .. " time cost: " .. Time.realtimeSinceStartup - var1_16)
		arg0_16:SetUIParent(var0_16)

		if arg0_16:CheckTempCache() then
			PoolMgr.GetInstance():KeepUICache(var2_16, true)
		end

		arg0_16:onUILoaded(var0_16)
	end)
end

function var0_0.SetUIParent(arg0_21, arg1_21)
	local var0_21 = pg.UIMgr.GetInstance().UIMain

	arg1_21.transform:SetParent(var0_21.transform, false)
end

function var0_0.LoadUIFromPool(arg0_22, arg1_22, arg2_22)
	PoolMgr.GetInstance():GetUI(arg1_22, true, arg2_22)
end

function var0_0.getBGM(arg0_23, arg1_23)
	return getBgm(arg1_23 or arg0_23.__cname)
end

function var0_0.PlayBGM(arg0_24)
	local var0_24 = arg0_24:getBGM()

	if var0_24 then
		pg.BgmMgr.GetInstance():Push(arg0_24.__cname, var0_24)
	end
end

function var0_0.StopBgm(arg0_25)
	if not arg0_25.contextData then
		return
	end

	if arg0_25.contextData.isLayer then
		pg.BgmMgr.GetInstance():Pop(arg0_25.__cname)
	else
		pg.BgmMgr.GetInstance():Clear()
	end
end

function var0_0.isLoaded(arg0_26)
	return arg0_26._isLoaded
end

function var0_0.CheckTempCache(arg0_27)
	return arg0_27:tempCache() and arg0_27:isLayer()
end

function var0_0.isLayer(arg0_28)
	return arg0_28.contextData ~= nil and arg0_28.contextData.isLayer
end

function var0_0.Add2Overlay(arg0_29, arg1_29, arg2_29)
	if not arg0_29.contextData then
		return
	end

	arg2_29 = arg2_29 or {}
	arg2_29.groupName = arg0_29:getGroupName()

	pg.LayerWeightMgr.GetInstance():Add2Overlay(arg1_29, arg2_29)
end

function var0_0.DelFromOverlay(arg0_30, arg1_30, ...)
	if not arg0_30.contextData then
		return
	end

	pg.LayerWeightMgr.GetInstance():DelFromOverlay(arg1_30, ...)
end

function var0_0.OverlayPanel(arg0_31, arg1_31, arg2_31)
	arg2_31 = arg2_31 or {}
	arg2_31.type = LayerWeightConst.UI_TYPE_SUB

	arg0_31:Add2Overlay(arg1_31, arg2_31)
end

function var0_0.BlurPanel(arg0_32, arg1_32, arg2_32)
	arg2_32 = arg2_32 or {}
	arg2_32.type = LayerWeightConst.UI_TYPE_SUB
	arg2_32.globalBlur = true

	arg0_32:Add2Overlay(arg1_32, arg2_32)
end

function var0_0.UnOverlayPanel(arg0_33, arg1_33, arg2_33)
	arg0_33:DelFromOverlay(arg1_33, arg2_33 or arg0_33.UIMain)
end

function var0_0.TempOverlayPanelPB(arg0_34, arg1_34, arg2_34)
	if not arg0_34.contextData then
		return
	end

	arg2_34 = arg2_34 or {}
	arg2_34.groupName = arg0_34:getGroupName()

	pg.UIMgr.GetInstance():TempOverlayPanelPB(arg1_34, arg2_34)
end

function var0_0.TempUnOverlayPanelPB(arg0_35, arg1_35, arg2_35)
	if not arg0_35.contextData then
		return
	end

	pg.UIMgr.GetInstance():TempUnOverlayPanelPB(arg1_35, arg2_35)
end

var0_0.optionsPath = {
	"option",
	"top/option",
	"top/left_top/option",
	"blur_container/top/title/option",
	"blur_container/top/option",
	"top/top/option",
	"common/top/option",
	"blur_panel/top/option",
	"blurPanel/top/option",
	"blur_container/top/option",
	"top/title/option",
	"blur_panel/adapt/top/option",
	"mainPanel/top/option",
	"bg/top/option",
	"blur_container/adapt/top/title/option",
	"blur_container/adapt/top/option",
	"ForNorth/top/option",
	"top/top_chapter/option",
	"Main/blur_panel/adapt/top/option",
	"adapt/blur_panel/adapt/top/option"
}

function var0_0.onUILoaded(arg0_36, arg1_36)
	arg0_36._go = arg1_36
	arg0_36._tf = arg1_36 and arg1_36.transform

	arg0_36:Add2Overlay(arg0_36:getDefaultUI(), {
		type = LayerWeightConst.UI_TYPE_SYSTEM
	})
	pg.SeriesGuideMgr.GetInstance():dispatch({
		view = arg0_36.__cname
	})
	pg.NewStoryMgr.GetInstance():OnSceneEnter({
		view = arg0_36.__cname
	})

	arg0_36._isLoaded = true

	pg.DelegateInfo.New(arg0_36)

	arg0_36.optionBtns = {}

	for iter0_36, iter1_36 in ipairs(arg0_36.optionsPath) do
		table.insert(arg0_36.optionBtns, arg0_36._tf:Find(iter1_36))
	end

	setActiveViaLayer(arg0_36._tf, true)
	bindComponent(arg0_36, arg0_36._go)
	arg0_36:init()
	arg0_36:emit(var0_0.LOADED)
end

function var0_0.ResUISettings(arg0_37)
	return nil
end

function var0_0.ShowOrHideResUI(arg0_38, arg1_38)
	local var0_38 = arg0_38:ResUISettings()

	if not var0_38 then
		return
	end

	if var0_38 == true then
		var0_38 = {
			anim = true,
			showType = PlayerResUI.TYPE_ALL
		}
	end

	local var1_38 = arg0_38:getGroupName()

	if arg1_38 then
		pg.playerResUI:SetSettings(var1_38, setmetatable({
			groupName = var1_38
		}, {
			__index = var0_38
		}))
	else
		pg.playerResUI:RemoveSettings(var1_38)
	end
end

function var0_0.onUIAnimEnd(arg0_39, arg1_39)
	arg1_39()
end

function var0_0.init(arg0_40)
	return
end

function var0_0.quickExitFunc(arg0_41)
	arg0_41:emit(var0_0.ON_HOME)
end

function var0_0.quickExit(arg0_42)
	for iter0_42, iter1_42 in ipairs(arg0_42.optionBtns) do
		onButton(arg0_42, iter1_42, function()
			arg0_42:quickExitFunc()
		end, SFX_PANEL)
	end
end

function var0_0.enter(arg0_44)
	arg0_44:quickExit()
	arg0_44:PlayBGM()
	arg0_44:emit(var0_0.DID_ENTER)

	if arg0_44:forceRatio() then
		pg.CameraFixMgr.GetInstance():SetForceRatio(arg0_44:forceRatio())
	end

	if not arg0_44._isCachedView then
		arg0_44:didEnter()
		arg0_44:ShowOrHideResUI(true)
	end

	if tobool(arg0_44:loadingQueue()) and arg0_44.contextData.resumeCallback then
		local var0_44 = arg0_44.contextData.resumeCallback

		arg0_44.contextData.resumeCallback = nil

		var0_44()
	end

	arg0_44:emit(var0_0.AVALIBLE)
	arg0_44:onUIAnimEnd(function()
		pg.SeriesGuideMgr.GetInstance():start({
			view = arg0_44.__cname,
			code = {
				pg.SeriesGuideMgr.CODES.MAINUI
			}
		})
		pg.NewGuideMgr.GetInstance():OnSceneEnter({
			view = arg0_44.__cname
		})
	end)
end

function var0_0.closeView(arg0_46)
	if arg0_46.contextData.isLayer then
		arg0_46:emit(var0_0.ON_CLOSE)
	else
		arg0_46:emit(var0_0.ON_BACK)
	end
end

function var0_0.didEnter(arg0_47)
	return
end

function var0_0.willExit(arg0_48)
	return
end

function var0_0.exit(arg0_49)
	arg0_49.exited = true

	arg0_49:StopBgm()
	pg.DelegateInfo.Dispose(arg0_49)
	arg0_49:willExit()
	arg0_49:ShowOrHideResUI(false)
	arg0_49:DelFromOverlay(arg0_49:getDefaultUI())
	arg0_49:setLayerMgrRegister(false)
	arg0_49:detach()

	if arg0_49:forceRatio() then
		pg.CameraFixMgr.GetInstance():SetForceRatio(nil)
	end

	pg.NewGuideMgr.GetInstance():OnSceneExit({
		view = arg0_49.__cname
	})
	pg.NewStoryMgr.GetInstance():OnSceneExit({
		view = arg0_49.__cname
	})
	arg0_49:emit(var0_0.DID_EXIT)
end

function var0_0.PlayUIAnimation(arg0_50, arg1_50, arg2_50, arg3_50)
	local var0_50 = arg1_50:GetComponent(typeof(Animation))
	local var1_50 = arg1_50:GetComponent(typeof(UIEventTrigger))

	var1_50.didExit:RemoveAllListeners()
	var1_50.didExit:AddListener(function()
		var1_50.didExit:RemoveAllListeners()
		arg3_50()
	end)
	var0_50:Play(arg2_50)
end

function var0_0.attach(arg0_52, arg1_52)
	return
end

function var0_0.ClearTweens(arg0_53, arg1_53)
	arg0_53:cleanManagedTween(arg1_53)
end

function var0_0.detach(arg0_54, arg1_54)
	arg0_54._isLoaded = false

	pg.DynamicBgMgr.GetInstance():ClearBg(arg0_54:getUIName())
	arg0_54:disposeEvent()
	arg0_54:ClearTweens(false)

	arg0_54._tf = nil

	local var0_54 = PoolMgr.GetInstance()
	local var1_54 = arg0_54:getUIName()

	if arg0_54._go ~= nil and var1_54 then
		var0_54:ReturnUI(var1_54, arg0_54._go)

		arg0_54._go = nil
	end
end

function var0_0.getTpl(arg0_55, arg1_55, arg2_55)
	local var0_55 = (arg2_55 or arg0_55._tf):Find(arg1_55)

	var0_55:SetParent(arg0_55._tf, false)
	SetActive(var0_55, false)

	return var0_55
end

function var0_0.setSpriteTo(arg0_56, arg1_56, arg2_56, arg3_56)
	local var0_56 = arg2_56:GetComponent(typeof(Image))

	var0_56.sprite = arg0_56._tf:Find(arg1_56):GetComponent(typeof(Image)).sprite

	if arg3_56 then
		var0_56:SetNativeSize()
	end
end

function var0_0.setImageAmount(arg0_57, arg1_57, arg2_57)
	arg1_57:GetComponent(typeof(Image)).fillAmount = arg2_57
end

function var0_0.setVisible(arg0_58, arg1_58)
	arg0_58:ShowOrHideResUI(arg1_58)

	if arg1_58 then
		arg0_58:OnVisible()
	else
		arg0_58:OnDisVisible()
	end

	setActiveViaLayer(arg0_58._tf, arg1_58)
end

function var0_0.OnVisible(arg0_59)
	return
end

function var0_0.OnDisVisible(arg0_60)
	return
end

function var0_0.onBackPressed(arg0_61)
	arg0_61:emit(var0_0.ON_BACK_PRESSED)
end

return var0_0
