local var0 = class("MainPlayerInfoBtn", import(".MainBaseBtn"))

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0, arg1, arg2)

	arg0.playerInfoBtn = findTF(arg0._tf, "iconBack")
	arg0.playerNameTxt = findTF(arg0._tf, "name"):GetComponent(typeof(Text))
	arg0.playerLevelTxt = findTF(arg0._tf, "level"):GetComponent(typeof(Text))
	arg0.expSlider = findTF(arg0._tf, "exp"):GetComponent(typeof(Slider))
end

function var0.GetTarget(arg0)
	return arg0.playerInfoBtn
end

function var0.OnClick(arg0)
	arg0:emit(NewMainMediator.GO_SCENE, SCENE.PLAYER_INFO)
end

function var0.Flush(arg0, arg1)
	arg0:UpdateLevelAndName()
	arg0:UpdateExp()

	if not arg1 then
		arg0.playerNameTxt.enabled = false
		arg0.playerNameTxt.enabled = true
		arg0.playerLevelTxt.enabled = false
		arg0.playerLevelTxt.enabled = true
	end
end

function var0.UpdateLevelAndName(arg0)
	local var0 = getProxy(PlayerProxy):getRawData()

	arg0.playerNameTxt.text = var0.name
	arg0.playerLevelTxt.text = "LV." .. var0.level
end

function var0.UpdateExp(arg0)
	local var0 = getProxy(PlayerProxy):getRawData()

	if var0.level == var0:getMaxLevel() then
		arg0.expSlider.value = 1
	else
		local var1 = getConfigFromLevel1(pg.user_level, var0.level)

		arg0.expSlider.value = var0.exp / var1.exp_interval
	end
end

return var0
