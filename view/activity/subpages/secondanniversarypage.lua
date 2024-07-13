local var0_0 = class("SecondAnniversaryPage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.btnShop = arg0_1:findTF("BtnShop")
	arg0_1.btnContainer = arg0_1:findTF("BtnList/Viewport/Content")
	arg0_1.btn1 = arg0_1:findTF("1", arg0_1.btnContainer)
	arg0_1.btn2 = arg0_1:findTF("2", arg0_1.btnContainer)
	arg0_1.btn3 = arg0_1:findTF("3", arg0_1.btnContainer)
	arg0_1.btn4 = arg0_1:findTF("4", arg0_1.btnContainer)
	arg0_1.btn5 = arg0_1:findTF("5", arg0_1.btnContainer)
	arg0_1.btn6 = arg0_1:findTF("6", arg0_1.btnContainer)
	arg0_1.btn7 = arg0_1:findTF("7", arg0_1.btnContainer)
	arg0_1.btn8 = arg0_1:findTF("8", arg0_1.btnContainer)
	arg0_1.btn9 = arg0_1:findTF("9", arg0_1.btnContainer)
	arg0_1.btnList1 = {
		arg0_1.btn1,
		arg0_1.btn2,
		arg0_1.btn3,
		arg0_1.btn4,
		arg0_1.btn5,
		arg0_1.btn6,
		arg0_1.btn7,
		arg0_1.btn8,
		arg0_1.btn9
	}
	arg0_1.btn11 = arg0_1:findTF("11", arg0_1.btnContainer)
	arg0_1.btn12 = arg0_1:findTF("12", arg0_1.btnContainer)
	arg0_1.btn13 = arg0_1:findTF("13", arg0_1.btnContainer)
	arg0_1.btn14 = arg0_1:findTF("14", arg0_1.btnContainer)
	arg0_1.btn15 = arg0_1:findTF("15", arg0_1.btnContainer)
	arg0_1.btn16 = arg0_1:findTF("16", arg0_1.btnContainer)
	arg0_1.btn17 = arg0_1:findTF("17", arg0_1.btnContainer)
	arg0_1.btn18 = arg0_1:findTF("18", arg0_1.btnContainer)
	arg0_1.btn19 = arg0_1:findTF("19", arg0_1.btnContainer)
	arg0_1.btnList2 = {
		arg0_1.btn11,
		arg0_1.btn12,
		arg0_1.btn13,
		arg0_1.btn14,
		arg0_1.btn15,
		arg0_1.btn16,
		arg0_1.btn17,
		arg0_1.btn18,
		arg0_1.btn19
	}
end

function var0_0.OnFirstFlush(arg0_2)
	onButton(arg0_2, arg0_2.btnShop, function()
		arg0_2:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SKINSHOP)
	end, SFX_PANEL)
	arg0_2:initBtn(arg0_2.btnList1)
	arg0_2:initBtn(arg0_2.btnList2)
end

function var0_0.initBtn(arg0_4, arg1_4)
	onButton(arg0_4, arg1_4[1], function()
		arg0_4:emit(ActivityMediator.GO_PRAY_POOL)
	end, SFX_PANEL)
	onButton(arg0_4, arg1_4[2], function()
		arg0_4:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SUMMARY)
	end, SFX_PANEL)
	onButton(arg0_4, arg1_4[3], function()
		arg0_4:emit(ActivityMediator.SELECT_ACTIVITY, ActivityConst.ACTIVITY_TYPE_RETURN_AWARD_ID)
	end, SFX_PANEL)
	onButton(arg0_4, arg1_4[4], function()
		arg0_4:emit(ActivityMediator.SELECT_ACTIVITY, ActivityConst.XIMU_LOGIN_ID)
	end, SFX_PANEL)
	onButton(arg0_4, arg1_4[5], function()
		arg0_4:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.CHARGE, {
			wrap = ChargeScene.TYPE_DIAMOND
		})
	end, SFX_PANEL)
	onButton(arg0_4, arg1_4[6], function()
		arg0_4:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT, {
			projectName = "light"
		})
	end, SFX_PANEL)
	onButton(arg0_4, arg1_4[7], function()
		arg0_4:emit(ActivityMediator.SELECT_ACTIVITY, ActivityConst.SANDIEGO_PT_ID)
	end, SFX_PANEL)
	onButton(arg0_4, arg1_4[8], function()
		arg0_4:emit(ActivityMediator.SELECT_ACTIVITY, ActivityConst.SKIN_U73)
	end, SFX_PANEL)
	onButton(arg0_4, arg1_4[9], function()
		pg.TipsMgr.GetInstance():ShowTips("即将开放，敬请期待！")
	end, SFX_PANEL)
end

return var0_0
