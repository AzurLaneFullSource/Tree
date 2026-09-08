local var0_0 = class("ShadowCityCollectMsgBox", import("view.activity.CorePage.DOA.DOACoreActivityMsgBox"))

function var0_0.getUIName(arg0_1)
	return "ShadowCityCollectMsgBox"
end

function var0_0.OnInit(arg0_2)
	var0_0.super.OnInit(arg0_2)
	setText(arg0_2.window:Find("top/title"), i18n("island_get_way"))
end

function var0_0.Show(arg0_3, arg1_3)
	var0_0.super.super.Show(arg0_3)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf, {
		staticBlur = true
	})

	local var0_3 = Drop.New({
		type = arg1_3.drop_type,
		id = arg1_3.drop_id
	})

	updateDrop(arg0_3.iconTF, var0_3)
	UpdateOwnDisplay(arg0_3.ownTF, var0_3)

	local var1_3 = var0_3.cfg

	changeToScrollText(arg0_3.title, var1_3.name)
	setText(arg0_3.desc, var0_3.desc)
	setActive(arg0_3.owner, false)
	setActive(arg0_3.ownerLimit, true)
	setText(arg0_3.ownerLimit:Find("Text"), arg1_3.count .. "/" .. (arg1_3.count_limit or 0))

	local var2_3 = #arg1_3.skipable_list

	arg0_3:setWindowSize(var2_3 - 1)
	UIItemList.StaticAlign(arg0_3.list, arg0_3.tpl, var2_3, function(arg0_4, arg1_4, arg2_4)
		if arg0_4 == UIItemList.EventUpdate then
			local var0_4 = arg1_3.skipable_list[arg1_4 + 1]
			local var1_4 = var0_4[1]
			local var2_4 = var0_4[2]
			local var3_4 = var0_4[3]

			changeToScrollText(arg2_4:Find("mask/title"), var3_4)

			local var4_4 = arg2_4:Find("skip_btn")

			setText(var4_4:Find("text"), i18n("task_go"))
			onButton(arg0_3, var4_4, function()
				if var1_4 == var0_0.SKIP_TYPE_SCENE then
					pg.m02:sendNotification(GAME.GO_SCENE, var2_4[1], var2_4[2] or {})
				elseif var1_4 == var0_0.SKIP_TYPE_ACTIVITY then
					pg.m02:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY, {
						id = var2_4
					})
				end

				arg0_3:Hide()
			end, SFX_PANEL)
			Canvas.ForceUpdateCanvases()
		end
	end)
end

function var0_0.setWindowSize(arg0_6, arg1_6)
	setSizeDelta(arg0_6.window:Find("bg"), Vector2(769, 440 + 50 * arg1_6))
end

return var0_0
