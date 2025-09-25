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

function var0_0.load(arg0_15)
	arg0_15:setLayerMgrRegister(true)

	local var0_15
	local var1_15 = Time.realtimeSinceStartup
	local var2_15 = arg0_15:getUIName()

	seriesAsync({
		function(arg0_16)
			if tobool(arg0_15:loadingQueue()) then
				gcAll(true)
			end

			arg0_15:preload(arg0_16)
		end,
		function(arg0_17)
			arg0_15:LoadUIFromPool(var2_15, function(arg0_18)
				print("Loaded " .. var2_15)

				var0_15 = arg0_18

				arg0_17()
			end)
		end
	}, function()
		originalPrint("load " .. var0_15.name .. " time cost: " .. Time.realtimeSinceStartup - var1_15)
		arg0_15:SetUIParent(var0_15)

		if arg0_15:CheckTempCache() then
			PoolMgr.GetInstance():KeepUICache(var2_15, true)
		end

		arg0_15:onUILoaded(var0_15)
	end)
end

function var0_0.SetUIParent(arg0_20, arg1_20)
	local var0_20 = pg.UIMgr.GetInstance().UIMain

	arg1_20.transform:SetParent(var0_20.transform, false)
end

function var0_0.LoadUIFromPool(arg0_21, arg1_21, arg2_21)
	PoolMgr.GetInstance():GetUI(arg1_21, true, arg2_21)
end

function var0_0.getBGM(arg0_22, arg1_22)
	return getBgm(arg1_22 or arg0_22.__cname)
end

function var0_0.PlayBGM(arg0_23)
	local var0_23 = arg0_23:getBGM()

	if var0_23 then
		pg.BgmMgr.GetInstance():Push(arg0_23.__cname, var0_23)
	end
end

function var0_0.StopBgm(arg0_24)
	if not arg0_24.contextData then
		return
	end

	if arg0_24.contextData.isLayer then
		pg.BgmMgr.GetInstance():Pop(arg0_24.__cname)
	else
		pg.BgmMgr.GetInstance():Clear()
	end
end

function var0_0.isLoaded(arg0_25)
	return arg0_25._isLoaded
end

function var0_0.CheckTempCache(arg0_26)
	return arg0_26:tempCache() and arg0_26:isLayer()
end

function var0_0.isLayer(arg0_27)
	return arg0_27.contextData ~= nil and arg0_27.contextData.isLayer
end

function var0_0.Add2Overlay(arg0_28, arg1_28, arg2_28)
	if not arg0_28.contextData then
		return
	end

	arg2_28 = arg2_28 or {}
	arg2_28.groupName = arg0_28:getGroupName()

	pg.LayerWeightMgr.GetInstance():Add2Overlay(arg1_28, arg2_28)
end

function var0_0.DelFromOverlay(arg0_29, arg1_29, ...)
	if not arg0_29.contextData then
		return
	end

	pg.LayerWeightMgr.GetInstance():DelFromOverlay(arg1_29, ...)
end

function var0_0.OverlayPanel(arg0_30, arg1_30, arg2_30)
	arg2_30 = arg2_30 or {}
	arg2_30.type = LayerWeightConst.UI_TYPE_SUB

	arg0_30:Add2Overlay(arg1_30, arg2_30)
end

function var0_0.BlurPanel(arg0_31, arg1_31, arg2_31)
	arg2_31 = arg2_31 or {}
	arg2_31.type = LayerWeightConst.UI_TYPE_SUB
	arg2_31.globalBlur = true

	arg0_31:Add2Overlay(arg1_31, arg2_31)
end

function var0_0.UnOverlayPanel(arg0_32, arg1_32, arg2_32)
	arg0_32:DelFromOverlay(arg1_32, arg2_32 or arg0_32.UIMain)
end

function var0_0.TempOverlayPanelPB(arg0_33, arg1_33, arg2_33)
	if not arg0_33.contextData then
		return
	end

	arg2_33 = arg2_33 or {}
	arg2_33.groupName = arg0_33:getGroupName()

	pg.UIMgr.GetInstance():TempOverlayPanelPB(arg1_33, arg2_33)
end

function var0_0.TempUnOverlayPanelPB(arg0_34, arg1_34, arg2_34)
	if not arg0_34.contextData then
		return
	end

	pg.UIMgr.GetInstance():TempUnOverlayPanelPB(arg1_34, arg2_34)
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

function var0_0.onUILoaded(arg0_35, arg1_35)
	arg0_35._go = arg1_35
	arg0_35._tf = arg1_35 and arg1_35.transform

	arg0_35:Add2Overlay(arg0_35:getDefaultUI(), {
		type = LayerWeightConst.UI_TYPE_SYSTEM
	})
	pg.SeriesGuideMgr.GetInstance():dispatch({
		view = arg0_35.__cname
	})
	pg.NewStoryMgr.GetInstance():OnSceneEnter({
		view = arg0_35.__cname
	})

	arg0_35._isLoaded = true

	pg.DelegateInfo.New(arg0_35)

	arg0_35.optionBtns = {}

	for iter0_35, iter1_35 in ipairs(arg0_35.optionsPath) do
		table.insert(arg0_35.optionBtns, arg0_35:findTF(iter1_35))
	end

	setActiveViaLayer(arg0_35._tf, true)
	bindComponent(arg0_35, arg0_35._go)
	arg0_35:init()
	arg0_35:emit(var0_0.LOADED)
end

function var0_0.ResUISettings(arg0_36)
	return nil
end

function var0_0.ShowOrHideResUI(arg0_37, arg1_37)
	local var0_37 = arg0_37:ResUISettings()

	if not var0_37 then
		return
	end

	if var0_37 == true then
		var0_37 = {
			anim = true,
			showType = PlayerResUI.TYPE_ALL
		}
	end

	local var1_37 = arg0_37:getGroupName()

	if arg1_37 then
		pg.playerResUI:SetSettings(var1_37, setmetatable({
			groupName = var1_37
		}, {
			__index = var0_37
		}))
	else
		pg.playerResUI:RemoveSettings(var1_37)
	end
end

function var0_0.onUIAnimEnd(arg0_38, arg1_38)
	arg1_38()
end

function var0_0.init(arg0_39)
	return
end

function var0_0.quickExitFunc(arg0_40)
	arg0_40:emit(var0_0.ON_HOME)
end

function var0_0.quickExit(arg0_41)
	for iter0_41, iter1_41 in ipairs(arg0_41.optionBtns) do
		onButton(arg0_41, iter1_41, function()
			arg0_41:quickExitFunc()
		end, SFX_PANEL)
	end
end

function var0_0.enter(arg0_43)
	arg0_43:quickExit()
	arg0_43:PlayBGM()
	arg0_43:emit(var0_0.DID_ENTER)

	if arg0_43:forceRatio() then
		pg.CameraFixMgr.GetInstance():SetForceRatio(arg0_43:forceRatio())
	end

	if not arg0_43._isCachedView then
		arg0_43:didEnter()
		arg0_43:ShowOrHideResUI(true)
	end

	if tobool(arg0_43:loadingQueue()) and arg0_43.contextData.resumeCallback then
		local var0_43 = arg0_43.contextData.resumeCallback

		arg0_43.contextData.resumeCallback = nil

		var0_43()
	end

	arg0_43:emit(var0_0.AVALIBLE)
	arg0_43:onUIAnimEnd(function()
		pg.SeriesGuideMgr.GetInstance():start({
			view = arg0_43.__cname,
			code = {
				pg.SeriesGuideMgr.CODES.MAINUI
			}
		})
		pg.NewGuideMgr.GetInstance():OnSceneEnter({
			view = arg0_43.__cname
		})
	end)
end

function var0_0.closeView(arg0_45)
	if arg0_45.contextData.isLayer then
		arg0_45:emit(var0_0.ON_CLOSE)
	else
		arg0_45:emit(var0_0.ON_BACK)
	end
end

function var0_0.didEnter(arg0_46)
	return
end

function var0_0.willExit(arg0_47)
	return
end

function var0_0.exit(arg0_48)
	arg0_48.exited = true

	arg0_48:StopBgm()
	pg.DelegateInfo.Dispose(arg0_48)
	arg0_48:willExit()
	arg0_48:ShowOrHideResUI(false)
	arg0_48:DelFromOverlay(arg0_48:getDefaultUI())
	arg0_48:setLayerMgrRegister(false)
	arg0_48:detach()

	if arg0_48:forceRatio() then
		pg.CameraFixMgr.GetInstance():SetForceRatio(nil)
	end

	pg.NewGuideMgr.GetInstance():OnSceneExit({
		view = arg0_48.__cname
	})
	pg.NewStoryMgr.GetInstance():OnSceneExit({
		view = arg0_48.__cname
	})
	arg0_48:emit(var0_0.DID_EXIT)
end

function var0_0.PlayUIAnimation(arg0_49, arg1_49, arg2_49, arg3_49)
	local var0_49 = arg1_49:GetComponent(typeof(Animation))
	local var1_49 = arg1_49:GetComponent(typeof(UIEventTrigger))

	var1_49.didExit:RemoveAllListeners()
	var1_49.didExit:AddListener(function()
		var1_49.didExit:RemoveAllListeners()
		arg3_49()
	end)
	var0_49:Play(arg2_49)
end

function var0_0.attach(arg0_51, arg1_51)
	return
end

function var0_0.ClearTweens(arg0_52, arg1_52)
	arg0_52:cleanManagedTween(arg1_52)
end

function var0_0.detach(arg0_53, arg1_53)
	arg0_53._isLoaded = false

	pg.DynamicBgMgr.GetInstance():ClearBg(arg0_53:getUIName())
	arg0_53:disposeEvent()
	arg0_53:ClearTweens(false)

	arg0_53._tf = nil

	local var0_53 = PoolMgr.GetInstance()
	local var1_53 = arg0_53:getUIName()

	if arg0_53._go ~= nil and var1_53 then
		var0_53:ReturnUI(var1_53, arg0_53._go)

		arg0_53._go = nil
	end
end

function var0_0.findGO(arg0_54, arg1_54, arg2_54)
	assert(arg0_54._go, "game object should exist")

	return findGO(arg2_54 or arg0_54._go, arg1_54)
end

function var0_0.findTF(arg0_55, arg1_55, arg2_55)
	assert(arg0_55._tf, "transform should exist")

	return findTF(arg2_55 or arg0_55._tf, arg1_55)
end

function var0_0.getTpl(arg0_56, arg1_56, arg2_56)
	local var0_56 = arg0_56:findTF(arg1_56, arg2_56)

	var0_56:SetParent(arg0_56._tf, false)
	SetActive(var0_56, false)

	return var0_56
end

function var0_0.setSpriteTo(arg0_57, arg1_57, arg2_57, arg3_57)
	local var0_57 = arg2_57:GetComponent(typeof(Image))

	var0_57.sprite = arg0_57:findTF(arg1_57):GetComponent(typeof(Image)).sprite

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
