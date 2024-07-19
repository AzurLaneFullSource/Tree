local var0_0 = class("YingxiV3FrameRePage", import(".TemplatePage.NewFrameTemplatePage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.battleBtn = arg0_1:findTF("btn/battle_btn", arg0_1.bg)
	arg0_1.getBtn = arg0_1:findTF("btn/get_btn", arg0_1.bg)
	arg0_1.gotBtn = arg0_1:findTF("btn/got_btn", arg0_1.bg)
	arg0_1.bar = arg0_1:findTF("barContent/bar", arg0_1.bg)
	arg0_1.cur = arg0_1:findTF("progress/cur", arg0_1.bg)
	arg0_1.target = arg0_1:findTF("progress/target", arg0_1.bg)
	arg0_1.gotTag = arg0_1:findTF("tag/got", arg0_1.bg)
	arg0_1.getTag = arg0_1:findTF("tag/get", arg0_1.bg)
end

function var0_0.OnFirstFlush(arg0_2)
	onButton(arg0_2, arg0_2.battleBtn, function()
		arg0_2:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.getBtn, function()
		arg0_2:emit(ActivityMediator.EVENT_OPERATION, {
			cmd = 1,
			activity_id = arg0_2.activity.id
		})
	end, SFX_PANEL)

	arg0_2.inPhase2 = arg0_2.timeStamp and pg.TimeMgr.GetInstance():GetServerTime() - arg0_2.timeStamp > 0
end

function var0_0.OnUpdateFlush(arg0_5)
	var0_0.super.OnUpdateFlush(arg0_5)

	local var0_5 = arg0_5.activity.data1
	local var1_5 = arg0_5.avatarConfig.target
	local var2_5 = arg0_5.activity.data2 >= 1
	local var3_5 = var1_5 <= var0_5

	setActive(arg0_5.getTag, arg0_5.inPhase2 and not var2_5 and var3_5)
end

return var0_0
