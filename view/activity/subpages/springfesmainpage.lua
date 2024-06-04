local var0 = class("SpringFesMainPage", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.go1 = arg0:findTF("1", arg0.bg)
	arg0.go2 = arg0:findTF("2", arg0.bg)
	arg0.go3 = arg0:findTF("3", arg0.bg)
	arg0.go4 = arg0:findTF("4", arg0.bg)
end

function var0.OnFirstFlush(arg0)
	onButton(arg0, arg0.go1, function()
		arg0:emit(ActivityMediator.SELECT_ACTIVITY, 470)
	end)
	onButton(arg0, arg0.go2, function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.COLORING)
	end)
	onButton(arg0, arg0.go3, function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.CHARGE, {
			wrap = 4
		})
	end)
	onButton(arg0, arg0.go4, function()
		arg0:emit(ActivityMediator.SELECT_ACTIVITY, 473)
	end)
end

return var0
