local var0_0 = class("WorldResource", import("..base.BaseUI"))

var0_0.Listeners = {
	onUpdateInventory = "OnUpdateInventory",
	onUpdateActivate = "OnUpdateActivate",
	onUpdateStamina = "OnUpdateStamina",
	onBossProgressUpdate = "OnBossProgressUpdate"
}

function var0_0.Ctor(arg0_1)
	var0_0.super.Ctor(arg0_1)
	PoolMgr.GetInstance():GetUI("WorldResPanel", false, function(arg0_2)
		local var0_2 = pg.UIMgr.GetInstance().UIMain

		arg0_2.transform:SetParent(var0_2.transform, false)
		arg0_1:onUILoaded(arg0_2)
	end)
end

function var0_0.init(arg0_3)
	for iter0_3, iter1_3 in pairs(var0_0.Listeners) do
		arg0_3[iter0_3] = function(...)
			var0_0[iter1_3](arg0_3, ...)
		end
	end

	local var0_3 = nowWorld()

	arg0_3.stamina = arg0_3:findTF("res/stamina")

	onButton(arg0_3, arg0_3.stamina, function()
		var0_3.staminaMgr:Show()
	end, SFX_PANEL)

	arg0_3.oil = arg0_3:findTF("res/oil")

	onButton(arg0_3, arg0_3.oil, function()
		local var0_6 = ShoppingStreet.getRiseShopId(ShopArgs.BuyOil, arg0_3.player.buyOilCount)

		if not var0_6 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_today_buy_limit"))

			return
		end

		local var1_6 = pg.shop_template[var0_6]
		local var2_6 = var1_6.num

		if var1_6.num == -1 and var1_6.genre == ShopArgs.BuyOil then
			var2_6 = ShopArgs.getOilByLevel(arg0_3.player.level)
		end

		if pg.gameset.buy_oil_limit.key_value > arg0_3.player.buyOilCount then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_SINGLE_ITEM,
				content = i18n("oil_buy_tip", var1_6.resource_num, var2_6, arg0_3.player.buyOilCount),
				drop = {
					id = 2,
					type = DROP_TYPE_RESOURCE,
					count = var2_6
				},
				onYes = function()
					pg.m02:sendNotification(GAME.SHOPPING, {
						isQuickShopping = true,
						count = 1,
						id = var0_6
					})
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
	end, SFX_PANEL)

	arg0_3.Whuobi = arg0_3:findTF("res/Whuobi")

	onButton(arg0_3, arg0_3.Whuobi, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_SINGLE_ITEM,
			drop = Drop.New({
				type = DROP_TYPE_WORLD_ITEM,
				id = WorldItem.MoneyId
			})
		})
	end, SFX_PANEL)

	arg0_3.bossProgress = arg0_3:findTF("res/boss_progress")

	onButton(arg0_3, arg0_3.bossProgress, function()
		local var0_9 = WorldBossConst.GetCurrBossItemInfo()
		local var1_9 = WorldBossConst.CanUnlockCurrBoss()

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			type = MSGBOX_TYPE_DROP_ITEM,
			name = var0_9.name,
			content = var0_9.display,
			iconPath = var0_9.icon,
			frame = var0_9.rarity,
			yesText = i18n("common_go_to_analyze"),
			yesGray = not var1_9,
			onYes = function()
				if var1_9 and var0_3:GetBossProxy():IsOpen() then
					pg.m02:sendNotification(GAME.GO_SCENE, SCENE.WORLDBOSS)
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("world_boss_progress_no_enough"))
					pg.MsgboxMgr.GetInstance():hide()
				end
			end
		})
	end, SFX_PANEL)

	if var0_3:GetActiveMap() then
		arg0_3:setStaminaMgr(var0_3.staminaMgr)
	else
		arg0_3.atlas = var0_3:GetAtlas()

		arg0_3.atlas:AddListener(WorldAtlas.EventUpdateActiveMap, arg0_3.onUpdateActivate)
		setActive(arg0_3.stamina, false)
	end

	arg0_3:setWorldInventory(var0_3:GetInventoryProxy())
	arg0_3:SetWorldBossRes(var0_3:GetBossProxy())
end

function var0_0.setParent(arg0_11, arg1_11, arg2_11)
	setParent(arg0_11._go, arg1_11, arg2_11)
end

function var0_0.setPlayer(arg0_12, arg1_12)
	assert(isa(arg1_12, Player), "should be an instance of Player")

	arg0_12.player = arg1_12

	setText(arg0_12.oil:Find("max_value"), "MAX:" .. pg.user_level[arg1_12.level].max_oil)
	setText(arg0_12.oil:Find("value"), arg1_12.oil)
end

function var0_0.OnUpdateActivate(arg0_13)
	arg0_13:setStaminaMgr(nowWorld().staminaMgr)
	arg0_13.atlas:RemoveListener(WorldAtlas.EventUpdateActiveMap, arg0_13.onUpdateActivate)
end

function var0_0.setStaminaMgr(arg0_14, arg1_14)
	arg0_14.staminaMgr = arg1_14

	setText(arg0_14.stamina:Find("max_value"), "MAX:" .. arg1_14:GetMaxStamina())
	arg0_14.staminaMgr:AddListener(WorldStaminaManager.EventUpdateStamina, arg0_14.onUpdateStamina)
	arg0_14:OnUpdateStamina()
	setActive(arg0_14.stamina, true)
end

function var0_0.setWorldInventory(arg0_15, arg1_15)
	arg0_15.inventoryProxy = arg1_15

	arg0_15.inventoryProxy:AddListener(WorldInventoryProxy.EventUpdateItem, arg0_15.onUpdateInventory)
	arg0_15:OnUpdateInventory()
end

function var0_0.OnUpdateStamina(arg0_16)
	setText(arg0_16.stamina:Find("value"), arg0_16.staminaMgr:GetDisplayStanima())
end

function var0_0.OnUpdateInventory(arg0_17, arg1_17, arg2_17, arg3_17)
	if not arg1_17 or arg1_17 == WorldInventoryProxy.EventUpdateItem and arg3_17.id == WorldItem.MoneyId then
		setText(arg0_17.Whuobi:Find("value"), arg0_17.inventoryProxy:GetItemCount(WorldItem.MoneyId))
	end
end

function var0_0.SetWorldBossRes(arg0_18, arg1_18)
	arg0_18.worldBossProxy = arg1_18

	arg0_18.worldBossProxy:AddListener(WorldBossProxy.EventUnlockProgressUpdated, arg0_18.onBossProgressUpdate)
	arg0_18:OnBossProgressUpdate()
end

function var0_0.OnBossProgressUpdate(arg0_19)
	local var0_19 = WorldBossConst.GetCurrBossItemProgress()
	local var1_19, var2_19, var3_19 = WorldBossConst.GetCurrBossItemCapacity()
	local var4_19, var5_19 = WorldBossConst.GetCurrBossConsume()
	local var6_19 = arg0_19.bossProgress:Find("value")
	local var7_19 = arg0_19.bossProgress:Find("max_value")
	local var8_19 = var3_19 <= var2_19 and COLOR_GREY or COLOR_WHITE

	setText(var6_19, "<color=" .. var8_19 .. ">" .. var0_19 .. "/" .. var5_19 .. "</color>")
	setText(var7_19, "<color=" .. var8_19 .. ">DAILY:" .. var2_19 .. "/" .. var3_19 .. "</color>")
	setActive(arg0_19.bossProgress, nowWorld():IsSystemOpen(WorldConst.SystemWorldBoss))
end

function var0_0.willExit(arg0_20)
	if arg0_20.staminaMgr then
		arg0_20.staminaMgr:RemoveListener(WorldStaminaManager.EventUpdateStamina, arg0_20.onUpdateStamina)
	else
		arg0_20.atlas:RemoveListener(WorldAtlas.EventUpdateActiveMap, arg0_20.onUpdateActivate)
	end

	arg0_20.inventoryProxy:RemoveListener(WorldInventoryProxy.EventUpdateItem, arg0_20.onUpdateInventory)
	arg0_20.worldBossProxy:RemoveListener(WorldBossProxy.EventUnlockProgressUpdated, arg0_20.onBossProgressUpdate)
	PoolMgr.GetInstance():ReturnUI("WorldResPanel", arg0_20._go)
end

return var0_0
