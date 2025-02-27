local var0_0 = class("Dorm3dInsCharPage", import("view.base.BaseEventLogic"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	pg.DelegateInfo.New(arg0_1)
	var0_0.super.Ctor(arg0_1, arg2_1)

	arg0_1.tf = arg1_1
	arg0_1.go = arg1_1.gameObject

	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	eachChild(arg0_2.tf:Find("entrance"), function(arg0_3)
		local var0_3 = arg0_3.name

		arg0_2[var0_3 .. "Btn"] = arg0_3
		arg0_2[var0_3 .. "Content"] = arg0_3:Find("content")
		arg0_2[var0_3 .. "Tip"] = arg0_3:Find("tip")

		setText(arg0_3:Find("label"), i18n("dorm3d_privatechat_" .. var0_3))
	end)
	onButton(arg0_2, arg0_2.insBtn, function()
		arg0_2:emit(Dorm3dInsMainLayer.OPEN_INS)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.chatBtn, function()
		arg0_2:emit(Dorm3dInsMainLayer.OPEN_CHAT)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.phoneBtn, function()
		arg0_2:emit(Dorm3dInsMainLayer.OPEN_PHONE)
	end, SFX_PANEL)

	arg0_2.name = arg0_2.tf:Find("name/Text")
	arg0_2.avatar = arg0_2.tf:Find("avatar/mask/img")
	arg0_2.likeBtn = arg0_2.tf:Find("avatar/like_bottom")
	arg0_2.like = arg0_2.likeBtn:Find("like")

	onButton(arg0_2, arg0_2.likeBtn, function()
		if not arg0_2.data:IsDownloaded() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_privatechat_room_unlock"))

			return
		end

		setActive(arg0_2.like, not arg0_2.data:IsCare())
		arg0_2.data:SetCare(arg0_2.data:IsCare() and 0 or 1)
		arg0_2:emit(Dorm3dInsMainLayer.FLUSH_LEFT)
	end)
	eachChild(arg0_2.tf:Find("info"), function(arg0_8)
		local var0_8 = arg0_8.name

		setText(arg0_8:Find("label"), i18n("dorm3d_privatechat_" .. var0_8))

		arg0_2[var0_8 .. "Content"] = arg0_8:Find("val")
	end)
	setText(arg0_2.tf:Find("block/Text"), i18n("secretary_closed"))
	setActive(arg0_2.tf:Find("entrance/phone"), not DORM_LOCK_INS_PHONE)
	setActive(arg0_2.tf:Find("block"), DORM_LOCK_INS_PHONE)
end

function var0_0.Flush(arg0_9, arg1_9)
	arg0_9.data = arg1_9

	setText(arg0_9.name, arg1_9:GetName())
	GetImageSpriteFromAtlasAsync(arg1_9:GetCard(), "", arg0_9.avatar, true)
	setText(arg0_9.favorContent, arg1_9:GetFavorLevel())
	setText(arg0_9.furnitureContent, arg1_9:GetFurnitureNum())
	setText(arg0_9.visitContent, arg1_9:GetLastVisit())
	setText(arg0_9.giftContent, arg1_9:GetGiftNum())

	local function var0_9(arg0_10, arg1_10, arg2_10)
		setActive(arg0_9[arg0_10 .. "Tip"], arg1_10)
		setText(arg0_9[arg0_10 .. "Content"], arg1_10 and setColorStr(arg2_10, "#32a6e8") or arg2_10)
	end

	var0_9("ins", arg1_9:GetInsContent())
	var0_9("chat", arg1_9:GetChatContent())
	var0_9("phone", arg1_9:GetPhoneContent())
	setActive(arg0_9.like, arg1_9:IsCare())
end

function var0_0.Show(arg0_11)
	setActive(arg0_11.tf, true)
end

function var0_0.Hide(arg0_12)
	setActive(arg0_12.tf, false)
end

function var0_0.Destroy(arg0_13)
	pg.DelegateInfo.Dispose(arg0_13)
end

return var0_0
