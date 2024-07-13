local var0_0 = class("PlayerResUI", pm.Mediator)

var0_0.GO_MALL = "PlayerResUI:GO_MALL"
var0_0.CHANGE_TOUCH_ABLE = "PlayerResUI:CHANGE_TOUCH_ABLE"
var0_0.HIDE = "PlayerResUI:HIDE"
var0_0.SHOW = "PlayerResUI:SHOW"

local var1_0 = 1
local var2_0 = 2
local var3_0 = 3
local var4_0 = 4

var0_0.TYPE_OIL = 2
var0_0.TYPE_GOLD = 4
var0_0.TYPE_GEM = 8
var0_0.TYPE_ALL = bit.bor(2, 4, 8)
var0_0.DEFAULT_MODE = {
	showType = var0_0.TYPE_ALL
}

function var0_0.Ctor(arg0_1)
	var0_0.super.Ctor(arg0_1)
	pg.DelegateInfo.New(arg0_1)
	pg.m02:registerMediator(arg0_1)

	arg0_1.state = var1_0
	arg0_1.settingsStack = {}
end

function var0_0.GetPlayer(arg0_2)
	return getProxy(PlayerProxy):getRawData()
end

function var0_0.IsLoaded(arg0_3)
	return arg0_3.state > var2_0
end

function var0_0.IsEnable(arg0_4)
	return arg0_4.state == var4_0
end

function var0_0.Load(arg0_5, arg1_5)
	if arg0_5.state ~= var1_0 then
		return
	end

	arg0_5.state = var2_0

	PoolMgr.GetInstance():GetUI("ResPanel", true, arg1_5)
end

function var0_0.Init(arg0_6, arg1_6)
	arg0_6._go = arg1_6
	arg0_6.oilAddBtn = findTF(arg0_6._go, "oil")
	arg0_6.goldAddBtn = findTF(arg0_6._go, "gold")
	arg0_6.gemAddBtn = findTF(arg0_6._go, "gem")
	arg0_6.goldMax = findTF(arg0_6._go, "gold/gold_max_value"):GetComponent(typeof(Text))
	arg0_6.goldValue = findTF(arg0_6._go, "gold/gold_value"):GetComponent(typeof(Text))
	arg0_6.oilMax = findTF(arg0_6._go, "oil/oil_max_value"):GetComponent(typeof(Text))
	arg0_6.oilValue = findTF(arg0_6._go, "oil/oil_value"):GetComponent(typeof(Text))
	arg0_6.gemValue = findTF(arg0_6._go, "gem/gem_value"):GetComponent(typeof(Text))
	arg0_6.animation = arg0_6._go:GetComponent(typeof(Animation))
	arg0_6.gemPos = arg0_6.gemAddBtn.anchoredPosition
	arg0_6.oilPos = arg0_6.oilAddBtn.anchoredPosition
	arg0_6.foldableHelper = MainFoldableHelper.New(arg0_6._go.transform, Vector2(0, 1))

	onButton(arg0_6, arg0_6.goldAddBtn, function()
		arg0_6:ClickGold()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.oilAddBtn, function()
		arg0_6:ClickOil()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.gemAddBtn, function()
		arg0_6:ClickGem()
	end, SFX_PANEL)

	arg0_6.position = tf(arg0_6._go).anchoredPosition

	setActive(arg0_6._go, true)
end

function var0_0.SetActive(arg0_10, arg1_10)
	if arg1_10.active then
		table.insert(arg0_10.settingsStack, arg1_10)
		arg0_10:Enable(arg1_10)
	else
		if arg1_10.clear then
			arg0_10.settingsStack = {}
		else
			table.remove(arg0_10.settingsStack)
		end

		arg0_10:Disable()
	end
end

function var0_0.Enable(arg0_11, arg1_11)
	if not arg0_11:IsLoaded() then
		arg0_11:Load(function(arg0_12)
			arg0_11._tf = arg0_12.transform
			arg0_11.state = var4_0

			arg0_11:Init(arg0_11._tf:Find("frame").gameObject)
			arg0_11:CustomSetting(arg1_11)
			arg0_11:Flush()
		end)
	elseif arg0_11.state == var4_0 then
		arg0_11:CustomSetting(arg1_11)
	else
		arg0_11.state = var4_0

		arg0_11:CustomSetting(arg1_11)
		setActive(arg0_11._go, true)

		if arg0_11:IsDirty() then
			arg0_11:Flush()
		end
	end
end

function var0_0.Disable(arg0_13)
	if pg.goldExchangeMgr then
		pg.goldExchangeMgr:exit()

		pg.goldExchangeMgr = nil
	end

	if #arg0_13.settingsStack > 0 then
		local var0_13 = arg0_13.settingsStack[#arg0_13.settingsStack]

		var0_13.anim = false

		arg0_13:Enable(var0_13)
	elseif arg0_13:IsLoaded() then
		if arg0_13:IsLoaded() then
			setActive(arg0_13._go, false)
		end

		arg0_13.state = var3_0
	end
end

function var0_0.CustomSetting(arg0_14, arg1_14)
	local var0_14 = arg1_14.showType

	setActive(arg0_14.oilAddBtn, bit.band(var0_14, var0_0.TYPE_OIL) > 0)
	setActive(arg0_14.goldAddBtn, bit.band(var0_14, var0_0.TYPE_GOLD) > 0)
	setActive(arg0_14.gemAddBtn, bit.band(var0_14, var0_0.TYPE_GEM) > 0)
	arg0_14._go.transform:SetAsLastSibling()

	if arg1_14.anim then
		arg0_14:DoAnimation()
	end

	local var1_14 = arg1_14.gemOffsetX or 0

	arg0_14.gemAddBtn.anchoredPosition3D = Vector3(arg0_14.gemPos.x + var1_14, arg0_14.gemPos.y, 1)
	arg0_14.oilAddBtn.anchoredPosition3D = Vector3(arg0_14.oilPos.x + var1_14, arg0_14.oilPos.y, 1)

	NotchAdapt.AdjustUI()
	setCanvasOverrideSorting(arg0_14._tf, tobool(arg1_14.canvasOrder))

	if arg1_14.canvasOrder then
		GetComponent(arg0_14._tf, typeof(Canvas)).sortingOrder = arg1_14.canvasOrder
	end

	pg.LayerWeightMgr.GetInstance():Add2Overlay(LayerWeightConst.UI_TYPE_OVERLAY_FOREVER, arg0_14._tf, {
		weight = arg1_14.weight,
		groupName = arg1_14.groupName
	})
end

function var0_0.DoAnimation(arg0_15)
	arg0_15.foldableHelper:Fold(true, 0)
	arg0_15.foldableHelper:Fold(false, 0.5)
end

function var0_0.ClickGem(arg0_16)
	local var0_16 = arg0_16:GetPlayer()

	local function var1_16()
		if not pg.m02:hasMediator(ChargeMediator.__cname) then
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE.CHARGE, {
				wrap = ChargeScene.TYPE_DIAMOND
			})
		else
			pg.m02:sendNotification(var0_0.GO_MALL)
		end
	end

	if PLATFORM_CODE == PLATFORM_JP then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			fontSize = 23,
			yesText = "text_buy",
			content = i18n("word_diamond_tip", var0_16:getFreeGem(), var0_16:getChargeGem(), var0_16:getTotalGem()),
			onYes = var1_16,
			alignment = TextAnchor.UpperLeft,
			weight = LayerWeightConst.TOP_LAYER
		})
	else
		var1_16()
	end
end

function var0_0.ClickGold(arg0_18)
	if not pg.goldExchangeMgr then
		pg.goldExchangeMgr = GoldExchangeView.New()
	end
end

function var0_0.ClickOil(arg0_19)
	local var0_19 = arg0_19:GetPlayer()
	local var1_19 = pg.shop_template
	local var2_19 = ShoppingStreet.getRiseShopId(ShopArgs.BuyOil, var0_19.buyOilCount)

	if not var2_19 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_today_buy_limit"))

		return
	end

	local var3_19 = pg.shop_template[var2_19]
	local var4_19 = var3_19.num

	if var3_19.num == -1 and var3_19.genre == ShopArgs.BuyOil then
		var4_19 = ShopArgs.getOilByLevel(var0_19.level)
	end

	if pg.gameset.buy_oil_limit.key_value > var0_19.buyOilCount then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_SINGLE_ITEM,
			windowSize = {
				y = 570
			},
			content = i18n("oil_buy_tip", var3_19.resource_num, var4_19, var0_19.buyOilCount),
			drop = {
				id = 2,
				type = DROP_TYPE_RESOURCE,
				count = var4_19
			},
			onYes = function()
				pg.m02:sendNotification(GAME.SHOPPING, {
					isQuickShopping = true,
					count = 1,
					id = var2_19
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

function var0_0.Flush(arg0_21)
	local var0_21 = arg0_21:GetPlayer()

	var0_0.StaticFlush(var0_21, arg0_21.goldMax, arg0_21.goldValue, arg0_21.oilMax, arg0_21.oilValue, arg0_21.gemValue)
	arg0_21:SetDirty(false)
end

function var0_0.StaticFlush(arg0_22, arg1_22, arg2_22, arg3_22, arg4_22, arg5_22)
	local var0_22 = arg0_22:getLevelMaxGold()
	local var1_22 = arg0_22:getLevelMaxOil()

	arg1_22.text = "MAX: " .. var0_22
	arg2_22.text = arg0_22.gold
	arg3_22.text = "MAX: " .. var1_22
	arg4_22.text = arg0_22.oil
	arg5_22.text = arg0_22:getTotalGem()
end

function var0_0.Dispose(arg0_23)
	pg.DelegateInfo.Dispose(arg0_23)
	arg0_23:Disable()
	pg.m02:removeMediator(arg0_23.__cname)
	PoolMgr.GetInstance():ReturnUI("ResPanel", arg0_23._go)

	arg0_23.state = var1_0
end

function var0_0.SetDirty(arg0_24, arg1_24)
	arg0_24.dirty = arg1_24
end

function var0_0.IsDirty(arg0_25)
	return arg0_25.dirty
end

function var0_0.Fold(arg0_26, arg1_26, arg2_26)
	if not arg0_26:IsLoaded() then
		return
	end

	arg0_26.foldableHelper:Fold(arg1_26, arg2_26)
end

function var0_0.listNotificationInterests(arg0_27)
	return {
		PlayerProxy.UPDATED,
		GAME.GUILD_GET_USER_INFO_DONE,
		GAME.GET_PUBLIC_GUILD_USER_DATA_DONE,
		PlayerResUI.CHANGE_TOUCH_ABLE,
		var0_0.HIDE,
		var0_0.SHOW
	}
end

function var0_0.handleNotification(arg0_28, arg1_28)
	local var0_28 = arg1_28:getName()

	if var0_28 == PlayerResUI.CHANGE_TOUCH_ABLE then
		local var1_28 = arg1_28:getBody()
		local var2_28 = GetComponent(tf(arg0_28._go), typeof(CanvasGroup))

		var2_28.interactable = var1_28
		var2_28.blocksRaycasts = var1_28

		return
	end

	arg0_28:updateResPanel(var0_28)
end

function var0_0.updateResPanel(arg0_29, arg1_29)
	if not arg0_29:IsEnable() then
		arg0_29:SetDirty(true)

		return
	end

	if arg1_29 == PlayerProxy.UPDATED or arg1_29 == GAME.GUILD_GET_USER_INFO_DONE or arg1_29 == GAME.GET_PUBLIC_GUILD_USER_DATA_DONE then
		arg0_29:Flush()
	end
end

function var0_0.checkBackPressed(arg0_30)
	if pg.goldExchangeMgr then
		pg.goldExchangeMgr:exit()

		pg.goldExchangeMgr = nil

		return true
	else
		return false
	end
end

return var0_0
