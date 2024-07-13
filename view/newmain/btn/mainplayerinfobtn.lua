local var0_0 = class("MainPlayerInfoBtn", import(".MainBaseBtn"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.playerInfoBtn = findTF(arg0_1._tf, "iconBack")
	arg0_1.playerNameTxt = findTF(arg0_1._tf, "name"):GetComponent(typeof(Text))
	arg0_1.playerLevelTxt = findTF(arg0_1._tf, "level"):GetComponent(typeof(Text))
	arg0_1.expSlider = findTF(arg0_1._tf, "exp"):GetComponent(typeof(Slider))
end

function var0_0.GetTarget(arg0_2)
	return arg0_2.playerInfoBtn
end

function var0_0.OnClick(arg0_3)
	arg0_3:emit(NewMainMediator.GO_SCENE, SCENE.PLAYER_INFO)
end

function var0_0.Flush(arg0_4, arg1_4)
	arg0_4:UpdateLevelAndName()
	arg0_4:UpdateExp()

	if not arg1_4 then
		arg0_4.playerNameTxt.enabled = false
		arg0_4.playerNameTxt.enabled = true
		arg0_4.playerLevelTxt.enabled = false
		arg0_4.playerLevelTxt.enabled = true
	end
end

function var0_0.UpdateLevelAndName(arg0_5)
	local var0_5 = getProxy(PlayerProxy):getRawData()

	arg0_5.playerNameTxt.text = var0_5.name
	arg0_5.playerLevelTxt.text = "LV." .. var0_5.level
end

function var0_0.UpdateExp(arg0_6)
	local var0_6 = getProxy(PlayerProxy):getRawData()

	if var0_6.level == var0_6:getMaxLevel() then
		arg0_6.expSlider.value = 1
	else
		local var1_6 = getConfigFromLevel1(pg.user_level, var0_6.level)

		arg0_6.expSlider.value = var0_6.exp / var1_6.exp_interval
	end
end

return var0_0
