local var0 = class("BaseUI", import("view.base.BaseEventLogic"))

var0.LOADED = "BaseUI:LOADED"
var0.DID_ENTER = "BaseUI:DID_ENTER"
var0.AVALIBLE = "BaseUI:AVALIBLE"
var0.DID_EXIT = "BaseUI:DID_EXIT"
var0.ON_BACK = "BaseUI:ON_BACK"
var0.ON_RETURN = "BaseUI:ON_RETURN"
var0.ON_HOME = "BaseUI:ON_HOME"
var0.ON_CLOSE = "BaseUI:ON_CLOSE"
var0.ON_DROP = "BaseUI.ON_DROP"
var0.ON_DROP_LIST = "BaseUI.ON_DROP_LIST"
var0.ON_DROP_LIST_OWN = "BaseUI.ON_DROP_LIST_OWN"
var0.ON_ITEM = "BaseUI:ON_ITEM"
var0.ON_ITEM_EXTRA = "BaseUI.ON_ITEM_EXTRA"
var0.ON_SHIP = "BaseUI:ON_SHIP"
var0.ON_AWARD = "BaseUI:ON_AWARD"
var0.ON_ACHIEVE = "BaseUI:ON_ACHIEVE"
var0.ON_WORLD_ACHIEVE = "BaseUI:ON_WORLD_ACHIEVE"
var0.ON_EQUIPMENT = "BaseUI:ON_EQUIPMENT"
var0.ON_SPWEAPON = "BaseUI:ON_SPWEAPON"
var0.ON_SHIP_EXP = "BaseUI.ON_SHIP_EXP"
var0.ON_BACK_PRESSED = "BaseUI:ON_BACK_PRESS"

function var0.Ctor(arg0)
	var0.super.Ctor(arg0)

	arg0._isLoaded = false
	arg0._go = nil
	arg0._tf = nil
	arg0._isCachedView = false
end

function var0.setContextData(arg0, arg1)
	arg0.contextData = arg1
end

function var0.getUIName(arg0)
	return nil
end

function var0.needCache(arg0)
	return false
end

function var0.forceGC(arg0)
	return false
end

function var0.tempCache(arg0)
	return false
end

function var0.getGroupName(arg0)
	return nil
end

function var0.getLayerWeight(arg0)
	return LayerWeightConst.BASE_LAYER
end

function var0.preload(arg0, arg1)
	arg1()
end

function var0.loadUISync(arg0, arg1)
	local var0 = LoadAndInstantiateSync("UI", arg1, true, false)
	local var1 = pg.UIMgr.GetInstance().UIMain

	var0.transform:SetParent(var1.transform, false)

	return var0
end

function var0.load(arg0)
	local var0
	local var1 = Time.realtimeSinceStartup
	local var2 = arg0:getUIName()

	seriesAsync({
		function(arg0)
			arg0:preload(arg0)
		end,
		function(arg0)
			arg0:LoadUIFromPool(var2, function(arg0)
				print("Loaded " .. var2)

				var0 = arg0

				arg0()
			end)
		end
	}, function()
		originalPrint("load " .. var0.name .. " time cost: " .. Time.realtimeSinceStartup - var1)

		local var0 = pg.UIMgr.GetInstance().UIMain

		var0.transform:SetParent(var0.transform, false)

		if arg0:tempCache() then
			PoolMgr.GetInstance():AddTempCache(var2)
		end

		arg0:onUILoaded(var0)
	end)
end

function var0.LoadUIFromPool(arg0, arg1, arg2)
	PoolMgr.GetInstance():GetUI(arg1, true, arg2)
end

function var0.getBGM(arg0, arg1)
	return getBgm(arg1 or arg0.__cname)
end

function var0.PlayBGM(arg0)
	local var0 = arg0:getBGM()

	if var0 then
		pg.BgmMgr.GetInstance():Push(arg0.__cname, var0)
	end
end

function var0.StopBgm(arg0)
	if not arg0.contextData then
		return
	end

	if arg0.contextData.isLayer then
		pg.BgmMgr.GetInstance():Pop(arg0.__cname)
	else
		pg.BgmMgr.GetInstance():Clear()
	end
end

function var0.SwitchToDefaultBGM(arg0)
	local var0 = arg0:getBGM()

	if not var0 then
		if pg.CriMgr.GetInstance():IsDefaultBGM() then
			var0 = pg.voice_bgm.NewMainScene.default_bgm
		else
			var0 = pg.voice_bgm.NewMainScene.bgm
		end
	end

	pg.BgmMgr.GetInstance():Push(arg0.__cname, var0)
end

function var0.isLoaded(arg0)
	return arg0._isLoaded
end

function var0.getGroupNameFromData(arg0)
	local var0

	if arg0.contextData ~= nil and arg0.contextData.LayerWeightMgr_groupName then
		var0 = arg0.contextData.LayerWeightMgr_groupName
	else
		var0 = arg0:getGroupName()
	end

	return var0
end

function var0.getWeightFromData(arg0)
	local var0

	if arg0.contextData ~= nil and arg0.contextData.LayerWeightMgr_weight then
		var0 = arg0.contextData.LayerWeightMgr_weight
	else
		var0 = arg0:getLayerWeight()
	end

	return var0
end

function var0.isLayer(arg0)
	return arg0.contextData ~= nil and arg0.contextData.isLayer and not arg0.contextData.isSubView
end

function var0.addToLayerMgr(arg0)
	local var0 = arg0:getGroupNameFromData()
	local var1 = arg0:getWeightFromData()

	pg.LayerWeightMgr.GetInstance():Add2Overlay(LayerWeightConst.UI_TYPE_SYSTEM, arg0._tf, {
		globalBlur = false,
		groupName = var0,
		weight = var1
	})
end

var0.optionsPath = {
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

function var0.onUILoaded(arg0, arg1)
	arg0._go = arg1
	arg0._tf = arg1 and arg1.transform

	if arg0:isLayer() then
		arg0:addToLayerMgr()
	end

	pg.SeriesGuideMgr.GetInstance():dispatch({
		view = arg0.__cname
	})
	pg.NewStoryMgr.GetInstance():OnSceneEnter({
		view = arg0.__cname
	})

	arg0._isLoaded = true

	pg.DelegateInfo.New(arg0)

	arg0.optionBtns = {}

	for iter0, iter1 in ipairs(arg0.optionsPath) do
		table.insert(arg0.optionBtns, arg0:findTF(iter1))
	end

	setActiveViaLayer(arg0._tf, true)
	arg0:init()
	arg0:emit(var0.LOADED)
end

function var0.ResUISettings(arg0)
	return nil
end

function var0.ShowOrHideResUI(arg0, arg1)
	local var0 = arg0:ResUISettings()

	if not var0 then
		return
	end

	if var0 == true then
		var0 = {
			anim = true,
			showType = PlayerResUI.TYPE_ALL
		}
	end

	pg.playerResUI:SetActive(setmetatable({
		active = arg1,
		clear = not arg1 and not arg0:isLayer(),
		weight = var0.weight or arg0:getWeightFromData(),
		groupName = var0.groupName or arg0:getGroupNameFromData(),
		canvasOrder = var0.order or false
	}, {
		__index = var0
	}))
end

function var0.onUIAnimEnd(arg0, arg1)
	arg1()
end

function var0.init(arg0)
	return
end

function var0.quickExitFunc(arg0)
	arg0:emit(var0.ON_HOME)
end

function var0.quickExit(arg0)
	for iter0, iter1 in ipairs(arg0.optionBtns) do
		onButton(arg0, iter1, function()
			arg0:quickExitFunc()
		end, SFX_PANEL)
	end
end

function var0.enter(arg0)
	arg0:quickExit()
	arg0:PlayBGM()

	local var0 = function()
		arg0:emit(var0.DID_ENTER)

		if not arg0._isCachedView then
			arg0:didEnter()
			arg0:ShowOrHideResUI(true)
		end

		arg0:emit(var0.AVALIBLE)
		arg0:onUIAnimEnd(function()
			pg.SeriesGuideMgr.GetInstance():start({
				view = arg0.__cname,
				code = {
					pg.SeriesGuideMgr.CODES.MAINUI
				}
			})
			pg.NewGuideMgr.GetInstance():OnSceneEnter({
				view = arg0.__cname
			})
		end)
	end
	local var1 = false

	if not IsNil(arg0._tf:GetComponent(typeof(Animation))) then
		arg0.animTF = arg0._tf
	else
		arg0.animTF = arg0:findTF("blur_panel")
	end

	if arg0.animTF ~= nil then
		local var2 = arg0.animTF:GetComponent(typeof(Animation))
		local var3 = arg0.animTF:GetComponent(typeof(UIEventTrigger))

		if var2 ~= nil and var3 ~= nil then
			if var2:get_Item("enter") == nil then
				originalPrint("cound not found enter animation")
			else
				var2:Play("enter")
			end
		elseif var2 ~= nil then
			originalPrint("cound not found [UIEventTrigger] component")
		elseif var3 ~= nil then
			originalPrint("cound not found [Animation] component")
		end
	end

	if not var1 then
		var0()
	end
end

function var0.closeView(arg0)
	if arg0.contextData.isLayer then
		arg0:emit(var0.ON_CLOSE)
	else
		arg0:emit(var0.ON_BACK)
	end
end

function var0.didEnter(arg0)
	return
end

function var0.willExit(arg0)
	return
end

function var0.exit(arg0)
	arg0.exited = true

	arg0:StopBgm()
	pg.DelegateInfo.Dispose(arg0)

	local var0 = function()
		arg0:willExit()
		arg0:ShowOrHideResUI(false)
		arg0:detach()
		pg.NewGuideMgr.GetInstance():OnSceneExit({
			view = arg0.__cname
		})
		pg.NewStoryMgr.GetInstance():OnSceneExit({
			view = arg0.__cname
		})
		arg0:emit(var0.DID_EXIT)
	end
	local var1 = false

	if not var1 then
		var0()
	end
end

function var0.PlayExitAnimation(arg0, arg1)
	local var0 = arg0._tf:GetComponent(typeof(Animation))
	local var1 = arg0._tf:GetComponent(typeof(UIEventTrigger))

	var1.didExit:RemoveAllListeners()
	var1.didExit:AddListener(function()
		var1.didExit:RemoveAllListeners()
		arg1()
	end)
	var0:Play("exit")
end

function var0.attach(arg0, arg1)
	return
end

function var0.ClearTweens(arg0, arg1)
	arg0:cleanManagedTween(arg1)
end

function var0.RemoveTempCache(arg0)
	local var0 = arg0:getUIName()

	PoolMgr.GetInstance():DelTempCache(var0)
end

function var0.detach(arg0, arg1)
	arg0._isLoaded = false

	pg.LayerWeightMgr.GetInstance():DelFromOverlay(arg0._tf)
	pg.DynamicBgMgr.GetInstance():ClearBg(arg0:getUIName())
	arg0:disposeEvent()
	arg0:ClearTweens(false)

	arg0._tf = nil

	local var0 = PoolMgr.GetInstance()
	local var1 = arg0:getUIName()

	if arg0._go ~= nil and var1 then
		var0:ReturnUI(var1, arg0._go)

		arg0._go = nil
	end
end

function var0.findGO(arg0, arg1, arg2)
	assert(arg0._go, "game object should exist")

	return findGO(arg2 or arg0._go, arg1)
end

function var0.findTF(arg0, arg1, arg2)
	assert(arg0._tf, "transform should exist")

	return findTF(arg2 or arg0._tf, arg1)
end

function var0.getTpl(arg0, arg1, arg2)
	local var0 = arg0:findTF(arg1, arg2)

	var0:SetParent(arg0._tf, false)
	SetActive(var0, false)

	return var0
end

function var0.setSpriteTo(arg0, arg1, arg2, arg3)
	local var0 = arg2:GetComponent(typeof(Image))

	var0.sprite = arg0:findTF(arg1):GetComponent(typeof(Image)).sprite

	if arg3 then
		var0:SetNativeSize()
	end
end

function var0.setImageAmount(arg0, arg1, arg2)
	arg1:GetComponent(typeof(Image)).fillAmount = arg2
end

function var0.setVisible(arg0, arg1)
	arg0:ShowOrHideResUI(arg1)

	if arg1 then
		arg0:OnVisible()
	else
		arg0:OnDisVisible()
	end

	setActiveViaLayer(arg0._tf, arg1)
end

function var0.OnVisible(arg0)
	return
end

function var0.OnDisVisible(arg0)
	return
end

function var0.onBackPressed(arg0)
	arg0:emit(var0.ON_BACK_PRESSED)
end

return var0
