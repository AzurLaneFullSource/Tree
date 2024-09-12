local var0_0 = class("DreamlandChatPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "DreamlandChatUI"
end

function var0_0.Ctor(arg0_2, arg1_2, arg2_2, arg3_2)
	var0_0.super.Ctor(arg0_2, arg1_2, arg2_2, arg3_2)

	arg0_2.uiList = {
		arg1_2:Find("adapt/time"),
		arg1_2:Find("adapt/handbook"),
		arg1_2:Find("adapt/hotspring")
	}
	arg0_2.toHideUI = {}
end

function var0_0.OnLoaded(arg0_3)
	arg0_3.icon = arg0_3._tf:Find("icon"):GetComponent(typeof(Image))
	arg0_3.content = arg0_3._tf:Find("Text"):GetComponent(typeof(Text))
end

function var0_0.OnInit(arg0_4)
	onButton(arg0_4, arg0_4._tf, function()
		if arg0_4.clickCnt < arg0_4.totlalCnt then
			arg0_4:ShowContent()
		else
			arg0_4:Hide()
		end
	end, SFX_PANEL)
end

function var0_0.Show(arg0_6, arg1_6)
	var0_0.super.Show(arg0_6)

	arg0_6.clickCnt = 0
	arg0_6.textList = _.flatten(arg1_6.desc)
	arg0_6.totlalCnt = #arg0_6.textList

	arg0_6:ShowContent()

	local var0_6 = arg0_6:GetPic(arg1_6)
	local var1_6 = LoadSprite("exploreObj/icon_" .. var0_6)

	arg0_6.icon.sprite = var1_6

	arg0_6.icon:SetNativeSize()
	arg0_6:HideUI()
end

function var0_0.ShowContent(arg0_7)
	arg0_7.clickCnt = arg0_7.clickCnt + 1

	local var0_7 = arg0_7.textList[arg0_7.clickCnt] or ""

	arg0_7.content.text = HXSet.hxLan(var0_7)
end

function var0_0.HideUI(arg0_8)
	arg0_8.toHideUI = {}

	for iter0_8, iter1_8 in ipairs(arg0_8.uiList) do
		if isActive(iter1_8) then
			setActive(iter1_8, false)
			table.insert(arg0_8.toHideUI, iter1_8)
		end
	end
end

function var0_0.ShowUI(arg0_9)
	for iter0_9, iter1_9 in ipairs(arg0_9.toHideUI or {}) do
		if not isActive(iter1_9) then
			setActive(iter1_9, true)
		end
	end

	arg0_9.toHideUI = {}
end

function var0_0.Hide(arg0_10)
	var0_0.super.Hide(arg0_10)

	arg0_10.textList = {}
	arg0_10.clickCnt = 0
	arg0_10.totlalCnt = 0

	arg0_10:ShowUI()
end

function var0_0.GetPic(arg0_11, arg1_11)
	local var0_11 = (pg.activity_dreamland_explore.get_id_list_by_group[arg1_11.group] or {})[1] or arg1_11.id

	return pg.activity_dreamland_explore[var0_11].pic
end

function var0_0.OnDestroy(arg0_12)
	return
end

return var0_0
