local var0_0 = class("IslandDrawAwardAllWindow", import("Mod.Island.View.page.msgbox.window.IslandBaseMsgboxWindow"))

function var0_0.getUIName(arg0_1)
	return "IslandDrawAwardAllMsgBox"
end

function var0_0.OnLoaded(arg0_2)
	local var0_2 = arg0_2._tf:GetComponent(typeof(ItemList)).prefabItem:ToTable()

	for iter0_2, iter1_2 in ipairs({
		"rtTitle",
		"btnClose",
		"rtRarities"
	}) do
		arg0_2[iter1_2] = var0_2[iter0_2].transform
	end
end

function var0_0.OnInit(arg0_3)
	setText(arg0_3.rtTitle, i18n("island_draw_reward"))
	onButton(arg0_3, arg0_3.btnClose, function()
		arg0_3:Hide()
	end, SFX_CANCEL)
end

function var0_0.OnShow(arg0_5)
	var0_0.super.OnShow(arg0_5)
	arg0_5:UpdateActivity(arg0_5.settings.activity)
end

function var0_0.UpdateActivity(arg0_6, arg1_6)
	arg0_6.activity = arg1_6

	eachChild(arg0_6.rtRarities, function(arg0_7, arg1_7)
		local var0_7 = arg0_7.name
		local var1_7 = arg0_6.activity:GetRankList(var0_7)

		setText(arg0_7:Find("title/Text"), i18n("island_draw_" .. var0_7))
		UIItemList.StaticAlign(arg0_7:Find("container"), arg0_7:Find("container/tpl"), #var1_7, function(arg0_8, arg1_8, arg2_8)
			arg1_8 = arg1_8 + 1

			if arg0_8 == UIItemList.EventUpdate then
				local var0_8, var1_8 = unpack(var1_7[arg1_8])
				local var2_8 = pg.island_draw_reward[var0_8]
				local var3_8 = Drop.New({
					type = var2_8.drop_type,
					id = var2_8.drop_id
				})

				IslandShopDrawAwardPage.ShowDropInfo(var3_8, arg2_8:Find("mask/Image"))
				setText(arg2_8:Find("name/Text"), var3_8:getName())
				onNextTick(function()
					changeToScrollText(arg2_8:Find("name/Text"), var3_8:getName())
				end)
				setText(arg2_8:Find("got/got/Text"), i18n("island_draw_get"))
				setActive(arg2_8:Find("got"), not var1_8)
			end
		end)
	end)
end

return var0_0
