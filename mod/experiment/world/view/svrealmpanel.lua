local var0 = class("SVRealmPanel", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "SVRealmPanel"
end

function var0.OnLoaded(arg0)
	return
end

function var0.OnInit(arg0)
	local var0 = arg0._tf:Find("panel")

	arg0.btnBLHX = var0:Find("blhx")
	arg0.btnCSZZ = var0:Find("cszz")

	setActive(arg0.btnBLHX, true)
	setActive(arg0.btnCSZZ, true)
	onButton(arg0, arg0.btnBLHX, function()
		arg0:PlayAnim(arg0.btnBLHX, function()
			arg0:Hide()
			arg0.onConfirm(1)
		end)
	end, SFX_PANEL)
	onButton(arg0, arg0.btnCSZZ, function()
		arg0:PlayAnim(arg0.btnCSZZ, function()
			arg0:Hide()
			arg0.onConfirm(2)
		end)
	end)
end

function var0.OnDestroy(arg0)
	return
end

function var0.Show(arg0)
	pg.UIMgr.GetInstance():OverlayPanel(arg0._tf)
	setActive(arg0._tf, true)
end

function var0.Hide(arg0)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf, arg0._parentTf)
	setActive(arg0._tf, false)
end

function var0.Setup(arg0, arg1)
	arg0.onConfirm = arg1
end

function var0.PlayAnim(arg0, arg1, arg2)
	local var0 = arg1:Find("bg")

	setActive(var0, true)
	LeanTween.value(go(var0), 1, 1.2, 0.2):setOnUpdate(System.Action_float(function(arg0)
		var0.localScale = Vector3(arg0, arg0, 1)
	end)):setOnComplete(System.Action(function()
		setActive(var0, false)

		var0.localScale = Vector3(1, 1, 1)

		arg2()
	end))
	LeanTween.value(go(var0), 1, 0.7, 0.2)
end

return var0
