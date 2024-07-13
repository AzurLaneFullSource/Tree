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
var0_0.ON_ITEM = "BaseUI:ON_ITEM"
var0_0.ON_ITEM_EXTRA = "BaseUI.ON_ITEM_EXTRA"
var0_0.ON_SHIP = "BaseUI:ON_SHIP"
var0_0.ON_AWARD = "BaseUI:ON_AWARD"
var0_0.ON_ACHIEVE = "BaseUI:ON_ACHIEVE"
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

function var0_0.tempCache(arg0_6)
	return false
end

function var0_0.getGroupName(arg0_7)
	return nil
end

function var0_0.getLayerWeight(arg0_8)
	return LayerWeightConst.BASE_LAYER
end

function var0_0.preload(arg0_9, arg1_9)
	arg1_9()
end

function var0_0.loadUISync(arg0_10, arg1_10)
	local var0_10 = LoadAndInstantiateSync("UI", arg1_10, true, false)
	local var1_10 = pg.UIMgr.GetInstance().UIMain

	var0_10.transform:SetParent(var1_10.transform, false)

	return var0_10
end

function var0_0.load(arg0_11)
	local var0_11
	local var1_11 = Time.realtimeSinceStartup
	local var2_11 = arg0_11:getUIName()

	seriesAsync({
		function(arg0_12)
			arg0_11:preload(arg0_12)
		end,
		function(arg0_13)
			arg0_11:LoadUIFromPool(var2_11, function(arg0_14)
				print("Loaded " .. var2_11)

				var0_11 = arg0_14

				arg0_13()
			end)
		end
	}, function()
		originalPrint("load " .. var0_11.name .. " time cost: " .. Time.realtimeSinceStartup - var1_11)

		local var0_15 = pg.UIMgr.GetInstance().UIMain

		var0_11.transform:SetParent(var0_15.transform, false)

		if arg0_11:tempCache() then
			PoolMgr.GetInstance():AddTempCache(var2_11)
		end

		arg0_11:onUILoaded(var0_11)
	end)
end

function var0_0.LoadUIFromPool(arg0_16, arg1_16, arg2_16)
	PoolMgr.GetInstance():GetUI(arg1_16, true, arg2_16)
end

function var0_0.getBGM(arg0_17, arg1_17)
	return getBgm(arg1_17 or arg0_17.__cname)
end

function var0_0.PlayBGM(arg0_18)
	local var0_18 = arg0_18:getBGM()

	if var0_18 then
		pg.BgmMgr.GetInstance():Push(arg0_18.__cname, var0_18)
	end
end

function var0_0.StopBgm(arg0_19)
	if not arg0_19.contextData then
		return
	end

	if arg0_19.contextData.isLayer then
		pg.BgmMgr.GetInstance():Pop(arg0_19.__cname)
	else
		pg.BgmMgr.GetInstance():Clear()
	end
end

function var0_0.SwitchToDefaultBGM(arg0_20)
	local var0_20 = arg0_20:getBGM()

	if not var0_20 then
		if pg.CriMgr.GetInstance():IsDefaultBGM() then
			var0_20 = pg.voice_bgm.NewMainScene.default_bgm
		else
			var0_20 = pg.voice_bgm.NewMainScene.bgm
		end
	end

	pg.BgmMgr.GetInstance():Push(arg0_20.__cname, var0_20)
end

function var0_0.isLoaded(arg0_21)
	return arg0_21._isLoaded
end

function var0_0.getGroupNameFromData(arg0_22)
	local var0_22

	if arg0_22.contextData ~= nil and arg0_22.contextData.LayerWeightMgr_groupName then
		var0_22 = arg0_22.contextData.LayerWeightMgr_groupName
	else
		var0_22 = arg0_22:getGroupName()
	end

	return var0_22
end

function var0_0.getWeightFromData(arg0_23)
	local var0_23

	if arg0_23.contextData ~= nil and arg0_23.contextData.LayerWeightMgr_weight then
		var0_23 = arg0_23.contextData.LayerWeightMgr_weight
	else
		var0_23 = arg0_23:getLayerWeight()
	end

	return var0_23
end

function var0_0.isLayer(arg0_24)
	return arg0_24.contextData ~= nil and arg0_24.contextData.isLayer and not arg0_24.contextData.isSubView
end

function var0_0.addToLayerMgr(arg0_25)
	local var0_25 = arg0_25:getGroupNameFromData()
	local var1_25 = arg0_25:getWeightFromData()

	pg.LayerWeightMgr.GetInstance():Add2Overlay(LayerWeightConst.UI_TYPE_SYSTEM, arg0_25._tf, {
		globalBlur = false,
		groupName = var0_25,
		weight = var1_25
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

function var0_0.onUILoaded(arg0_26, arg1_26)
	arg0_26._go = arg1_26
	arg0_26._tf = arg1_26 and arg1_26.transform

	if arg0_26:isLayer() then
		arg0_26:addToLayerMgr()
	end

	pg.SeriesGuideMgr.GetInstance():dispatch({
		view = arg0_26.__cname
	})
	pg.NewStoryMgr.GetInstance():OnSceneEnter({
		view = arg0_26.__cname
	})

	arg0_26._isLoaded = true

	pg.DelegateInfo.New(arg0_26)

	arg0_26.optionBtns = {}

	for iter0_26, iter1_26 in ipairs(arg0_26.optionsPath) do
		table.insert(arg0_26.optionBtns, arg0_26:findTF(iter1_26))
	end

	setActiveViaLayer(arg0_26._tf, true)
	arg0_26:init()
	arg0_26:emit(var0_0.LOADED)
end

function var0_0.ResUISettings(arg0_27)
	return nil
end

function var0_0.ShowOrHideResUI(arg0_28, arg1_28)
	local var0_28 = arg0_28:ResUISettings()

	if not var0_28 then
		return
	end

	if var0_28 == true then
		var0_28 = {
			anim = true,
			showType = PlayerResUI.TYPE_ALL
		}
	end

	pg.playerResUI:SetActive(setmetatable({
		active = arg1_28,
		clear = not arg1_28 and not arg0_28:isLayer(),
		weight = var0_28.weight or arg0_28:getWeightFromData(),
		groupName = var0_28.groupName or arg0_28:getGroupNameFromData(),
		canvasOrder = var0_28.order or false
	}, {
		__index = var0_28
	}))
end

function var0_0.onUIAnimEnd(arg0_29, arg1_29)
	arg1_29()
end

function var0_0.init(arg0_30)
	return
end

function var0_0.quickExitFunc(arg0_31)
	arg0_31:emit(var0_0.ON_HOME)
end

function var0_0.quickExit(arg0_32)
	for iter0_32, iter1_32 in ipairs(arg0_32.optionBtns) do
		onButton(arg0_32, iter1_32, function()
			arg0_32:quickExitFunc()
		end, SFX_PANEL)
	end
end

function var0_0.enter(arg0_34)
	arg0_34:quickExit()
	arg0_34:PlayBGM()

	local function var0_34()
		arg0_34:emit(var0_0.DID_ENTER)

		if not arg0_34._isCachedView then
			arg0_34:didEnter()
			arg0_34:ShowOrHideResUI(true)
		end

		arg0_34:emit(var0_0.AVALIBLE)
		arg0_34:onUIAnimEnd(function()
			pg.SeriesGuideMgr.GetInstance():start({
				view = arg0_34.__cname,
				code = {
					pg.SeriesGuideMgr.CODES.MAINUI
				}
			})
			pg.NewGuideMgr.GetInstance():OnSceneEnter({
				view = arg0_34.__cname
			})
		end)
	end

	local var1_34 = false

	if not IsNil(arg0_34._tf:GetComponent(typeof(Animation))) then
		arg0_34.animTF = arg0_34._tf
	else
		arg0_34.animTF = arg0_34:findTF("blur_panel")
	end

	if arg0_34.animTF ~= nil then
		local var2_34 = arg0_34.animTF:GetComponent(typeof(Animation))
		local var3_34 = arg0_34.animTF:GetComponent(typeof(UIEventTrigger))

		if var2_34 ~= nil and var3_34 ~= nil then
			if var2_34:get_Item("enter") == nil then
				originalPrint("cound not found enter animation")
			else
				var2_34:Play("enter")
			end
		elseif var2_34 ~= nil then
			originalPrint("cound not found [UIEventTrigger] component")
		elseif var3_34 ~= nil then
			originalPrint("cound not found [Animation] component")
		end
	end

	if not var1_34 then
		var0_34()
	end
end

function var0_0.closeView(arg0_37)
	if arg0_37.contextData.isLayer then
		arg0_37:emit(var0_0.ON_CLOSE)
	else
		arg0_37:emit(var0_0.ON_BACK)
	end
end

function var0_0.didEnter(arg0_38)
	return
end

function var0_0.willExit(arg0_39)
	return
end

function var0_0.exit(arg0_40)
	arg0_40.exited = true

	arg0_40:StopBgm()
	pg.DelegateInfo.Dispose(arg0_40)

	local function var0_40()
		arg0_40:willExit()
		arg0_40:ShowOrHideResUI(false)
		arg0_40:detach()
		pg.NewGuideMgr.GetInstance():OnSceneExit({
			view = arg0_40.__cname
		})
		pg.NewStoryMgr.GetInstance():OnSceneExit({
			view = arg0_40.__cname
		})
		arg0_40:emit(var0_0.DID_EXIT)
	end

	local var1_40 = false

	if not var1_40 then
		var0_40()
	end
end

function var0_0.PlayExitAnimation(arg0_42, arg1_42)
	local var0_42 = arg0_42._tf:GetComponent(typeof(Animation))
	local var1_42 = arg0_42._tf:GetComponent(typeof(UIEventTrigger))

	var1_42.didExit:RemoveAllListeners()
	var1_42.didExit:AddListener(function()
		var1_42.didExit:RemoveAllListeners()
		arg1_42()
	end)
	var0_42:Play("exit")
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
