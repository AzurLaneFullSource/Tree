local var0 = class("MailMgrWindow", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "MailMgrMsgboxUI"
end

function var0.OnInit(arg0)
	onButton(arg0, arg0._tf:Find("bg"), function()
		arg0:Hide()
	end, SFX_PANEL)

	arg0.closeBtn = arg0:findTF("window/top/btnBack")

	onButton(arg0, arg0.closeBtn, function()
		arg0:Hide()
	end, SFX_PANEL)

	arg0.readBtn = arg0._tf:Find("window/button_container/btn_read")

	onButton(arg0, arg0.readBtn, function()
		arg0:emit(MailMediator.ON_OPERATION, {
			cmd = "read",
			filter = arg0:GetFilterData()
		})
	end, SFX_CONFIRM)

	arg0.attachBtn = arg0._tf:Find("window/button_container/btn_get")

	onButton(arg0, arg0.attachBtn, function()
		arg0:emit(MailMediator.ON_OPERATION, {
			cmd = "attachment",
			filter = arg0:GetFilterData()
		})
	end, SFX_CONFIRM)

	arg0.deleteBtn = arg0._tf:Find("window/button_container/btn_delete")

	onButton(arg0, arg0.deleteBtn, function()
		seriesAsync({
			function(arg0)
				pg.m02:sendNotification(GAME.MAIL_DOUBLE_CONFIREMATION_MSGBOX, {
					type = MailProxy.MailMessageBoxType.ShowTips,
					content = i18n("main_mailLayer_quest_clear_choice"),
					onYes = arg0
				})
			end
		}, function()
			arg0:emit(MailMediator.ON_OPERATION, {
				cmd = "delete",
				filter = arg0:GetFilterData()
			})
		end)
	end, SFX_CONFIRM)

	local var0 = {}

	for iter0, iter1 in pairs({
		[DROP_TYPE_RESOURCE] = {
			PlayerConst.ResGold,
			PlayerConst.ResOil,
			PlayerConst.ResExploit,
			PlayerConst.ResDiamond
		},
		[DROP_TYPE_ITEM] = {
			ITEM_ID_CUBE
		}
	}) do
		for iter2, iter3 in ipairs(iter1) do
			table.insert(var0, Drop.New({
				type = iter0,
				id = iter3
			}))
		end
	end

	arg0.filterDic = {}
	arg0.rtContent = arg0._tf:Find("window/frame/toggle_group/filter/content")

	UIItemList.StaticAlign(arg0.rtContent, arg0.rtContent:Find("toggle_tpl"), #var0, function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = var0[arg1]

			GetImageSpriteFromAtlasAsync(var0:getIcon(), "", arg2:Find("Image"))
			onToggle(arg0, arg2, function(arg0)
				arg0.filterDic[var0.type .. "_" .. var0.id] = arg0

				if arg0 then
					triggerToggle(arg0._tf:Find("window/frame/toggle_group/filter"), true)
				end
			end, SFX_PANEL)
		end
	end)
	eachChild(arg0._tf:Find("window/frame/toggle_group"), function(arg0)
		onToggle(arg0, arg0, function(arg0)
			if arg0 then
				arg0.filterType = arg0.name

				if arg0.filterType == "all" then
					eachChild(arg0.rtContent, function(arg0)
						triggerToggle(arg0, false)
					end)
				end
			end
		end, SFX_PANEL)
	end)
	setText(arg0._tf:Find("window/top/bg/infomation/title"), i18n("mail_manager_title"))
	setText(arg0._tf:Find("window/frame/tip/Text"), i18n("mail_manage_tip_1"))
	setText(arg0._tf:Find("window/frame/tip_1/Text"), i18n("mail_manager_tips_2"))
	setText(arg0._tf:Find("window/frame/toggle_group/all/Text"), i18n("mail_manage_1"))
	setText(arg0._tf:Find("window/frame/toggle_group/filter/Text"), i18n("mail_manage_2"))
	setText(arg0.attachBtn:Find("Text"), i18n("mail_get_oneclick"))
	setText(arg0.readBtn:Find("Text"), i18n("mail_read_oneclick"))
	setText(arg0.deleteBtn:Find("Text"), i18n("mail_delete_oneclick"))
end

function var0.GetFilterData(arg0)
	return switch(arg0.filterType, {
		all = function()
			return {
				type = "all"
			}
		end,
		filter = function()
			local var0 = {}

			for iter0, iter1 in pairs(arg0.filterDic) do
				if iter1 then
					local var1, var2 = unpack(string.split(iter0, "_"))

					table.insert(var0, Drop.New({
						type = tonumber(var1),
						id = tonumber(var2)
					}))
				end
			end

			return {
				type = "drops",
				list = var0
			}
		end
	}, function()
		assert(false)
	end)
end

function var0.Show(arg0, arg1)
	var0.super.Show(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	triggerToggle(arg0._tf:Find("window/frame/toggle_group/all"), true)
end

function var0.Hide(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
	var0.super.Hide(arg0)
end

function var0.OnDestroy(arg0)
	if arg0:isShowing() then
		arg0:Hide()
	end
end

return var0
