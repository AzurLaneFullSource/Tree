local var0_0 = class("SVRealmPanel", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "SVRealmPanel"
end

function var0_0.OnLoaded(arg0_2)
	return
end

function var0_0.OnInit(arg0_3)
	local var0_3 = arg0_3._tf:Find("panel")

	arg0_3.btnBLHX = var0_3:Find("blhx")
	arg0_3.btnCSZZ = var0_3:Find("cszz")

	setActive(arg0_3.btnBLHX, true)
	setActive(arg0_3.btnCSZZ, true)
	onButton(arg0_3, arg0_3.btnBLHX, function()
		arg0_3:PlayAnim(arg0_3.btnBLHX, function()
			arg0_3:Hide()
			arg0_3.onConfirm(1)
		end)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.btnCSZZ, function()
		arg0_3:PlayAnim(arg0_3.btnCSZZ, function()
			arg0_3:Hide()
			arg0_3.onConfirm(2)
		end)
	end)
end

function var0_0.OnDestroy(arg0_8)
	return
end

function var0_0.Show(arg0_9)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_9._tf)
	setActive(arg0_9._tf, true)
end

function var0_0.Hide(arg0_10)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_10._tf, arg0_10._parentTf)
	setActive(arg0_10._tf, false)
end

function var0_0.Setup(arg0_11, arg1_11)
	arg0_11.onConfirm = arg1_11
end

function var0_0.PlayAnim(arg0_12, arg1_12, arg2_12)
	local var0_12 = arg1_12:Find("bg")

	setActive(var0_12, true)
	LeanTween.value(go(var0_12), 1, 1.2, 0.2):setOnUpdate(System.Action_float(function(arg0_13)
		var0_12.localScale = Vector3(arg0_13, arg0_13, 1)
	end)):setOnComplete(System.Action(function()
		setActive(var0_12, false)

		var0_12.localScale = Vector3(1, 1, 1)

		arg2_12()
	end))
	LeanTween.value(go(var0_12), 1, 0.7, 0.2)
end

return var0_0
