local var0 = class("SecondAnniversaryPage", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.btnShop = arg0:findTF("BtnShop")
	arg0.btnContainer = arg0:findTF("BtnList/Viewport/Content")
	arg0.btn1 = arg0:findTF("1", arg0.btnContainer)
	arg0.btn2 = arg0:findTF("2", arg0.btnContainer)
	arg0.btn3 = arg0:findTF("3", arg0.btnContainer)
	arg0.btn4 = arg0:findTF("4", arg0.btnContainer)
	arg0.btn5 = arg0:findTF("5", arg0.btnContainer)
	arg0.btn6 = arg0:findTF("6", arg0.btnContainer)
	arg0.btn7 = arg0:findTF("7", arg0.btnContainer)
	arg0.btn8 = arg0:findTF("8", arg0.btnContainer)
	arg0.btn9 = arg0:findTF("9", arg0.btnContainer)
	arg0.btnList1 = {
		arg0.btn1,
		arg0.btn2,
		arg0.btn3,
		arg0.btn4,
		arg0.btn5,
		arg0.btn6,
		arg0.btn7,
		arg0.btn8,
		arg0.btn9
	}
	arg0.btn11 = arg0:findTF("11", arg0.btnContainer)
	arg0.btn12 = arg0:findTF("12", arg0.btnContainer)
	arg0.btn13 = arg0:findTF("13", arg0.btnContainer)
	arg0.btn14 = arg0:findTF("14", arg0.btnContainer)
	arg0.btn15 = arg0:findTF("15", arg0.btnContainer)
	arg0.btn16 = arg0:findTF("16", arg0.btnContainer)
	arg0.btn17 = arg0:findTF("17", arg0.btnContainer)
	arg0.btn18 = arg0:findTF("18", arg0.btnContainer)
	arg0.btn19 = arg0:findTF("19", arg0.btnContainer)
	arg0.btnList2 = {
		arg0.btn11,
		arg0.btn12,
		arg0.btn13,
		arg0.btn14,
		arg0.btn15,
		arg0.btn16,
		arg0.btn17,
		arg0.btn18,
		arg0.btn19
	}
end

function var0.OnFirstFlush(arg0)
	onButton(arg0, arg0.btnShop, function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SKINSHOP)
	end, SFX_PANEL)
	arg0:initBtn(arg0.btnList1)
	arg0:initBtn(arg0.btnList2)
end

function var0.initBtn(arg0, arg1)
	onButton(arg0, arg1[1], function()
		arg0:emit(ActivityMediator.GO_PRAY_POOL)
	end, SFX_PANEL)
	onButton(arg0, arg1[2], function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SUMMARY)
	end, SFX_PANEL)
	onButton(arg0, arg1[3], function()
		arg0:emit(ActivityMediator.SELECT_ACTIVITY, ActivityConst.ACTIVITY_TYPE_RETURN_AWARD_ID)
	end, SFX_PANEL)
	onButton(arg0, arg1[4], function()
		arg0:emit(ActivityMediator.SELECT_ACTIVITY, ActivityConst.XIMU_LOGIN_ID)
	end, SFX_PANEL)
	onButton(arg0, arg1[5], function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.CHARGE, {
			wrap = ChargeScene.TYPE_DIAMOND
		})
	end, SFX_PANEL)
	onButton(arg0, arg1[6], function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT, {
			projectName = "light"
		})
	end, SFX_PANEL)
	onButton(arg0, arg1[7], function()
		arg0:emit(ActivityMediator.SELECT_ACTIVITY, ActivityConst.SANDIEGO_PT_ID)
	end, SFX_PANEL)
	onButton(arg0, arg1[8], function()
		arg0:emit(ActivityMediator.SELECT_ACTIVITY, ActivityConst.SKIN_U73)
	end, SFX_PANEL)
	onButton(arg0, arg1[9], function()
		pg.TipsMgr.GetInstance():ShowTips("即将开放，敬请期待！")
	end, SFX_PANEL)
end

return var0
