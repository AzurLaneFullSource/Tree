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

function var0_0.preloadUIList(arg0_4)
	return {
		arg0_4:getUIName()
	}
end

function var0_0.needCache(arg0_5)
	return false
end

function var0_0.forceGC(arg0_6)
	return false
end

function var0_0.loadingQueue(arg0_7)
	return false
end

function var0_0.lowerAdpter(arg0_8)
	return false
end

function var0_0.tempCache(arg0_9)
	return false
end

function var0_0.getGroupName(arg0_10)
	return nil
end

function var0_0.getLayerWeight(arg0_11)
	return LayerWeightConst.BASE_LAYER
end

function var0_0.preload(arg0_12, arg1_12)
	arg1_12()
end

function var0_0.loadUISync(arg0_13, arg1_13)
	local var0_13 = LoadAndInstantiateSync("UI", arg1_13, true, false)
	local var1_13 = pg.UIMgr.GetInstance().UIMain

	var0_13.transform:SetParent(var1_13.transform, false)

	return var0_13
end

function var0_0.load(arg0_14)
	local var0_14
	local var1_14 = Time.realtimeSinceStartup
	local var2_14 = arg0_14:getUIName()

	seriesAsync({
		function(arg0_15)
			if tobool(arg0_14:loadingQueue()) then
				gcAll(true)
			end

			arg0_14:preload(arg0_15)
		end,
		function(arg0_16)
			arg0_14:LoadUIFromPool(var2_14, function(arg0_17)
				print("Loaded " .. var2_14)

				var0_14 = arg0_17

				arg0_16()
			end)
		end
	}, function()
		originalPrint("load " .. var0_14.name .. " time cost: " .. Time.realtimeSinceStartup - var1_14)

		local var0_18 = pg.UIMgr.GetInstance().UIMain

		var0_14.transform:SetParent(var0_18.transform, false)

		if arg0_14:tempCache() then
			PoolMgr.GetInstance():AddTempCache(var2_14)
		end

		arg0_14:onUILoaded(var0_14)
	end)
end

function var0_0.LoadUIFromPool(arg0_19, arg1_19, arg2_19)
	PoolMgr.GetInstance():GetUI(arg1_19, true, arg2_19)
end

function var0_0.getBGM(arg0_20, arg1_20)
	return getBgm(arg1_20 or arg0_20.__cname)
end

function var0_0.PlayBGM(arg0_21)
	local var0_21 = arg0_21:getBGM()

	if var0_21 then
		pg.BgmMgr.GetInstance():Push(arg0_21.__cname, var0_21)
	end
end

function var0_0.StopBgm(arg0_22)
	if not arg0_22.contextData then
		return
	end

	if arg0_22.contextData.isLayer then
		pg.BgmMgr.GetInstance():Pop(arg0_22.__cname)
	else
		pg.BgmMgr.GetInstance():Clear()
	end
end

function var0_0.isLoaded(arg0_23)
	return arg0_23._isLoaded
end

function var0_0.getGroupNameFromData(arg0_24)
	local var0_24

	if arg0_24.contextData ~= nil and arg0_24.contextData.LayerWeightMgr_groupName then
		var0_24 = arg0_24.contextData.LayerWeightMgr_groupName
	else
		var0_24 = arg0_24:getGroupName()
	end

	return var0_24
end

function var0_0.getWeightFromData(arg0_25)
	local var0_25

	if arg0_25.contextData ~= nil and arg0_25.contextData.LayerWeightMgr_weight then
		var0_25 = arg0_25.contextData.LayerWeightMgr_weight
	else
		var0_25 = arg0_25:getLayerWeight()
	end

	return var0_25
end

function var0_0.isLayer(arg0_26)
	return arg0_26.contextData ~= nil and arg0_26.contextData.isLayer
end

function var0_0.addToLayerMgr(arg0_27)
	local var0_27 = arg0_27:getGroupNameFromData()
	local var1_27 = arg0_27:getWeightFromData()

	pg.LayerWeightMgr.GetInstance():Add2Overlay(LayerWeightConst.UI_TYPE_SYSTEM, arg0_27._tf, {
		globalBlur = false,
		groupName = var0_27,
		weight = var1_27
	})
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
	"Main/blur_panel/adapt/top/option"
}

function var0_0.onUILoaded(arg0_28, arg1_28)
	arg0_28._go = arg1_28
	arg0_28._tf = arg1_28 and arg1_28.transform

	if arg0_28:isLayer() then
		arg0_28:addToLayerMgr()
	end

	pg.SeriesGuideMgr.GetInstance():dispatch({
		view = arg0_28.__cname
	})
	pg.NewStoryMgr.GetInstance():OnSceneEnter({
		view = arg0_28.__cname
	})

	arg0_28._isLoaded = true

	pg.DelegateInfo.New(arg0_28)

	arg0_28.optionBtns = {}

	for iter0_28, iter1_28 in ipairs(arg0_28.optionsPath) do
		table.insert(arg0_28.optionBtns, arg0_28:findTF(iter1_28))
	end

	setActiveViaLayer(arg0_28._tf, true)
	arg0_28:init()
	arg0_28:emit(var0_0.LOADED)
end

function var0_0.ResUISettings(arg0_29)
	return nil
end

function var0_0.ShowOrHideResUI(arg0_30, arg1_30)
	local var0_30 = arg0_30:ResUISettings()

	if not var0_30 then
		return
	end

	if var0_30 == true then
		var0_30 = {
			anim = true,
			showType = PlayerResUI.TYPE_ALL
		}
	end

	pg.playerResUI:SetActive(setmetatable({
		active = arg1_30,
		clear = not arg1_30 and not arg0_30:isLayer(),
		weight = var0_30.weight or arg0_30:getWeightFromData(),
		groupName = var0_30.groupName or arg0_30:getGroupNameFromData(),
		canvasOrder = var0_30.order or false
	}, {
		__index = var0_30
	}))
end

function var0_0.onUIAnimEnd(arg0_31, arg1_31)
	arg1_31()
end

function var0_0.init(arg0_32)
	return
end

function var0_0.quickExitFunc(arg0_33)
	arg0_33:emit(var0_0.ON_HOME)
end

function var0_0.quickExit(arg0_34)
	for iter0_34, iter1_34 in ipairs(arg0_34.optionBtns) do
		onButton(arg0_34, iter1_34, function()
			arg0_34:quickExitFunc()
		end, SFX_PANEL)
	end
end

function var0_0.enter(arg0_36)
	arg0_36:quickExit()
	arg0_36:PlayBGM()
	arg0_36:emit(var0_0.DID_ENTER)

	if arg0_36:lowerAdpter() then
		setActive(pg.CameraFixMgr.GetInstance().adpterTr, false)
	end

	if not arg0_36._isCachedView then
		arg0_36:didEnter()
		arg0_36:ShowOrHideResUI(true)
	end

	if tobool(arg0_36:loadingQueue()) and arg0_36.contextData.resumeCallback then
		local var0_36 = arg0_36.contextData.resumeCallback

		arg0_36.contextData.resumeCallback = nil

		var0_36()
	end

	arg0_36:emit(var0_0.AVALIBLE)
	arg0_36:onUIAnimEnd(function()
		pg.SeriesGuideMgr.GetInstance():start({
			view = arg0_36.__cname,
			code = {
				pg.SeriesGuideMgr.CODES.MAINUI
			}
		})
		pg.NewGuideMgr.GetInstance():OnSceneEnter({
			view = arg0_36.__cname
		})
	end)
end

function var0_0.closeView(arg0_38)
	if arg0_38.contextData.isLayer then
		arg0_38:emit(var0_0.ON_CLOSE)
	else
		arg0_38:emit(var0_0.ON_BACK)
	end
end

function var0_0.didEnter(arg0_39)
	return
end

function var0_0.willExit(arg0_40)
	return
end

function var0_0.exit(arg0_41)
	arg0_41.exited = true

	arg0_41:StopBgm()
	pg.DelegateInfo.Dispose(arg0_41)
	arg0_41:willExit()
	arg0_41:ShowOrHideResUI(false)
	arg0_41:detach()

	if arg0_41:lowerAdpter() then
		setActive(pg.CameraFixMgr.GetInstance().adpterTr, true)
	end

	pg.NewGuideMgr.GetInstance():OnSceneExit({
		view = arg0_41.__cname
	})
	pg.NewStoryMgr.GetInstance():OnSceneExit({
		view = arg0_41.__cname
	})
	arg0_41:emit(var0_0.DID_EXIT)
end

function var0_0.PlayUIAnimation(arg0_42, arg1_42, arg2_42, arg3_42)
	local var0_42 = arg1_42:GetComponent(typeof(Animation))
	local var1_42 = arg1_42:GetComponent(typeof(UIEventTrigger))

	var1_42.didExit:RemoveAllListeners()
	var1_42.didExit:AddListener(function()
		var1_42.didExit:RemoveAllListeners()
		arg3_42()
	end)
	var0_42:Play(arg2_42)
end

function var0_0.attach(arg0_44, arg1_44)
	return
end

function var0_0.ClearTweens(arg0_45, arg1_45)
	arg0_45:cleanManagedTween(arg1_45)
end

function var0_0.RemoveTempCache(arg0_46)
	local var0_46 = arg0_46:getUIName()

	PoolMgr.GetInstance():DelTempCache(var0_46)
end

function var0_0.detach(arg0_47, arg1_47)
	arg0_47._isLoaded = false

	pg.LayerWeightMgr.GetInstance():DelFromOverlay(arg0_47._tf)
	pg.DynamicBgMgr.GetInstance():ClearBg(arg0_47:getUIName())
	arg0_47:disposeEvent()
	arg0_47:ClearTweens(false)

	arg0_47._tf = nil

	local var0_47 = PoolMgr.GetInstance()
	local var1_47 = arg0_47:getUIName()

	if arg0_47._go ~= nil and var1_47 then
		var0_47:ReturnUI(var1_47, arg0_47._go)

		arg0_47._go = nil
	end
end

function var0_0.findGO(arg0_48, arg1_48, arg2_48)
	assert(arg0_48._go, "game object should exist")

	return findGO(arg2_48 or arg0_48._go, arg1_48)
end

function var0_0.findTF(arg0_49, arg1_49, arg2_49)
	assert(arg0_49._tf, "transform should exist")

	return findTF(arg2_49 or arg0_49._tf, arg1_49)
end

function var0_0.getTpl(arg0_50, arg1_50, arg2_50)
	local var0_50 = arg0_50:findTF(arg1_50, arg2_50)

	var0_50:SetParent(arg0_50._tf, false)
	SetActive(var0_50, false)

	return var0_50
end

function var0_0.setSpriteTo(arg0_51, arg1_51, arg2_51, arg3_51)
	local var0_51 = arg2_51:GetComponent(typeof(Image))

	var0_51.sprite = arg0_51:findTF(arg1_51):GetComponent(typeof(Image)).sprite

	if arg3_51 then
		var0_51:SetNativeSize()
	end
end

function var0_0.setImageAmount(arg0_52, arg1_52, arg2_52)
	arg1_52:GetComponent(typeof(Image)).fillAmount = arg2_52
end

function var0_0.setVisible(arg0_53, arg1_53)
	arg0_53:ShowOrHideResUI(arg1_53)

	if arg1_53 then
		arg0_53:OnVisible()
	else
		arg0_53:OnDisVisible()
	end

	setActiveViaLayer(arg0_53._tf, arg1_53)
end

function var0_0.OnVisible(arg0_54)
	return
end

function var0_0.OnDisVisible(arg0_55)
	return
end

function var0_0.onBackPressed(arg0_56)
	arg0_56:emit(var0_0.ON_BACK_PRESSED)
end

return var0_0
