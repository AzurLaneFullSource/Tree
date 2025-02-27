local var0_0 = class("Dorm3dInsCharPage", import("view.base.BaseEventLogic"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	pg.DelegateInfo.New(arg0_1)
	var0_0.super.Ctor(arg0_1, arg2_1)

	arg0_1.tf = arg1_1
	arg0_1.go = arg1_1.gameObject

	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	eachChild(arg0_2.tf:Find("info"), function(arg0_3)
		local var0_3 = arg0_3.name

		setText(arg0_3:Find("label"), i18n("dorm3d_privatechat_" .. var0_3))

		arg0_2[var0_3 .. "Content"] = arg0_3:Find("val")
	end)

	arg0_2.name = arg0_2.tf:Find("name/Text")
	arg0_2.avatar = arg0_2.tf:Find("avatar/img")
	arg0_2.desc = arg0_2.tf:Find("invite/desc")

	setText(arg0_2.tf:Find("invite/hint/Text"), i18n("dorm3d_privatechat_room_character"))

	arg0_2.inviteListContainer = arg0_2.tf:Find("invite/list")
	arg0_2.inviteItemList = UIItemList.New(arg0_2.inviteListContainer, arg0_2.inviteListContainer:Find("tpl"))

	arg0_2.inviteItemList:make(function(arg0_4, arg1_4, arg2_4)
		if arg0_4 == UIItemList.EventUpdate then
			arg0_2:UpdateInvite(arg1_4, arg2_4)
		end
	end)
end

function var0_0.Flush(arg0_5, arg1_5)
	arg0_5.data = arg1_5
	arg0_5.charIds, arg0_5.unlockIds, arg0_5.roomIds = arg1_5:GetWelcomeCharList()

	setText(arg0_5.name, arg1_5:GetConfig("room"))
	GetImageSpriteFromAtlasAsync(arg1_5:GetCard(), "", arg0_5.avatar, true)
	setText(arg0_5.welcomeContent, #arg0_5.unlockIds)
	setText(arg0_5.desc, arg1_5:GetDesc())
	arg0_5.inviteItemList:align(#arg0_5.charIds)
end

function var0_0.UpdateInvite(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg0_6.charIds[arg1_6 + 1]
	local var1_6 = arg0_6.roomIds[arg1_6 + 1]
	local var2_6 = getProxy(Dorm3dInsProxy):GetRoomById(var1_6):GetIcon()
	local var3_6 = not table.contains(arg0_6.unlockIds, var0_6)

	GetImageSpriteFromAtlasAsync(var2_6, "", arg2_6:Find("mask/icon"))
	setActive(arg2_6:Find("lock"), var3_6)
	onButton(arg0_6, arg2_6, function()
		if not var3_6 then
			return
		end

		if not arg0_6.data:IsDownloaded() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_privatechat_room_unlock"))

			return
		end

		if not pg.NewStoryMgr.GetInstance():IsPlayed("DORM3D_GUIDE_06") then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_privatechat_room_guide"))

			return
		end

		arg0_6:emit(Dorm3dInsMainMediator.OPEN_ROOM_UNLOCK_WINDOW, arg0_6.data.id, var0_6)
	end)
end

function var0_0.Show(arg0_8)
	setActive(arg0_8.tf, true)
end

function var0_0.Hide(arg0_9)
	setActive(arg0_9.tf, false)
end

function var0_0.Destroy(arg0_10)
	pg.DelegateInfo.Dispose(arg0_10)
end

return var0_0
