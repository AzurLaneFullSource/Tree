local var0_0 = class("DOACoreActivityMsgBox", import("view.base.BaseSubView"))

var0_0.SKIP_TYPE_SCENE = 2
var0_0.SKIP_TYPE_ACTIVITY = 3

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
end

function var0_0.getUIName(arg0_2)
	return "DOACoreActivityMsgBox"
end

function var0_0.OnLoaded(arg0_3)
	arg0_3.bg = arg0_3._tf:Find("bg")
	arg0_3.btnClose = arg0_3._tf:Find("window/top/btnBack")

	onButton(arg0_3, arg0_3.btnClose, function()
		arg0_3:Hide()
	end, SOUND_BACK)
	onButton(arg0_3, arg0_3.bg, function()
		arg0_3:Hide()
	end, SOUND_BACK)
end

function var0_0.OnInit(arg0_6)
	arg0_6.window = arg0_6._tf:Find("window")
	arg0_6.page = arg0_6._tf:Find("window/page")
	arg0_6.title = arg0_6.page:Find("name_mask/name")
	arg0_6.owner = arg0_6.page:Find("owner")

	setText(arg0_6.owner:Find("title"), i18n("collect_page_got"))

	arg0_6.ownerLimit = arg0_6.page:Find("owner_limit")

	setText(arg0_6.ownerLimit:Find("title"), i18n("collect_page_got"))

	arg0_6.iconTF = arg0_6.page:Find("left/IconTpl")
	arg0_6.ownTF = arg0_6.page:Find("left/own")
	arg0_6.detailTF = arg0_6.page:Find("left/detail")
	arg0_6.desc = arg0_6.page:Find("content/desc")
	arg0_6.list = arg0_6.page:Find("content/skipable_list")
	arg0_6.tpl = arg0_6.list:Find("tpl")
end

function var0_0.Show(arg0_7, arg1_7)
	var0_0.super.Show(arg0_7)
	pg.UIMgr.GetInstance():BlurPanel(arg0_7._tf, {
		staticBlur = true
	})

	local var0_7 = Drop.New({
		type = arg1_7.drop_type,
		id = arg1_7.drop_id
	})

	updateDrop(arg0_7.iconTF, var0_7)
	UpdateOwnDisplay(arg0_7.ownTF, var0_7)

	local var1_7 = var0_7.cfg

	changeToScrollText(arg0_7.title, var1_7.name)
	setText(arg0_7.desc, var0_7.desc)
	setActive(arg0_7.owner, false)
	setActive(arg0_7.ownerLimit, true)
	setText(arg0_7.ownerLimit:Find("Text"), arg1_7.count .. "/" .. (arg1_7.count_limit or 0))

	local var2_7 = #arg1_7.skipable_list

	if var2_7 > 1 then
		arg0_7:setWindowSize(var2_7 - 1)
	end

	UIItemList.StaticAlign(arg0_7.list, arg0_7.tpl, var2_7, function(arg0_8, arg1_8, arg2_8)
		if arg0_8 == UIItemList.EventUpdate then
			local var0_8 = arg1_7.skipable_list[arg1_8 + 1]
			local var1_8 = var0_8[1]
			local var2_8 = var0_8[2]
			local var3_8 = var0_8[3]

			changeToScrollText(arg2_8:Find("mask/title"), var3_8)

			local var4_8 = arg2_8:Find("skip_btn")

			onButton(arg0_7, var4_8, function()
				if var1_8 == var0_0.SKIP_TYPE_SCENE then
					pg.m02:sendNotification(GAME.GO_SCENE, var2_8[1], var2_8[2] or {})
				elseif var1_8 == var0_0.SKIP_TYPE_ACTIVITY then
					pg.m02:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY, {
						id = var2_8
					})
				end

				arg0_7:Hide()
			end, SFX_PANEL)
			Canvas.ForceUpdateCanvases()
		end
	end)
end

function var0_0.setWindowSize(arg0_10, arg1_10)
	setSizeDelta(arg0_10.window, Vector2(716, 391 + 50 * arg1_10))
end

function var0_0.Hide(arg0_11)
	if arg0_11:isShowing() then
		var0_0.super.Hide(arg0_11)
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_11._tf, arg0_11._parentTf)
	end
end

return var0_0
