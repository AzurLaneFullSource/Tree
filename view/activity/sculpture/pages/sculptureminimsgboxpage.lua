local var0 = class("SculptureMiniMsgBoxPage", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "SculptureMiniMsgBoxUI"
end

function var0.OnLoaded(arg0)
	arg0.contentTxt = arg0:findTF("frame/Text"):GetComponent(typeof(Text))
	arg0.confirmBtn = arg0:findTF("frame/btns/btn_confrim")
	arg0.btnImg = arg0.confirmBtn:GetComponent(typeof(Image))
	arg0.cancelBtn = arg0:findTF("frame/btns/btn_cancel")
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.confirmBtn, function()
		arg0:Hide()

		if arg0.settings.onYes then
			arg0.settings.onYes()
		end
	end, SFX_PANEL)
	onButton(arg0, arg0._tf, function()
		if arg0.settings.model then
			return
		end

		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.cancelBtn, function()
		if arg0.settings.model then
			return
		end

		arg0:Hide()
	end, SFX_PANEL)
end

function var0.Show(arg0, arg1)
	var0.super.Show(arg0)

	arg0.settings = arg1
	arg0.contentTxt.text = HXSet.hxLan(arg1.content)

	SetParent(arg0._tf, pg.UIMgr.GetInstance().OverlayMain)

	local var0 = arg1.yes_text or "btn_confrim"
	local var1 = GetSpriteFromAtlas("ui/SculptureUI_atlas", var0)

	arg0.btnImg.sprite = var1

	if arg1.effect then
		arg0:LoadEffect()
	end

	setActive(arg0.cancelBtn, arg1.showNo)
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)

	if arg0.effectGo then
		Object.Destroy(arg0.effectGo)

		arg0.effectGo = nil
	end
end

function var0.LoadEffect(arg0)
	local var0 = "liwucaijian_caidai"

	if not arg0.effectGo then
		ResourceMgr.Inst:getAssetAsync("ui/" .. var0, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
			if arg0.exited then
				return
			end

			arg0.effectGo = Object.Instantiate(arg0, arg0._tf)
			arg0.effectGo.name = var0
		end), true, true)
	else
		setActive(arg0.effectGo, false)
		setActive(arg0.effectGo, true)
	end
end

function var0.OnDestroy(arg0)
	if arg0:isShowing() then
		arg0:Hide()
	end
end

return var0
