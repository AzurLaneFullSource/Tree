local var0 = class("WorldResource", import("..base.BaseUI"))

var0.Listeners = {
	onUpdateInventory = "OnUpdateInventory",
	onUpdateActivate = "OnUpdateActivate",
	onUpdateStamina = "OnUpdateStamina",
	onBossProgressUpdate = "OnBossProgressUpdate"
}

function var0.Ctor(arg0)
	var0.super.Ctor(arg0)
	PoolMgr.GetInstance():GetUI("WorldResPanel", false, function(arg0)
		local var0 = pg.UIMgr.GetInstance().UIMain

		arg0.transform:SetParent(var0.transform, false)
		arg0:onUILoaded(arg0)
	end)
end

function var0.init(arg0)
	for iter0, iter1 in pairs(var0.Listeners) do
		arg0[iter0] = function(...)
			var0[iter1](arg0, ...)
		end
	end

	local var0 = nowWorld()

	arg0.stamina = arg0:findTF("res/stamina")

	onButton(arg0, arg0.stamina, function()
		var0.staminaMgr:Show()
	end, SFX_PANEL)

	arg0.oil = arg0:findTF("res/oil")

	onButton(arg0, arg0.oil, function()
		local var0 = ShoppingStreet.getRiseShopId(ShopArgs.BuyOil, arg0.player.buyOilCount)

		if not var0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_today_buy_limit"))

			return
		end

		local var1 = pg.shop_template[var0]
		local var2 = var1.num

		if var1.num == -1 and var1.genre == ShopArgs.BuyOil then
			var2 = ShopArgs.getOilByLevel(arg0.player.level)
		end

		if pg.gameset.buy_oil_limit.key_value > arg0.player.buyOilCount then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_SINGLE_ITEM,
				content = i18n("oil_buy_tip", var1.resource_num, var2, arg0.player.buyOilCount),
				drop = {
					id = 2,
					type = DROP_TYPE_RESOURCE,
					count = var2
				},
				onYes = function()
					pg.m02:sendNotification(GAME.SHOPPING, {
						isQuickShopping = true,
						count = 1,
						id = var0
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

	arg0.Whuobi = arg0:findTF("res/Whuobi")

	onButton(arg0, arg0.Whuobi, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_SINGLE_ITEM,
			drop = Drop.New({
				type = DROP_TYPE_WORLD_ITEM,
				id = WorldItem.MoneyId
			})
		})
	end, SFX_PANEL)

	arg0.bossProgress = arg0:findTF("res/boss_progress")

	onButton(arg0, arg0.bossProgress, function()
		local var0 = WorldBossConst.GetCurrBossItemInfo()
		local var1 = WorldBossConst.CanUnlockCurrBoss()

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			type = MSGBOX_TYPE_DROP_ITEM,
			name = var0.name,
			content = var0.display,
			iconPath = var0.icon,
			frame = var0.rarity,
			yesText = i18n("common_go_to_analyze"),
			yesGray = not var1,
			onYes = function()
				if var1 and var0:GetBossProxy():IsOpen() then
					pg.m02:sendNotification(GAME.GO_SCENE, SCENE.WORLDBOSS)
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("world_boss_progress_no_enough"))
					pg.MsgboxMgr.GetInstance():hide()
				end
			end
		})
	end, SFX_PANEL)

	if var0:GetActiveMap() then
		arg0:setStaminaMgr(var0.staminaMgr)
	else
		arg0.atlas = var0:GetAtlas()

		arg0.atlas:AddListener(WorldAtlas.EventUpdateActiveMap, arg0.onUpdateActivate)
		setActive(arg0.stamina, false)
	end

	arg0:setWorldInventory(var0:GetInventoryProxy())
	arg0:SetWorldBossRes(var0:GetBossProxy())
end

function var0.setParent(arg0, arg1, arg2)
	setParent(arg0._go, arg1, arg2)
end

function var0.setPlayer(arg0, arg1)
	assert(isa(arg1, Player), "should be an instance of Player")

	arg0.player = arg1

	setText(arg0.oil:Find("max_value"), "MAX:" .. pg.user_level[arg1.level].max_oil)
	setText(arg0.oil:Find("value"), arg1.oil)
end

function var0.OnUpdateActivate(arg0)
	arg0:setStaminaMgr(nowWorld().staminaMgr)
	arg0.atlas:RemoveListener(WorldAtlas.EventUpdateActiveMap, arg0.onUpdateActivate)
end

function var0.setStaminaMgr(arg0, arg1)
	arg0.staminaMgr = arg1

	setText(arg0.stamina:Find("max_value"), "MAX:" .. arg1:GetMaxStamina())
	arg0.staminaMgr:AddListener(WorldStaminaManager.EventUpdateStamina, arg0.onUpdateStamina)
	arg0:OnUpdateStamina()
	setActive(arg0.stamina, true)
end

function var0.setWorldInventory(arg0, arg1)
	arg0.inventoryProxy = arg1

	arg0.inventoryProxy:AddListener(WorldInventoryProxy.EventUpdateItem, arg0.onUpdateInventory)
	arg0:OnUpdateInventory()
end

function var0.OnUpdateStamina(arg0)
	setText(arg0.stamina:Find("value"), arg0.staminaMgr:GetDisplayStanima())
end

function var0.OnUpdateInventory(arg0, arg1, arg2, arg3)
	if not arg1 or arg1 == WorldInventoryProxy.EventUpdateItem and arg3.id == WorldItem.MoneyId then
		setText(arg0.Whuobi:Find("value"), arg0.inventoryProxy:GetItemCount(WorldItem.MoneyId))
	end
end

function var0.SetWorldBossRes(arg0, arg1)
	arg0.worldBossProxy = arg1

	arg0.worldBossProxy:AddListener(WorldBossProxy.EventUnlockProgressUpdated, arg0.onBossProgressUpdate)
	arg0:OnBossProgressUpdate()
end

function var0.OnBossProgressUpdate(arg0)
	local var0 = WorldBossConst.GetCurrBossItemProgress()
	local var1, var2, var3 = WorldBossConst.GetCurrBossItemCapacity()
	local var4, var5 = WorldBossConst.GetCurrBossConsume()
	local var6 = arg0.bossProgress:Find("value")
	local var7 = arg0.bossProgress:Find("max_value")
	local var8 = var3 <= var2 and COLOR_GREY or COLOR_WHITE

	setText(var6, "<color=" .. var8 .. ">" .. var0 .. "/" .. var5 .. "</color>")
	setText(var7, "<color=" .. var8 .. ">DAILY:" .. var2 .. "/" .. var3 .. "</color>")
	setActive(arg0.bossProgress, nowWorld():IsSystemOpen(WorldConst.SystemWorldBoss))
end

function var0.willExit(arg0)
	if arg0.staminaMgr then
		arg0.staminaMgr:RemoveListener(WorldStaminaManager.EventUpdateStamina, arg0.onUpdateStamina)
	else
		arg0.atlas:RemoveListener(WorldAtlas.EventUpdateActiveMap, arg0.onUpdateActivate)
	end

	arg0.inventoryProxy:RemoveListener(WorldInventoryProxy.EventUpdateItem, arg0.onUpdateInventory)
	arg0.worldBossProxy:RemoveListener(WorldBossProxy.EventUnlockProgressUpdated, arg0.onBossProgressUpdate)
	PoolMgr.GetInstance():ReturnUI("WorldResPanel", arg0._go)
end

return var0
