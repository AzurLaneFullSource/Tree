local var0 = class("Msgbox4LinkCollectGuide", import(".MsgboxSubPanel"))

var0.SHOW_TYPE_NORMAL = 1
var0.SHOW_TYPE_LIMIT = 2
var0.SKIP_TYPE_SCENE = 2
var0.SKIP_TYPE_ACTIVITY = 3

function var0.getUIName(arg0)
	return "Msgbox4LinkCollectGuide"
end

function var0.OnInit(arg0)
	arg0.title = arg0:findTF("name_mask/name")
	arg0.owner = arg0:findTF("owner")

	setText(arg0:findTF("title", arg0.owner), i18n("collect_page_got"))

	arg0.ownerLimit = arg0:findTF("owner_limit")

	setText(arg0:findTF("title", arg0.ownerLimit), i18n("collect_page_got"))

	arg0.iconTF = arg0:findTF("left/IconTpl")
	arg0.ownTF = arg0:findTF("left/own")
	arg0.detailTF = arg0:findTF("left/detail")
	arg0.desc = arg0:findTF("content/desc")
	arg0.list = arg0:findTF("content/skipable_list")
	arg0.tpl = arg0:findTF("tpl", arg0.list)
end

function var0.OnRefresh(arg0, arg1)
	arg0:SetWindowSize(Vector2(930, 540))
	setActive(arg0.viewParent._btnContainer, false)

	local var0 = Drop.New({
		type = arg1.drop_type,
		id = arg1.drop_id
	})

	updateDrop(arg0.iconTF, var0)
	UpdateOwnDisplay(arg0.ownTF, var0)
	RegisterDetailButton(arg0.viewParent, arg0.detailTF, var0)

	local var1 = var0.cfg

	changeToScrollText(arg0.title, var1.name)
	setText(arg0.desc, var0.desc)

	if arg1.show_type == var0.SHOW_TYPE_NORMAL then
		setActive(arg0.owner, true)
		setActive(arg0.ownerLimit, false)
		setText(arg0:findTF("Text", arg0.owner), arg1.count)
	elseif arg1.show_type == var0.SHOW_TYPE_LIMIT then
		setActive(arg0.owner, false)
		setActive(arg0.ownerLimit, true)
		setText(arg0:findTF("Text", arg0.ownerLimit), arg1.count .. "/" .. (arg1.count_limit or 0))
	end

	UIItemList.StaticAlign(arg0.list, arg0.tpl, #arg1.skipable_list, function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1.skipable_list[arg1 + 1]
			local var1 = var0[1]
			local var2 = var0[2]
			local var3 = var0[3]

			changeToScrollText(arg0:findTF("mask/title", arg2), var3)

			local var4 = arg0:findTF("skip_btn", arg2)

			onButton(arg0, var4, function()
				if var1 == var0.SKIP_TYPE_SCENE then
					pg.m02:sendNotification(GAME.GO_SCENE, var2[1], var2[2] or {})
				elseif var1 == var0.SKIP_TYPE_ACTIVITY then
					pg.m02:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY, {
						id = var2
					})
				end

				arg0.viewParent:hide()
			end, SFX_PANEL)
			Canvas.ForceUpdateCanvases()
		end
	end)
end

return var0
