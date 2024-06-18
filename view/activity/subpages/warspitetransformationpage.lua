local var0_0 = class("WarspiteTransformationPage", import("view.base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD", arg0_1._tf)
	arg0_1.btn = arg0_1:findTF("battle_btn", arg0_1.bg)
	arg0_1.tip = arg0_1:findTF("help", arg0_1.bg)
	arg0_1.mainAward = arg0_1:findTF("award", arg0_1.bg)
	arg0_1.subAwards = CustomIndexLayer.Clone2Full(arg0_1:findTF("list", arg0_1.bg), 7)
	arg0_1.step = arg0_1:findTF("receivetimes", arg0_1.bg)
	arg0_1.score = arg0_1:findTF("highscore", arg0_1.bg)
end

function var0_0.OnDataSetting(arg0_2)
	local var0_2 = arg0_2.activity

	if var0_2.data4 == 0 and var0_2.data2 >= 7 then
		arg0_2:emit(ActivityMediator.EVENT_OPERATION, {
			cmd = 3,
			activity_id = var0_2.id
		})

		return true
	elseif defaultValue(var0_2.data2_list[1], 0) > 0 or defaultValue(var0_2.data2_list[2], 0) > 0 then
		arg0_2:emit(ActivityMediator.EVENT_OPERATION, {
			cmd = 2,
			activity_id = var0_2.id
		})

		return true
	end
end

function var0_0.OnFirstFlush(arg0_3)
	local var0_3 = arg0_3.activity
	local var1_3 = var0_3:getConfig("config_client")[2]
	local var2_3 = {
		type = var1_3[1],
		id = var1_3[2],
		count = var1_3[3]
	}

	onButton(arg0_3, arg0_3.mainAward, function()
		arg0_3:emit(BaseUI.ON_DROP, var2_3)
	end, SFX_PANEL)

	for iter0_3 = 1, 7 do
		local var3_3 = arg0_3.subAwards[iter0_3]
		local var4_3 = var0_3:getConfig("config_client")[1]
		local var5_3 = {
			type = var4_3[1],
			id = var4_3[2],
			count = var4_3[3]
		}

		onButton(arg0_3, var3_3, function()
			arg0_3:emit(BaseUI.ON_DROP, var5_3)
		end, SFX_PANEL)
	end

	onButton(arg0_3, arg0_3.tip, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.goldship_help_tip.tip
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.btn, function()
		arg0_3:emit(ActivityMediator.GO_DODGEM)
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_8)
	local var0_8 = arg0_8.activity
	local var1_8 = pg.TimeMgr.GetInstance()
	local var2_8 = var1_8:DiffDay(var0_8.data1, var1_8:GetServerTime()) + 1

	setActive(findTF(arg0_8.mainAward, "get"), var0_8.data4 > 0)

	for iter0_8 = 1, 7 do
		local var3_8 = arg0_8.subAwards[iter0_8]

		setActive(findTF(var3_8, "get"), iter0_8 <= var0_8.data2)
		setActive(findTF(var3_8, "lock"), var2_8 < iter0_8)
	end

	setText(arg0_8.step, var0_8.data2)
	setText(arg0_8.score, var0_8.data1_list[1])
end

return var0_0
