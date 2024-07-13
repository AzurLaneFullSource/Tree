local var0_0 = class("SculptureAwardInfoPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "SculptureAwardInfoUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.uilist = UIItemList.New(arg0_2:findTF("frame/scrollrect/content"), arg0_2:findTF("frame/scrollrect/content/tpl"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_5, arg1_5)
	var0_0.super.Show(arg0_5)

	arg0_5.activity = arg1_5

	arg0_5:UpdateList()
	setText(arg0_5:findTF("frame/tip"), i18n("sculpture_close_tip"))
end

function var0_0.UpdateList(arg0_6)
	local var0_6 = arg0_6.activity:getConfig("config_data")

	arg0_6.uilist:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventUpdate then
			arg0_6:UpdateCard(var0_6[arg1_7 + 1], arg2_7)
		end
	end)
	arg0_6.uilist:align(#var0_6)
end

function var0_0.UpdateCard(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg0_8.activity:GetAwards(arg1_8)
	local var1_8 = arg0_8.activity:GetResorceName(arg1_8)
	local var2_8 = arg2_8:Find("icon/mask/image"):GetComponent(typeof(Image))

	LoadSpriteAtlasAsync("SculptureRole/" .. var1_8 .. "_normal", nil, function(arg0_9)
		if arg0_8.exited then
			return
		end

		var2_8.sprite = arg0_9

		var2_8:SetNativeSize()
	end)
	setText(arg2_8:Find("Text"), HXSet.hxLan(arg0_8.activity:GetAwardDesc(arg1_8)))

	local var3_8 = UIItemList.New(arg2_8:Find("awards"), arg2_8:Find("awards/tpl"))

	var3_8:make(function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventUpdate then
			local var0_10 = var0_8[arg1_10 + 1]
			local var1_10 = {
				type = var0_10[1],
				id = var0_10[2],
				count = var0_10[3]
			}

			updateDrop(arg2_10, var1_10)
			onButton(arg0_8, arg2_10, function()
				arg0_8:emit(BaseUI.ON_DROP, var1_10)
			end, SFX_PANEL)
		end
	end)
	var3_8:align(#var0_8)
	setActive(arg2_8:Find("mask"), arg0_8.activity:GetSculptureState(arg1_8) == SculptureActivity.STATE_FINSIH)
end

function var0_0.OnDestroy(arg0_12)
	return
end

return var0_0
