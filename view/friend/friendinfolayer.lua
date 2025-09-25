local var0_0 = class("FriendInfoLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "FriendInfoUI"
end

function var0_0.setFriend(arg0_2, arg1_2)
	arg0_2.friend = arg1_2
end

function var0_0.setFriendProxy(arg0_3, arg1_3)
	arg0_3.friendProxy = arg1_3
end

function var0_0.GetBtnTags(arg0_4)
	return {
		"OPEN_RESUME",
		"OPEND_FRIEND",
		"OPEN_BACKYARD",
		"TOGGLE_BLACK",
		"OPEN_INFORM",
		"OPEN_ISLAND_CARD"
	}
end

function var0_0.init(arg0_5)
	arg0_5:OverlayPanel(arg0_5._tf)

	arg0_5.frame = arg0_5:findTF("frame")
	arg0_5.iconTF = arg0_5:findTF("frame/left_bg/icon_bg/frame/icon"):GetComponent(typeof(Image))
	arg0_5.starsTF = arg0_5:findTF("frame/left_bg/icon_bg/stars")
	arg0_5.starTF = arg0_5:findTF("frame/left_bg/icon_bg/stars/star")
	arg0_5.playerNameTF = arg0_5:findTF("frame/left_bg/name_bg/Text"):GetComponent(typeof(Text))
	arg0_5.levelTF = arg0_5:findTF("frame/left_bg/icon_bg/lv/Text"):GetComponent(typeof(Text))
	arg0_5.resumeEmblem = arg0_5:findTF("frame/left_bg/emblem")
	arg0_5.resumeRank = arg0_5:findTF("frame/left_bg/emblem/Text"):GetComponent(typeof(Text))
	arg0_5.informPanel = arg0_5:findTF("inform_panel")
	arg0_5.toggleTpl = arg0_5:findTF("inform_panel/frame/window/main/Toggle")
	arg0_5.buttonTpl = arg0_5:findTF("inform_panel/frame/window/main/button")
	arg0_5.toggleContainer = arg0_5:findTF("inform_panel/frame/window/main/toggles")
	arg0_5.confirmBtn = arg0_5:findTF("frame/window/buttons/confirm_btn", arg0_5.informPanel)
	arg0_5.cancelBtn = arg0_5:findTF("frame/window/buttons/cancel_btn", arg0_5.informPanel)
	arg0_5.backBtn = arg0_5:findTF("inform_panel/frame/window/top/btnBack")
	arg0_5.nameTF = arg0_5:findTF("inform_panel/frame/window/name"):GetComponent(typeof(Text))

	if arg0_5.contextData.pos then
		if arg0_5.contextData.backyardView then
			local var0_5 = arg0_5:findTF("frame_for_backyard")

			var0_5.position = arg0_5.contextData.pos
			var0_5.localPosition = Vector3(var0_5.localPosition.x, var0_5.localPosition.y, 0)
		else
			arg0_5.height = arg0_5._tf.rect.height
			arg0_5.frame.position = arg0_5.contextData.pos

			local var1_5 = arg0_5.frame.localPosition
			local var2_5 = -1 * (arg0_5.height / 2 - arg0_5.frame.sizeDelta.y)
			local var3_5 = var2_5 >= var1_5.y and var2_5 or var1_5.y

			arg0_5.frame.localPosition = Vector3(var1_5.x, var3_5, 0)
		end
	end
end

function var0_0.didEnter(arg0_6)
	arg0_6:Init()
	onButton(arg0_6, arg0_6._tf, function()
		arg0_6:emit(var0_0.ON_CLOSE)
	end, SOUND_BACK)
end

function var0_0.Init(arg0_8)
	local var0_8 = arg0_8.contextData.backyardView

	arg0_8:initInfo()
	setActive(arg0_8:findTF("frame_for_backyard"), var0_8)
	setActive(arg0_8:findTF("frame"), not var0_8)

	local var1_8

	if var0_8 then
		var1_8 = arg0_8:findTF("frame_for_backyard/right_bg")
	else
		var1_8 = arg0_8:findTF("frame/right_bg")
	end

	arg0_8.btnTFs = {}

	for iter0_8, iter1_8 in ipairs(arg0_8:GetBtnTags()) do
		local var2_8 = var1_8:GetChild(iter0_8 - 1)

		setActive(var2_8, true)
		onButton(arg0_8, var2_8, function()
			if iter1_8 == "" then
				return
			end

			if iter1_8 == "OPEN_INFORM" then
				local var0_9 = arg0_8.friend.id .. arg0_8.contextData.msg
				local var1_9 = getProxy(ChatProxy)

				if not table.contains(var1_9.informs, var0_9) then
					arg0_8:openInfromPanel()
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("chat_msg_inform"))
				end
			else
				arg0_8:emit(FriendInfoMediator[iter1_8])
			end
		end)

		arg0_8.btnTFs[iter0_8] = var2_8
	end

	if arg0_8.btnTFs[6] then
		setActive(arg0_8.btnTFs[6], not LOCK_ISLAND_DISPLAY)
	end

	setActive(arg0_8.btnTFs[5], arg0_8.contextData.msg)
	setButtonEnabled(arg0_8.btnTFs[2], not arg0_8.friendProxy:isFriend(arg0_8.friend.id))
	arg0_8:updateBlack()

	if arg0_8.contextData.form == NotificationLayer.FORM_BATTLE then
		setActive(arg0_8.btnTFs[3], false)
	end

	setActive(arg0_8:findTF("frame/left_bg", false))
end

function var0_0.openInfromPanel(arg0_10)
	setActive(arg0_10.informPanel, true)

	if not arg0_10.isInitInform then
		arg0_10.isInitInform = true

		arg0_10:initInform()
	end
end

function var0_0.initInform(arg0_11)
	arg0_11.informInfoForBackYard = {}

	local var0_11
	local var1_11 = arg0_11.contextData.backyardView

	if var1_11 then
		arg0_11.nameTF.text = i18n("inform_player", arg0_11.friend.name) .. i18n("backyard_theme_inform_them", arg0_11.contextData.msg)

		local var2_11 = require("ShareCfg.InformForBackYardThemeTemplateCfg")

		for iter0_11, iter1_11 in ipairs(var2_11) do
			local var3_11 = cloneTplTo(arg0_11.buttonTpl, arg0_11.toggleContainer)

			var3_11:Find("Label"):GetComponent("Text").text = iter1_11.content

			local var4_11 = false

			onButton(arg0_11, var3_11, function()
				var4_11 = not var4_11

				setActive(var3_11:Find("Background/Checkmark"), var4_11)

				if var4_11 then
					table.insert(arg0_11.informInfoForBackYard, iter0_11)
				elseif table.contains(arg0_11.informInfoForBackYard, iter0_11) then
					table.removebyvalue(arg0_11.informInfoForBackYard, iter0_11)
				end
			end)
		end
	else
		arg0_11.nameTF.text = i18n("inform_player", arg0_11.friend.name)

		local var5_11 = require("ShareCfg.informCfg")

		for iter2_11, iter3_11 in ipairs(var5_11) do
			local var6_11 = cloneTplTo(arg0_11.toggleTpl, arg0_11.toggleContainer)

			var6_11:Find("Label"):GetComponent("Text").text = iter3_11.content

			onToggle(arg0_11, var6_11, function(arg0_13)
				if arg0_13 then
					arg0_11.informInfo = iter3_11.content
				end
			end)
		end
	end

	onButton(arg0_11, arg0_11.confirmBtn, function()
		if not arg0_11.contextData.msg then
			pg.TipsMgr.GetInstance():ShowTips(i18n("inform_chat_msg"))

			return
		end

		if var1_11 then
			if #arg0_11.informInfoForBackYard == 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("inform_select_type"))

				return
			end

			arg0_11:emit(FriendInfoMediator.INFORM_BACKYARD, arg0_11.friend.id, arg0_11.informInfoForBackYard, arg0_11.contextData.msg, arg0_11.friend.name)
		else
			if not arg0_11.informInfo then
				pg.TipsMgr.GetInstance():ShowTips(i18n("inform_select_type"))

				return
			end

			arg0_11:emit(FriendInfoMediator.INFORM, arg0_11.friend.id, arg0_11.informInfo, arg0_11.contextData.msg)
		end
	end)
	onButton(arg0_11, arg0_11.cancelBtn, function()
		arg0_11:closeInfromPanel()
	end)
	onButton(arg0_11, arg0_11.backBtn, function()
		arg0_11:closeInfromPanel()
	end)
end

function var0_0.closeInfromPanel(arg0_17)
	setActive(arg0_17.informPanel, false)

	arg0_17.informInfo = nil
end

function var0_0.initInfo(arg0_18)
	assert(arg0_18.friend, "self.friend is nil")

	local var0_18 = pg.ship_data_statistics[arg0_18.friend.icon]

	assert(var0_18, "shipCfg is nil >> id ==" .. arg0_18.friend.icon)

	local var1_18 = pg.ship_skin_template[var0_18.skin_id]

	assert(var1_18, "skinCfg is nil >> id ==" .. var0_18.skin_id)
	LoadSpriteAsync("qicon/" .. var1_18.painting, function(arg0_19)
		if not IsNil(arg0_18.iconTF) then
			if not arg0_19 then
				arg0_18.iconTF.sprite = GetSpriteFromAtlas("heroicon/unknown", "")
			else
				arg0_18.iconTF.sprite = arg0_19
			end
		end
	end)

	for iter0_18 = arg0_18.starsTF.childCount, var0_18.star - 1 do
		cloneTplTo(arg0_18.starTF, arg0_18.starsTF)
	end

	for iter1_18 = 1, var0_18.star do
		local var2_18 = arg0_18.starsTF:GetChild(iter1_18 - 1)

		setActive(var2_18, iter1_18 <= var0_18.star)
	end

	arg0_18.playerNameTF.text = arg0_18.friend.name
	arg0_18.levelTF.text = arg0_18.friend.level

	local var3_18 = SeasonInfo.getMilitaryRank(arg0_18.friend.score, arg0_18.friend.rank)
	local var4_18 = SeasonInfo.getEmblem(arg0_18.friend.score, arg0_18.friend.rank)

	LoadImageSpriteAsync("emblem/" .. var4_18, arg0_18.resumeEmblem)
end

function var0_0.updateBlack(arg0_20)
	local var0_20 = arg0_20.friendProxy:getBlackPlayerById(arg0_20.friend.id) ~= nil

	setActive(findTF(arg0_20.btnTFs[4], "black"), not var0_20)
	setActive(findTF(arg0_20.btnTFs[4], "unblack"), var0_20)
end

function var0_0.willExit(arg0_21)
	return
end

return var0_0
