local var0_0 = class("MailMgrWindow", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "MailMgrMsgboxUI"
end

function var0_0.OnInit(arg0_2)
	onButton(arg0_2, arg0_2._tf:Find("bg"), function()
		arg0_2:Hide()
	end, SFX_PANEL)

	arg0_2.closeBtn = arg0_2:findTF("window/top/btnBack")

	onButton(arg0_2, arg0_2.closeBtn, function()
		arg0_2:Hide()
	end, SFX_PANEL)

	arg0_2.readBtn = arg0_2._tf:Find("window/button_container/btn_read")

	onButton(arg0_2, arg0_2.readBtn, function()
		arg0_2:emit(MailMediator.ON_OPERATION, {
			cmd = "read",
			filter = arg0_2:GetFilterData()
		})
	end, SFX_CONFIRM)

	arg0_2.attachBtn = arg0_2._tf:Find("window/button_container/btn_get")

	onButton(arg0_2, arg0_2.attachBtn, function()
		arg0_2:emit(MailMediator.ON_OPERATION, {
			cmd = "attachment",
			filter = arg0_2:GetFilterData()
		})
	end, SFX_CONFIRM)

	arg0_2.deleteBtn = arg0_2._tf:Find("window/button_container/btn_delete")

	onButton(arg0_2, arg0_2.deleteBtn, function()
		seriesAsync({
			function(arg0_8)
				pg.m02:sendNotification(GAME.MAIL_DOUBLE_CONFIREMATION_MSGBOX, {
					type = MailProxy.MailMessageBoxType.ShowTips,
					content = i18n("main_mailLayer_quest_clear_choice"),
					onYes = arg0_8
				})
			end
		}, function()
			arg0_2:emit(MailMediator.ON_OPERATION, {
				cmd = "delete",
				filter = arg0_2:GetFilterData()
			})
		end)
	end, SFX_CONFIRM)

	local var0_2 = {}

	for iter0_2, iter1_2 in pairs({
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
		for iter2_2, iter3_2 in ipairs(iter1_2) do
			table.insert(var0_2, Drop.New({
				type = iter0_2,
				id = iter3_2
			}))
		end
	end

	arg0_2.filterDic = {}
	arg0_2.rtContent = arg0_2._tf:Find("window/frame/toggle_group/filter/content")

	UIItemList.StaticAlign(arg0_2.rtContent, arg0_2.rtContent:Find("toggle_tpl"), #var0_2, function(arg0_10, arg1_10, arg2_10)
		arg1_10 = arg1_10 + 1

		if arg0_10 == UIItemList.EventUpdate then
			local var0_10 = var0_2[arg1_10]

			GetImageSpriteFromAtlasAsync(var0_10:getIcon(), "", arg2_10:Find("Image"))
			onToggle(arg0_2, arg2_10, function(arg0_11)
				arg0_2.filterDic[var0_10.type .. "_" .. var0_10.id] = arg0_11

				if arg0_11 then
					triggerToggle(arg0_2._tf:Find("window/frame/toggle_group/filter"), true)
				end
			end, SFX_PANEL)
		end
	end)
	eachChild(arg0_2._tf:Find("window/frame/toggle_group"), function(arg0_12)
		onToggle(arg0_2, arg0_12, function(arg0_13)
			if arg0_13 then
				arg0_2.filterType = arg0_12.name

				if arg0_2.filterType == "all" then
					eachChild(arg0_2.rtContent, function(arg0_14)
						triggerToggle(arg0_14, false)
					end)
				end
			end
		end, SFX_PANEL)
	end)
	setText(arg0_2._tf:Find("window/top/bg/infomation/title"), i18n("mail_manager_title"))
	setText(arg0_2._tf:Find("window/frame/tip/Text"), i18n("mail_manage_tip_1"))
	setText(arg0_2._tf:Find("window/frame/tip_1/Text"), i18n("mail_manager_tips_2"))
	setText(arg0_2._tf:Find("window/frame/toggle_group/all/Text"), i18n("mail_manage_1"))
	setText(arg0_2._tf:Find("window/frame/toggle_group/filter/Text"), i18n("mail_manage_2"))
	setText(arg0_2.attachBtn:Find("Text"), i18n("mail_get_oneclick"))
	setText(arg0_2.readBtn:Find("Text"), i18n("mail_read_oneclick"))
	setText(arg0_2.deleteBtn:Find("Text"), i18n("mail_delete_oneclick"))
end

function var0_0.GetFilterData(arg0_15)
	return switch(arg0_15.filterType, {
		all = function()
			return {
				type = "all"
			}
		end,
		filter = function()
			local var0_17 = {}

			for iter0_17, iter1_17 in pairs(arg0_15.filterDic) do
				if iter1_17 then
					local var1_17, var2_17 = unpack(string.split(iter0_17, "_"))

					table.insert(var0_17, Drop.New({
						type = tonumber(var1_17),
						id = tonumber(var2_17)
					}))
				end
			end

			return {
				type = "drops",
				list = var0_17
			}
		end
	}, function()
		assert(false)
	end)
end

function var0_0.Show(arg0_19, arg1_19)
	var0_0.super.Show(arg0_19)
	pg.UIMgr.GetInstance():BlurPanel(arg0_19._tf)
	triggerToggle(arg0_19._tf:Find("window/frame/toggle_group/all"), true)
end

function var0_0.Hide(arg0_20)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_20._tf, arg0_20._parentTf)
	var0_0.super.Hide(arg0_20)
end

function var0_0.OnDestroy(arg0_21)
	if arg0_21:isShowing() then
		arg0_21:Hide()
	end
end

return var0_0
