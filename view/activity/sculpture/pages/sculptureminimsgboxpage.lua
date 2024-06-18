local var0_0 = class("SculptureMiniMsgBoxPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "SculptureMiniMsgBoxUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.contentTxt = arg0_2:findTF("frame/Text"):GetComponent(typeof(Text))
	arg0_2.confirmBtn = arg0_2:findTF("frame/btns/btn_confrim")
	arg0_2.btnImg = arg0_2.confirmBtn:GetComponent(typeof(Image))
	arg0_2.cancelBtn = arg0_2:findTF("frame/btns/btn_cancel")
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		arg0_3:Hide()

		if arg0_3.settings.onYes then
			arg0_3.settings.onYes()
		end
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf, function()
		if arg0_3.settings.model then
			return
		end

		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.cancelBtn, function()
		if arg0_3.settings.model then
			return
		end

		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_7, arg1_7)
	var0_0.super.Show(arg0_7)

	arg0_7.settings = arg1_7
	arg0_7.contentTxt.text = HXSet.hxLan(arg1_7.content)

	SetParent(arg0_7._tf, pg.UIMgr.GetInstance().OverlayMain)

	local var0_7 = arg1_7.yes_text or "btn_confrim"
	local var1_7 = GetSpriteFromAtlas("ui/SculptureUI_atlas", var0_7)

	arg0_7.btnImg.sprite = var1_7

	if arg1_7.effect then
		arg0_7:LoadEffect()
	end

	setActive(arg0_7.cancelBtn, arg1_7.showNo)
end

function var0_0.Hide(arg0_8)
	var0_0.super.Hide(arg0_8)

	if arg0_8.effectGo then
		Object.Destroy(arg0_8.effectGo)

		arg0_8.effectGo = nil
	end
end

function var0_0.LoadEffect(arg0_9)
	local var0_9 = "liwucaijian_caidai"

	if not arg0_9.effectGo then
		ResourceMgr.Inst:getAssetAsync("ui/" .. var0_9, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_10)
			if arg0_9.exited then
				return
			end

			arg0_9.effectGo = Object.Instantiate(arg0_10, arg0_9._tf)
			arg0_9.effectGo.name = var0_9
		end), true, true)
	else
		setActive(arg0_9.effectGo, false)
		setActive(arg0_9.effectGo, true)
	end
end

function var0_0.OnDestroy(arg0_11)
	if arg0_11:isShowing() then
		arg0_11:Hide()
	end
end

return var0_0
