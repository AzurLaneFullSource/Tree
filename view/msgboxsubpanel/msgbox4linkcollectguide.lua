local var0_0 = class("Msgbox4LinkCollectGuide", import(".MsgboxSubPanel"))

var0_0.SHOW_TYPE_NORMAL = 1
var0_0.SHOW_TYPE_LIMIT = 2
var0_0.SKIP_TYPE_SCENE = 2
var0_0.SKIP_TYPE_ACTIVITY = 3

function var0_0.getUIName(arg0_1)
	return "Msgbox4LinkCollectGuide"
end

function var0_0.OnInit(arg0_2)
	arg0_2.title = arg0_2:findTF("name_mask/name")
	arg0_2.owner = arg0_2:findTF("owner")

	setText(arg0_2:findTF("title", arg0_2.owner), i18n("collect_page_got"))

	arg0_2.ownerLimit = arg0_2:findTF("owner_limit")

	setText(arg0_2:findTF("title", arg0_2.ownerLimit), i18n("collect_page_got"))

	arg0_2.iconTF = arg0_2:findTF("left/IconTpl")
	arg0_2.ownTF = arg0_2:findTF("left/own")
	arg0_2.detailTF = arg0_2:findTF("left/detail")
	arg0_2.desc = arg0_2:findTF("content/desc")
	arg0_2.list = arg0_2:findTF("content/skipable_list")
	arg0_2.tpl = arg0_2:findTF("tpl", arg0_2.list)
end

function var0_0.OnRefresh(arg0_3, arg1_3)
	arg0_3:SetWindowSize(Vector2(930, 540))
	setActive(arg0_3.viewParent._btnContainer, false)

	local var0_3 = Drop.New({
		type = arg1_3.drop_type,
		id = arg1_3.drop_id
	})

	updateDrop(arg0_3.iconTF, var0_3)
	UpdateOwnDisplay(arg0_3.ownTF, var0_3)
	RegisterDetailButton(arg0_3.viewParent, arg0_3.detailTF, var0_3)

	local var1_3 = var0_3.cfg

	changeToScrollText(arg0_3.title, var1_3.name)
	setText(arg0_3.desc, var0_3.desc)

	if arg1_3.show_type == var0_0.SHOW_TYPE_NORMAL then
		setActive(arg0_3.owner, true)
		setActive(arg0_3.ownerLimit, false)
		setText(arg0_3:findTF("Text", arg0_3.owner), arg1_3.count)
	elseif arg1_3.show_type == var0_0.SHOW_TYPE_LIMIT then
		setActive(arg0_3.owner, false)
		setActive(arg0_3.ownerLimit, true)
		setText(arg0_3:findTF("Text", arg0_3.ownerLimit), arg1_3.count .. "/" .. (arg1_3.count_limit or 0))
	end

	UIItemList.StaticAlign(arg0_3.list, arg0_3.tpl, #arg1_3.skipable_list, function(arg0_4, arg1_4, arg2_4)
		if arg0_4 == UIItemList.EventUpdate then
			local var0_4 = arg1_3.skipable_list[arg1_4 + 1]
			local var1_4 = var0_4[1]
			local var2_4 = var0_4[2]
			local var3_4 = var0_4[3]

			changeToScrollText(arg0_3:findTF("mask/title", arg2_4), var3_4)

			local var4_4 = arg0_3:findTF("skip_btn", arg2_4)

			onButton(arg0_3, var4_4, function()
				if var1_4 == var0_0.SKIP_TYPE_SCENE then
					pg.m02:sendNotification(GAME.GO_SCENE, var2_4[1], var2_4[2] or {})
				elseif var1_4 == var0_0.SKIP_TYPE_ACTIVITY then
					pg.m02:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY, {
						id = var2_4
					})
				end

				arg0_3.viewParent:hide()
			end, SFX_PANEL)
			Canvas.ForceUpdateCanvases()
		end
	end)
end

return var0_0
