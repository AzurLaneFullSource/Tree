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
	arg0_1.settingsDic = {}
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

function var0_0.SetSettings(arg0_10, arg1_10, arg2_10)
	arg0_10.settingsDic[arg1_10] = arg2_10

	arg0_10:Reflush()
end

function var0_0.RemoveSettings(arg0_11, arg1_11)
	arg0_11.settingsDic[arg1_11] = nil

	arg0_11:Reflush()
end

function var0_0.GetWeight(arg0_12, arg1_12)
	return pg.LayerWeightMgr.GetInstance().groupWeightDic[arg1_12]
end

function var0_0.Reflush(arg0_13)
	local var0_13

	for iter0_13, iter1_13 in pairs(arg0_13.settingsDic) do
		if not var0_13 or arg0_13:GetWeight(var0_13) < arg0_13:GetWeight(iter0_13) then
			var0_13 = iter0_13
		end
	end

	if (var0_13 and arg0_13.settingsDic[var0_13] or nil) ~= arg0_13.topSettings then
		arg0_13.topSettings = var0_13 and arg0_13.settingsDic[var0_13] or nil

		if arg0_13.topSettings then
			arg0_13:Enable(arg0_13.topSettings)
		else
			arg0_13:Disable()
		end
	end
end

function var0_0.Enable(arg0_14, arg1_14)
	if not arg0_14:IsLoaded() then
		arg0_14:Load(function(arg0_15)
			arg0_14._tf = arg0_15.transform
			arg0_14.state = var4_0

			arg0_14:Init(arg0_14._tf:Find("frame").gameObject)
			arg0_14:CustomSetting(arg1_14)
			arg0_14:Flush()
		end)
	elseif arg0_14.state == var4_0 then
		arg0_14:CustomSetting(arg1_14)
	else
		arg0_14.state = var4_0

		arg0_14:CustomSetting(arg1_14)
		setActive(arg0_14._go, true)

		if arg0_14:IsDirty() then
			arg0_14:Flush()
		end
	end
end

function var0_0.Disable(arg0_16)
	if pg.goldExchangeMgr then
		pg.goldExchangeMgr:exit()

		pg.goldExchangeMgr = nil
	end

	if arg0_16:IsLoaded() then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_16._tf)
		setActive(arg0_16._go, false)

		arg0_16.state = var3_0
	end
end

function var0_0.CustomSetting(arg0_17, arg1_17)
	local var0_17 = arg1_17.showType

	setActive(arg0_17.oilAddBtn, bit.band(var0_17, var0_0.TYPE_OIL) > 0)
	setActive(arg0_17.goldAddBtn, bit.band(var0_17, var0_0.TYPE_GOLD) > 0)
	setActive(arg0_17.gemAddBtn, bit.band(var0_17, var0_0.TYPE_GEM) > 0)

	if arg1_17.anim then
		arg0_17:DoAnimation()
	end

	local var1_17 = arg1_17.gemOffsetX or 0

	arg0_17.gemAddBtn.anchoredPosition3D = Vector3(arg0_17.gemPos.x + var1_17, arg0_17.gemPos.y, 1)
	arg0_17.oilAddBtn.anchoredPosition3D = Vector3(arg0_17.oilPos.x + var1_17, arg0_17.oilPos.y, 1)

	pg.UIMgr.GetInstance():OverlayPanel(arg0_17._tf, {
		groupName = arg1_17.groupName,
		groupDelta = arg1_17.groupDelta
	})
end

function var0_0.DoAnimation(arg0_18)
	arg0_18.foldableHelper:Fold(true, 0)
	arg0_18.foldableHelper:Fold(false, 0.5)
end

function var0_0.ClickGem(arg0_19)
	local var0_19 = arg0_19:GetPlayer()

	local function var1_19()
		if not pg.m02:hasMediator(NewShopMainMediator.__cname) then
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
			content = i18n("word_diamond_tip", var0_19:getFreeGem(), var0_19:getChargeGem(), var0_19:getTotalGem()),
			onYes = var1_19,
			alignment = TextAnchor.UpperLeft
		})
	else
		var1_19()
	end
end

function var0_0.ClickGold(arg0_21)
	if not pg.goldExchangeMgr then
		pg.goldExchangeMgr = GoldExchangeView.New()
	end
end

function var0_0.ClickOil(arg0_22)
	local var0_22 = arg0_22:GetPlayer()
	local var1_22 = pg.shop_template
	local var2_22 = ShoppingStreet.getRiseShopId(ShopArgs.BuyOil, var0_22.buyOilCount)

	if not var2_22 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_today_buy_limit"))

		return
	end

	local var3_22 = pg.shop_template[var2_22]
	local var4_22 = var3_22.num

	if var3_22.num == -1 and var3_22.genre == ShopArgs.BuyOil then
		var4_22 = ShopArgs.getOilByLevel(var0_22.level)
	end

	if pg.gameset.buy_oil_limit.key_value > var0_22.buyOilCount then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_SINGLE_ITEM,
			windowSize = {
				y = 570
			},
			content = i18n("oil_buy_tip", var3_22.resource_num, var4_22, var0_22.buyOilCount),
			drop = {
				id = 2,
				type = DROP_TYPE_RESOURCE,
				count = var4_22
			},
			onYes = function()
				pg.m02:sendNotification(GAME.SHOPPING, {
					isQuickShopping = true,
					count = 1,
					id = var2_22
				})
				pg.TrackerMgr.GetInstance():Tracking(TRACKING_PAY_OIL)
			end
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

function var0_0.Flush(arg0_24)
	local var0_24 = arg0_24:GetPlayer()

	var0_0.StaticFlush(var0_24, arg0_24.goldMax, arg0_24.goldValue, arg0_24.oilMax, arg0_24.oilValue, arg0_24.gemValue)
	arg0_24:SetDirty(false)
end

function var0_0.StaticFlush(arg0_25, arg1_25, arg2_25, arg3_25, arg4_25, arg5_25)
	local var0_25 = arg0_25:getLevelMaxGold()
	local var1_25 = arg0_25:getLevelMaxOil()

	arg1_25.text = "MAX: " .. var0_25
	arg2_25.text = arg0_25.gold
	arg3_25.text = "MAX: " .. var1_25
	arg4_25.text = arg0_25.oil
	arg5_25.text = arg0_25:getTotalGem()
end

function var0_0.Dispose(arg0_26)
	pg.DelegateInfo.Dispose(arg0_26)
	arg0_26:Disable()
	pg.m02:removeMediator(arg0_26.__cname)
	PoolMgr.GetInstance():ReturnUI("ResPanel", arg0_26._go)

	arg0_26.state = var1_0
end

function var0_0.SetDirty(arg0_27, arg1_27)
	arg0_27.dirty = arg1_27
end

function var0_0.IsDirty(arg0_28)
	return arg0_28.dirty
end

function var0_0.Fold(arg0_29, arg1_29, arg2_29)
	if not arg0_29:IsLoaded() then
		return
	end

	arg0_29.foldableHelper:Fold(arg1_29, arg2_29)
end

function var0_0.listNotificationInterests(arg0_30)
	return {
		PlayerProxy.UPDATED,
		GAME.GUILD_GET_USER_INFO_DONE,
		GAME.GET_PUBLIC_GUILD_USER_DATA_DONE,
		PlayerResUI.CHANGE_TOUCH_ABLE,
		var0_0.HIDE,
		var0_0.SHOW
	}
end

function var0_0.handleNotification(arg0_31, arg1_31)
	local var0_31 = arg1_31:getName()

	if var0_31 == PlayerResUI.CHANGE_TOUCH_ABLE then
		local var1_31 = arg1_31:getBody()
		local var2_31 = GetComponent(tf(arg0_31._go), typeof(CanvasGroup))

		var2_31.interactable = var1_31
		var2_31.blocksRaycasts = var1_31

		return
	end

	arg0_31:updateResPanel(var0_31)
end

function var0_0.updateResPanel(arg0_32, arg1_32)
	if not arg0_32:IsEnable() then
		arg0_32:SetDirty(true)

		return
	end

	if arg1_32 == PlayerProxy.UPDATED or arg1_32 == GAME.GUILD_GET_USER_INFO_DONE or arg1_32 == GAME.GET_PUBLIC_GUILD_USER_DATA_DONE then
		arg0_32:Flush()
	end
end

function var0_0.checkBackPressed(arg0_33)
	if pg.goldExchangeMgr then
		pg.goldExchangeMgr:exit()

		pg.goldExchangeMgr = nil

		return true
	else
		return false
	end
end

return var0_0
