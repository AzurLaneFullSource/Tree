local var0 = class("HoloLivePage", import("view.base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.listbtn = arg0:findTF("list", arg0.bg)
	arg0.btnFubuki = arg0:findTF("1", arg0.listbtn)
	arg0.btnBattle = arg0:findTF("2", arg0.listbtn)
	arg0.btnSora = arg0:findTF("3", arg0.listbtn)
	arg0.btnShion = arg0:findTF("4", arg0.listbtn)
	arg0.btnMio = arg0:findTF("5", arg0.listbtn)
	arg0.btnAqua = arg0:findTF("6", arg0.listbtn)
	arg0.btnAyame = arg0:findTF("7", arg0.listbtn)
	arg0.btnMatsuri = arg0:findTF("8", arg0.listbtn)
end

function var0.OnFirstFlush(arg0)
	onButton(arg0, arg0.btnFubuki, function()
		arg0:emit(ActivityMediator.BATTLE_OPERA)
	end)
	onButton(arg0, arg0.btnBattle, function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT, {
			projectName = "new",
			page = 1
		})
	end)
	onButton(arg0, arg0.btnSora, function()
		arg0:emit(ActivityMediator.SELECT_ACTIVITY, ActivityConst.HOLOLIVE_MORNING_ID)
	end)
	onButton(arg0, arg0.btnShion, function()
		arg0:emit(ActivityMediator.SELECT_ACTIVITY, ActivityConst.HOLOLIVE_PT_ID)
	end)
	onButton(arg0, arg0.btnMio, function()
		arg0:emit(ActivityMediator.SELECT_ACTIVITY, ActivityConst.HOLOLIVE_MIO_ID)
	end)
	onButton(arg0, arg0.btnAqua, function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.HOLOLIVE_LINKLINK_SELECT_SCENE)
	end)
	onButton(arg0, arg0.btnAyame, function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.HOLOLIVE_MEDAL)
	end)
	onButton(arg0, arg0.btnMatsuri, function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SHOP, {
			warp = NewShopsScene.TYPE_ACTIVITY
		})
	end)
end

return var0
