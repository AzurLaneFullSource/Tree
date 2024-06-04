local var0 = class("PlayerResUI", pm.Mediator)

var0.GO_MALL = "PlayerResUI:GO_MALL"
var0.CHANGE_TOUCH_ABLE = "PlayerResUI:CHANGE_TOUCH_ABLE"
var0.HIDE = "PlayerResUI:HIDE"
var0.SHOW = "PlayerResUI:SHOW"

local var1 = 1
local var2 = 2
local var3 = 3
local var4 = 4

var0.TYPE_OIL = 2
var0.TYPE_GOLD = 4
var0.TYPE_GEM = 8
var0.TYPE_ALL = bit.bor(2, 4, 8)
var0.DEFAULT_MODE = {
	showType = var0.TYPE_ALL
}

function var0.Ctor(arg0)
	var0.super.Ctor(arg0)
	pg.DelegateInfo.New(arg0)
	pg.m02:registerMediator(arg0)

	arg0.state = var1
	arg0.settingsStack = {}
end

function var0.GetPlayer(arg0)
	return getProxy(PlayerProxy):getRawData()
end

function var0.IsLoaded(arg0)
	return arg0.state > var2
end

function var0.IsEnable(arg0)
	return arg0.state == var4
end

function var0.Load(arg0, arg1)
	if arg0.state ~= var1 then
		return
	end

	arg0.state = var2

	PoolMgr.GetInstance():GetUI("ResPanel", true, arg1)
end

function var0.Init(arg0, arg1)
	arg0._go = arg1
	arg0.oilAddBtn = findTF(arg0._go, "oil")
	arg0.goldAddBtn = findTF(arg0._go, "gold")
	arg0.gemAddBtn = findTF(arg0._go, "gem")
	arg0.goldMax = findTF(arg0._go, "gold/gold_max_value"):GetComponent(typeof(Text))
	arg0.goldValue = findTF(arg0._go, "gold/gold_value"):GetComponent(typeof(Text))
	arg0.oilMax = findTF(arg0._go, "oil/oil_max_value"):GetComponent(typeof(Text))
	arg0.oilValue = findTF(arg0._go, "oil/oil_value"):GetComponent(typeof(Text))
	arg0.gemValue = findTF(arg0._go, "gem/gem_value"):GetComponent(typeof(Text))
	arg0.animation = arg0._go:GetComponent(typeof(Animation))
	arg0.gemPos = arg0.gemAddBtn.anchoredPosition
	arg0.oilPos = arg0.oilAddBtn.anchoredPosition
	arg0.foldableHelper = MainFoldableHelper.New(arg0._go.transform, Vector2(0, 1))

	onButton(arg0, arg0.goldAddBtn, function()
		arg0:ClickGold()
	end, SFX_PANEL)
	onButton(arg0, arg0.oilAddBtn, function()
		arg0:ClickOil()
	end, SFX_PANEL)
	onButton(arg0, arg0.gemAddBtn, function()
		arg0:ClickGem()
	end, SFX_PANEL)

	arg0.position = tf(arg0._go).anchoredPosition

	setActive(arg0._go, true)
end

function var0.SetActive(arg0, arg1)
	if arg1.active then
		table.insert(arg0.settingsStack, arg1)
		arg0:Enable(arg1)
	else
		if arg1.clear then
			arg0.settingsStack = {}
		else
			table.remove(arg0.settingsStack)
		end

		arg0:Disable()
	end
end

function var0.Enable(arg0, arg1)
	if not arg0:IsLoaded() then
		arg0:Load(function(arg0)
			arg0._tf = arg0.transform
			arg0.state = var4

			arg0:Init(arg0._tf:Find("frame").gameObject)
			arg0:CustomSetting(arg1)
			arg0:Flush()
		end)
	elseif arg0.state == var4 then
		arg0:CustomSetting(arg1)
	else
		arg0.state = var4

		arg0:CustomSetting(arg1)
		setActive(arg0._go, true)

		if arg0:IsDirty() then
			arg0:Flush()
		end
	end
end

function var0.Disable(arg0)
	if pg.goldExchangeMgr then
		pg.goldExchangeMgr:exit()

		pg.goldExchangeMgr = nil
	end

	if #arg0.settingsStack > 0 then
		local var0 = arg0.settingsStack[#arg0.settingsStack]

		var0.anim = false

		arg0:Enable(var0)
	elseif arg0:IsLoaded() then
		if arg0:IsLoaded() then
			setActive(arg0._go, false)
		end

		arg0.state = var3
	end
end

function var0.CustomSetting(arg0, arg1)
	local var0 = arg1.showType

	setActive(arg0.oilAddBtn, bit.band(var0, var0.TYPE_OIL) > 0)
	setActive(arg0.goldAddBtn, bit.band(var0, var0.TYPE_GOLD) > 0)
	setActive(arg0.gemAddBtn, bit.band(var0, var0.TYPE_GEM) > 0)
	arg0._go.transform:SetAsLastSibling()

	if arg1.anim then
		arg0:DoAnimation()
	end

	local var1 = arg1.gemOffsetX or 0

	arg0.gemAddBtn.anchoredPosition3D = Vector3(arg0.gemPos.x + var1, arg0.gemPos.y, 1)
	arg0.oilAddBtn.anchoredPosition3D = Vector3(arg0.oilPos.x + var1, arg0.oilPos.y, 1)

	NotchAdapt.AdjustUI()
	setCanvasOverrideSorting(arg0._tf, tobool(arg1.canvasOrder))

	if arg1.canvasOrder then
		GetComponent(arg0._tf, typeof(Canvas)).sortingOrder = arg1.canvasOrder
	end

	pg.LayerWeightMgr.GetInstance():Add2Overlay(LayerWeightConst.UI_TYPE_OVERLAY_FOREVER, arg0._tf, {
		weight = arg1.weight,
		groupName = arg1.groupName
	})
end

function var0.DoAnimation(arg0)
	arg0.foldableHelper:Fold(true, 0)
	arg0.foldableHelper:Fold(false, 0.5)
end

function var0.ClickGem(arg0)
	local var0 = arg0:GetPlayer()

	local function var1()
		if not pg.m02:hasMediator(ChargeMediator.__cname) then
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.CHARGE, {
				wrap = ChargeScene.TYPE_DIAMOND
			})
		else
			pg.m02:sendNotification(var0.GO_MALL)
		end
	end

	if PLATFORM_CODE == PLATFORM_JP then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			fontSize = 23,
			yesText = "text_buy",
			content = i18n("word_diamond_tip", var0:getFreeGem(), var0:getChargeGem(), var0:getTotalGem()),
			onYes = var1,
			alignment = TextAnchor.UpperLeft,
			weight = LayerWeightConst.TOP_LAYER
		})
	else
		var1()
	end
end

function var0.ClickGold(arg0)
	if not pg.goldExchangeMgr then
		pg.goldExchangeMgr = GoldExchangeView.New()
	end
end

function var0.ClickOil(arg0)
	local var0 = arg0:GetPlayer()
	local var1 = pg.shop_template
	local var2 = ShoppingStreet.getRiseShopId(ShopArgs.BuyOil, var0.buyOilCount)

	if not var2 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_today_buy_limit"))

		return
	end

	local var3 = pg.shop_template[var2]
	local var4 = var3.num

	if var3.num == -1 and var3.genre == ShopArgs.BuyOil then
		var4 = ShopArgs.getOilByLevel(var0.level)
	end

	if pg.gameset.buy_oil_limit.key_value > var0.buyOilCount then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_SINGLE_ITEM,
			windowSize = {
				y = 570
			},
			content = i18n("oil_buy_tip", var3.resource_num, var4, var0.buyOilCount),
			drop = {
				id = 2,
				type = DROP_TYPE_RESOURCE,
				count = var4
			},
			onYes = function()
				pg.m02:sendNotification(GAME.SHOPPING, {
					isQuickShopping = true,
					count = 1,
					id = var2
				})
			end,
			weight = LayerWeightConst.TOP_LAYER
		})
	else
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("help_oil_buy_limit"),
			custom = {
				{
					text = "text_iknow",
					sound = SFX_CANCEL
				}
			}
		})
	end
end

function var0.Flush(arg0)
	local var0 = arg0:GetPlayer()

	var0.StaticFlush(var0, arg0.goldMax, arg0.goldValue, arg0.oilMax, arg0.oilValue, arg0.gemValue)
	arg0:SetDirty(false)
end

function var0.StaticFlush(arg0, arg1, arg2, arg3, arg4, arg5)
	local var0 = arg0:getLevelMaxGold()
	local var1 = arg0:getLevelMaxOil()

	arg1.text = "MAX: " .. var0
	arg2.text = arg0.gold
	arg3.text = "MAX: " .. var1
	arg4.text = arg0.oil
	arg5.text = arg0:getTotalGem()
end

function var0.Dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)
	arg0:Disable()
	pg.m02:removeMediator(arg0.__cname)
	PoolMgr.GetInstance():ReturnUI("ResPanel", arg0._go)

	arg0.state = var1
end

function var0.SetDirty(arg0, arg1)
	arg0.dirty = arg1
end

function var0.IsDirty(arg0)
	return arg0.dirty
end

function var0.Fold(arg0, arg1, arg2)
	if not arg0:IsLoaded() then
		return
	end

	arg0.foldableHelper:Fold(arg1, arg2)
end

function var0.listNotificationInterests(arg0)
	return {
		PlayerProxy.UPDATED,
		GAME.GUILD_GET_USER_INFO_DONE,
		GAME.GET_PUBLIC_GUILD_USER_DATA_DONE,
		PlayerResUI.CHANGE_TOUCH_ABLE,
		var0.HIDE,
		var0.SHOW
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()

	if var0 == PlayerResUI.CHANGE_TOUCH_ABLE then
		local var1 = arg1:getBody()
		local var2 = GetComponent(tf(arg0._go), typeof(CanvasGroup))

		var2.interactable = var1
		var2.blocksRaycasts = var1

		return
	end

	arg0:updateResPanel(var0)
end

function var0.updateResPanel(arg0, arg1)
	if not arg0:IsEnable() then
		arg0:SetDirty(true)

		return
	end

	if arg1 == PlayerProxy.UPDATED or arg1 == GAME.GUILD_GET_USER_INFO_DONE or arg1 == GAME.GET_PUBLIC_GUILD_USER_DATA_DONE then
		arg0:Flush()
	end
end

function var0.checkBackPressed(arg0)
	if pg.goldExchangeMgr then
		pg.goldExchangeMgr:exit()

		pg.goldExchangeMgr = nil

		return true
	else
		return false
	end
end

return var0
