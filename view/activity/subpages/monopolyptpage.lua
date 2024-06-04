local var0 = class("MonopolyPtPage", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	onToggle(arg0, findTF(arg0._tf, "AD/toggle/1"), function()
		arg0:changeToggle(1)
	end, SFX_CONFIRM)
	onToggle(arg0, findTF(arg0._tf, "AD/toggle/2"), function()
		arg0:changeToggle(2)
	end, SFX_CONFIRM)
	onToggle(arg0, findTF(arg0._tf, "AD/toggle/3"), function()
		arg0:changeToggle(3)
	end, SFX_CONFIRM)
	triggerToggle(findTF(arg0._tf, "AD/toggle/1"), true)
	onButton(arg0, findTF(arg0._tf, "AD/btnShop"), function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SHOP)
	end, SFX_CONFIRM)
	onButton(arg0, findTF(arg0._tf, "AD/btnGo"), function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.MONOPOLY_PT, {
			config_id = arg0.activity.id
		})
	end, SFX_CONFIRM)
end

function var0.changeToggle(arg0, arg1)
	for iter0 = 1, 3 do
		setActive(findTF(arg0._tf, "AD/toggle/" .. iter0 .. "/on/desc"), iter0 == arg1)
	end
end

function var0.OnFirstFlush(arg0)
	if arg0.ptData then
		arg0.ptData:Update(arg0.activity)
	else
		arg0.ptData = ActivityPtData.New(arg0.activity)
	end
end

function var0.OnUpdateFlush(arg0)
	if arg0.ptData then
		arg0.ptData:Update(arg0.activity)
	else
		arg0.ptData = ActivityPtData.New(arg0.activity)
	end

	local var0, var1, var2 = arg0.ptData:GetLevelProgress()
	local var3, var4, var5 = arg0.ptData:GetResProgress()
	local var6 = arg0.ptData:GetLevel()
	local var7 = 20 - var6
	local var8 = math.floor(var3 / 500) - var6

	if var7 < var8 then
		var8 = var7
	end

	if var7 == 0 then
		setActive(findTF(arg0._tf, "AD/clear"), true)
	else
		setActive(findTF(arg0._tf, "AD/clear"), false)
	end

	setActive(findTF(arg0._tf, "AD/count"), var8 > 0)
	setText(findTF(arg0._tf, "AD/count/txt"), var8)
end

return var0
