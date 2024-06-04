local var0 = class("SculptureAwardInfoPage", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "SculptureAwardInfoUI"
end

function var0.OnLoaded(arg0)
	arg0.uilist = UIItemList.New(arg0:findTF("frame/scrollrect/content"), arg0:findTF("frame/scrollrect/content/tpl"))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
end

function var0.Show(arg0, arg1)
	var0.super.Show(arg0)

	arg0.activity = arg1

	arg0:UpdateList()
	setText(arg0:findTF("frame/tip"), i18n("sculpture_close_tip"))
end

function var0.UpdateList(arg0)
	local var0 = arg0.activity:getConfig("config_data")

	arg0.uilist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:UpdateCard(var0[arg1 + 1], arg2)
		end
	end)
	arg0.uilist:align(#var0)
end

function var0.UpdateCard(arg0, arg1, arg2)
	local var0 = arg0.activity:GetAwards(arg1)
	local var1 = arg0.activity:GetResorceName(arg1)
	local var2 = arg2:Find("icon/mask/image"):GetComponent(typeof(Image))

	LoadSpriteAtlasAsync("SculptureRole/" .. var1 .. "_normal", nil, function(arg0)
		if arg0.exited then
			return
		end

		var2.sprite = arg0

		var2:SetNativeSize()
	end)
	setText(arg2:Find("Text"), HXSet.hxLan(arg0.activity:GetAwardDesc(arg1)))

	local var3 = UIItemList.New(arg2:Find("awards"), arg2:Find("awards/tpl"))

	var3:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var0[arg1 + 1]
			local var1 = {
				type = var0[1],
				id = var0[2],
				count = var0[3]
			}

			updateDrop(arg2, var1)
			onButton(arg0, arg2, function()
				arg0:emit(BaseUI.ON_DROP, var1)
			end, SFX_PANEL)
		end
	end)
	var3:align(#var0)
	setActive(arg2:Find("mask"), arg0.activity:GetSculptureState(arg1) == SculptureActivity.STATE_FINSIH)
end

function var0.OnDestroy(arg0)
	return
end

return var0
