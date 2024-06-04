local var0 = class("MainPlayerInfoBtn4Mellow", import(".MainPlayerInfoBtn"))

function var0.Ctor(arg0, arg1, arg2)
	var0.super.super.Ctor(arg0, arg1, arg2)
	pg.DelegateInfo.New(arg0)

	arg0.playerInfoBtn = findTF(arg0._tf, "name_bg")
	arg0.playerNameTxt = findTF(arg0._tf, "name_bg/Text"):GetComponent(typeof(Text))
	arg0.playerLevelTr = findTF(arg0._tf, "name_bg/level/Text")
	arg0.playerLevelTxt = findTF(arg0._tf, "name_bg/level/Text"):GetComponent(typeof(Text))
	arg0.expTxt = findTF(arg0._tf, "name_bg/level/mask/Text"):GetComponent(typeof(Text))
	arg0.goldMax = findTF(arg0._tf, "res/gold/max"):GetComponent(typeof(Text))
	arg0.goldValue = findTF(arg0._tf, "res/gold/Text"):GetComponent(typeof(Text))
	arg0.oilMax = findTF(arg0._tf, "res/oil/max"):GetComponent(typeof(Text))
	arg0.oilValue = findTF(arg0._tf, "res/oil/Text"):GetComponent(typeof(Text))
	arg0.gemValue = findTF(arg0._tf, "res/gem/Text"):GetComponent(typeof(Text))
	arg0.expTr = findTF(arg0._tf, "name_bg/level/mask")

	onButton(arg0, findTF(arg0._tf, "res/gold"), function()
		pg.playerResUI:ClickGold()
	end, SFX_PANEL)
	onButton(arg0, findTF(arg0._tf, "res/oil"), function()
		pg.playerResUI:ClickOil()
	end, SFX_PANEL)
	onButton(arg0, findTF(arg0._tf, "res/gem"), function()
		pg.playerResUI:ClickGem()
	end, SFX_PANEL)
	arg0:bind(PlayerProxy.UPDATED, function()
		arg0:Flush()
	end)
	arg0:bind(GAME.GUILD_GET_USER_INFO_DONE, function()
		arg0:Flush()
	end)
	arg0:bind(GAME.GET_PUBLIC_GUILD_USER_DATA_DONE, function()
		arg0:Flush()
	end)
end

function var0.Flush(arg0, arg1)
	var0.super.Flush(arg0, arg1)
	arg0:UpdateRes()
end

function var0.UpdateRes(arg0)
	local var0 = getProxy(PlayerProxy):getRawData()

	PlayerResUI.StaticFlush(var0, arg0.goldMax, arg0.goldValue, arg0.oilMax, arg0.oilValue, arg0.gemValue)
end

function var0.UpdateExp(arg0)
	local var0 = 0
	local var1 = getProxy(PlayerProxy):getRawData()

	arg0.playerLevelTxt.text = var1.level
	arg0.expTxt.text = var1.level

	local var2

	if var1.level == var1:getMaxLevel() then
		var2 = 1
	else
		local var3 = getConfigFromLevel1(pg.user_level, var1.level)

		var2 = var1.exp / var3.exp_interval
	end

	local var4 = 34 * var2

	arg0.expTr.sizeDelta = Vector2(70, var4)
end

function var0.Dispose(arg0)
	var0.super.Dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)
end

return var0
