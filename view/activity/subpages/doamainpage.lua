local var0 = class("DoaMainPage", import(".TemplatePage.PreviewTemplatePage"))

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.charactorTf = arg0:findTF("charactor", arg0.bg)
end

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)
	onButton(arg0, arg0:findTF("btnMiniGame", arg0.bg), function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.DOALINK_ISLAND)
	end)
end

function var0.OnUpdateFlush(arg0)
	local var0 = math.random(1, 9)

	for iter0 = 1, 9 do
		setActive(findTF(arg0.charactorTf, "charactor" .. iter0), var0 == iter0)
	end
end

return var0
