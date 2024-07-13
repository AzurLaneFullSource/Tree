local var0_0 = class("MonopolyPtPage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	onToggle(arg0_1, findTF(arg0_1._tf, "AD/toggle/1"), function()
		arg0_1:changeToggle(1)
	end, SFX_CONFIRM)
	onToggle(arg0_1, findTF(arg0_1._tf, "AD/toggle/2"), function()
		arg0_1:changeToggle(2)
	end, SFX_CONFIRM)
	onToggle(arg0_1, findTF(arg0_1._tf, "AD/toggle/3"), function()
		arg0_1:changeToggle(3)
	end, SFX_CONFIRM)
	triggerToggle(findTF(arg0_1._tf, "AD/toggle/1"), true)
	onButton(arg0_1, findTF(arg0_1._tf, "AD/btnShop"), function()
		arg0_1:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SHOP)
	end, SFX_CONFIRM)
	onButton(arg0_1, findTF(arg0_1._tf, "AD/btnGo"), function()
		arg0_1:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.MONOPOLY_PT, {
			config_id = arg0_1.activity.id
		})
	end, SFX_CONFIRM)
end

function var0_0.changeToggle(arg0_7, arg1_7)
	for iter0_7 = 1, 3 do
		setActive(findTF(arg0_7._tf, "AD/toggle/" .. iter0_7 .. "/on/desc"), iter0_7 == arg1_7)
	end
end

function var0_0.OnFirstFlush(arg0_8)
	if arg0_8.ptData then
		arg0_8.ptData:Update(arg0_8.activity)
	else
		arg0_8.ptData = ActivityPtData.New(arg0_8.activity)
	end
end

function var0_0.OnUpdateFlush(arg0_9)
	if arg0_9.ptData then
		arg0_9.ptData:Update(arg0_9.activity)
	else
		arg0_9.ptData = ActivityPtData.New(arg0_9.activity)
	end

	local var0_9, var1_9, var2_9 = arg0_9.ptData:GetLevelProgress()
	local var3_9, var4_9, var5_9 = arg0_9.ptData:GetResProgress()
	local var6_9 = arg0_9.ptData:GetLevel()
	local var7_9 = 20 - var6_9
	local var8_9 = math.floor(var3_9 / 500) - var6_9

	if var7_9 < var8_9 then
		var8_9 = var7_9
	end

	if var7_9 == 0 then
		setActive(findTF(arg0_9._tf, "AD/clear"), true)
	else
		setActive(findTF(arg0_9._tf, "AD/clear"), false)
	end

	setActive(findTF(arg0_9._tf, "AD/count"), var8_9 > 0)
	setText(findTF(arg0_9._tf, "AD/count/txt"), var8_9)
end

return var0_0
