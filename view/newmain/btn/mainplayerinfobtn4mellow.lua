local var0_0 = class("MainPlayerInfoBtn4Mellow", import(".MainPlayerInfoBtn"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.super.Ctor(arg0_1, arg1_1, arg2_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1.playerInfoBtn = findTF(arg0_1._tf, "name_bg")
	arg0_1.playerNameTxt = findTF(arg0_1._tf, "name_bg/Text"):GetComponent(typeof(Text))
	arg0_1.playerLevelTr = findTF(arg0_1._tf, "name_bg/level/Text")
	arg0_1.playerLevelTxt = findTF(arg0_1._tf, "name_bg/level/Text"):GetComponent(typeof(Text))
	arg0_1.expTxt = findTF(arg0_1._tf, "name_bg/level/mask/Text"):GetComponent(typeof(Text))
	arg0_1.goldMax = findTF(arg0_1._tf, "res/gold/max"):GetComponent(typeof(Text))
	arg0_1.goldValue = findTF(arg0_1._tf, "res/gold/Text"):GetComponent(typeof(Text))
	arg0_1.oilMax = findTF(arg0_1._tf, "res/oil/max"):GetComponent(typeof(Text))
	arg0_1.oilValue = findTF(arg0_1._tf, "res/oil/Text"):GetComponent(typeof(Text))
	arg0_1.gemValue = findTF(arg0_1._tf, "res/gem/Text"):GetComponent(typeof(Text))
	arg0_1.expTr = findTF(arg0_1._tf, "name_bg/level/mask")

	onButton(arg0_1, findTF(arg0_1._tf, "res/gold"), function()
		pg.playerResUI:ClickGold()
	end, SFX_PANEL)
	onButton(arg0_1, findTF(arg0_1._tf, "res/oil"), function()
		pg.playerResUI:ClickOil()
	end, SFX_PANEL)
	onButton(arg0_1, findTF(arg0_1._tf, "res/gem"), function()
		pg.playerResUI:ClickGem()
	end, SFX_PANEL)
	arg0_1:bind(PlayerProxy.UPDATED, function()
		arg0_1:Flush()
	end)
	arg0_1:bind(GAME.GUILD_GET_USER_INFO_DONE, function()
		arg0_1:Flush()
	end)
	arg0_1:bind(GAME.GET_PUBLIC_GUILD_USER_DATA_DONE, function()
		arg0_1:Flush()
	end)
end

function var0_0.Flush(arg0_8, arg1_8)
	var0_0.super.Flush(arg0_8, arg1_8)
	arg0_8:UpdateRes()
end

function var0_0.UpdateRes(arg0_9)
	local var0_9 = getProxy(PlayerProxy):getRawData()

	PlayerResUI.StaticFlush(var0_9, arg0_9.goldMax, arg0_9.goldValue, arg0_9.oilMax, arg0_9.oilValue, arg0_9.gemValue)
end

function var0_0.UpdateExp(arg0_10)
	local var0_10 = 0
	local var1_10 = getProxy(PlayerProxy):getRawData()

	arg0_10.playerLevelTxt.text = var1_10.level
	arg0_10.expTxt.text = var1_10.level

	local var2_10

	if var1_10.level == var1_10:getMaxLevel() then
		var2_10 = 1
	else
		local var3_10 = getConfigFromLevel1(pg.user_level, var1_10.level)

		var2_10 = var1_10.exp / var3_10.exp_interval
	end

	local var4_10 = 34 * var2_10

	arg0_10.expTr.sizeDelta = Vector2(70, var4_10)
end

function var0_0.Dispose(arg0_11)
	var0_0.super.Dispose(arg0_11)
	pg.DelegateInfo.Dispose(arg0_11)
end

return var0_0
