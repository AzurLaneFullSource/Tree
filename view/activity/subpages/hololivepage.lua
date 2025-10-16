local var0_0 = class("HoloLivePage", import("view.base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1._tf:Find("AD")
	arg0_1.listbtn = arg0_1.bg:Find("list")
	arg0_1.btnFubuki = arg0_1.listbtn:Find("1")
	arg0_1.btnBattle = arg0_1.listbtn:Find("2")
	arg0_1.btnSora = arg0_1.listbtn:Find("3")
	arg0_1.btnShion = arg0_1.listbtn:Find("4")
	arg0_1.btnMio = arg0_1.listbtn:Find("5")
	arg0_1.btnAqua = arg0_1.listbtn:Find("6")
	arg0_1.btnAyame = arg0_1.listbtn:Find("7")
	arg0_1.btnMatsuri = arg0_1.listbtn:Find("8")
end

function var0_0.OnFirstFlush(arg0_2)
	onButton(arg0_2, arg0_2.btnFubuki, function()
		arg0_2:emit(ActivityMediator.BATTLE_OPERA)
	end)
	onButton(arg0_2, arg0_2.btnBattle, function()
		arg0_2:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT, {
			projectName = "new",
			page = 1
		})
	end)
	onButton(arg0_2, arg0_2.btnSora, function()
		arg0_2:emit(ActivityMediator.SELECT_ACTIVITY, ActivityConst.HOLOLIVE_MORNING_ID)
	end)
	onButton(arg0_2, arg0_2.btnShion, function()
		arg0_2:emit(ActivityMediator.SELECT_ACTIVITY, ActivityConst.HOLOLIVE_PT_ID)
	end)
	onButton(arg0_2, arg0_2.btnMio, function()
		arg0_2:emit(ActivityMediator.SELECT_ACTIVITY, ActivityConst.HOLOLIVE_MIO_ID)
	end)
	onButton(arg0_2, arg0_2.btnAqua, function()
		arg0_2:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.HOLOLIVE_LINKLINK_SELECT_SCENE)
	end)
	onButton(arg0_2, arg0_2.btnAyame, function()
		arg0_2:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.HOLOLIVE_MEDAL)
	end)
	onButton(arg0_2, arg0_2.btnMatsuri, function()
		arg0_2:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SHOP, {
			warp = NewShopsScene.TYPE_ACTIVITY
		})
	end)
end

return var0_0
