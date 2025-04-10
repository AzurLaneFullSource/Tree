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

function var0_0.SwitchToDefaultBGM(arg0_23)
	local var0_23 = arg0_23:getBGM()

	if not var0_23 then
		if pg.CriMgr.GetInstance():IsDefaultBGM() then
			var0_23 = pg.voice_bgm.NewMainScene.default_bgm
		else
			var0_23 = pg.voice_bgm.NewMainScene.bgm
		end
	end

	pg.BgmMgr.GetInstance():Push(arg0_23.__cname, var0_23)
end

function var0_0.isLoaded(arg0_24)
	return arg0_24._isLoaded
end

function var0_0.getGroupNameFromData(arg0_25)
	local var0_25

	if arg0_25.contextData ~= nil and arg0_25.contextData.LayerWeightMgr_groupName then
		var0_25 = arg0_25.contextData.LayerWeightMgr_groupName
	else
		var0_25 = arg0_25:getGroupName()
	end

	return var0_25
end

function var0_0.getWeightFromData(arg0_26)
	local var0_26

	if arg0_26.contextData ~= nil and arg0_26.contextData.LayerWeightMgr_weight then
		var0_26 = arg0_26.contextData.LayerWeightMgr_weight
	else
		var0_26 = arg0_26:getLayerWeight()
	end

	return var0_26
end

function var0_0.isLayer(arg0_27)
	return arg0_27.contextData ~= nil and arg0_27.contextData.isLayer
end

function var0_0.addToLayerMgr(arg0_28)
	local var0_28 = arg0_28:getGroupNameFromData()
	local var1_28 = arg0_28:getWeightFromData()

	pg.LayerWeightMgr.GetInstance():Add2Overlay(LayerWeightConst.UI_TYPE_SYSTEM, arg0_28._tf, {
		globalBlur = false,
		groupName = var0_28,
		weight = var1_28
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

function var0_0.onUILoaded(arg0_29, arg1_29)
	arg0_29._go = arg1_29
	arg0_29._tf = arg1_29 and arg1_29.transform

	if arg0_29:isLayer() then
		arg0_29:addToLayerMgr()
	end

	pg.SeriesGuideMgr.GetInstance():dispatch({
		view = arg0_29.__cname
	})
	pg.NewStoryMgr.GetInstance():OnSceneEnter({
		view = arg0_29.__cname
	})

	arg0_29._isLoaded = true

	pg.DelegateInfo.New(arg0_29)

	arg0_29.optionBtns = {}

	for iter0_29, iter1_29 in ipairs(arg0_29.optionsPath) do
		table.insert(arg0_29.optionBtns, arg0_29:findTF(iter1_29))
	end

	setActiveViaLayer(arg0_29._tf, true)
	arg0_29:init()
	arg0_29:emit(var0_0.LOADED)
end

function var0_0.ResUISettings(arg0_30)
	return nil
end

function var0_0.ShowOrHideResUI(arg0_31, arg1_31)
	local var0_31 = arg0_31:ResUISettings()

	if not var0_31 then
		return
	end

	if var0_31 == true then
		var0_31 = {
			anim = true,
			showType = PlayerResUI.TYPE_ALL
		}
	end

	pg.playerResUI:SetActive(setmetatable({
		active = arg1_31,
		clear = not arg1_31 and not arg0_31:isLayer(),
		weight = var0_31.weight or arg0_31:getWeightFromData(),
		groupName = var0_31.groupName or arg0_31:getGroupNameFromData(),
		canvasOrder = var0_31.order or false
	}, {
		__index = var0_31
	}))
end

function var0_0.onUIAnimEnd(arg0_32, arg1_32)
	arg1_32()
end

function var0_0.init(arg0_33)
	return
end

function var0_0.quickExitFunc(arg0_34)
	arg0_34:emit(var0_0.ON_HOME)
end

function var0_0.quickExit(arg0_35)
	for iter0_35, iter1_35 in ipairs(arg0_35.optionBtns) do
		onButton(arg0_35, iter1_35, function()
			arg0_35:quickExitFunc()
		end, SFX_PANEL)
	end
end

function var0_0.enter(arg0_37)
	arg0_37:quickExit()
	arg0_37:PlayBGM()

	local function var0_37()
		arg0_37:emit(var0_0.DID_ENTER)

		if arg0_37:lowerAdpter() then
			setActive(pg.CameraFixMgr.GetInstance().adpterTr, false)
		end

		if not arg0_37._isCachedView then
			arg0_37:didEnter()
			arg0_37:ShowOrHideResUI(true)
		end

		if tobool(arg0_37:loadingQueue()) and arg0_37.contextData.resumeCallback then
			local var0_38 = arg0_37.contextData.resumeCallback

			arg0_37.contextData.resumeCallback = nil

			var0_38()
		end

		arg0_37:emit(var0_0.AVALIBLE)
		arg0_37:onUIAnimEnd(function()
			pg.SeriesGuideMgr.GetInstance():start({
				view = arg0_37.__cname,
				code = {
					pg.SeriesGuideMgr.CODES.MAINUI
				}
			})
			pg.NewGuideMgr.GetInstance():OnSceneEnter({
				view = arg0_37.__cname
			})
		end)
	end

	arg0_37:inOutAnim(true, var0_37)
end

function var0_0.closeView(arg0_40)
	if arg0_40.contextData.isLayer then
		arg0_40:emit(var0_0.ON_CLOSE)
	else
		arg0_40:emit(var0_0.ON_BACK)
	end
end

function var0_0.didEnter(arg0_41)
	return
end

function var0_0.willExit(arg0_42)
	return
end

function var0_0.exit(arg0_43)
	arg0_43.exited = true

	arg0_43:StopBgm()
	pg.DelegateInfo.Dispose(arg0_43)

	local function var0_43()
		arg0_43:willExit()
		arg0_43:ShowOrHideResUI(false)
		arg0_43:detach()

		if arg0_43:lowerAdpter() then
			setActive(pg.CameraFixMgr.GetInstance().adpterTr, true)
		end

		pg.NewGuideMgr.GetInstance():OnSceneExit({
			view = arg0_43.__cname
		})
		pg.NewStoryMgr.GetInstance():OnSceneExit({
			view = arg0_43.__cname
		})
		arg0_43:emit(var0_0.DID_EXIT)
	end

	arg0_43:inOutAnim(false, var0_43)
end

function var0_0.inOutAnim(arg0_45, arg1_45, arg2_45)
	local var0_45 = false

	if arg1_45 then
		if not IsNil(arg0_45._tf:GetComponent(typeof(Animation))) then
			arg0_45.animTF = arg0_45._tf
		else
			arg0_45.animTF = arg0_45:findTF("blur_panel")
		end

		if arg0_45.animTF ~= nil then
			local var1_45 = arg0_45.animTF:GetComponent(typeof(Animation))
			local var2_45 = arg0_45.animTF:GetComponent(typeof(UIEventTrigger))

			if var1_45 ~= nil and var2_45 ~= nil then
				if var1_45:get_Item("enter") == nil then
					originalPrint("cound not found enter animation")
				else
					var1_45:Play("enter")
				end
			elseif var1_45 ~= nil then
				originalPrint("cound not found [UIEventTrigger] component")
			elseif var2_45 ~= nil then
				originalPrint("cound not found [Animation] component")
			end
		end
	end

	if not var0_45 then
		arg2_45()
	end
end

function var0_0.PlayExitAnimation(arg0_46, arg1_46)
	local var0_46 = arg0_46._tf:GetComponent(typeof(Animation))
	local var1_46 = arg0_46._tf:GetComponent(typeof(UIEventTrigger))

	var1_46.didExit:RemoveAllListeners()
	var1_46.didExit:AddListener(function()
		var1_46.didExit:RemoveAllListeners()
		arg1_46()
	end)
	var0_46:Play("exit")
end

function var0_0.attach(arg0_48, arg1_48)
	return
end

function var0_0.ClearTweens(arg0_49, arg1_49)
	arg0_49:cleanManagedTween(arg1_49)
end

function var0_0.RemoveTempCache(arg0_50)
	local var0_50 = arg0_50:getUIName()

	PoolMgr.GetInstance():DelTempCache(var0_50)
end

function var0_0.detach(arg0_51, arg1_51)
	arg0_51._isLoaded = false

	pg.LayerWeightMgr.GetInstance():DelFromOverlay(arg0_51._tf)
	pg.DynamicBgMgr.GetInstance():ClearBg(arg0_51:getUIName())
	arg0_51:disposeEvent()
	arg0_51:ClearTweens(false)

	arg0_51._tf = nil

	local var0_51 = PoolMgr.GetInstance()
	local var1_51 = arg0_51:getUIName()

	if arg0_51._go ~= nil and var1_51 then
		var0_51:ReturnUI(var1_51, arg0_51._go)

		arg0_51._go = nil
	end
end

function var0_0.findGO(arg0_52, arg1_52, arg2_52)
	assert(arg0_52._go, "game object should exist")

	return findGO(arg2_52 or arg0_52._go, arg1_52)
end

function var0_0.findTF(arg0_53, arg1_53, arg2_53)
	assert(arg0_53._tf, "transform should exist")

	return findTF(arg2_53 or arg0_53._tf, arg1_53)
end

function var0_0.getTpl(arg0_54, arg1_54, arg2_54)
	local var0_54 = arg0_54:findTF(arg1_54, arg2_54)

	var0_54:SetParent(arg0_54._tf, false)
	SetActive(var0_54, false)

	return var0_54
end

function var0_0.setSpriteTo(arg0_55, arg1_55, arg2_55, arg3_55)
	local var0_55 = arg2_55:GetComponent(typeof(Image))

	var0_55.sprite = arg0_55:findTF(arg1_55):GetComponent(typeof(Image)).sprite

	if arg3_55 then
		var0_55:SetNativeSize()
	end
end

function var0_0.setImageAmount(arg0_56, arg1_56, arg2_56)
	arg1_56:GetComponent(typeof(Image)).fillAmount = arg2_56
end

function var0_0.setVisible(arg0_57, arg1_57)
	arg0_57:ShowOrHideResUI(arg1_57)

	if arg1_57 then
		arg0_57:OnVisible()
	else
		arg0_57:OnDisVisible()
	end

	setActiveViaLayer(arg0_57._tf, arg1_57)
end

function var0_0.OnVisible(arg0_58)
	return
end

function var0_0.OnDisVisible(arg0_59)
	return
end

function var0_0.onBackPressed(arg0_60)
	arg0_60:emit(var0_0.ON_BACK_PRESSED)
end

return var0_0
