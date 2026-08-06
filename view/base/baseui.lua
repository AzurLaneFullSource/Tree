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
var0_0.ON_ADD_SUBLAYER = "BaseUI:ON_ADD_SUBLAYER"

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

function var0_0.DontGC(arg0_10)
	return false
end

function var0_0.forceRatio(arg0_11)
	return nil
end

function var0_0.loadingQueue(arg0_12)
	return false
end

function var0_0.setLayerMgrRegister(arg0_13, arg1_13)
	if not arg0_13.contextData then
		return
	end

	local var0_13 = arg0_13:getGroupName()

	if arg1_13 then
		pg.LayerWeightMgr.GetInstance():RegisterGroupWeight(var0_13)
	else
		pg.LayerWeightMgr.GetInstance():RemoveGroupWeight(var0_13)
	end
end

function var0_0.preload(arg0_14, arg1_14)
	arg1_14()
end

function var0_0.loadUISync(arg0_15, arg1_15)
	local var0_15 = LoadAndInstantiateSync("UI", arg1_15, true, false)
	local var1_15 = pg.UIMgr.GetInstance().UIMain

	var0_15.transform:SetParent(var1_15.transform, false)

	return var0_15
end

function var0_0.GCWhenAwake(arg0_16)
	return tobool(arg0_16:loadingQueue())
end

function var0_0.load(arg0_17)
	arg0_17:setLayerMgrRegister(true)

	local var0_17
	local var1_17 = Time.realtimeSinceStartup
	local var2_17 = arg0_17:getUIName()

	seriesAsync({
		function(arg0_18)
			if arg0_17:GCWhenAwake() then
				gcAll(true)
			end

			arg0_17:preload(arg0_18)
		end,
		function(arg0_19)
			arg0_17:LoadUIFromPool(var2_17, function(arg0_20)
				print("Loaded " .. var2_17)

				var0_17 = arg0_20

				arg0_19()
			end)
		end
	}, function()
		originalPrint("load " .. var0_17.name .. " time cost: " .. Time.realtimeSinceStartup - var1_17)
		arg0_17:SetUIParent(var0_17)

		if arg0_17:CheckTempCache() then
			PoolMgr.GetInstance():KeepUICache(var2_17, true)
		end

		arg0_17:onUILoaded(var0_17)
	end)
end

function var0_0.SetUIParent(arg0_22, arg1_22)
	local var0_22 = pg.UIMgr.GetInstance().UIMain

	arg1_22.transform:SetParent(var0_22.transform, false)
end

function var0_0.LoadUIFromPool(arg0_23, arg1_23, arg2_23)
	PoolMgr.GetInstance():GetUI(arg1_23, true, arg2_23)
end

function var0_0.getBGM(arg0_24, arg1_24)
	return getBgm(arg1_24 or arg0_24.__cname)
end

function var0_0.PlayBGM(arg0_25)
	local var0_25 = arg0_25:getBGM()

	if var0_25 then
		pg.BgmMgr.GetInstance():Push(arg0_25.__cname, var0_25)
	end
end

function var0_0.StopBgm(arg0_26)
	if not arg0_26.contextData then
		return
	end

	if arg0_26.contextData.isLayer then
		pg.BgmMgr.GetInstance():Pop(arg0_26.__cname)
	else
		pg.BgmMgr.GetInstance():Clear()
	end
end

function var0_0.isLoaded(arg0_27)
	return arg0_27._isLoaded
end

function var0_0.CheckTempCache(arg0_28)
	return arg0_28:tempCache() and arg0_28:isLayer()
end

function var0_0.isLayer(arg0_29)
	return arg0_29.contextData ~= nil and arg0_29.contextData.isLayer
end

function var0_0.Add2Overlay(arg0_30, arg1_30, arg2_30)
	if not arg0_30.contextData then
		return
	end

	arg2_30 = arg2_30 or {}
	arg2_30.groupName = arg0_30:getGroupName()

	pg.LayerWeightMgr.GetInstance():Add2Overlay(arg1_30, arg2_30)
end

function var0_0.DelFromOverlay(arg0_31, arg1_31, ...)
	if not arg0_31.contextData then
		return
	end

	pg.LayerWeightMgr.GetInstance():DelFromOverlay(arg1_31, ...)
end

function var0_0.OverlayPanel(arg0_32, arg1_32, arg2_32)
	arg2_32 = arg2_32 or {}
	arg2_32.type = LayerWeightConst.UI_TYPE_SUB

	arg0_32:Add2Overlay(arg1_32, arg2_32)
end

function var0_0.BlurPanel(arg0_33, arg1_33, arg2_33)
	arg2_33 = arg2_33 or {}
	arg2_33.type = LayerWeightConst.UI_TYPE_SUB
	arg2_33.globalBlur = true

	arg0_33:Add2Overlay(arg1_33, arg2_33)
end

function var0_0.UnOverlayPanel(arg0_34, arg1_34, arg2_34)
	arg0_34:DelFromOverlay(arg1_34, arg2_34 or arg0_34.UIMain)
end

function var0_0.TempOverlayPanelPB(arg0_35, arg1_35, arg2_35)
	if not arg0_35.contextData then
		return
	end

	arg2_35 = arg2_35 or {}
	arg2_35.groupName = arg0_35:getGroupName()

	pg.UIMgr.GetInstance():TempOverlayPanelPB(arg1_35, arg2_35)
end

function var0_0.TempUnOverlayPanelPB(arg0_36, arg1_36, arg2_36)
	if not arg0_36.contextData then
		return
	end

	pg.UIMgr.GetInstance():TempUnOverlayPanelPB(arg1_36, arg2_36)
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

function var0_0.onUILoaded(arg0_37, arg1_37)
	arg0_37._go = arg1_37
	arg0_37._tf = arg1_37 and arg1_37.transform

	arg0_37:Add2Overlay(arg0_37:getDefaultUI(), {
		type = LayerWeightConst.UI_TYPE_SYSTEM
	})
	pg.SeriesGuideMgr.GetInstance():dispatch({
		view = arg0_37.__cname
	})
	pg.NewStoryMgr.GetInstance():OnSceneEnter({
		view = arg0_37.__cname
	})

	arg0_37._isLoaded = true

	pg.DelegateInfo.New(arg0_37)

	arg0_37.optionBtns = {}

	for iter0_37, iter1_37 in ipairs(arg0_37.optionsPath) do
		table.insert(arg0_37.optionBtns, arg0_37._tf:Find(iter1_37))
	end

	setActiveViaLayer(arg0_37._tf, true)
	bindComponent(arg0_37, arg0_37._go)
	arg0_37:init()
	arg0_37:emit(var0_0.LOADED)
end

function var0_0.ResUISettings(arg0_38)
	return nil
end

function var0_0.ShowOrHideResUI(arg0_39, arg1_39)
	local var0_39 = arg0_39:ResUISettings()

	if not var0_39 then
		return
	end

	if var0_39 == true then
		var0_39 = {
			anim = true,
			showType = PlayerResUI.TYPE_ALL
		}
	end

	local var1_39 = arg0_39:getGroupName()

	if arg1_39 then
		pg.playerResUI:SetSettings(var1_39, setmetatable({
			groupName = var1_39
		}, {
			__index = var0_39
		}))
	else
		pg.playerResUI:RemoveSettings(var1_39)
	end
end

function var0_0.onUIAnimEnd(arg0_40, arg1_40)
	arg1_40()
end

function var0_0.init(arg0_41)
	return
end

function var0_0.quickExitFunc(arg0_42)
	arg0_42:emit(var0_0.ON_HOME)
end

function var0_0.quickExit(arg0_43)
	for iter0_43, iter1_43 in ipairs(arg0_43.optionBtns) do
		onButton(arg0_43, iter1_43, function()
			arg0_43:quickExitFunc()
		end, SFX_PANEL)
	end
end

function var0_0.enter(arg0_45)
	arg0_45:quickExit()
	arg0_45:PlayBGM()
	arg0_45:emit(var0_0.DID_ENTER)

	if arg0_45:forceRatio() then
		pg.CameraFixMgr.GetInstance():SetForceRatio(arg0_45:forceRatio())
	end

	if not arg0_45._isCachedView then
		arg0_45:didEnter()
		arg0_45:ShowOrHideResUI(true)
	end

	if tobool(arg0_45:loadingQueue()) and arg0_45.contextData.resumeCallback then
		local var0_45 = arg0_45.contextData.resumeCallback

		arg0_45.contextData.resumeCallback = nil

		var0_45()
	end

	arg0_45:emit(var0_0.AVALIBLE)
	arg0_45:onUIAnimEnd(function()
		pg.SeriesGuideMgr.GetInstance():start({
			view = arg0_45.__cname,
			code = {
				pg.SeriesGuideMgr.CODES.MAINUI
			}
		})
		pg.NewGuideMgr.GetInstance():OnSceneEnter({
			view = arg0_45.__cname
		})
	end)
end

function var0_0.closeView(arg0_47)
	if arg0_47.contextData.isLayer then
		arg0_47:emit(var0_0.ON_CLOSE)
	else
		arg0_47:emit(var0_0.ON_BACK)
	end
end

function var0_0.didEnter(arg0_48)
	return
end

function var0_0.willExit(arg0_49)
	return
end

function var0_0.exit(arg0_50)
	arg0_50.exited = true

	arg0_50:StopBgm()
	pg.DelegateInfo.Dispose(arg0_50)
	arg0_50:willExit()
	bindComponent(arg0_50, arg0_50._go, true)
	arg0_50:ShowOrHideResUI(false)
	arg0_50:DelFromOverlay(arg0_50:getDefaultUI())
	arg0_50:setLayerMgrRegister(false)
	arg0_50:detach()

	if arg0_50:forceRatio() then
		pg.CameraFixMgr.GetInstance():SetForceRatio(nil)
	end

	pg.NewGuideMgr.GetInstance():OnSceneExit({
		view = arg0_50.__cname
	})
	pg.NewStoryMgr.GetInstance():OnSceneExit({
		view = arg0_50.__cname
	})
	arg0_50:emit(var0_0.DID_EXIT)
end

function var0_0.PlayUIAnimation(arg0_51, arg1_51, arg2_51, arg3_51)
	local var0_51 = arg1_51:GetComponent(typeof(Animation))
	local var1_51 = arg1_51:GetComponent(typeof(UIEventTrigger))

	var1_51.didExit:RemoveAllListeners()
	var1_51.didExit:AddListener(function()
		var1_51.didExit:RemoveAllListeners()
		arg3_51()
	end)
	var0_51:Play(arg2_51)
end

function var0_0.attach(arg0_53, arg1_53)
	return
end

function var0_0.ClearTweens(arg0_54, arg1_54)
	arg0_54:cleanManagedTween(arg1_54)
end

function var0_0.detach(arg0_55, arg1_55)
	arg0_55._isLoaded = false

	pg.DynamicBgMgr.GetInstance():ClearBg(arg0_55:getUIName())
	arg0_55:disposeEvent()
	arg0_55:ClearTweens(false)

	arg0_55._tf = nil

	local var0_55 = PoolMgr.GetInstance()
	local var1_55 = arg0_55:getUIName()

	if arg0_55._go ~= nil and var1_55 then
		var0_55:ReturnUI(var1_55, arg0_55._go)

		arg0_55._go = nil
	end
end

function var0_0.getTpl(arg0_56, arg1_56, arg2_56)
	local var0_56 = (arg2_56 or arg0_56._tf):Find(arg1_56)

	var0_56:SetParent(arg0_56._tf, false)
	SetActive(var0_56, false)

	return var0_56
end

function var0_0.setSpriteTo(arg0_57, arg1_57, arg2_57, arg3_57)
	local var0_57 = arg2_57:GetComponent(typeof(Image))

	var0_57.sprite = arg0_57._tf:Find(arg1_57):GetComponent(typeof(Image)).sprite

	if arg3_57 then
		var0_57:SetNativeSize()
	end
end

function var0_0.setImageAmount(arg0_58, arg1_58, arg2_58)
	arg1_58:GetComponent(typeof(Image)).fillAmount = arg2_58
end

function var0_0.setVisible(arg0_59, arg1_59)
	arg0_59:ShowOrHideResUI(arg1_59)

	if arg1_59 then
		arg0_59:OnVisible()
	else
		arg0_59:OnDisVisible()
	end

	setActiveViaLayer(arg0_59._tf, arg1_59)
end

function var0_0.OnVisible(arg0_60)
	return
end

function var0_0.OnDisVisible(arg0_61)
	return
end

function var0_0.onBackPressed(arg0_62)
	arg0_62:emit(var0_0.ON_BACK_PRESSED)
end

return var0_0
