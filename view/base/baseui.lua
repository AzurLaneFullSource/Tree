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

function var0_0.needCache(arg0_4)
	return false
end

function var0_0.forceGC(arg0_5)
	return false
end

function var0_0.loadingQueue(arg0_6)
	return false
end

function var0_0.lowerAdpter(arg0_7)
	return false
end

function var0_0.tempCache(arg0_8)
	return false
end

function var0_0.getGroupName(arg0_9)
	return nil
end

function var0_0.getLayerWeight(arg0_10)
	return LayerWeightConst.BASE_LAYER
end

function var0_0.preload(arg0_11, arg1_11)
	arg1_11()
end

function var0_0.loadUISync(arg0_12, arg1_12)
	local var0_12 = LoadAndInstantiateSync("UI", arg1_12, true, false)
	local var1_12 = pg.UIMgr.GetInstance().UIMain

	var0_12.transform:SetParent(var1_12.transform, false)

	return var0_12
end

function var0_0.load(arg0_13)
	local var0_13
	local var1_13 = Time.realtimeSinceStartup
	local var2_13 = arg0_13:getUIName()

	seriesAsync({
		function(arg0_14)
			arg0_13:preload(arg0_14)
		end,
		function(arg0_15)
			arg0_13:LoadUIFromPool(var2_13, function(arg0_16)
				print("Loaded " .. var2_13)

				var0_13 = arg0_16

				arg0_15()
			end)
		end
	}, function()
		originalPrint("load " .. var0_13.name .. " time cost: " .. Time.realtimeSinceStartup - var1_13)

		local var0_17 = pg.UIMgr.GetInstance().UIMain

		var0_13.transform:SetParent(var0_17.transform, false)

		if arg0_13:tempCache() then
			PoolMgr.GetInstance():AddTempCache(var2_13)
		end

		arg0_13:onUILoaded(var0_13)
	end)
end

function var0_0.LoadUIFromPool(arg0_18, arg1_18, arg2_18)
	PoolMgr.GetInstance():GetUI(arg1_18, true, arg2_18)
end

function var0_0.getBGM(arg0_19, arg1_19)
	return getBgm(arg1_19 or arg0_19.__cname)
end

function var0_0.PlayBGM(arg0_20)
	local var0_20 = arg0_20:getBGM()

	if var0_20 then
		pg.BgmMgr.GetInstance():Push(arg0_20.__cname, var0_20)
	end
end

function var0_0.StopBgm(arg0_21)
	if not arg0_21.contextData then
		return
	end

	if arg0_21.contextData.isLayer then
		pg.BgmMgr.GetInstance():Pop(arg0_21.__cname)
	else
		pg.BgmMgr.GetInstance():Clear()
	end
end

function var0_0.SwitchToDefaultBGM(arg0_22)
	local var0_22 = arg0_22:getBGM()

	if not var0_22 then
		if pg.CriMgr.GetInstance():IsDefaultBGM() then
			var0_22 = pg.voice_bgm.NewMainScene.default_bgm
		else
			var0_22 = pg.voice_bgm.NewMainScene.bgm
		end
	end

	pg.BgmMgr.GetInstance():Push(arg0_22.__cname, var0_22)
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

	local function var0_36()
		arg0_36:emit(var0_0.DID_ENTER)

		if arg0_36:lowerAdpter() then
			setActive(pg.CameraFixMgr.GetInstance().adpterTr, false)
		end

		if not arg0_36._isCachedView then
			arg0_36:didEnter()
			arg0_36:ShowOrHideResUI(true)
		end

		if tobool(arg0_36:loadingQueue()) and arg0_36.contextData.resumeCallback then
			local var0_37 = arg0_36.contextData.resumeCallback

			arg0_36.contextData.resumeCallback = nil

			var0_37()
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

	arg0_36:inOutAnim(true, var0_36)
end

function var0_0.closeView(arg0_39)
	if arg0_39.contextData.isLayer then
		arg0_39:emit(var0_0.ON_CLOSE)
	else
		arg0_39:emit(var0_0.ON_BACK)
	end
end

function var0_0.didEnter(arg0_40)
	return
end

function var0_0.willExit(arg0_41)
	return
end

function var0_0.exit(arg0_42)
	arg0_42.exited = true

	arg0_42:StopBgm()
	pg.DelegateInfo.Dispose(arg0_42)

	local function var0_42()
		arg0_42:willExit()
		arg0_42:ShowOrHideResUI(false)
		arg0_42:detach()

		if arg0_42:lowerAdpter() then
			setActive(pg.CameraFixMgr.GetInstance().adpterTr, true)
		end

		pg.NewGuideMgr.GetInstance():OnSceneExit({
			view = arg0_42.__cname
		})
		pg.NewStoryMgr.GetInstance():OnSceneExit({
			view = arg0_42.__cname
		})
		arg0_42:emit(var0_0.DID_EXIT)
	end

	arg0_42:inOutAnim(false, var0_42)
end

function var0_0.inOutAnim(arg0_44, arg1_44, arg2_44)
	local var0_44 = false

	if arg1_44 then
		if not IsNil(arg0_44._tf:GetComponent(typeof(Animation))) then
			arg0_44.animTF = arg0_44._tf
		else
			arg0_44.animTF = arg0_44:findTF("blur_panel")
		end

		if arg0_44.animTF ~= nil then
			local var1_44 = arg0_44.animTF:GetComponent(typeof(Animation))
			local var2_44 = arg0_44.animTF:GetComponent(typeof(UIEventTrigger))

			if var1_44 ~= nil and var2_44 ~= nil then
				if var1_44:get_Item("enter") == nil then
					originalPrint("cound not found enter animation")
				else
					var1_44:Play("enter")
				end
			elseif var1_44 ~= nil then
				originalPrint("cound not found [UIEventTrigger] component")
			elseif var2_44 ~= nil then
				originalPrint("cound not found [Animation] component")
			end
		end
	end

	if not var0_44 then
		arg2_44()
	end
end

function var0_0.PlayExitAnimation(arg0_45, arg1_45)
	local var0_45 = arg0_45._tf:GetComponent(typeof(Animation))
	local var1_45 = arg0_45._tf:GetComponent(typeof(UIEventTrigger))

	var1_45.didExit:RemoveAllListeners()
	var1_45.didExit:AddListener(function()
		var1_45.didExit:RemoveAllListeners()
		arg1_45()
	end)
	var0_45:Play("exit")
end

function var0_0.attach(arg0_47, arg1_47)
	return
end

function var0_0.ClearTweens(arg0_48, arg1_48)
	arg0_48:cleanManagedTween(arg1_48)
end

function var0_0.RemoveTempCache(arg0_49)
	local var0_49 = arg0_49:getUIName()

	PoolMgr.GetInstance():DelTempCache(var0_49)
end

function var0_0.detach(arg0_50, arg1_50)
	arg0_50._isLoaded = false

	pg.LayerWeightMgr.GetInstance():DelFromOverlay(arg0_50._tf)
	pg.DynamicBgMgr.GetInstance():ClearBg(arg0_50:getUIName())
	arg0_50:disposeEvent()
	arg0_50:ClearTweens(false)

	arg0_50._tf = nil

	local var0_50 = PoolMgr.GetInstance()
	local var1_50 = arg0_50:getUIName()

	if arg0_50._go ~= nil and var1_50 then
		var0_50:ReturnUI(var1_50, arg0_50._go)

		arg0_50._go = nil
	end
end

function var0_0.findGO(arg0_51, arg1_51, arg2_51)
	assert(arg0_51._go, "game object should exist")

	return findGO(arg2_51 or arg0_51._go, arg1_51)
end

function var0_0.findTF(arg0_52, arg1_52, arg2_52)
	assert(arg0_52._tf, "transform should exist")

	return findTF(arg2_52 or arg0_52._tf, arg1_52)
end

function var0_0.getTpl(arg0_53, arg1_53, arg2_53)
	local var0_53 = arg0_53:findTF(arg1_53, arg2_53)

	var0_53:SetParent(arg0_53._tf, false)
	SetActive(var0_53, false)

	return var0_53
end

function var0_0.setSpriteTo(arg0_54, arg1_54, arg2_54, arg3_54)
	local var0_54 = arg2_54:GetComponent(typeof(Image))

	var0_54.sprite = arg0_54:findTF(arg1_54):GetComponent(typeof(Image)).sprite

	if arg3_54 then
		var0_54:SetNativeSize()
	end
end

function var0_0.setImageAmount(arg0_55, arg1_55, arg2_55)
	arg1_55:GetComponent(typeof(Image)).fillAmount = arg2_55
end

function var0_0.setVisible(arg0_56, arg1_56)
	arg0_56:ShowOrHideResUI(arg1_56)

	if arg1_56 then
		arg0_56:OnVisible()
	else
		arg0_56:OnDisVisible()
	end

	setActiveViaLayer(arg0_56._tf, arg1_56)
end

function var0_0.OnVisible(arg0_57)
	return
end

function var0_0.OnDisVisible(arg0_58)
	return
end

function var0_0.onBackPressed(arg0_59)
	arg0_59:emit(var0_0.ON_BACK_PRESSED)
end

return var0_0
