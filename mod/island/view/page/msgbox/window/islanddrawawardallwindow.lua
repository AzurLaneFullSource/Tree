local var0_0 = class("IslandDrawAwardAllWindow", import("Mod.Island.View.page.msgbox.window.IslandBaseMsgboxWindow"))

function var0_0.getUIName(arg0_1)
	return "IslandDrawAwardAllMsgBox"
end

function var0_0.OnInit(arg0_2)
	setText(arg0_2.rtTitle, i18n("island_draw_reward"))
	onButton(arg0_2, arg0_2.btnClose, function()
		arg0_2:Hide()
	end, SFX_CANCEL)
end

function var0_0.OnShow(arg0_4)
	var0_0.super.OnShow(arg0_4)
	arg0_4:UpdateActivity(arg0_4.settings.activity)
end

function var0_0.UpdateActivity(arg0_5, arg1_5)
	arg0_5.activity = arg1_5

	eachChild(arg0_5.rtRarities, function(arg0_6, arg1_6)
		local var0_6 = arg0_6.name
		local var1_6 = arg0_5.activity:GetRankList(var0_6)

		setText(arg0_6:Find("title/Text"), i18n("island_draw_" .. var0_6))
		UIItemList.StaticAlign(arg0_6:Find("container"), arg0_6:Find("container/tpl"), #var1_6, function(arg0_7, arg1_7, arg2_7)
			arg1_7 = arg1_7 + 1

			if arg0_7 == UIItemList.EventUpdate then
				local var0_7, var1_7 = unpack(var1_6[arg1_7])
				local var2_7 = pg.island_draw_reward[var0_7]
				local var3_7 = Drop.New({
					type = var2_7.drop_type,
					id = var2_7.drop_id
				})

				IslandShopDrawAwardPage.ShowDropInfo(var3_7, arg2_7:Find("mask/Image"))
				setScrollText(arg2_7:Find("name/Text"), var3_7:getName())
				setText(arg2_7:Find("got/got/Text"), i18n("island_draw_get"))
				setActive(arg2_7:Find("got"), not var1_7)
			end
		end)
	end)
end

return var0_0
