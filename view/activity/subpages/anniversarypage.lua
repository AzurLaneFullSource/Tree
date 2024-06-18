local var0_0 = class("AnniversaryPage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.btnShop = arg0_1:findTF("BtnShop")
	arg0_1.charListTF = arg0_1:findTF("list")
	arg0_1.charTF = arg0_1:findTF("Image", arg0_1.charListTF)

	arg0_1:scrollAnim()
end

function var0_0.OnFirstFlush(arg0_2)
	onButton(arg0_2, arg0_2.btnShop, function()
		arg0_2:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SKINSHOP)
	end, SFX_PANEL)
end

function var0_0.scrollAnim(arg0_4)
	arg0_4._tf:GetComponent(typeof(DftAniEvent)):SetTriggerEvent(function(arg0_5)
		arg0_4.charListTF:GetChild(0):SetAsLastSibling()

		local var0_5 = 0

		eachChild(arg0_4.charListTF, function(arg0_6)
			setActive(arg0_4.charListTF:GetChild(var0_5), var0_5 ~= 6)

			var0_5 = var0_5 + 1
		end)
		arg0_4.charTF:SetSiblingIndex(6)
	end)
end

function var0_0.OnDestroy(arg0_7)
	return
end

return var0_0
