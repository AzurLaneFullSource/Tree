local var0 = class("AnniversaryPage", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.btnShop = arg0:findTF("BtnShop")
	arg0.charListTF = arg0:findTF("list")
	arg0.charTF = arg0:findTF("Image", arg0.charListTF)

	arg0:scrollAnim()
end

function var0.OnFirstFlush(arg0)
	onButton(arg0, arg0.btnShop, function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SKINSHOP)
	end, SFX_PANEL)
end

function var0.scrollAnim(arg0)
	arg0._tf:GetComponent(typeof(DftAniEvent)):SetTriggerEvent(function(arg0)
		arg0.charListTF:GetChild(0):SetAsLastSibling()

		local var0 = 0

		eachChild(arg0.charListTF, function(arg0)
			setActive(arg0.charListTF:GetChild(var0), var0 ~= 6)

			var0 = var0 + 1
		end)
		arg0.charTF:SetSiblingIndex(6)
	end)
end

function var0.OnDestroy(arg0)
	return
end

return var0
